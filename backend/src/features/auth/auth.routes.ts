import { Router } from "express";

import {
    signupController,
    loginController,
    logoutController,
    forgotPasswordController,
    verifyOtpController,
    resetPasswordController,
    meController,
} from "./auth.controller.js";

import { requireAuth } from "../../middleware/auth.middleware.js";

const router = Router();

router.post(
    "/signup",
    signupController
);

router.post(
    "/login",
    loginController
);

router.post(
    "/logout",
    requireAuth,
    logoutController
);

router.post(
    "/forgot-password",
    forgotPasswordController
);

router.post(
    "/verify-otp",
    verifyOtpController
);

router.post(
    "/reset-password",
    resetPasswordController
);

router.get(
    "/me",
    requireAuth,
    meController
);

export default router;