import express from "express";
import cors from "cors";
import cookieParser from "cookie-parser";

import { env } from "./config/env.js";
import authRoutes from "./features/auth/auth.routes.js";
import productRoutes from "./features/products/product.routes.js";
import catalogRoutes from "./features/catalog/catalog.routes.js";
import warehouseRoutes from "./features/warehouse/warehouse.routes.js";
import stockRoutes from "./features/inventory/stock.routes.js";
import { errorHandler } from "./middleware/error.middleware.js";

const app = express();

app.use(
  cors({
    origin: env.clientUrl,
    credentials: true,
  })
);

app.use(express.json());

app.use(cookieParser());

app.get("/api/health", (_req, res) => {
  res.json({
    success: true,
    message: "StockSense API is running",
  });
});

app.use(
  "/api/auth",
  authRoutes
);

app.use("/api/products", productRoutes);
app.use("/api/catalog", catalogRoutes);
app.use("/api/warehouses", warehouseRoutes);
app.use("/api/inventory/stock", stockRoutes);

app.use(errorHandler);

export default app;