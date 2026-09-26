import crypto from "crypto";
import bcrypt from "bcrypt";

export function generateOtp(): string {
    return crypto
        .randomInt(100000, 1000000)
        .toString();
}

export async function hashOtp(
    otp: string
): Promise<string> {
    return bcrypt.hash(otp, 10);
}

export async function verifyOtp(
    otp: string,
    otpHash: string
): Promise<boolean> {
    return bcrypt.compare(otp, otpHash);
}