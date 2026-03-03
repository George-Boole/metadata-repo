"use client";

import { useSearchParams } from "next/navigation";
import { Suspense, useState, useEffect } from "react";
import SearchBar from "@/components/SearchBar";
import ArtifactCard from "@/components/ArtifactCard";
import { TierBadge, StatusBadge } from "@/components/Badge";
import { searchArtifacts, type SearchResult } from "@/lib/search";
import { TIER_LABELS, type TierId } from "@/types";
import Link from "next/link";

const TIER_ROUTE: Record<TierId, string> = {
  "1": "/guidance",
  "2A": "/specs",
  "2B": "/profiles",
  "3": "/tools",
  "ontology": "/ontologies",
};

const TIER_HEADER_STYLES: Record<TierId, string> = {
  "1": "border-l-tier-1 text-tier-1",
  "2A": "border-l-tier-2a text-tier-2a",
  "2B": "border-l-tier-2b text-tier-2b",
  "3": "border-l-tier-3 text-tier-3",
  "ontology": "border-l-ontology text-ontology",
};

const TIER_BORDER: Record<string, string> = {
  "1": "border-l-tier-1",
  "2a": "border-l-tier-2a",
  "2b": "border-l-tier-2b",
  "3": "border-l-tier-3",
  ontology: "border-l-ontology",
};

const TIER_KEY_MAP: Record<string, TierId> = {
  "1": "1",
  "2a": "2A",
  "2b": "2B",
  "3": "3",
  ontology: "ontology",
};

interface SupabaseSearchResult {
  id: string;
  title: string;
  url: string;
  tier: string | null;
  source_type: string;
  chunk_count: number;
  metadata: { description?: string | null } | null;
}

function buildMetadata(result: SearchResult): { label: string; value: string }[] {
  const a = result.artifact;
  switch (a.tier) {
    case "1":
      return [{ label: "Document", value: a.documentNumber }];
    case "2A":
      return [
        { label: "Version", value: a.version },
        { label: "Category", value: a.category },
      ];
    case "2B":
      return [
        { label: "Domain", value: a.domain },
        { label: "Org", value: a.owningOrganization },
      ];
    case "3":
      return [
        { label: "Vendor", value: a.vendor },
        { label: "License", value: a.licenseType },
      ];
    case "ontology":
      return [
        { label: "Type", value: a.ontologyType },
        ...(a.format ? [{ label: "Format", value: a.format }] : []),
      ];
  }
}

