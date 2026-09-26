import {
    Request,
    Response,
    NextFunction,
} from "express";

import { ZodError } from "zod";

export function errorHandler(
    error: unknown,
    _req: Request,
    res: Response,
    _next: NextFunction
) {
    console.error("=================================");
    console.error("API ERROR:");
    console.error(error);
    console.error("=================================");

    // Zod validation errors
    if (error instanceof ZodError) {
        return res.status(400).json({
            success: false,
            error: {
                code: "VALIDATION_ERROR",
                message:
                    "Please correct the highlighted fields.",
                fields: error.flatten().fieldErrors,
            },
        });
    }

    // Normal application errors
    if (error instanceof Error) {
        return res.status(400).json({
            success: false,
            error: {
                code: "APPLICATION_ERROR",
                message: error.message,
            },
        });
    }

    return res.status(500).json({
        success: false,
        error: {
            code: "INTERNAL_SERVER_ERROR",
            message:
                "Something went wrong. Please try again.",
        },
    });
}