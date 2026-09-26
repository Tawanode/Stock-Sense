import { prisma } from "../../config/database.js";

export async function findProducts(params: {
    search?: string;
    categoryId?: bigint;
    isActive?: boolean;
}) {
    const { search, categoryId, isActive } = params;

    let query = prisma.orm.public.Products.where({});
    
    if (isActive !== undefined) {
        query = query.where({ isActive });
    }
    
    if (categoryId !== undefined) {
        query = query.where({ categoryId: BigInt(categoryId) });
    }
    
    if (search) {
        query = query.where((q: any) => q.or(
            q.name.ilike(`%${search}%`),
            q.sku.ilike(`%${search}%`)
        ));
    }

    return query
        .include("category")
        .include("unit")
        .include("stocks", (s: any) => s.include("location", (l: any) => l.include("warehouse")))
        .include("reorderRules", (r: any) => r.include("location"))
        .orderBy((q: any) => q.createdAt.desc())
        .all();
}

export async function findProductById(id: bigint) {
    return prisma.orm.public.Products
        .where({ id: BigInt(id) })
        .include("category")
        .include("unit")
        .include("stocks", (s: any) => s.include("location", (l: any) => l.include("warehouse")))
        .include("reorderRules", (r: any) => r.include("location"))
        .first();
}

export async function findProductBySku(sku: string) {
    return prisma.orm.public.Products
        .where({ sku: sku as any })
        .first();
}

export async function createProduct(data: {
    name: string;
    sku: string;
    categoryId: bigint;
    unitId: bigint;
}) {
    return prisma.orm.public.Products.create({
        name: data.name as any,
        sku: data.sku as any,
        categoryId: BigInt(data.categoryId),
        unitId: BigInt(data.unitId),
    });
}

export async function updateProduct(
    id: bigint,
    data: {
        name?: string;
        sku?: string;
        categoryId?: bigint;
        unitId?: bigint;
        isActive?: boolean;
    }
) {
    const updateData: any = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.sku !== undefined) updateData.sku = data.sku;
    if (data.categoryId !== undefined) updateData.categoryId = BigInt(data.categoryId);
    if (data.unitId !== undefined) updateData.unitId = BigInt(data.unitId);
    if (data.isActive !== undefined) updateData.isActive = data.isActive;

    return prisma.orm.public.Products
        .where({ id: BigInt(id) })
        .update(updateData);
}