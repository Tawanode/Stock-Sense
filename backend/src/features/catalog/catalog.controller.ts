import { Request, Response, NextFunction } from "express";
import {
    createCategorySchema,
    createUnitSchema,
    updateCategorySchema,
    updateUnitSchema,
} from "./catalog.validator.js";
import * as service from "./catalog.service.js";

// --------------------
// Categories
// --------------------

export async function getCategories(
    _req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const categories = await service.getCategories();

        res.json({
            success: true,
            data: categories,
        });
    } catch (error) {
        next(error);
    }
}

export async function createCategory(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const data = createCategorySchema.parse(req.body);

        const category = await service.createCategory(data);

        res.status(201).json({
            success: true,
            message: "Category created successfully",
            data: category,
        });
    } catch (error) {
        next(error);
    }
}

export async function updateCategory(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const id = BigInt(req.params.id as string);

        const data = updateCategorySchema.parse(req.body);

        const category = await service.updateCategory(id, data);

        res.json({
            success: true,
            message: "Category updated successfully",
            data: category,
        });
    } catch (error) {
        next(error);
    }
}

// --------------------
// Units
// --------------------

export async function getUnits(
    _req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const units = await service.getUnits();

        res.json({
            success: true,
            data: units,
        });
    } catch (error) {
        next(error);
    }
}

export async function createUnit(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const data = createUnitSchema.parse(req.body);

        const unit = await service.createUnit(data);

        res.status(201).json({
            success: true,
            message: "Unit created successfully",
            data: unit,
        });
    } catch (error) {
        next(error);
    }
}

export async function updateUnit(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const id = BigInt(req.params.id as string);

        const data = updateUnitSchema.parse(req.body);

        const unit = await service.updateUnit(id, data);

        res.json({
            success: true,
            message: "Unit updated successfully",
            data: unit,
        });
    } catch (error) {
        next(error);
    }
}