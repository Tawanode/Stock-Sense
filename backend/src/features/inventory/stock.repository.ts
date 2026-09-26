import { prisma } from "../../config/database.js";

/**
 * Find stock for a specific product and location.
 */
export async function findStock(
    productId: bigint,
    locationId: bigint,
    tx: any = prisma,
) {
    const db = tx.orm ? tx : prisma;
    return db.orm.public.Stock
        .where({
            productId,
            locationId,
        })
        .include("product", (p: any) => p.include("category").include("unit"))
        .include("location", (l: any) => l.include("warehouse"))
        .first();
}

/**
 * Find all stock records.
 */
export async function findAllStock(params?: {
    productId?: bigint;
    locationId?: bigint;
}) {
    let query = prisma.orm.public.Stock.where({});

    if (params?.productId !== undefined) {
        query = query.where({ productId: params.productId });
    }

    if (params?.locationId !== undefined) {
        query = query.where({ locationId: params.locationId });
    }

    return query
        .include("product", (p: any) => p.include("category").include("unit"))
        .include("location", (l: any) => l.include("warehouse"))
        .orderBy((q: any) => q.updatedAt.desc())
        .all();
}

/**
 * Find stock records for one product.
 */
export async function findProductStock(
    productId: bigint,
) {
    return prisma.orm.public.Stock
        .where({ productId })
        .include("location", (l: any) => l.include("warehouse"))
        .orderBy((q: any) => q.updatedAt.desc())
        .all();
}

/**
 * Find stock records for one location.
 */
export async function findLocationStock(
    locationId: bigint,
) {
    return prisma.orm.public.Stock
        .where({ locationId })
        .include("product", (p: any) => p.include("category").include("unit"))
        .orderBy((q: any) => q.updatedAt.desc())
        .all();
}

/**
 * Create a new stock record.
 */
export async function createStock(
    data: {
        productId: bigint;
        locationId: bigint;
        quantity: string;
    },
    tx: any = prisma,
) {
    const db = tx.orm ? tx : prisma;
    await db.orm.public.Stock.create({
        productId: data.productId,
        locationId: data.locationId,
        quantity: data.quantity as any,
    });
    
    return db.orm.public.Stock
        .where({
            productId: data.productId,
            locationId: data.locationId,
        })
        .include("product", (p: any) => p.include("category").include("unit"))
        .include("location", (l: any) => l.include("warehouse"))
        .first();
}

/**
 * Update stock quantity.
 */
export async function updateStockQuantity(
    productId: bigint,
    locationId: bigint,
    quantity: string,
    tx: any = prisma,
) {
    const db = tx.orm ? tx : prisma;
    await db.orm.public.Stock
        .where({
            productId,
            locationId,
        })
        .update({
            quantity: quantity as any,
        });
        
    return db.orm.public.Stock
        .where({
            productId,
            locationId,
        })
        .include("product", (p: any) => p.include("category").include("unit"))
        .include("location", (l: any) => l.include("warehouse"))
        .first();
}