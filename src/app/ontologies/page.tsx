export const dynamic = "force-dynamic";

import Link from "next/link";
import { getSourcesByTier, getSourceDescription, getHostname } from "@/lib/data-server";
import type { SourceItem } from "@/components/SourceList";
import SourceList from "@/components/SourceList";
import type { SupabaseSource } from "@/lib/data-server";

function isFictional(source: SupabaseSource): boolean {
  const meta = source.metadata as { fictional?: boolean } | null;
  return meta?.fictional === true;
}

export default async function OntologiesPage() {
  const supabaseSources = await getSourcesByTier("ontology");

  const sources: SourceItem[] = supabaseSources.map((s) => ({
    id: s.id,
    title: s.title,
    description: getSourceDescription(s),
    url: s.url,
    hostname: getHostname(s.url),
    sourceType: s.source_type,
    chunkCount: s.chunk_count,
    fictional: isFictional(s),
  }));

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">Ontologies</span>
      </nav>

      {/* Page Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="h-8 w-1 rounded-full bg-ontology" />
          <h1 className="text-2xl font-bold text-daf-dark-gray sm:text-3xl">
            Ontologies
          </h1>
        </div>
        <p className="ml-4 text-gray-600 max-w-3xl">
          Formal knowledge representations that define concepts and relationships
          within metadata domains. Ontologies enable semantic interoperability,
          automated reasoning, and consistent vocabulary across DAF systems.
        </p>
      </div>

      <SourceList
        sources={sources}
        tier="ontology"
        searchPlaceholder="Search ontologies..."
        emptyMessage="No ontologies match your search criteria."
      />
    </div>
  );
}