function SearchResults() {
  const searchParams = useSearchParams();
  const query = searchParams.get("q") ?? "";
  const [supabaseResults, setSupabaseResults] = useState<SupabaseSearchResult[]>([]);
  const [loading, setLoading] = useState(false);

  // Static JSON search
  const jsonResults = query ? searchArtifacts(query) : [];

  // Supabase search
  useEffect(() => {
    if (!query.trim()) {
      setSupabaseResults([]);
      return;
    }

    setLoading(true);
    fetch(`/api/search?q=${encodeURIComponent(query)}`)
      .then((res) => res.json())
      .then((data) => setSupabaseResults(data.results || []))
      .catch(() => setSupabaseResults([]))
      .finally(() => setLoading(false));
  }, [query]);

  // Deduplicate: if a JSON result and Supabase result share a similar title, prefer JSON (richer data)
  const jsonTitles = new Set(jsonResults.map((r) => r.artifact.title.toLowerCase()));
  const uniqueSupabase = supabaseResults.filter(
    (s) => !jsonTitles.has(s.title.toLowerCase()),
  );

  // Group JSON results by tier
  const grouped: Partial<Record<TierId, SearchResult[]>> = {};
  for (const r of jsonResults) {
    const tier = r.artifact.tier;
    if (!grouped[tier]) grouped[tier] = [];
    grouped[tier]!.push(r);
  }

  const tierOrder: TierId[] = ["1", "2A", "2B", "3", "ontology"];
  const totalResults = jsonResults.length + uniqueSupabase.length;

  return (
    <div className="mx-auto max-w-5xl px-4 py-6 sm:px-6 sm:py-8 lg:px-8">
      {/* Search bar */}
      <div className="mb-6 sm:mb-8">
        <h1 className="mb-3 sm:mb-4 text-xl sm:text-2xl font-bold text-daf-dark-gray">
          Search Standards
        </h1>
        <SearchBar
          value={query}
          navigateOnSubmit
          className="max-w-2xl"
        />
      </div>

      {/* Results summary */}
      {query && (
        <p className="mb-6 text-sm text-gray-600">
          {totalResults === 0 && !loading
            ? `No results found for "${query}"`
            : `${totalResults} result${totalResults !== 1 ? "s" : ""} for "${query}"`}
          {loading && " (searching indexed sources...)"}
        </p>
      )}

      {/* No results state */}
      {query && totalResults === 0 && !loading && (
        <div className="rounded-lg border border-gray-200 bg-white p-8 text-center shadow-sm">
          <svg
            className="mx-auto mb-4 h-12 w-12 text-gray-300"
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={1.5}
            stroke="currentColor"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"
            />
          </svg>
          <h2 className="mb-2 text-lg font-semibold text-daf-dark-gray">
            No matching standards found
          </h2>
          <p className="mb-4 text-sm text-gray-500">
            Try adjusting your search terms. Here are some suggestions:
          </p>
          <ul className="mx-auto max-w-md space-y-1 text-left text-sm text-gray-500">
            <li>- Search by document number (e.g., &quot;DoDI 8320.02&quot;)</li>
            <li>- Search by standard name (e.g., &quot;NIEM&quot;, &quot;Dublin Core&quot;)</li>
            <li>- Search by keyword (e.g., &quot;interoperability&quot;, &quot;security marking&quot;)</li>
            <li>- Search by vendor name (e.g., &quot;Microsoft&quot;, &quot;Collibra&quot;)</li>
          </ul>
        </div>
      )}

      {/* Grouped JSON results */}
      {tierOrder.map((tier) => {
        const tierResults = grouped[tier];
        if (!tierResults || tierResults.length === 0) return null;
        return (
          <section key={tier} className="mb-8">
            <h2
              className={`mb-4 border-l-4 pl-3 text-lg font-bold ${TIER_HEADER_STYLES[tier]}`}
            >
              {tier === "ontology" ? TIER_LABELS[tier] : `Tier ${tier} — ${TIER_LABELS[tier]}`}
              <span className="ml-2 text-sm font-normal text-gray-500">
                ({tierResults.length})
              </span>
            </h2>
            <div className="space-y-3">
              {tierResults.map((r) => (
                <ArtifactCard
                  key={r.artifact.id}
                  title={r.artifact.title}
                  description={r.artifact.description}
                  tier={r.artifact.tier}
                  hostingType={r.artifact.hostingType}
                  status={r.artifact.status}
                  href={`${TIER_ROUTE[r.artifact.tier]}/${r.artifact.id}`}
                  metadata={buildMetadata(r)}
                />
              ))}
            </div>
          </section>
        );
      })}

      {/* Supabase-only results */}
      {uniqueSupabase.length > 0 && (
        <section className="mb-8">
          <h2 className="mb-4 border-l-4 border-l-daf-light-blue pl-3 text-lg font-bold text-daf-light-blue">
            Indexed Sources
            <span className="ml-2 text-sm font-normal text-gray-500">
              ({uniqueSupabase.length})
            </span>
          </h2>
          <div className="space-y-3">
            {uniqueSupabase.map((s) => {
              const tierKey = s.tier?.toLowerCase() || "";
              const tierId = TIER_KEY_MAP[tierKey];
              const borderClass = TIER_BORDER[tierKey] || "border-l-gray-400";
              let hostname = "";
              try { hostname = new URL(s.url).hostname; } catch { hostname = s.url; }
              const description = (s.metadata as { description?: string | null })?.description || `Content from ${hostname}`;

              return (
                <Link
                  key={s.id}
                  href={`/sources/${s.id}`}
                  className={`block rounded-lg border border-gray-200 border-l-4 ${borderClass} bg-white p-3 sm:p-5 shadow-sm transition-shadow hover:shadow-md`}
                >
                  <div className="flex flex-wrap items-start justify-between gap-2 mb-2">
                    <h3 className="text-base sm:text-lg font-semibold text-daf-dark-gray">
                      {s.title}
                    </h3>
                    <div className="flex items-center gap-2">
                      <StatusBadge status="active" />
                      {tierId && <TierBadge tier={tierId} />}
                    </div>
                  </div>
                  <p className="mb-2 text-sm text-gray-600 line-clamp-2">
                    {description}
                  </p>
                  <span className="text-xs text-gray-500">
                    <span className="font-medium text-gray-600">Source:</span> {hostname}
                  </span>
                </Link>
              );
            })}
          </div>
        </section>
      )}
    </div>
  );
}

export default function SearchPage() {
  return (
    <Suspense
      fallback={
        <div className="mx-auto max-w-5xl px-4 py-8">
          <p className="text-gray-500">Loading search...</p>
        </div>
      }
    >
      <SearchResults />
    </Suspense>
  );
}
