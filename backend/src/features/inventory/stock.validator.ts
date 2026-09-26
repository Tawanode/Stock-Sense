import { z } from "zod";

const quantitySchema = z
  .string()
  .trim()
  .regex(
    /^\d+(\.\d{1,3})?$/,
    "Quantity must be a positive number with up to 3 decimal places",
  );

export const stockQuerySchema = z.object({
  productId: z.coerce.bigint().optional(),
  locationId: z.coerce.bigint().optional(),
});

export const setStockSchema = z.object({
  productId: z.coerce.bigint({
    message: "Invalid product",
  }),

  locationId: z.coerce.bigint({
    message: "Invalid location",
  }),

  quantity: quantitySchema,
});
