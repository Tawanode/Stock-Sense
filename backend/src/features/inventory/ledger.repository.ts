import { prisma } from "../../config/database.js";

export async function createLedgerEntry(
    data: {
        productId: bigint;
        operationType: string;
        referenceType: string;
        referenceId: bigint;
        fromLocationId?: bigint;
        toLocationId?: bigint;
        quantity: string;
        performedBy: bigint;
    },
    tx: any = prisma,
) {
    const db = tx.orm ? tx : prisma;
    await db.orm.public.StockLedger.create({
        productId: data.productId,
        operationType: data.operationType as any,
        referenceType: data.referenceType as any,
        referenceId: data.referenceId,
        fromLocationId: data.fromLocationId,
        toLocationId: data.toLocationId,
        quantity: data.quantity as any,
        performedBy: data.performedBy,
    });
}

export async function findLedgerEntries(params?: {
    productId?: bigint;
    operationType?: string;
    referenceType?: string;
}) {
    let query = prisma.orm.public.StockLedger.where({});

    if (params?.productId !== undefined) {
        query = query.where({ productId: params.productId });
    }

    if (params?.operationType !== undefined) {
        query = query.where({ operationType: params.operationType as any });
    }

    if (params?.referenceType !== undefined) {
        query = query.where({ referenceType: params.referenceType as any });
    }

    return query
        .include("product", (p: any) => p.include("unit"))
        .include("fromLocation", (fl: any) => fl.include("warehouse"))
        .include("toLocation", (tl: any) => tl.include("warehouse"))
        .include("users")
        .orderBy((q: any) => q.createdAt.desc())
        .all();
}