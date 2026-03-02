import { cookies } from "next/headers";

const COOKIE_NAME = "daf-auth-token";

function getAuthSecret(): string {
  const secret = process.env.AUTH_SECRET;
  if (!secret) throw new Error("AUTH_SECRET not set");
  return secret;
}

function getSitePassword(): string {
  const password = process.env.SITE_PASSWORD;
  if (!password) throw new Error("SITE_PASSWORD not set");
  return password;
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

export async function generateToken(password: string): Promise<string> {
  return hmacSha256(getAuthSecret(), password);
}

export function validatePassword(password: string): boolean {
  return password === getSitePassword();
}

export async function getExpectedToken(): Promise<string> {
  return generateToken(getSitePassword());
}

export async function isAuthenticated(): Promise<boolean> {
  const cookieStore = await cookies();
  const token = cookieStore.get(COOKIE_NAME)?.value;
  if (!token) return false;
  return token === (await getExpectedToken());
}

export { COOKIE_NAME };
