import { anthropic } from "@ai-sdk/anthropic";
import { google } from "@ai-sdk/google";
import { getSupabaseServer } from "../supabase";
import type { LanguageModel } from "ai";

interface ModelConfig {
  label: string;
  model_id: string;
  provider: "anthropic" | "google";
}

/**
 * Resolve the active model from app_settings to an AI SDK provider instance.
 */
export async function resolveActiveModel(): Promise<{
  model: LanguageModel;
  label: string;
}> {
  const supabase = getSupabaseServer();

  // Get active model key
  const { data: activeRow } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", "active_model")
    .single();

  // Get all model configs
  const { data: modelsRow } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", "models")
    .single();

  const activeKey = (activeRow?.value as string) || "gemini-2.5-flash";
  const models = (modelsRow?.value as Record<string, ModelConfig>) || {};
  const config = models[activeKey];

  if (!config) {
    // Fallback to Gemini 2.0 Flash
    return {
      model: google("gemini-2.5-flash"),
      label: "Gemini 2.5 Flash",
    };
  }

  const model =
    config.provider === "anthropic"
      ? anthropic(config.model_id)
      : google(config.model_id);

  return { model, label: config.label };
}
