import { NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";

/**
 * Public settings endpoint — returns only public-facing settings (no auth required).
 * Currently exposes: show_stardog
 */
const PUBLIC_KEYS = ["show_stardog"];

export async function GET() {
  try {
    const supabase = getSupabaseServer();

    const { data, error } = await supabase
      .from("app_settings")
      .select("key, value")
      .in("key", PUBLIC_KEYS);

    if (error) {
      console.error("Public settings GET error:", error);
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
    console.error("Public settings GET error:", error);
    return NextResponse.json(
      { error: "Failed to load settings" },
      { status: 500 }
    );
  }
}
