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

export default async function ProfilesPage() {
  const supabaseSources = await getSourcesByTier("2b");

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

  const allFictional = sources.length > 0 && sources.every((s) => s.fictional);

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">Profiles</span>
      </nav>

      {/* Page Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="h-8 w-1 rounded-full bg-tier-2b" />
          <h1 className="text-2xl font-bold text-daf-dark-gray sm:text-3xl">
            Domain Profiles
          </h1>
        </div>
        <p className="ml-4 text-gray-600 max-w-3xl">
          Tier 2B domain-specific metadata profiles — organization-level
          standards that select and constrain elements from Tier 2A technical
          specifications for a particular mission domain.
        </p>
      </div>

      {/* Fictional Notice */}
      {allFictional && (
        <div className="mb-6 rounded-lg border border-orange-200 bg-orange-50 p-4">
          <div className="flex items-start gap-3">
            <svg
              className="h-5 w-5 text-orange-500 mt-0.5 shrink-0"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth={2}
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"
              />
            </svg>
            <div>
              <p className="text-sm font-semibold text-orange-800">
                Illustrative Examples
              </p>
              <p className="mt-1 text-sm text-orange-700">
                The domain profiles shown below are fictional examples created
                to illustrate how organization-specific metadata profiles might
                be structured. They are not real deployed profiles. Real DAF
                domain profiles are typically not published publicly.
              </p>
            </div>
          </div>
        </div>
      )}

      <SourceList
        sources={sources}
        tier="2B"
        searchPlaceholder="Search domain profiles..."
        emptyMessage="No domain profiles match your search criteria."
      />
    </div>
  );
}
