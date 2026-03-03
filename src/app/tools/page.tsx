export const dynamic = "force-dynamic";

import Link from "next/link";
import { getSourcesByTier, getSourceDescription, getHostname } from "@/lib/data-server";
import { getTools } from "@/lib/data";
import type { SourceItem } from "@/components/SourceList";
import ToolsList from "./ToolsList";

export default async function ToolsPage() {
  const supabaseSources = await getSourcesByTier("3");

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
  const jsonTools = useJson ? getTools() : [];

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">Tools</span>
      </nav>

      {/* Page Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="h-8 w-1 rounded-full bg-tier-3" />
          <h1 className="text-2xl font-bold text-daf-dark-gray sm:text-3xl">
            Tagging & Labeling Tools
          </h1>
        </div>
        <p className="ml-4 text-gray-600 max-w-3xl">
          Tier 3 tools that apply metadata standards to data assets — automated
          classification, security marking, sensitivity labeling, and
          standards-based tagging platforms used across the DAF enterprise.
        </p>
      </div>

      <ToolsList sources={sources} jsonTools={jsonTools} />
    </div>
  );
}
