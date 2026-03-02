"use client";

import { Suspense, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";

function LoginForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const from = searchParams.get("from") || "/";
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const res = await fetch("/api/auth", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          username: username.trim() || undefined,
          password,
        }),
      });

      if (res.ok) {
        router.push(from);
        router.refresh();
      } else {
        const data = await res.json();
        setError(data.error || "Invalid credentials");
        setPassword("");
      }
    } catch {
      setError("Something went wrong. Please try again.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="rounded-xl bg-white p-8 shadow-lg">
      {/* DAF Branding */}
      <div className="mb-8 text-center">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-lg bg-daf-navy text-lg font-bold text-white">
          DAF
        </div>
        <h1 className="text-xl font-semibold text-daf-dark-gray">
          Metadata Repository
        </h1>
        <p className="mt-1 text-sm text-daf-gray">
          Department of the Air Force — Prototype
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label
            htmlFor="username"
            className="block text-sm font-medium text-daf-dark-gray"
          >
            Username{" "}
            <span className="font-normal text-gray-400">(optional)</span>
          </label>
          <input
            id="username"
            type="text"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            placeholder="Leave blank for shared password"
            autoFocus
            autoComplete="username"
            className="mt-1 w-full rounded-lg border border-gray-300 px-4 py-2.5 text-sm text-daf-dark-gray placeholder-gray-400 focus:border-daf-blue focus:outline-none focus:ring-2 focus:ring-daf-blue/20"
          />
        </div>

        <div>
          <label
            htmlFor="password"
            className="block text-sm font-medium text-daf-dark-gray"
          >
            Password
          </label>
          <input
            id="password"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Enter password"
            required
            autoComplete="current-password"
            className="mt-1 w-full rounded-lg border border-gray-300 px-4 py-2.5 text-sm text-daf-dark-gray placeholder-gray-400 focus:border-daf-blue focus:outline-none focus:ring-2 focus:ring-daf-blue/20"
          />
        </div>

        {error && <p className="text-sm text-red-600">{error}</p>}

        <button
          type="submit"
          disabled={loading || !password}
          className="w-full rounded-lg bg-daf-navy px-4 py-2.5 text-sm font-medium text-white hover:bg-daf-blue focus:outline-none focus:ring-2 focus:ring-daf-blue/50 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {loading ? "Signing in..." : "Sign In"}
        </button>
      </form>
    </div>
  );
}

export default function LoginPage() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-daf-light-gray px-4">
      <div className="w-full max-w-sm">
        <Suspense
          fallback={
            <div className="rounded-xl bg-white p-8 shadow-lg text-center text-daf-gray">
              Loading...
            </div>
          }
        >
          <LoginForm />
        </Suspense>

        <p className="mt-4 text-center text-xs text-daf-gray">
          This is a prototype for demonstration purposes only.
        </p>
      </div>
    </div>
  );
}
