import { notFound } from "next/navigation";
import Link from "next/link";
import { getSourceById, getHostname, getSourceDescription } from "@/lib/data-server";
import { TierBadge, StatusBadge } from "@/components/Badge";
import type { TierId } from "@/types";

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

export default async function SourceDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const source = await getSourceById(id);
  if (!source) notFound();

  const tierKey = source.tier?.toLowerCase() || "";
  const tierId = TIER_MAP[tierKey];
  const backRoute = TIER_BACK_ROUTES[tierKey];
  const borderClass = TIER_BORDER[tierKey] || "border-l-gray-400";
  const description = getSourceDescription(source);
  const hostname = getHostname(source.url);

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
