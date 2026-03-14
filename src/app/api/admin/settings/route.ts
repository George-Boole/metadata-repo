import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";
import { adminLimiter, getClientId, rateLimitResponse } from "@/lib/rate-limit";
import { logActivity, getUserFromRequest } from "@/lib/activity-log";

export async function GET(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  try {
    const supabase = getSupabaseServer();

    const { data, error } = await supabase
      .from("app_settings")
      .select("key, value");

    if (error) {
      console.error("Settings GET error:", error);
      return NextResponse.json(
        { error: "Failed to load settings" },
        { status: 500 }
      );
    }

    const settings: Record<string, unknown> = {};
    for (const row of data || []) {
      settings[row.key] = row.value;
    }

    return NextResponse.json(settings);
  } catch (error) {
    console.error("Settings GET error:", error);
    return NextResponse.json(
      { error: "Failed to load settings" },
      { status: 500 }
    );
  }
}

export async function PATCH(request: NextRequest) {
  const clientId = getClientId(request);
  const limit = adminLimiter(clientId);
  if (!limit.success) return rateLimitResponse(limit.reset);

  try {
    const body = await request.json();
    const supabase = getSupabaseServer();

    const updates: { key: string; value: unknown }[] = [];

    if (body.active_model !== undefined) {
      updates.push({ key: "active_model", value: body.active_model });
    }
    if (body.system_prompt !== undefined) {
      updates.push({ key: "system_prompt", value: body.system_prompt });
    }

    if (updates.length === 0) {
      return NextResponse.json(
        { error: "No valid settings provided" },
        { status: 400 }
      );
    }

    for (const update of updates) {
      const { error } = await supabase
        .from("app_settings")
        .update({ value: update.value, updated_at: new Date().toISOString() })
        .eq("key", update.key);

      if (error) {
        console.error("Settings PATCH error:", error);
        return NextResponse.json(
          { error: "Failed to update settings" },
          { status: 500 }
        );
      }
    }

    const actor = getUserFromRequest(request);
    logActivity(actor, "admin_update_settings", "/api/admin/settings", {
      updated_keys: updates.map((u) => u.key),
    });

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Settings PATCH error:", error);
    return NextResponse.json(
      { error: "Failed to update settings" },
      { status: 500 }
    );
  }
}
