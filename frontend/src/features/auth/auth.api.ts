import { api } from "../../services/api";

export interface User {
    id: number;
    name: string;
    email: string;
    role: string;
}

export async function signup(data: {
    name: string;
    email: string;
    password: string;
}) {
    const response = await api.post(
        "/auth/signup",
        data
    );

    return response.data;
}

export async function login(data: {
    email: string;
    password: string;
}) {
    const response = await api.post(
        "/auth/login",
        data
    );

    return response.data;
}

export async function logout() {
    const response = await api.post(
        "/auth/logout"
    );

    return response.data;
}

export async function getCurrentUser() {
    const response = await api.get(
        "/auth/me"
    );

    return response.data;
}

export async function forgotPassword(
    email: string
) {
    const response = await api.post(
        "/auth/forgot-password",
        { email }
    );

    return response.data;
}

export async function verifyOtp(
    email: string,
    otp: string
) {
    const response = await api.post(
        "/auth/verify-otp",
        {
            email,
            otp,
        }
    );

    return response.data;
}

export async function resetPassword(data: {
    email: string;
    otp: string;
    newPassword: string;
}) {
    const response = await api.post(
        "/auth/reset-password",
        data
    );

    return response.data;
}