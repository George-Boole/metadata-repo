import { notFound } from "next/navigation";
import Link from "next/link";
import { getSourceById, getHostname, getSourceDescription, getSourceByUrl } from "@/lib/data-server";
import { TierBadge, StatusBadge } from "@/components/Badge";
import type { TierId } from "@/types";
import { runCypher } from "@/lib/neo4j";

const TIER_MAP: Record<string, TierId> = {
  "1": "1",
  "2a": "2A",
  "2b": "2B",
  "3": "3",
  ontology: "ontology",
};

const TIER_BACK_ROUTES: Record<string, { href: string; label: string }> = {
  "1": { href: "/guidance", label: "Guidance" },
  "2a": { href: "/specs", label: "Specifications" },
  "2b": { href: "/profiles", label: "Profiles" },
  "3": { href: "/tools", label: "Tools" },
  ontology: { href: "/ontologies", label: "Ontologies" },
};

const TIER_BORDER: Record<string, string> = {
  "1": "border-l-tier-1",
  "2a": "border-l-tier-2a",
  "2b": "border-l-tier-2b",
  "3": "border-l-tier-3",
  ontology: "border-l-ontology",
};

const REL_TYPE_LABELS: Record<string, string> = {
  MANDATES: "Mandates",
  REFERENCES: "References",
  IMPLEMENTS: "Implements",
  SUPPORTS: "Supports",
  CHILD_OF: "Child Of",
  PART_OF: "Part Of",
};

interface GraphRelation {
  entityName: string;
  entityType: string;
  relType: string;
  direction: "outgoing" | "incoming";
  sourceUrl?: string;
}

async function getGraphRelations(sourceUrl: string): Promise<GraphRelation[]> {
  try {
    const results = await runCypher<{
      entityName: string;
      entityType: string;
      relType: string;
      direction: string;
      relatedUrl: string | null;
    }>(
      `MATCH (s:Source {url: $url})-[:MENTIONS]->(e:Entity)
       OPTIONAL MATCH (e)-[r:RELATES_TO]->(other:Entity)
       OPTIONAL MATCH (otherSource:Source)-[:MENTIONS]->(other)
       WITH e, r, other, otherSource, 'outgoing' as dir
       WHERE other IS NOT NULL
       RETURN other.name as entityName, other.type as entityType,
              r.rel_type as relType, dir as direction,
              otherSource.url as relatedUrl
       UNION
       MATCH (s:Source {url: $url})-[:MENTIONS]->(e:Entity)
       OPTIONAL MATCH (other:Entity)-[r:RELATES_TO]->(e)
       OPTIONAL MATCH (otherSource:Source)-[:MENTIONS]->(other)
       WITH e, r, other, otherSource, 'incoming' as dir
       WHERE other IS NOT NULL
       RETURN other.name as entityName, other.type as entityType,
              r.rel_type as relType, dir as direction,
              otherSource.url as relatedUrl
       LIMIT 30`,
      { url: sourceUrl },
    );

    return results.map((r) => ({
      entityName: r.entityName,
      entityType: r.entityType,
      relType: r.relType,
      direction: r.direction as "outgoing" | "incoming",
      sourceUrl: r.relatedUrl || undefined,
    }));
  } catch {
    return [];
  }
}

