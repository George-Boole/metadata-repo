"use client";

import { useState, useMemo } from "react";
import { getGuidance } from "@/lib/data";
import type { GuidanceDocument } from "@/types";
import ArtifactCard from "@/components/ArtifactCard";
import SearchBar from "@/components/SearchBar";
import FilterBar from "@/components/FilterBar";
import Link from "next/link";

const allGuidance = getGuidance();

function extractUniqueAuthorities(docs: GuidanceDocument[]) {
  const set = new Set(docs.map((d) => d.issuingAuthority));
  return Array.from(set).sort();
}

const authorities = extractUniqueAuthorities(allGuidance);

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

export default function GuidancePage() {
  const [search, setSearch] = useState("");
  const [authorityFilter, setAuthorityFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim();
    return allGuidance.filter((doc) => {
      // keyword search
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
      // authority filter
      if (authorityFilter !== "all" && doc.issuingAuthority !== authorityFilter)
        return false;
      // status filter
      if (statusFilter !== "all" && doc.status !== statusFilter) return false;
      return true;
    });
  }, [search, authorityFilter, statusFilter]);

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">Guidance</span>
      </nav>

      {/* Page Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="h-8 w-1 rounded-full bg-tier-1" />
          <h1 className="text-2xl font-bold text-daf-dark-gray sm:text-3xl">
            Authoritative Guidance
          </h1>
        </div>
        <p className="ml-4 text-gray-600 max-w-3xl">
          Tier 1 policy documents — DoD Instructions, Directives, and Memoranda
          that mandate the use of metadata standards across the enterprise. These
          documents establish the authoritative basis for all downstream
          technical specifications and domain profiles.
        </p>
      </div>

      {/* Search */}
      <div className="mb-6">
        <SearchBar
          value={search}
          onChange={setSearch}
          placeholder="Search guidance documents..."
        />
      </div>

      {/* Filters */}
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

      {/* Results Count */}
      <p className="mb-4 text-sm text-gray-500">
        Showing {filtered.length} of {allGuidance.length} guidance documents
      </p>

      {/* Card Grid */}
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
    </div>
  );
}
