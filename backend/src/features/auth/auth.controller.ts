import { Request, Response, NextFunction } from "express";

import {
    signupSchema,
    loginSchema,
    forgotPasswordSchema,
    verifyOtpSchema,
    resetPasswordSchema,
} from "./auth.validator.js";

import {
    signup,
    login,
    requestPasswordReset,
    verifyPasswordResetOtp,
    resetPassword,
} from "./auth.service.js";

function setAuthCookie(
    res: Response,
    token: string
) {
    res.cookie("stocksense_token", token, {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "lax",
        maxAge: 8 * 60 * 60 * 1000,
    });
}

export async function signupController(
    req: Request,
    res: Response,
    next: NextFunction
) {
    try {
        const data = signupSchema.parse(req.body);

        const result = await signup(data);

        setAuthCookie(res, result.token);

        res.status(201).json({
            success: true,
            data: {
                user: result.user,
            },
        });
    } catch (error) {
        next(error);
    }
}

export async function loginController(
    req: Request,
    res: Response,
    next: NextFunction
) {
    try {
        const data = loginSchema.parse(req.body);

        const result = await login(data);

        setAuthCookie(res, result.token);

        res.json({
            success: true,
            data: {
                user: result.user,
            },
        });
    } catch (error) {
        next(error);
    }
}

export async function logoutController(
    _req: Request,
    res: Response
) {
    res.clearCookie("stocksense_token");

    res.json({
        success: true,
        message: "Logged out successfully",
    });
}

export async function forgotPasswordController(
    req: Request,
    res: Response,
    next: NextFunction
) {
    try {
        const { email } =
            forgotPasswordSchema.parse(req.body);

        await requestPasswordReset(email);

        res.json({
            success: true,
            message:
                "If an account exists with this email, an OTP has been sent.",
        });
    } catch (error) {
        next(error);
    }
}

export async function verifyOtpController(
    req: Request,
    res: Response,
    next: NextFunction
) {
    try {
        const data = verifyOtpSchema.parse(req.body);

        const result =
            await verifyPasswordResetOtp(
                data.email,
                data.otp
            );

        res.json({
            success: true,
            data: result,
        });
    } catch (error) {
        next(error);
    }
}

export async function resetPasswordController(
    req: Request,
    res: Response,
    next: NextFunction
) {
    try {
        const data =
            resetPasswordSchema.parse(req.body);

        await resetPassword(data);

        res.json({
            success: true,
            message:
                "Password reset successfully. You can now log in.",
        });
    } catch (error) {
        next(error);
    }
}

export async function meController(
    req: Request,
    res: Response
) {
    res.json({
        success: true,
        data: {
            user: req.user,
        },
    });
}