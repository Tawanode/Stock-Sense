import { z } from "zod";

export const createProductSchema = z.object({
    name: z
        .string()
        .min(2, "Product name must be at least 2 characters")
        .max(150, "Product name cannot exceed 150 characters"),

    sku: z
        .string()
        .min(2, "SKU must be at least 2 characters")
        .max(80, "SKU cannot exceed 80 characters")
        .trim()
        .toUpperCase(),

    categoryId: z.coerce.bigint({
        message: "Invalid category",
    }),

    unitId: z.coerce.bigint({
        message: "Invalid unit",
    }),
});

export const updateProductSchema = createProductSchema.partial().extend({
    isActive: z.boolean().optional(),
});

export const productQuerySchema = z.object({
    search: z.string().optional(),
    categoryId: z.coerce.bigint().optional(),
    isActive: z
        .enum(["true", "false"])
        .transform((value) => value === "true")
        .optional(),
});