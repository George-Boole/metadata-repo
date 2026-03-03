import Link from "next/link";
import { getSourcesByTier, getSourceDescription, getHostname } from "@/lib/data-server";
import { getGuidance } from "@/lib/data";
import type { SourceItem } from "@/components/SourceList";
import GuidanceList from "./GuidanceList";

export default async function GuidancePage() {
  const supabaseSources = await getSourcesByTier("1");

  // Map Supabase sources to SourceItem format
  const sources: SourceItem[] = supabaseSources.map((s) => ({
    id: s.id,
    title: s.title,
    description: getSourceDescription(s),
    url: s.url,
    hostname: getHostname(s.url),
    sourceType: s.source_type,
    chunkCount: s.chunk_count,
  }));

  // Fallback to static JSON if Supabase returns nothing
  const useJson = sources.length === 0;
  const jsonGuidance = useJson ? getGuidance() : [];

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">Guidance</span>
      </nav>

      {/* Page Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="h-8 w-1 rounded-full bg-tier-1" />
          <h1 className="text-2xl font-bold text-daf-dark-gray sm:text-3xl">
            Authoritative Guidance
          </h1>
        </div>
        <p className="ml-4 text-gray-600 max-w-3xl">
          Tier 1 policy documents — DoD Instructions, Directives, and Memoranda
          that mandate the use of metadata standards across the enterprise. These
          documents establish the authoritative basis for all downstream
          technical specifications and domain profiles.
        </p>
      </div>

      <GuidanceList sources={sources} jsonGuidance={jsonGuidance} />
    </div>
  );
}
