import { useState } from "react";
import type { FormEvent } from "react";

import { useNavigate } from "react-router-dom";

import { useAuth } from "./AuthContext";

export default function LoginPage() {
    const navigate = useNavigate();

    const { login } = useAuth();

    const [email, setEmail] =
        useState("");

    const [password, setPassword] =
        useState("");

    const [error, setError] =
        useState("");

    const [loading, setLoading] =
        useState(false);

    async function handleSubmit(
        event: FormEvent
    ) {
        event.preventDefault();

        setError("");

        if (!email.includes("@")) {
            setError("Entered email is invalid");
            return;
        }

        if (!password) {
            setError("Password is required");
            return;
        }

        try {
            setLoading(true);

            await login(email, password);

            navigate("/dashboard");
        } catch (error: unknown) {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            const err = error as any;
            setError(
                err?.response?.data?.error
                    ?.message ??
                "Unable to login"
            );
        } finally {
            setLoading(false);
        }
    }

    return (
        <div>
            <h1>Welcome back</h1>

            <form onSubmit={handleSubmit}>
                <input
                    type="email"
                    placeholder="Email"
                    value={email}
                    onChange={(e) =>
                        setEmail(e.target.value)
                    }
                />

                <input
                    type="password"
                    placeholder="Password"
                    value={password}
                    onChange={(e) =>
                        setPassword(e.target.value)
                    }
                />

                {error && (
                    <p role="alert">
                        {error}
                    </p>
                )}

                <button
                    type="submit"
                    disabled={loading}
                >
                    {loading
                        ? "Signing in..."
                        : "Sign in"}
                </button>
            </form>
        </div>
    );
}