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

/** Get all active sources for a specific tier */
export async function getSourcesByTier(tier: string): Promise<SupabaseSource[]> {
  try {
    const supabase = getSupabaseServer();
    const { data, error } = await supabase
      .from("sources")
      .select("*")
      .eq("status", "active")
      .eq("tier", tier)
      .order("title");

    if (error || !data) return [];
    return data;
  } catch {
    return [];
  }
}

/** Get counts of active sources per tier */
export async function getSourceCounts(): Promise<{
  guidance: number;
  specs: number;
  profiles: number;
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
      return { guidance: 0, specs: 0, profiles: 0, tools: 0, ontologies: 0, total: 0 };
    }

    let guidance = 0;
    let specs = 0;
    let profiles = 0;
    let tools = 0;
    let ontologies = 0;

    for (const row of data) {
      const t = row.tier;
      if (t === "1") guidance++;
      else if (t === "2a") specs++;
      else if (t === "2b") profiles++;
      else if (t === "3") tools++;
      else if (t === "ontology") ontologies++;
    }

    return { guidance, specs, profiles, tools, ontologies, total: data.length };
  } catch {
    return { guidance: 0, specs: 0, profiles: 0, tools: 0, ontologies: 0, total: 0 };
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

/** Look up a source by its URL */
export async function getSourceByUrl(
  url: string,
): Promise<SupabaseSource | null> {
  try {
    const supabase = getSupabaseServer();
    const { data, error } = await supabase
      .from("sources")
      .select("*")
      .eq("url", url)
      .single();

    if (error || !data) return null;
    return data;
  } catch {
    return null;
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
