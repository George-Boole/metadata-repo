import { NextRequest, NextResponse } from "next/server";
import {
  validateSitePassword,
  verifyPasswordHash,
  createToken,
  COOKIE_NAME,
} from "@/lib/auth";
import { getSupabaseServer } from "@/lib/supabase";

export async function POST(request: NextRequest) {
  const body = await request.json();
  const { username, password } = body;

  if (!password) {
    return NextResponse.json(
      { error: "Password is required" },
      { status: 400 }
    );
  }

  let tokenUsername: string;
  let tokenRole: "admin" | "user";

  if (username) {
    // User-based login: look up in database
    const supabase = getSupabaseServer();
    const { data: user } = await supabase
      .from("users")
      .select("id, username, password_hash, role, display_name")
      .eq("username", username)
      .single();

    if (!user) {
      return NextResponse.json(
        { error: "Invalid credentials" },
        { status: 401 }
      );
    }

    const valid = await verifyPasswordHash(password, user.password_hash);
    if (!valid) {
      return NextResponse.json(
        { error: "Invalid credentials" },
        { status: 401 }
      );
    }

    tokenUsername = user.username;
    tokenRole = user.role as "admin" | "user";
  } else {
    // Shared password login: validate against SITE_PASSWORD → admin role
    if (!validateSitePassword(password)) {
      return NextResponse.json(
        { error: "Invalid password" },
        { status: 401 }
      );
    }

    tokenUsername = "admin";
    tokenRole = "admin";
  }

  const token = await createToken(tokenUsername, tokenRole);
  const response = NextResponse.json({
    success: true,
    username: tokenUsername,
    role: tokenRole,
  });

  response.cookies.set(COOKIE_NAME, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    path: "/",
    maxAge: 60 * 60 * 24 * 7, // 7 days
  });

  return response;
}

export async function DELETE() {
  const response = NextResponse.json({ success: true });
  response.cookies.delete(COOKIE_NAME);
  return response;
}
