"use client";

import { useSearchParams } from "next/navigation";
import { Suspense, useState, useEffect } from "react";
import SearchBar from "@/components/SearchBar";
import { TierBadge, StatusBadge } from "@/components/Badge";
import { TIER_LABELS, type TierId } from "@/types";
import Link from "next/link";

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

const TIER_ORDER_LOWER = ["1", "2a", "2b", "3", "ontology"];

const TIER_HEADER_STYLES: Record<TierId, string> = {
  "1": "border-l-tier-1 text-tier-1",
  "2A": "border-l-tier-2a text-tier-2a",
  "2B": "border-l-tier-2b text-tier-2b",
  "3": "border-l-tier-3 text-tier-3",
  "ontology": "border-l-ontology text-ontology",
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

function SearchResults() {
  const searchParams = useSearchParams();
  const query = searchParams.get("q") ?? "";
  const [results, setResults] = useState<SupabaseSearchResult[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!query.trim()) {
      setResults([]);
      return;
    }

    setLoading(true);
    fetch(`/api/search?q=${encodeURIComponent(query)}`)
      .then((res) => res.json())
      .then((data) => setResults(data.results || []))
      .catch(() => setResults([]))
      .finally(() => setLoading(false));
  }, [query]);

  // Group results by tier
  const grouped: Partial<Record<string, SupabaseSearchResult[]>> = {};
  for (const r of results) {
    const tier = r.tier || "other";
    if (!grouped[tier]) grouped[tier] = [];
    grouped[tier]!.push(r);
  }

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
          {results.length === 0 && !loading
            ? `No results found for "${query}"`
            : `${results.length} result${results.length !== 1 ? "s" : ""} for "${query}"`}
          {loading && " (searching...)"}
        </p>
      )}

      {/* No results state */}
      {query && results.length === 0 && !loading && (
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

      {/* Grouped results by tier */}
      {TIER_ORDER_LOWER.map((tierKey) => {
        const tierResults = grouped[tierKey];
        if (!tierResults || tierResults.length === 0) return null;
        const tierId = TIER_KEY_MAP[tierKey];
        return (
          <section key={tierKey} className="mb-8">
            <h2
              className={`mb-4 border-l-4 pl-3 text-lg font-bold ${TIER_HEADER_STYLES[tierId]}`}
            >
              {tierId === "ontology" ? TIER_LABELS[tierId] : `Tier ${tierId} — ${TIER_LABELS[tierId]}`}
              <span className="ml-2 text-sm font-normal text-gray-500">
                ({tierResults.length})
              </span>
            </h2>
            <div className="space-y-3">
              {tierResults.map((s) => {
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
        );
      })}

      {/* Ungrouped results (no tier) */}
      {grouped["other"] && grouped["other"].length > 0 && (
        <section className="mb-8">
          <h2 className="mb-4 border-l-4 border-l-daf-light-blue pl-3 text-lg font-bold text-daf-light-blue">
            Other Sources
            <span className="ml-2 text-sm font-normal text-gray-500">
              ({grouped["other"].length})
            </span>
          </h2>
          <div className="space-y-3">
            {grouped["other"].map((s) => {
              let hostname = "";
              try { hostname = new URL(s.url).hostname; } catch { hostname = s.url; }
              const description = (s.metadata as { description?: string | null })?.description || `Content from ${hostname}`;

              return (
                <Link
                  key={s.id}
                  href={`/sources/${s.id}`}
                  className="block rounded-lg border border-gray-200 border-l-4 border-l-gray-400 bg-white p-3 sm:p-5 shadow-sm transition-shadow hover:shadow-md"
                >
                  <div className="flex flex-wrap items-start justify-between gap-2 mb-2">
                    <h3 className="text-base sm:text-lg font-semibold text-daf-dark-gray">
                      {s.title}
                    </h3>
                    <StatusBadge status="active" />
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
