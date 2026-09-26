import jwt from "jsonwebtoken";
import { env } from "../config/env.js";

export interface JwtPayload {
    userId: number;
    roleId: number;
}

export function generateToken(payload: JwtPayload): string {
    return jwt.sign(payload, env.jwtSecret, {
        expiresIn: "8h",
    });
}

export function verifyToken(token: string): JwtPayload {
    return jwt.verify(
        token,
        env.jwtSecret
    ) as JwtPayload;
}
