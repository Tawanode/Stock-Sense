import { Request, Response, NextFunction } from "express";

import {
    createLocationSchema,
    createWarehouseSchema,
    updateLocationSchema,
    updateWarehouseSchema,
} from "./warehouse.validator.js";

import * as service from "./warehouse.service.js";

// --------------------
// Warehouses
// --------------------

export async function getWarehouses(
    _req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const warehouses =
            await service.getWarehouses();

        res.json({
            success: true,
            data: warehouses,
        });
    } catch (error) {
        next(error);
    }
}

export async function getWarehouse(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const id = BigInt(req.params.id as string);

        const warehouse =
            await service.getWarehouse(id);

        res.json({
            success: true,
            data: warehouse,
        });
    } catch (error) {
        next(error);
    }
}

export async function createWarehouse(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const data =
            createWarehouseSchema.parse(req.body);

        const warehouse =
            await service.createWarehouse(data);

        res.status(201).json({
            success: true,
            message: "Warehouse created successfully",
            data: warehouse,
        });
    } catch (error) {
        next(error);
    }
}

export async function updateWarehouse(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const id = BigInt(req.params.id as string);

        const data =
            updateWarehouseSchema.parse(req.body);

        const warehouse =
            await service.updateWarehouse(id, data);

        res.json({
            success: true,
            message: "Warehouse updated successfully",
            data: warehouse,
        });
    } catch (error) {
        next(error);
    }
}

// --------------------
// Locations
// --------------------

export async function getLocations(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const warehouseId = req.query.warehouseId
            ? BigInt(String(req.query.warehouseId))
            : undefined;

        const locations =
            await service.getLocations(warehouseId);

        res.json({
            success: true,
            data: locations,
        });
    } catch (error) {
        next(error);
    }
}

export async function getLocation(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const id = BigInt(req.params.id as string);

        const location =
            await service.getLocation(id);

        res.json({
            success: true,
            data: location,
        });
    } catch (error) {
        next(error);
    }
}

export async function createLocation(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const data =
            createLocationSchema.parse(req.body);

        const location =
            await service.createLocation(data);

        res.status(201).json({
            success: true,
            message: "Location created successfully",
            data: location,
        });
    } catch (error) {
        next(error);
    }
}

export async function updateLocation(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const id = BigInt(req.params.id as string);

        const data =
            updateLocationSchema.parse(req.body);

        const location =
            await service.updateLocation(id, data);

        res.json({
            success: true,
            message: "Location updated successfully",
            data: location,
        });
    } catch (error) {
        next(error);
    }
}