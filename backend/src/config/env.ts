import "dotenv/config";

const requiredEnv = [
    "DATABASE_URL",
    "JWT_SECRET",
];

for (const key of requiredEnv) {
    if (!process.env[key]) {
        throw new Error(`Missing required environment variable: ${key}`);
    }
}

export const env = {
    port: Number(process.env.PORT ?? 5000),

    databaseUrl: process.env.DATABASE_URL!,

    jwtSecret: process.env.JWT_SECRET!,

    clientUrl: process.env.CLIENT_URL ?? "http://localhost:5173",

    otpExpiryMinutes: Number(
        process.env.OTP_EXPIRY_MINUTES ?? 10
    ),

    nodeEnv: process.env.NODE_ENV ?? "development",
};