import * as repository from "./warehouse.repository.js";

function serializeWarehouse(warehouse: any) {
    return {
        ...warehouse,

        id: warehouse.id.toString(),

        locations:
            warehouse.locations?.map((location: any) => ({
                ...location,
                id: location.id.toString(),
                warehouseId: location.warehouseId.toString(),
            })) ?? [],
    };
}

function serializeLocation(location: any) {
    return {
        ...location,

        id: location.id.toString(),
        warehouseId: location.warehouseId.toString(),

        warehouse: location.warehouse
            ? {
                ...location.warehouse,
                id: location.warehouse.id.toString(),
            }
            : undefined,
    };
}

// --------------------
// Warehouses
// --------------------

export async function getWarehouses() {
    const warehouses = await repository.findWarehouses();

    return warehouses.map(serializeWarehouse);
}

export async function getWarehouse(id: bigint) {
    const warehouse = await repository.findWarehouseById(id);

    if (!warehouse) {
        throw new Error("Warehouse not found");
    }

    return serializeWarehouse(warehouse);
}

export async function createWarehouse(data: {
    name: string;
    code: string;
    address?: string;
}) {
    const existing = await repository.findWarehouseByCode(
        data.code,
    );

    if (existing) {
        throw new Error("A warehouse with this code already exists");
    }

    const warehouse = await repository.createWarehouse(data);

    return serializeWarehouse(warehouse);
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
    const existing = await repository.findWarehouseById(id);

    if (!existing) {
        throw new Error("Warehouse not found");
    }

    if (data.code && data.code !== existing.code) {
        const duplicate = await repository.findWarehouseByCode(
            data.code,
        );

        if (duplicate) {
            throw new Error(
                "A warehouse with this code already exists",
            );
        }
    }

    const warehouse = await repository.updateWarehouse(
        id,
        data,
    );

    return serializeWarehouse(warehouse);
}

// --------------------
// Locations
// --------------------

export async function getLocations(warehouseId?: bigint) {
    const locations =
        await repository.findLocations(warehouseId);

    return locations.map(serializeLocation);
}

export async function getLocation(id: bigint) {
    const location =
        await repository.findLocationById(id);

    if (!location) {
        throw new Error("Location not found");
    }

    return serializeLocation(location);
}

export async function createLocation(data: {
    warehouseId: bigint;
    name: string;
    code: string;
    description?: string;
}) {
    const warehouse =
        await repository.findWarehouseById(data.warehouseId);

    if (!warehouse) {
        throw new Error("Warehouse not found");
    }

    if (!warehouse.isActive) {
        throw new Error(
            "Cannot create a location inside an inactive warehouse",
        );
    }

    const existingCode =
        await repository.findLocationByCode(
            data.warehouseId,
            data.code,
        );

    if (existingCode) {
        throw new Error(
            "A location with this code already exists in this warehouse",
        );
    }

    const existingName =
        await repository.findLocationByName(
            data.warehouseId,
            data.name,
        );

    if (existingName) {
        throw new Error(
            "A location with this name already exists in this warehouse",
        );
    }

    const location =
        await repository.createLocation(data);

    return serializeLocation(location);
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
    const existing =
        await repository.findLocationById(id);

    if (!existing) {
        throw new Error("Location not found");
    }

    if (data.code && data.code !== existing.code) {
        const duplicate =
            await repository.findLocationByCode(
                existing.warehouseId,
                data.code,
            );

        if (duplicate) {
            throw new Error(
                "A location with this code already exists in this warehouse",
            );
        }
    }

    if (data.name && data.name !== existing.name) {
        const duplicate =
            await repository.findLocationByName(
                existing.warehouseId,
                data.name,
            );

        if (duplicate) {
            throw new Error(
                "A location with this name already exists in this warehouse",
            );
        }
    }

    const location =
        await repository.updateLocation(id, data);

    return serializeLocation(location);
}