import { z } from "zod";

// --------------------
// Warehouse
// --------------------

export const createWarehouseSchema = z.object({
    name: z
        .string()
        .trim()
        .min(2, "Warehouse name must be at least 2 characters")
        .max(120, "Warehouse name cannot exceed 120 characters"),

    code: z
        .string()
        .trim()
        .min(2, "Warehouse code must be at least 2 characters")
        .max(50, "Warehouse code cannot exceed 50 characters")
        .toUpperCase(),

    address: z
        .string()
        .trim()
        .max(500, "Address cannot exceed 500 characters")
        .optional(),
});

export const updateWarehouseSchema =
    createWarehouseSchema.partial().extend({
        isActive: z.boolean().optional(),
    });

// --------------------
// Location
// --------------------

export const createLocationSchema = z.object({
    warehouseId: z.coerce.bigint({
        message: "Invalid warehouse",
    }),

    name: z
        .string()
        .trim()
        .min(2, "Location name must be at least 2 characters")
        .max(120, "Location name cannot exceed 120 characters"),

    code: z
        .string()
        .trim()
        .min(1, "Location code is required")
        .max(50, "Location code cannot exceed 50 characters")
        .toUpperCase(),

    description: z
        .string()
        .trim()
        .max(500, "Description cannot exceed 500 characters")
        .optional(),
});

export const updateLocationSchema =
    createLocationSchema
        .omit({
            warehouseId: true,
        })
        .partial()
        .extend({
            isActive: z.boolean().optional(),
        });