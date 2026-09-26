import { prisma } from "../../config/database.js";
import * as ledgerRepository from "./ledger.repository.js";
import * as repository from "./stock.repository.js";

export type InventoryOperation =
    | "receipt"
    | "delivery"
    | "transfer"
    | "adjustment"
    | "initial_stock";

export async function increaseStock(params: {
    productId: bigint;
    locationId: bigint;
    quantity: string;
    operationType: InventoryOperation;
    referenceType: string;
    referenceId: bigint;
    performedBy: bigint;
}) {
    return prisma.transaction(async (tx: any) => {
        const stock = await repository.findStock(params.productId, params.locationId, tx);

        const currentQuantity = stock ? Number(stock.quantity) : 0;
        const increase = Number(params.quantity);

        if (!Number.isFinite(increase) || increase <= 0) {
            throw new Error("Quantity must be greater than zero");
        }

        const newQuantity = currentQuantity + increase;

        let updatedStock;

        if (stock) {
            updatedStock = await repository.updateStockQuantity(
                params.productId,
                params.locationId,
                newQuantity.toString(),
                tx
            );
        } else {
            updatedStock = await repository.createStock({
                productId: params.productId,
                locationId: params.locationId,
                quantity: params.quantity,
            }, tx);
        }

        await ledgerRepository.createLedgerEntry({
            productId: params.productId,
            operationType: params.operationType,
            referenceType: params.referenceType,
            referenceId: params.referenceId,
            toLocationId: params.locationId,
            quantity: params.quantity,
            performedBy: params.performedBy,
        }, tx);

        return updatedStock;
    });
}

export async function decreaseStock(params: {
    productId: bigint;
    locationId: bigint;
    quantity: string;
    operationType: InventoryOperation;
    referenceType: string;
    referenceId: bigint;
    performedBy: bigint;
}) {
    return prisma.transaction(async (tx: any) => {
        const stock = await repository.findStock(params.productId, params.locationId, tx);

        if (!stock) {
            throw new Error("Insufficient stock: no stock record exists");
        }

        const currentQuantity = Number(stock.quantity);
        const decrease = Number(params.quantity);

        if (!Number.isFinite(decrease) || decrease <= 0) {
            throw new Error("Quantity must be greater than zero");
        }

        if (decrease > currentQuantity) {
            throw new Error(`Insufficient stock. Available: ${currentQuantity}`);
        }

        const newQuantity = currentQuantity - decrease;

        const updatedStock = await repository.updateStockQuantity(
            params.productId,
            params.locationId,
            newQuantity.toString(),
            tx
        );

        await ledgerRepository.createLedgerEntry({
            productId: params.productId,
            operationType: params.operationType,
            referenceType: params.referenceType,
            referenceId: params.referenceId,
            fromLocationId: params.locationId,
            quantity: params.quantity,
            performedBy: params.performedBy,
        }, tx);

        return updatedStock;
    });
}

export async function transferStock(params: {
    productId: bigint;
    fromLocationId: bigint;
    toLocationId: bigint;
    quantity: string;
    referenceType: string;
    referenceId: bigint;
    performedBy: bigint;
}) {
    if (params.fromLocationId === params.toLocationId) {
        throw new Error("Source and destination locations must be different");
    }

    return prisma.transaction(async (tx: any) => {
        const sourceStock = await repository.findStock(params.productId, params.fromLocationId, tx);

        if (!sourceStock) {
            throw new Error("No stock exists at the source location");
        }

        const quantity = Number(params.quantity);
        const available = Number(sourceStock.quantity);

        if (!Number.isFinite(quantity) || quantity <= 0) {
            throw new Error("Quantity must be greater than zero");
        }

        if (quantity > available) {
            throw new Error(`Insufficient stock. Available: ${available}`);
        }

        const destinationStock = await repository.findStock(params.productId, params.toLocationId, tx);

        const newSourceQuantity = available - quantity;

        await repository.updateStockQuantity(
            params.productId,
            params.fromLocationId,
            newSourceQuantity.toString(),
            tx
        );

        if (destinationStock) {
            const newDestinationQuantity = Number(destinationStock.quantity) + quantity;
            await repository.updateStockQuantity(
                params.productId,
                params.toLocationId,
                newDestinationQuantity.toString(),
                tx
            );
        } else {
            await repository.createStock({
                productId: params.productId,
                locationId: params.toLocationId,
                quantity: params.quantity,
            }, tx);
        }

        await ledgerRepository.createLedgerEntry({
            productId: params.productId,
            operationType: "transfer",
            referenceType: params.referenceType,
            referenceId: params.referenceId,
            fromLocationId: params.fromLocationId,
            toLocationId: params.toLocationId,
            quantity: params.quantity,
            performedBy: params.performedBy,
        }, tx);

        return {
            sourceQuantity: newSourceQuantity.toString(),
            destinationQuantity: destinationStock
                ? (Number(destinationStock.quantity) + quantity).toString()
                : params.quantity,
        };
    });
}

export async function adjustStock(params: {
    productId: bigint;
    locationId: bigint;
    countedQuantity: string;
    referenceType: string;
    referenceId: bigint;
    performedBy: bigint;
}) {
    return prisma.transaction(async (tx: any) => {
        const stock = await repository.findStock(params.productId, params.locationId, tx);

        const currentQuantity = stock ? Number(stock.quantity) : 0;
        const counted = Number(params.countedQuantity);

        if (!Number.isFinite(counted) || counted < 0) {
            throw new Error("Counted quantity cannot be negative");
        }

        const difference = counted - currentQuantity;

        if (difference === 0) {
            return stock;
        }

        let updatedStock;

        if (stock) {
            updatedStock = await repository.updateStockQuantity(
                params.productId,
                params.locationId,
                counted.toString(),
                tx
            );
        } else {
            updatedStock = await repository.createStock({
                productId: params.productId,
                locationId: params.locationId,
                quantity: counted.toString(),
            }, tx);
        }

        await ledgerRepository.createLedgerEntry({
            productId: params.productId,
            operationType: "adjustment",
            referenceType: params.referenceType,
            referenceId: params.referenceId,
            fromLocationId: difference < 0 ? params.locationId : undefined,
            toLocationId: difference > 0 ? params.locationId : undefined,
            quantity: Math.abs(difference).toString(),
            performedBy: params.performedBy,
        }, tx);

        return updatedStock;
    });
}