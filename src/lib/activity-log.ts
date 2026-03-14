import { getSupabaseServer } from "@/lib/supabase";

export type ActivityAction =
  | "login"
  | "logout"
  | "chat"
  | "search"
  | "ingest_url"
  | "ingest_upload"
  | "admin_create_user"
  | "admin_delete_user"
  | "admin_update_user"
  | "admin_update_settings"
  | "admin_delete_source";

/**
 * Log a user activity event. Fire-and-forget — never throws.
 * Uses existing auth token identity (x-user header from middleware).
 * No additional cookies — purely server-side tracking.
 */
export function logActivity(
  username: string,
  action: ActivityAction,
  path?: string,
  metadata?: Record<string, unknown>
): void {
  const supabase = getSupabaseServer();
  supabase
    .from("user_activity_log")
    .insert({
      username,
      action,
      path: path ?? null,
      metadata: metadata ?? {},
    })
    .then(({ error }) => {
      if (error) console.error("Activity log insert error:", error.message);
    });
}

/**
 * Update last_login_at and increment login_count atomically via RPC.
 * Called on successful login. Fire-and-forget.
 */
export function recordLogin(username: string): void {
  const supabase = getSupabaseServer();
  supabase
    .rpc("increment_login_count", { target_username: username })
    .then(({ error }) => {
      if (error) console.error("recordLogin error:", error.message);
    });
}

/**
 * Get username from request headers (set by middleware from auth token).
 */
export function getUserFromRequest(request: Request): string {
  return request.headers.get("x-user") || "anonymous";
}
