"use client";

import { useState, useMemo } from "react";
import SourceList from "@/components/SourceList";
import ArtifactCard from "@/components/ArtifactCard";
import SearchBar from "@/components/SearchBar";
import FilterBar from "@/components/FilterBar";
import type { GuidanceDocument } from "@/types";
import type { SourceItem } from "@/components/SourceList";

interface GuidanceListProps {
  sources: SourceItem[];
  jsonGuidance: GuidanceDocument[];
}

export default function GuidanceList({
  sources,
  jsonGuidance,
}: GuidanceListProps) {
  // If we have Supabase sources, use them
  if (sources.length > 0) {
    return (
      <SourceList
        sources={sources}
        tier="1"
        searchPlaceholder="Search guidance documents..."
        emptyMessage="No guidance documents match your search criteria."
      />
    );
  }

  // Fallback to static JSON
  return <GuidanceJsonList guidance={jsonGuidance} />;
}

/** Fallback: render from static JSON (same as original) */
function GuidanceJsonList({ guidance }: { guidance: GuidanceDocument[] }) {
  const [search, setSearch] = useState("");
  const [authorityFilter, setAuthorityFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");

  const authorities = useMemo(() => {
    const set = new Set(guidance.map((d) => d.issuingAuthority));
    return Array.from(set).sort();
  }, [guidance]);

  const authorityOptions = [
    { value: "all", label: "All" },
    ...authorities.map((a) => ({ value: a, label: a })),
  ];

  const statusOptions = [
    { value: "all", label: "All" },
    { value: "active", label: "Active" },
    { value: "superseded", label: "Superseded" },
    { value: "draft", label: "Draft" },
  ];

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim();
    return guidance.filter((doc) => {
      if (q) {
        const haystack = [
          doc.title,
          doc.description,
          doc.documentNumber,
          ...doc.keywords,
        ]
          .join(" ")
          .toLowerCase();
        if (!haystack.includes(q)) return false;
      }
      if (authorityFilter !== "all" && doc.issuingAuthority !== authorityFilter)
        return false;
      if (statusFilter !== "all" && doc.status !== statusFilter) return false;
      return true;
    });
  }, [guidance, search, authorityFilter, statusFilter]);

  return (
    <>
      <div className="mb-6">
        <SearchBar
          value={search}
          onChange={setSearch}
          placeholder="Search guidance documents..."
        />
      </div>

      <div className="mb-6 flex flex-col gap-4 sm:flex-row sm:gap-8">
        <FilterBar
          label="Authority:"
          options={authorityOptions}
          selected={authorityFilter}
          onChange={setAuthorityFilter}
        />
        <FilterBar
          label="Status:"
          options={statusOptions}
          selected={statusFilter}
          onChange={setStatusFilter}
        />
      </div>

      <p className="mb-4 text-sm text-gray-500">
        Showing {filtered.length} of {guidance.length} guidance documents
      </p>

      {filtered.length === 0 ? (
        <div className="rounded-lg border border-gray-200 bg-white p-12 text-center">
          <p className="text-gray-500">
            No guidance documents match your search criteria.
          </p>
        </div>
      ) : (
        <div className="grid gap-4 sm:grid-cols-1 lg:grid-cols-2">
          {filtered.map((doc) => (
            <ArtifactCard
              key={doc.id}
              title={doc.title}
              description={doc.description}
              tier="1"
              hostingType={doc.hostingType}
              status={doc.status}
              href={`/guidance/${doc.id}`}
              metadata={[
                { label: "Doc #", value: doc.documentNumber },
                { label: "Authority", value: doc.issuingAuthority },
                { label: "Date", value: doc.issueDate },
              ]}
            />
          ))}
        </div>
      )}
    </>
  );
}
