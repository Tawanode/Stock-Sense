// To be implemented
import {
    Request,
    Response,
    NextFunction,
} from "express";

import {
    setStockSchema,
    stockQuerySchema,
} from "./stock.validator.js";

import * as service from "./stock.service.js";

export async function getAllStock(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const query =
            stockQuerySchema.parse(req.query);

        const stock =
            await service.getAllStock(query);

        res.json({
            success: true,
            data: stock,
        });
    } catch (error) {
        next(error);
    }
}

export async function getProductStock(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const productId =
            BigInt(req.params.productId as string);

        const stock =
            await service.getProductStock(productId);

        res.json({
            success: true,
            data: stock,
        });
    } catch (error) {
        next(error);
    }
}

export async function getLocationStock(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const locationId =
            BigInt(req.params.locationId as string);

        const stock =
            await service.getLocationStock(locationId);

        res.json({
            success: true,
            data: stock,
        });
    } catch (error) {
        next(error);
    }
}

export async function getStock(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const productId =
            BigInt(req.params.productId as string);

        const locationId =
            BigInt(req.params.locationId as string);

        const stock =
            await service.getStock(
                productId,
                locationId,
            );

        res.json({
            success: true,
            data: stock,
        });
    } catch (error) {
        next(error);
    }
}

export async function setStock(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const data =
            setStockSchema.parse(req.body);

        const stock =
            await service.setStockQuantity(
                data.productId,
                data.locationId,
                data.quantity,
            );

        res.json({
            success: true,
            message: "Stock updated successfully",
            data: stock,
        });
    } catch (error) {
        next(error);
    }
}