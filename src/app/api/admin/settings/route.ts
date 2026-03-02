import { NextRequest, NextResponse } from "next/server";
import { getSupabaseServer } from "@/lib/supabase";

export async function GET() {
  const supabase = getSupabaseServer();

  const { data, error } = await supabase
    .from("app_settings")
    .select("key, value");

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  const settings: Record<string, unknown> = {};
  for (const row of data || []) {
    settings[row.key] = row.value;
  }

  return NextResponse.json(settings);
}

export async function PATCH(request: NextRequest) {
  const body = await request.json();
  const supabase = getSupabaseServer();

  const updates: { key: string; value: unknown }[] = [];

  if (body.active_model !== undefined) {
    updates.push({ key: "active_model", value: body.active_model });
  }
  if (body.system_prompt !== undefined) {
    updates.push({ key: "system_prompt", value: body.system_prompt });
  }

  for (const update of updates) {
    const { error } = await supabase
      .from("app_settings")
      .update({ value: update.value, updated_at: new Date().toISOString() })
      .eq("key", update.key);

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }
  }

  return NextResponse.json({ success: true });
}
