import { prisma } from "../../config/database.js";

// --------------------
// Categories
// --------------------

export async function findCategories() {
    return prisma.orm.public.Categories
        .orderBy((q) => q.name.asc())
        .all();
}

export async function findCategoryById(id: bigint) {
    return prisma.orm.public.Categories
        .where({ id })
        .first();
}

export async function findCategoryByName(name: string) {
    return prisma.orm.public.Categories
        .where({ name: name as any })
        .first();
}

export async function createCategory(data: {
    name: string;
    description?: string;
}) {
    return prisma.orm.public.Categories.create({
        name: data.name as any,
        description: data.description,
    });
}

export async function updateCategory(
    id: bigint,
    data: {
        name?: string;
        description?: string;
    },
) {
    const updateData: any = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.description !== undefined) updateData.description = data.description;
    
    return prisma.orm.public.Categories
        .where({ id })
        .update(updateData);
}

// --------------------
// Units
// --------------------

export async function findUnits() {
    return prisma.orm.public.Units
        .orderBy((q) => q.name.asc())
        .all();
}

export async function findUnitById(id: bigint) {
    return prisma.orm.public.Units
        .where({ id })
        .first();
}

export async function findUnitByName(name: string) {
    return prisma.orm.public.Units
        .where({ name: name as any })
        .first();
}

export async function findUnitBySymbol(symbol: string) {
    return prisma.orm.public.Units
        .where({ symbol: symbol as any })
        .first();
}

export async function createUnit(data: {
    name: string;
    symbol: string;
}) {
    return prisma.orm.public.Units.create({
        name: data.name as any,
        symbol: data.symbol as any,
    });
}

export async function updateUnit(
    id: bigint,
    data: {
        name?: string;
        symbol?: string;
    },
) {
    const updateData: any = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.symbol !== undefined) updateData.symbol = data.symbol;
    
    return prisma.orm.public.Units
        .where({ id })
        .update(updateData);
}