export interface AuthUser {
    id: number;
    name: string;
    email: string;
    role: string;
}

export interface AuthenticatedRequestUser {
    id: number;
    roleId: number;
    role: string;
}