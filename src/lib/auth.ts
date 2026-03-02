import { cookies } from "next/headers";

export const COOKIE_NAME = "daf-auth-token";

function getAuthSecret(): string {
  const secret = process.env.AUTH_SECRET;
  if (!secret) throw new Error("AUTH_SECRET not set");
  return secret;
}

async function hmacSha256(secret: string, message: string): Promise<string> {
  const encoder = new TextEncoder();
  const key = await crypto.subtle.importKey(
    "raw",
    encoder.encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );
  const signature = await crypto.subtle.sign(
    "HMAC",
    key,
    encoder.encode(message)
  );
  return Array.from(new Uint8Array(signature))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

async function sha256(message: string): Promise<string> {
  const encoder = new TextEncoder();
  const hash = await crypto.subtle.digest("SHA-256", encoder.encode(message));
  return Array.from(new Uint8Array(hash))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

// --- Password hashing (for stored users) ---

export async function hashPassword(password: string): Promise<string> {
  const saltArray = crypto.getRandomValues(new Uint8Array(16));
  const salt = Array.from(saltArray)
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
  const hash = await sha256(salt + password);
  return `${salt}:${hash}`;
}

export async function verifyPasswordHash(
  password: string,
  stored: string
): Promise<boolean> {
  const [salt, hash] = stored.split(":");
  if (!salt || !hash) return false;
  const computed = await sha256(salt + password);
  return computed === hash;
}

// --- Token management ---

export interface TokenPayload {
  sub: string; // username
  role: "admin" | "user";
  iat: number; // issued at (ms)
}

export async function createToken(
  username: string,
  role: "admin" | "user"
): Promise<string> {
  const payload: TokenPayload = { sub: username, role, iat: Date.now() };
  const payloadB64 = btoa(JSON.stringify(payload));
  const sig = await hmacSha256(getAuthSecret(), payloadB64);
  return `${payloadB64}.${sig}`;
}

export async function verifyToken(
  token: string
): Promise<TokenPayload | null> {
  const dotIndex = token.indexOf(".");
  if (dotIndex === -1) return null;

  const payloadB64 = token.slice(0, dotIndex);
  const sig = token.slice(dotIndex + 1);

  const expected = await hmacSha256(getAuthSecret(), payloadB64);
  if (sig !== expected) return null;

  try {
    const payload = JSON.parse(atob(payloadB64)) as TokenPayload;
    if (!payload.sub || !payload.role) return null;
    return payload;
  } catch {
    return null;
  }
}

// --- Shared password validation (admin fallback) ---

export function validateSitePassword(password: string): boolean {
  const sitePassword = process.env.SITE_PASSWORD;
  if (!sitePassword) return false;
  return password === sitePassword;
}

// --- Session helpers (server components / API routes) ---

export async function getSession(): Promise<TokenPayload | null> {
  const cookieStore = await cookies();
  const token = cookieStore.get(COOKIE_NAME)?.value;
  if (!token) return null;
  return verifyToken(token);
}

export async function isAuthenticated(): Promise<boolean> {
  return (await getSession()) !== null;
}

export async function isAdmin(): Promise<boolean> {
  const session = await getSession();
  return session?.role === "admin";
}

// --- Legacy token support (for middleware backward compat) ---
// The middleware duplicates hmacSha256 since it can't import from next/headers

export async function generateLegacyToken(password: string): Promise<string> {
  return hmacSha256(getAuthSecret(), password);
}
