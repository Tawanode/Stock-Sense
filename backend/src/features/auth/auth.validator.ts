import { z } from "zod";

export const signupSchema = z.object({
    name: z
        .string()
        .trim()
        .min(2, "Name must contain at least 2 characters")
        .max(120, "Name is too long"),

    email: z
        .string()
        .trim()
        .email("Entered email is invalid")
        .toLowerCase(),

    password: z
        .string()
        .min(8, "Password must contain at least 8 characters")
        .max(72, "Password is too long"),
});

export const loginSchema = z.object({
    email: z
        .string()
        .trim()
        .email("Entered email is invalid")
        .toLowerCase(),

    password: z
        .string()
        .min(1, "Password is required"),
});

export const forgotPasswordSchema = z.object({
    email: z
        .string()
        .trim()
        .email("Entered email is invalid")
        .toLowerCase(),
});

export const verifyOtpSchema = z.object({
    email: z
        .string()
        .trim()
        .email("Entered email is invalid")
        .toLowerCase(),

    otp: z
        .string()
        .regex(/^\d{6}$/, "OTP must contain exactly 6 digits"),
});

export const resetPasswordSchema = z.object({
    email: z
        .string()
        .trim()
        .email("Entered email is invalid")
        .toLowerCase(),

    otp: z
        .string()
        .regex(/^\d{6}$/, "OTP must contain exactly 6 digits"),

    newPassword: z
        .string()
        .min(8, "Password must contain at least 8 characters")
        .max(72, "Password is too long"),
});