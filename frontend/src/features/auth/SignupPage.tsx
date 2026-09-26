import { useState } from "react";
import type { FormEvent } from "react";

import { useNavigate } from "react-router-dom";

import { useAuth } from "./AuthContext";

export default function SignupPage() {
    const navigate = useNavigate();

    const { signup } = useAuth();

    const [name, setName] =
        useState("");

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

        if (name.trim().length < 2) {
            setError(
                "Name must contain at least 2 characters"
            );
            return;
        }

        if (!email.includes("@")) {
            setError("Entered email is invalid");
            return;
        }

        if (password.length < 8) {
            setError(
                "Password must contain at least 8 characters"
            );
            return;
        }

        try {
            setLoading(true);

            await signup(
                name,
                email,
                password
            );

            navigate("/dashboard");
        } catch (error: unknown) {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            const err = error as any;
            setError(
                err?.response?.data?.error
                    ?.message ??
                "Unable to create account"
            );
        } finally {
            setLoading(false);
        }
    }

    return (
        <div>
            <h1>Create your account</h1>

            <form onSubmit={handleSubmit}>
                <input
                    placeholder="Full name"
                    value={name}
                    onChange={(e) =>
                        setName(e.target.value)
                    }
                />

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
                        ? "Creating account..."
                        : "Create account"}
                </button>
            </form>
        </div>
    );
}