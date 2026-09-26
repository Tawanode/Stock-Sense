import { z } from "zod";

export const createProductSchema = z.object({
    name: z
        .string()
        .trim()
        .min(2, "Product name must be at least 2 characters")
        .max(150, "Product name cannot exceed 150 characters"),

    sku: z
        .string()
        .trim()
        .min(2, "SKU must be at least 2 characters")
        .max(80, "SKU cannot exceed 80 characters")
        .transform((value) => value.toUpperCase()),

    categoryId: z.coerce.bigint({
        message: "Invalid category",
    }),

    unitId: z.coerce.bigint({
        message: "Invalid unit",
    }),
});

export const updateProductSchema = z.object({
    name: z
        .string()
        .trim()
        .min(2)
        .max(150)
        .optional(),

    sku: z
        .string()
        .trim()
        .min(2)
        .max(80)
        .transform((value) => value.toUpperCase())
        .optional(),

    categoryId: z.coerce.bigint().optional(),

    unitId: z.coerce.bigint().optional(),

    isActive: z.boolean().optional(),
});

export const productQuerySchema = z.object({
    search: z.string().trim().optional(),

    categoryId: z.coerce.bigint().optional(),

    isActive: z
        .enum(["true", "false"])
        .transform((value) => value === "true")
        .optional(),
});