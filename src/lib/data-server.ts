import { getSupabaseServer } from "./supabase";

/* ── Supabase source record type ──────────────────────────── */

export interface SupabaseSource {
  id: string;
  url: string;
  title: string;
  source_type: string;
  tier: string | null;
  status: string;
  chunk_count: number;
  error_message: string | null;
  metadata: { description?: string | null } | null;
  created_at: string;
}

/* ── Query functions ──────────────────────────────────────── */

/** Get all active sources for a specific tier (case-insensitive) */
export async function getSourcesByTier(tier: string): Promise<SupabaseSource[]> {
  try {
    const supabase = getSupabaseServer();
    const { data, error } = await supabase
      .from("sources")
      .select("*")
      .eq("status", "active")
      .order("title");

    if (error || !data) return [];

    const normalizedTier = tier.toLowerCase();
    return data.filter((s) => s.tier?.toLowerCase() === normalizedTier);
  } catch {
    return [];
  }
}

/** Get counts of active sources per tier */
export async function getSourceCounts(): Promise<{
  guidance: number;
  specs: number;
  tools: number;
  ontologies: number;
  total: number;
}> {
  try {
    const supabase = getSupabaseServer();
    const { data, error } = await supabase
      .from("sources")
      .select("tier")
      .eq("status", "active");

    if (error || !data) {
      return { guidance: 0, specs: 0, tools: 0, ontologies: 0, total: 0 };
    }

    let guidance = 0;
    let specs = 0;
    let tools = 0;
    let ontologies = 0;

    for (const row of data) {
      const t = row.tier?.toLowerCase();
      if (t === "1") guidance++;
      else if (t === "2a") specs++;
      else if (t === "3") tools++;
      else if (t === "ontology") ontologies++;
    }

    return { guidance, specs, tools, ontologies, total: data.length };
  } catch {
    return { guidance: 0, specs: 0, tools: 0, ontologies: 0, total: 0 };
  }
}

/** Get a single source by ID */
export async function getSourceById(
  id: string,
): Promise<SupabaseSource | null> {
  try {
    const supabase = getSupabaseServer();
    const { data, error } = await supabase
      .from("sources")
      .select("*")
      .eq("id", id)
      .single();

    if (error || !data) return null;
    return data;
  } catch {
    return null;
  }
}

/** Search active sources by title or URL */
export async function searchSources(
  query: string,
): Promise<SupabaseSource[]> {
  if (!query.trim()) return [];

  try {
    const supabase = getSupabaseServer();
    const q = `%${query.trim()}%`;
    const { data, error } = await supabase
      .from("sources")
      .select("*")
      .eq("status", "active")
      .or(`title.ilike.${q},url.ilike.${q}`)
      .order("title")
      .limit(50);

    if (error || !data) return [];
    return data;
  } catch {
    return [];
  }
}

/* ── Helper: extract hostname from URL ────────────────────── */

export function getHostname(url: string): string {
  try {
    return new URL(url).hostname;
  } catch {
    return url;
  }
}

/* ── Helper: get description from source metadata ─────────── */

export function getSourceDescription(source: SupabaseSource): string {
  const meta = source.metadata as { description?: string | null } | null;
  if (meta?.description) return meta.description;
  return `Content ingested from ${getHostname(source.url)}`;
}
