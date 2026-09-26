import { Router } from "express";
import {
    createProduct,
    getProduct,
    getProducts,
    updateProduct,
} from "./product.controller.js";
import { requireAuth } from "../../middleware/auth.middleware.js";
import { requireRole } from "../../middleware/role.middleware.js";

const router = Router();

router.use(requireAuth);

router.get("/", getProducts);

router.get("/:id", getProduct);

router.post(
    "/",
    requireRole("inventory_manager"),
    createProduct,
);

router.patch(
    "/:id",
    requireRole("inventory_manager"),
    updateProduct,
);

export default router;