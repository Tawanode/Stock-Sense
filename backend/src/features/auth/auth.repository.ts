import { prisma } from "../../config/database.js";

export async function findUserByEmail(email: string) {
    return prisma.orm.public.Users
        .where({ email })
        .include("role", (role) => role.select("id", "name", "description", "createdAt"))
        .first();
}

export async function findUserById(id: number | bigint) {
    return prisma.orm.public.Users
        .where({ id: BigInt(id) })
        .include("role", (role) => role.select("id", "name", "description", "createdAt"))
        .first();
}

export async function createUser(data: {
    name: string;
    email: string;
    passwordHash: string;
    roleId: number | bigint;
}) {
    return prisma.orm.public.Users
        .include("role", (role) => role.select("id", "name", "description", "createdAt"))
        .create({
            name: data.name as any,
            email: data.email,
            passwordHash: data.passwordHash,
            roleId: BigInt(data.roleId),
        });
}

export async function findRoleByName(name: string) {
    return prisma.orm.public.Roles
        .where({ name: name as any })
        .first();
}

export async function createPasswordResetOtp(data: {
    userId: number | bigint;
    otpHash: string;
    expiresAt: Date;
}) {
    return prisma.orm.public.PasswordResetOtps.create({
        userId: BigInt(data.userId),
        otpHash: data.otpHash,
        expiresAt: data.expiresAt,
    });
}

export async function findLatestPasswordResetOtp(
    userId: number | bigint
) {
    return prisma.orm.public.PasswordResetOtps
        .where({ userId: BigInt(userId) })
        .where((o) => o.usedAt.isNull())
        .orderBy((o) => o.createdAt.desc())
        .first();
}

export async function markOtpAsUsed(id: number | bigint) {
    return prisma.orm.public.PasswordResetOtps
        .where({ id: BigInt(id) })
        .update({
            usedAt: new Date(),
        });
}

export async function incrementOtpAttempts(id: number | bigint) {
    // Prisma 8 doesn't support nested update like { attempts: { increment: 1 } } in the ORM.
    // We should use the SQL builder for this, or fetch and update. 
    // Since we just need to increment, let's fetch then update, or use SQL builder.
    // I will use fetch and update for simplicity, or SQL builder for atomicity.
    const otp = await prisma.orm.public.PasswordResetOtps.where({ id: BigInt(id) }).first();
    if (otp) {
        return prisma.orm.public.PasswordResetOtps
            .where({ id: BigInt(id) })
            .update({
                attempts: otp.attempts + 1,
            });
    }
    return null;
}

export async function updatePassword(
    userId: number | bigint,
    passwordHash: string
) {
    return prisma.orm.public.Users
        .where({ id: BigInt(userId) })
        .update({
            passwordHash,
        });
}