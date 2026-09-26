import { Router } from "express";

import {
    createLocation,
    createWarehouse,
    getLocation,
    getLocations,
    getWarehouse,
    getWarehouses,
    updateLocation,
    updateWarehouse,
} from "./warehouse.controller.js";

import { requireAuth } from "../../middleware/auth.middleware.js";
import { requireRole } from "../../middleware/role.middleware.js";

const router = Router();

router.use(requireAuth);

// --------------------
// Warehouses
// --------------------

router.get("/", getWarehouses);

router.get("/:id", getWarehouse);

router.post(
    "/",
    requireRole("inventory_manager"),
    createWarehouse,
);

router.patch(
    "/:id",
    requireRole("inventory_manager"),
    updateWarehouse,
);

// --------------------
// Locations
// --------------------

router.get(
    "/locations/all",
    getLocations,
);

router.get(
    "/locations/:id",
    getLocation,
);

router.post(
    "/locations",
    requireRole("inventory_manager"),
    createLocation,
);

router.patch(
    "/locations/:id",
    requireRole("inventory_manager"),
    updateLocation,
);

export default router;