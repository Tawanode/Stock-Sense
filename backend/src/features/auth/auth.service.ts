import { env } from "../../config/env.js";
import {
    createPasswordResetOtp,
    createUser,
    findLatestPasswordResetOtp,
    findRoleByName,
    findUserByEmail,
    incrementOtpAttempts,
    markOtpAsUsed,
    updatePassword,
} from "./auth.repository.js";

import {
    comparePassword,
    hashPassword,
} from "../../utils/password.js";

import {
    generateOtp,
    hashOtp,
    verifyOtp,
} from "../../utils/otp.js";

import { generateToken } from "../../utils/jwt.js";

export async function signup(data: {
    name: string;
    email: string;
    password: string;
}) {
    const existingUser = await findUserByEmail(data.email);

    if (existingUser) {
        throw new Error("An account with this email already exists");
    }

    const warehouseStaffRole =
        await findRoleByName("warehouse_staff");

    if (!warehouseStaffRole) {
        throw new Error("Default user role is not configured");
    }

    const passwordHash = await hashPassword(
        data.password
    );

    const user = await createUser({
        name: data.name,
        email: data.email,
        passwordHash,
        roleId: warehouseStaffRole.id,
    });

    const token = generateToken({
        userId: Number(user.id),
        roleId: Number(user.roleId),
    });

    return {
        token,
        user: {
            id: Number(user.id),
            name: user.name,
            email: user.email,
            role: user.role!.name,
        },
    };
}

export async function login(data: {
    email: string;
    password: string;
}) {
    const user = await findUserByEmail(data.email);

    if (!user) {
        throw new Error("Invalid email or password");
    }

    if (!user.isActive) {
        throw new Error("This account has been deactivated");
    }

    const passwordValid = await comparePassword(
        data.password,
        user.passwordHash
    );

    if (!passwordValid) {
        throw new Error("Invalid email or password");
    }

    const token = generateToken({
        userId: Number(user.id),
        roleId: Number(user.roleId),
    });

    return {
        token,
        user: {
            id: Number(user.id),
            name: user.name,
            email: user.email,
            role: user.role!.name,
        },
    };
}

export async function requestPasswordReset(
    email: string
) {
    const user = await findUserByEmail(email);

    /*
     * Do not reveal whether an email exists.
     * This prevents account enumeration.
     */
    if (!user) {
        return;
    }

    const otp = generateOtp();
    const otpHash = await hashOtp(otp);

    const expiresAt = new Date(
        Date.now() +
        env.otpExpiryMinutes * 60 * 1000
    );

    await createPasswordResetOtp({
        userId: user.id,
        otpHash,
        expiresAt,
    });

    /*
     * Development fallback.
     *
     * Later we can replace this with an email provider.
     */
    console.log(
        `PASSWORD RESET OTP for ${email}: ${otp}`
    );
}

export async function verifyPasswordResetOtp(
    email: string,
    otp: string
) {
    const user = await findUserByEmail(email);

    if (!user) {
        throw new Error("Invalid or expired OTP");
    }

    const resetOtp =
        await findLatestPasswordResetOtp(user.id);

    if (!resetOtp) {
        throw new Error("Invalid or expired OTP");
    }

    if (resetOtp.attempts >= 5) {
        throw new Error(
            "Too many OTP attempts. Please request a new OTP."
        );
    }

    if (resetOtp.expiresAt < new Date()) {
        throw new Error("OTP has expired");
    }

    const valid = await verifyOtp(
        otp,
        resetOtp.otpHash
    );

    if (!valid) {
        await incrementOtpAttempts(resetOtp.id);
        throw new Error("Invalid OTP");
    }

    return {
        valid: true,
    };
}

export async function resetPassword(data: {
    email: string;
    otp: string;
    newPassword: string;
}) {
    const user = await findUserByEmail(data.email);

    if (!user) {
        throw new Error("Invalid or expired OTP");
    }

    const resetOtp =
        await findLatestPasswordResetOtp(user.id);

    if (!resetOtp) {
        throw new Error("Invalid or expired OTP");
    }

    if (resetOtp.attempts >= 5) {
        throw new Error("Too many OTP attempts");
    }

    if (resetOtp.expiresAt < new Date()) {
        throw new Error("OTP has expired");
    }

    const valid = await verifyOtp(
        data.otp,
        resetOtp.otpHash
    );

    if (!valid) {
        await incrementOtpAttempts(resetOtp.id);
        throw new Error("Invalid OTP");
    }

    const passwordHash =
        await hashPassword(data.newPassword);

    await updatePassword(
        user.id,
        passwordHash
    );

    await markOtpAsUsed(resetOtp.id);
}