import { getSourcesByTier, getSourceDescription, getHostname } from "@/lib/data-server";
import { getSpecs } from "@/lib/data";
import type { SourceItem } from "@/components/SourceList";
import SpecsList from "./SpecsList";

export default async function SpecsPage() {
  const supabaseSources = await getSourcesByTier("2a");

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
  const jsonSpecs = useJson ? getSpecs() : [];

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Page Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="h-8 w-1.5 rounded-full bg-tier-2a" />
          <h1 className="text-3xl font-bold text-daf-dark-gray">
            Technical Specifications
          </h1>
        </div>
        <p className="text-gray-600 ml-5">
          Tier 2A — Standards and specifications that define metadata formats,
          vocabularies, and exchange protocols used across the Department of the
          Air Force.
        </p>
      </div>

      <SpecsList sources={sources} jsonSpecs={jsonSpecs} />
    </div>
  );
}
