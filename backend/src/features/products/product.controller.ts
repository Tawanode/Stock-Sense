import { Request, Response, NextFunction } from "express";

import {
    createProductSchema,
    productQuerySchema,
    updateProductSchema,
} from "./product.validator.js";

import * as service from "./product.service.js";

export async function getProducts(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const query =
            productQuerySchema.parse(req.query);

        const products =
            await service.getProducts(query);

        res.json({
            success: true,
            data: products,
        });
    } catch (error) {
        next(error);
    }
}

export async function getProduct(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const id = BigInt(req.params.id as string);

        const product =
            await service.getProduct(id);

        res.json({
            success: true,
            data: product,
        });
    } catch (error) {
        next(error);
    }
}

export async function createProduct(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const data =
            createProductSchema.parse(req.body);

        const product =
            await service.createProduct(data);

        res.status(201).json({
            success: true,
            message: "Product created successfully",
            data: product,
        });
    } catch (error) {
        next(error);
    }
}

export async function updateProduct(
    req: Request,
    res: Response,
    next: NextFunction,
) {
    try {
        const id = BigInt(req.params.id as string);

        const data =
            updateProductSchema.parse(req.body);

        const product =
            await service.updateProduct(id, data);

        res.json({
            success: true,
            message: "Product updated successfully",
            data: product,
        });
    } catch (error) {
        next(error);
    }
}