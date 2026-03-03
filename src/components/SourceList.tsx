"use client";

import { useState, useMemo } from "react";
import Link from "next/link";
import SearchBar from "@/components/SearchBar";
import { TierBadge, StatusBadge, FictionalBadge } from "@/components/Badge";
import type { TierId } from "@/types";

/* ── Types ────────────────────────────────────────────────── */

export interface SourceItem {
  id: string;
  title: string;
  description: string;
  url: string;
  hostname: string;
  sourceType: string;
  chunkCount: number;
  fictional?: boolean;
}

interface SourceListProps {
  sources: SourceItem[];
  tier: TierId;
  searchPlaceholder?: string;
  emptyMessage?: string;
}

/* ── Tier border colors (matching ArtifactCard) ───────────── */

const TIER_BORDER: Record<TierId, string> = {
  "1": "border-l-tier-1",
  "2A": "border-l-tier-2a",
  "2B": "border-l-tier-2b",
  "3": "border-l-tier-3",
  ontology: "border-l-ontology",
};

/* ── Source Card ───────────────────────────────────────────── */

function SourceCard({ source, tier }: { source: SourceItem; tier: TierId }) {
  return (
    <div
      className={`relative rounded-lg border border-gray-200 border-l-4 ${TIER_BORDER[tier]} bg-white p-3 sm:p-5 shadow-sm transition-shadow hover:shadow-md`}
    >
      {source.fictional && (
        <div className="absolute top-2 right-2 z-10">
          <FictionalBadge />
        </div>
      )}
      <div className="flex flex-wrap items-start justify-between gap-2 mb-2">
        <h3 className="text-base sm:text-lg font-semibold text-daf-dark-gray">
          {source.title}
        </h3>
        {!source.fictional && <StatusBadge status="active" />}
      </div>

      <p className="mb-3 text-sm text-gray-600 line-clamp-2">
        {source.description}
      </p>

      <div className="flex flex-wrap items-center gap-3 mb-3">
        <TierBadge tier={tier} />
        <span className="text-xs text-gray-500">
          <span className="font-medium text-gray-600">Source:</span>{" "}
          {source.hostname}
        </span>
        {source.chunkCount > 0 && (
          <span className="text-xs text-gray-500">
            <span className="font-medium text-gray-600">Indexed:</span>{" "}
            {source.chunkCount} chunks
          </span>
        )}
      </div>

      <div className="flex items-center gap-2">
        <a
          href={source.url}
          target="_blank"
          rel="noopener noreferrer"
          className="inline-flex items-center gap-1.5 rounded-md bg-daf-blue px-3 py-1.5 text-xs font-medium text-white hover:bg-daf-navy transition-colors"
        >
          <svg
            className="h-3.5 w-3.5"
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
          View Source
        </a>
        <Link
          href={`/sources/${source.id}`}
          className="inline-flex items-center gap-1.5 rounded-md border border-gray-300 px-3 py-1.5 text-xs font-medium text-gray-600 hover:bg-gray-50 transition-colors"
        >
          Details
        </Link>
      </div>
    </div>
  );
}

/* ── Source List ───────────────────────────────────────────── */

export default function SourceList({
  sources,
  tier,
  searchPlaceholder = "Search sources...",
  emptyMessage = "No sources match your search criteria.",
}: SourceListProps) {
  const [search, setSearch] = useState("");

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim();
    if (!q) return sources;
    return sources.filter(
      (s) =>
        s.title.toLowerCase().includes(q) ||
        s.description.toLowerCase().includes(q) ||
        s.hostname.toLowerCase().includes(q),
    );
  }, [sources, search]);

  return (
    <>
      <SearchBar
        value={search}
        onChange={setSearch}
        placeholder={searchPlaceholder}
        className="mb-6"
      />

      <p className="text-sm text-gray-500 mb-4">
        Showing {filtered.length} of {sources.length} sources
      </p>

      {filtered.length === 0 ? (
        <div className="rounded-lg border border-gray-200 bg-white p-12 text-center">
          <p className="text-gray-500">{emptyMessage}</p>
        </div>
      ) : (
        <div className="grid gap-4 sm:grid-cols-1 lg:grid-cols-2">
          {filtered.map((source) => (
            <SourceCard key={source.id} source={source} tier={tier} />
          ))}
        </div>
      )}
    </>
  );
}
