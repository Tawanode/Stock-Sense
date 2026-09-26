/* eslint-disable react-refresh/only-export-components */
import {
    createContext,
    useContext,
    useEffect,
    useState,
} from "react";
import type { ReactNode } from "react";

import {
    getCurrentUser,
    login as loginApi,
    logout as logoutApi,
    signup as signupApi,
} from "./auth.api";
import type { User } from "./auth.api";

interface AuthContextType {
    user: User | null;
    loading: boolean;
    login: (
        email: string,
        password: string
    ) => Promise<void>;
    signup: (
        name: string,
        email: string,
        password: string
    ) => Promise<void>;
    logout: () => Promise<void>;
}

const AuthContext =
    createContext<AuthContextType | undefined>(
        undefined
    );

export function AuthProvider({
    children,
}: {
    children: ReactNode;
}) {
    const [user, setUser] =
        useState<User | null>(null);

    const [loading, setLoading] =
        useState(true);

    useEffect(() => {
        async function loadUser() {
            try {
                const result =
                    await getCurrentUser();

                setUser(result.data.user);
            } catch {
                setUser(null);
            } finally {
                setLoading(false);
            }
        }

        loadUser();
    }, []);

    async function login(
        email: string,
        password: string
    ) {
        const result = await loginApi({
            email,
            password,
        });

        setUser(result.data.user);
    }

    async function signup(
        name: string,
        email: string,
        password: string
    ) {
        const result = await signupApi({
            name,
            email,
            password,
        });

        setUser(result.data.user);
    }

    async function logout() {
        await logoutApi();
        setUser(null);
    }

    return (
        <AuthContext.Provider
      value= {{
        user,
            loading,
            login,
            signup,
            logout,
      }
}
    >
    { children }
    </AuthContext.Provider>
  );
}

export function useAuth() {
    const context =
        useContext(AuthContext);

    if (!context) {
        throw new Error(
            "useAuth must be used inside AuthProvider"
        );
    }

    return context;
}