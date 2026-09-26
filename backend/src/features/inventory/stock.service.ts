import { prisma } from "../../config/database.js";
import * as repository from "./stock.repository.js";

function serializeStock(stock: any) {
  return {
    ...stock,

    id: stock.id.toString(),
    productId: stock.productId.toString(),
    locationId: stock.locationId.toString(),

    quantity: stock.quantity.toString(),
    reservedQuantity: stock.reservedQuantity.toString(),

    product: stock.product
      ? {
          ...stock.product,

          id: stock.product.id.toString(),
          categoryId: stock.product.categoryId.toString(),
          unitId: stock.product.unitId.toString(),

          category: stock.product.category
            ? {
                ...stock.product.category,
                id: stock.product.category.id.toString(),
              }
            : null,

          unit: stock.product.unit
            ? {
                ...stock.product.unit,
                id: stock.product.unit.id.toString(),
              }
            : null,
        }
      : null,

    location: stock.location
      ? {
          ...stock.location,

          id: stock.location.id.toString(),
          warehouseId: stock.location.warehouseId.toString(),

          warehouse: stock.location.warehouse
            ? {
                ...stock.location.warehouse,
                id: stock.location.warehouse.id.toString(),
              }
            : null,
        }
      : null,
  };
}

export async function getAllStock(params?: {
    productId?: bigint;
    locationId?: bigint;
}) {
    const stock = await repository.findAllStock(params);

    return stock.map(serializeStock);
}

export async function getProductStock(productId: bigint) {
    const product = await prisma.orm.public.Products.where({ id: productId }).first();

    if (!product) {
        throw new Error("Product not found");
    }

    const stock = await repository.findProductStock(productId);

    return stock.map(serializeStock);
}

export async function getLocationStock(locationId: bigint) {
    const location = await prisma.orm.public.Locations.where({ id: locationId }).first();

    if (!location) {
        throw new Error("Location not found");
    }

    const stock = await repository.findLocationStock(locationId);

    return stock.map(serializeStock);
}

export async function getStock(
    productId: bigint,
    locationId: bigint,
) {
    const product = await prisma.orm.public.Products.where({ id: productId }).first();

    if (!product) {
        throw new Error("Product not found");
    }

    const location = await prisma.orm.public.Locations.where({ id: locationId }).first();

    if (!location) {
        throw new Error("Location not found");
    }

    const stock = await repository.findStock(
        productId,
        locationId,
    );

    if (!stock) {
        return null;
    }

    return serializeStock(stock);
}

export async function setStockQuantity(
    productId: bigint,
    locationId: bigint,
    quantity: string,
) {
    const product = await prisma.orm.public.Products.where({ id: productId }).first();

    if (!product) {
        throw new Error("Product not found");
    }

    if (!product.isActive) {
        throw new Error(
            "Cannot update stock for an inactive product",
        );
    }

    const location = await prisma.orm.public.Locations.where({ id: locationId }).first();

    if (!location) {
        throw new Error("Location not found");
    }

    if (!location.isActive) {
        throw new Error(
            "Cannot update stock in an inactive location",
        );
    }

    const parsedQuantity = Number(quantity);

    if (!Number.isFinite(parsedQuantity)) {
        throw new Error("Invalid stock quantity");
    }

    if (parsedQuantity < 0) {
        throw new Error(
            "Stock quantity cannot be negative",
        );
    }

    const existing = await repository.findStock(
        productId,
        locationId,
    );

    let stock;

    if (existing) {
        stock = await repository.updateStockQuantity(
            productId,
            locationId,
            quantity,
        );
    } else {
        stock = await repository.createStock({
            productId,
            locationId,
            quantity,
        });
    }

    return serializeStock(stock);
}