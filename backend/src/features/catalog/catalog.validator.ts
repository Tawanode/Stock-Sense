import { z } from "zod";

export const createCategorySchema = z.object({
    name: z
        .string()
        .trim()
        .min(2, "Category name must be at least 2 characters")
        .max(100, "Category name cannot exceed 100 characters"),

    description: z
        .string()
        .trim()
        .max(500, "Description cannot exceed 500 characters")
        .optional(),
});

export const updateCategorySchema = createCategorySchema.partial();

export const createUnitSchema = z.object({
    name: z
        .string()
        .trim()
        .min(1, "Unit name is required")
        .max(50, "Unit name cannot exceed 50 characters"),

    symbol: z
        .string()
        .trim()
        .min(1, "Unit symbol is required")
        .max(20, "Unit symbol cannot exceed 20 characters"),
});

export const updateUnitSchema = createUnitSchema.partial();