export default async function SourceDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const source = await getSourceById(id);
  if (!source) notFound();

  const tierKey = source.tier || "";
  const tierId = TIER_MAP[tierKey];
  const backRoute = TIER_BACK_ROUTES[tierKey];
  const borderClass = TIER_BORDER[tierKey] || "border-l-gray-400";
  const description = getSourceDescription(source);
  const hostname = getHostname(source.url);

  // Fetch graph relations (non-fatal)
  const graphRelations = await getGraphRelations(source.url);

  // Group relations by type
  const relationsByType: Record<string, GraphRelation[]> = {};
  for (const rel of graphRelations) {
    const key = rel.direction === "incoming"
      ? `${rel.relType}_by`
      : rel.relType;
    if (!relationsByType[key]) relationsByType[key] = [];
    // Deduplicate by entity name
    if (!relationsByType[key].some((r) => r.entityName === rel.entityName)) {
      relationsByType[key].push(rel);
    }
  }

  // Resolve source IDs for linked entities
  const relatedSourceIds: Record<string, string> = {};
  for (const rel of graphRelations) {
    if (rel.sourceUrl && !relatedSourceIds[rel.sourceUrl]) {
      const relSource = await getSourceByUrl(rel.sourceUrl);
      if (relSource) relatedSourceIds[rel.sourceUrl] = relSource.id;
    }
  }

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        {backRoute && (
          <>
            <span className="mx-2">/</span>
            <Link href={backRoute.href} className="hover:text-daf-light-blue">
              {backRoute.label}
            </Link>
          </>
        )}
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">{source.title}</span>
      </nav>

      {/* Back link */}
      {backRoute && (
        <Link
          href={backRoute.href}
          className="mb-6 inline-flex items-center gap-1 text-sm text-daf-light-blue hover:text-daf-blue"
        >
          <svg
            className="h-4 w-4"
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={2}
            stroke="currentColor"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M15.75 19.5L8.25 12l7.5-7.5"
            />
          </svg>
          Back to {backRoute.label}
        </Link>
      )}

      {/* Header Card */}
      <div
        className={`mt-4 rounded-lg border border-gray-200 border-l-4 ${borderClass} bg-white p-6 shadow-sm`}
      >
        <div className="flex flex-wrap items-start justify-between gap-3 mb-4">
          <h1 className="text-2xl font-bold text-daf-dark-gray">
            {source.title}
          </h1>
          <div className="flex items-center gap-2">
            <StatusBadge
              status={
                source.status === "active"
                  ? "active"
                  : source.status === "draft"
                    ? "draft"
                    : "superseded"
              }
            />
          </div>
        </div>

        {tierId && (
          <div className="mb-6">
            <TierBadge tier={tierId} />
          </div>
        )}

        {/* Metadata Grid */}
        <dl className="grid grid-cols-1 gap-4 sm:grid-cols-3 mb-6">
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Source
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray">
              {hostname}
            </dd>
          </div>
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Content Type
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray capitalize">
              {source.source_type}
            </dd>
          </div>
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Indexed Chunks
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray">
              {source.chunk_count}
            </dd>
          </div>
        </dl>

        {/* Description */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
            Description
          </h2>
          <p className="text-gray-700 leading-relaxed">{description}</p>
        </div>

        {/* Ingested Date */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
            Date Indexed
          </h2>
          <p className="text-sm text-gray-700">
            {new Date(source.created_at).toLocaleDateString("en-US", {
              year: "numeric",
              month: "long",
              day: "numeric",
            })}
          </p>
        </div>

        {/* External Link */}
        <a
          href={source.url}
          target="_blank"
          rel="noopener noreferrer"
          className="inline-flex items-center gap-2 rounded-lg bg-daf-blue px-5 py-2.5 text-sm font-medium text-white shadow-sm hover:bg-daf-navy transition-colors"
        >
          <svg
            className="h-4 w-4"
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={2}
            stroke="currentColor"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"
            />
          </svg>
          View Original Source
        </a>
      </div>

      {/* Graph Cross-References */}
      {Object.keys(relationsByType).length > 0 && (
        <div className="mt-8">
          <h2 className="text-lg font-bold text-daf-dark-gray mb-4">
            Related Standards & Entities
          </h2>
          <div className="space-y-4">
            {Object.entries(relationsByType).map(([relKey, rels]) => {
              const isIncoming = relKey.endsWith("_by");
              const baseType = isIncoming ? relKey.replace(/_by$/, "") : relKey;
              const label = isIncoming
                ? `${REL_TYPE_LABELS[baseType] || baseType} By`
                : REL_TYPE_LABELS[baseType] || baseType;

              return (
                <div key={relKey}>
                  <h3 className="text-sm font-semibold uppercase text-gray-500 mb-2">
                    {label}
                  </h3>
                  <div className="flex flex-wrap gap-2">
                    {rels.map((rel) => {
                      const linkedSourceId = rel.sourceUrl
                        ? relatedSourceIds[rel.sourceUrl]
                        : undefined;

                      if (linkedSourceId) {
                        return (
                          <Link
                            key={rel.entityName}
                            href={`/sources/${linkedSourceId}`}
                            className="inline-flex items-center gap-1.5 rounded-full bg-blue-50 px-3 py-1.5 text-sm font-medium text-blue-800 hover:bg-blue-100 transition-colors border border-blue-200"
                          >
                            {rel.entityName}
                            <span className="text-xs text-blue-500">
                              ({rel.entityType})
                            </span>
                          </Link>
                        );
                      }

                      return (
                        <span
                          key={rel.entityName}
                          className="inline-flex items-center gap-1.5 rounded-full bg-gray-100 px-3 py-1.5 text-sm font-medium text-gray-700 border border-gray-200"
                        >
                          {rel.entityName}
                          <span className="text-xs text-gray-500">
                            ({rel.entityType})
                          </span>
                        </span>
                      );
                    })}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Standards Brain CTA */}
      <div className="mt-8 rounded-lg border border-brain/30 bg-brain-bg p-6">
        <div className="flex items-start gap-4">
          <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-brain text-white">
            <svg
              className="h-5 w-5"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth={1.5}
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09zM18.259 8.715L18 9.75l-.259-1.035a3.375 3.375 0 00-2.455-2.456L14.25 6l1.036-.259a3.375 3.375 0 002.455-2.456L18 2.25l.259 1.035a3.375 3.375 0 002.455 2.456L21.75 6l-1.036.259a3.375 3.375 0 00-2.455 2.456z"
              />
            </svg>
          </div>
          <div>
            <h3 className="font-semibold text-daf-dark-gray">
              Ask about this source
            </h3>
            <p className="mt-1 text-sm text-gray-600">
              The Standards Brain has indexed {source.chunk_count} chunks from
              this source. Ask questions about its content.
            </p>
            <Link
              href="/standards-brain"
              className="mt-3 inline-flex items-center gap-1.5 text-sm font-medium text-brain hover:text-brain/80"
            >
              Open Standards Brain
              <svg
                className="h-4 w-4"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={2}
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                />
              </svg>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
