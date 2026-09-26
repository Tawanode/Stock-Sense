import { Request, Response, NextFunction } from "express";

import { verifyToken } from "../utils/jwt.js";
import { findUserById } from "../features/auth/auth.repository.js";

export async function requireAuth(
    req: Request,
    res: Response,
    next: NextFunction
) {
    try {
        const token =
            req.cookies?.stocksense_token;

        if (!token) {
            return res.status(401).json({
                success: false,
                error: {
                    code: "UNAUTHORIZED",
                    message: "Authentication required",
                },
            });
        }

        const payload = verifyToken(token);

        const user = await findUserById(
            payload.userId
        );

        if (!user || !user.isActive) {
            return res.status(401).json({
                success: false,
                error: {
                    code: "UNAUTHORIZED",
                    message: "Invalid authentication session",
                },
            });
        }

        req.user = {
            id: Number(user.id),
            roleId: Number(user.roleId),
            role: user.role!.name,
        };

        next();
    } catch {
        return res.status(401).json({
            success: false,
            error: {
                code: "UNAUTHORIZED",
                message: "Invalid or expired session",
            },
        });
    }
}