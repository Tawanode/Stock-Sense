import { prisma } from "../../config/database.js";

// --------------------
// Warehouses
// --------------------

export async function findWarehouses() {
    return prisma.orm.public.Warehouses.include("locations", (l: any) =>
        l.orderBy((q: any) => q.name.asc()),
    )
        .orderBy((q: any) => q.name.asc())
        .all();
}

export async function findWarehouseById(id: bigint) {
    return prisma.orm.public.Warehouses.include("locations", (l: any) =>
        l.orderBy((q: any) => q.name.asc()),
    )
        .where({ id })
        .first();
}

export async function findWarehouseByCode(code: string) {
    return prisma.orm.public.Warehouses.where({ code: code as any }).first();
}

export async function createWarehouse(data: {
    name: string;
    code: string;
    address?: string;
}) {
    return prisma.orm.public.Warehouses.create({
        name: data.name as any,
        code: data.code as any,
        address: data.address as any,
    });
}

export async function updateWarehouse(
    id: bigint,
    data: {
        name?: string;
        code?: string;
        address?: string;
        isActive?: boolean;
    },
) {
    const updateData: any = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.code !== undefined) updateData.code = data.code;
    if (data.address !== undefined) updateData.address = data.address;
    if (data.isActive !== undefined) updateData.isActive = data.isActive;

    return prisma.orm.public.Warehouses.where({ id }).update(updateData);
}

// --------------------
// Locations
// --------------------

export async function findLocations(warehouseId?: bigint) {
    let query = prisma.orm.public.Locations.include("warehouse", (w: any) => w);
    
    if (warehouseId) {
        query = query.where({ warehouseId }) as any;
    }

    return query.orderBy((q: any) => q.name.asc()).all();
}

export async function findLocationById(id: bigint) {
    return prisma.orm.public.Locations.include("warehouse", (w: any) => w)
        .where({ id })
        .first();
}

export async function findLocationByCode(
    warehouseId: bigint,
    code: string,
) {
    return prisma.orm.public.Locations.where({ warehouseId, code: code as any }).first();
}

export async function findLocationByName(
    warehouseId: bigint,
    name: string,
) {
    return prisma.orm.public.Locations.where({ warehouseId, name: name as any }).first();
}

export async function createLocation(data: {
    warehouseId: bigint;
    name: string;
    code: string;
    description?: string;
}) {
    return prisma.orm.public.Locations.create({
        warehouseId: data.warehouseId,
        name: data.name as any,
        code: data.code as any,
        description: data.description as any,
    });
}

export async function updateLocation(
    id: bigint,
    data: {
        name?: string;
        code?: string;
        description?: string;
        isActive?: boolean;
    },
) {
    const updateData: any = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.code !== undefined) updateData.code = data.code;
    if (data.description !== undefined) updateData.description = data.description;
    if (data.isActive !== undefined) updateData.isActive = data.isActive;

    return prisma.orm.public.Locations.where({ id }).update(updateData);
}