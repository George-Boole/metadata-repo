import { NextRequest, NextResponse } from "next/server";

const COOKIE_NAME = "daf-auth-token";

const PUBLIC_PATHS = ["/login", "/api/auth"];

function isPublicPath(pathname: string): boolean {
  return PUBLIC_PATHS.some((p) => pathname.startsWith(p));
}

function isStaticAsset(pathname: string): boolean {
  return (
    pathname.startsWith("/_next") ||
    pathname.startsWith("/favicon") ||
    pathname.endsWith(".ico") ||
    pathname.endsWith(".png") ||
    pathname.endsWith(".svg") ||
    pathname.endsWith(".jpg")
  );
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

interface TokenPayload {
  sub: string;
  role: "admin" | "user";
  iat: number;
}

async function verifyToken(
  token: string,
  secret: string
): Promise<TokenPayload | null> {
  const dotIndex = token.indexOf(".");
  if (dotIndex === -1) return null;

  const payloadB64 = token.slice(0, dotIndex);
  const sig = token.slice(dotIndex + 1);

  const expected = await hmacSha256(secret, payloadB64);
  if (sig !== expected) return null;

  try {
    const payload = JSON.parse(atob(payloadB64)) as TokenPayload;
    if (!payload.sub || !payload.role) return null;
    return payload;
  } catch {
    return null;
  }
}

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  if (isPublicPath(pathname) || isStaticAsset(pathname)) {
    return NextResponse.next();
  }

  const authSecret = process.env.AUTH_SECRET;
  if (!authSecret) {
    // No auth configured — allow all
    return NextResponse.next();
  }

  const token = request.cookies.get(COOKIE_NAME)?.value;

  if (token) {
    const payload = await verifyToken(token, authSecret);
    if (payload) {
      // Admin routes require admin role
      if (pathname.startsWith("/admin") || pathname.startsWith("/api/admin")) {
        if (payload.role !== "admin") {
          return NextResponse.json(
            { error: "Forbidden" },
            { status: 403 }
          );
        }
      }

      // Pass user info in headers for downstream use
      const response = NextResponse.next();
      response.headers.set("x-user", payload.sub);
      response.headers.set("x-user-role", payload.role);
      return response;
    }
  }

  // Not authenticated — redirect to login
  const loginUrl = new URL("/login", request.url);
  loginUrl.searchParams.set("from", pathname);
  return NextResponse.redirect(loginUrl);
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico).*)"],
};
