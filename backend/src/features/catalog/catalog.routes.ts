import { Router } from "express";

import {
    createCategory,
    createUnit,
    getCategories,
    getUnits,
    updateCategory,
    updateUnit,
} from "./catalog.controller.js";

import { requireAuth } from "../../middleware/auth.middleware.js";
import { requireRole } from "../../middleware/role.middleware.js";

const router = Router();

router.use(requireAuth);

// Categories
router.get("/categories", getCategories);

router.post(
    "/categories",
    requireRole("inventory_manager"),
    createCategory,
);

router.patch(
    "/categories/:id",
    requireRole("inventory_manager"),
    updateCategory,
);

// Units
router.get("/units", getUnits);

router.post(
    "/units",
    requireRole("inventory_manager"),
    createUnit,
);

router.patch(
    "/units/:id",
    requireRole("inventory_manager"),
    updateUnit,
);

export default router;