// To be implemented
import { Router } from "express";

import {
    getAllStock,
    getLocationStock,
    getProductStock,
    getStock,
    setStock,
} from "./stock.controller.js";

import { requireAuth } from "../../middleware/auth.middleware.js";
import { requireRole } from "../../middleware/role.middleware.js";

const router = Router();

router.use(requireAuth);

// Read stock
router.get("/", getAllStock);

router.get(
    "/product/:productId",
    getProductStock,
);

router.get(
    "/location/:locationId",
    getLocationStock,
);

router.get(
    "/product/:productId/location/:locationId",
    getStock,
);

// Temporary foundation endpoint.
// Later receipts/transfers/deliveries/adjustments
// will use the inventory transaction service instead.
router.post(
    "/set",
    requireRole("inventory_manager"),
    setStock,
);

export default router;