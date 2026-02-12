"use client";

import { useState, useMemo } from "react";
import { getTools, getSpecById } from "@/lib/data";
import type { TaggingTool } from "@/types";
import ArtifactCard from "@/components/ArtifactCard";
import SearchBar from "@/components/SearchBar";
import FilterBar from "@/components/FilterBar";
import Link from "next/link";

const allTools = getTools();

function extractUniqueSupportedSpecs(tools: TaggingTool[]) {
  const map = new Map<string, string>();
  for (const tool of tools) {
    for (const specId of tool.supportedSpecIds) {
      if (!map.has(specId)) {
        const spec = getSpecById(specId);
        if (spec) map.set(specId, spec.title);
      }
    }
  }
  return Array.from(map.entries())
    .sort(([, a], [, b]) => a.localeCompare(b));
}

const supportedSpecs = extractUniqueSupportedSpecs(allTools);

const specOptions = [
  { value: "all", label: "All" },
  ...supportedSpecs.map(([id, name]) => ({ value: id, label: name })),
];

const licenseOptions = [
  { value: "all", label: "All" },
  ...Array.from(new Set(allTools.map((t) => t.licenseType)))
    .sort()
    .map((l) => ({ value: l, label: l })),
];

const maturityOptions = [
  { value: "all", label: "All" },
  { value: "production", label: "Production" },
  { value: "emerging", label: "Emerging" },
  { value: "experimental", label: "Experimental" },
];

export default function ToolsPage() {
  const [search, setSearch] = useState("");
  const [specFilter, setSpecFilter] = useState("all");
  const [licenseFilter, setLicenseFilter] = useState("all");
  const [maturityFilter, setMaturityFilter] = useState("all");

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim();
    return allTools.filter((tool) => {
      if (q) {
        const haystack = [
          tool.title,
          tool.description,
          tool.vendor,
          ...tool.capabilities,
          ...tool.keywords,
        ]
          .join(" ")
          .toLowerCase();
        if (!haystack.includes(q)) return false;
      }
      if (specFilter !== "all" && !tool.supportedSpecIds.includes(specFilter))
        return false;
      if (licenseFilter !== "all" && tool.licenseType !== licenseFilter)
        return false;
      if (maturityFilter !== "all" && tool.maturityLevel !== maturityFilter)
        return false;
      return true;
    });
  }, [search, specFilter, licenseFilter, maturityFilter]);

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

      {/* Search */}
      <div className="mb-6">
        <SearchBar
          value={search}
          onChange={setSearch}
          placeholder="Search tagging and labeling tools..."
        />
      </div>

      {/* Filters */}
      <div className="mb-6 flex flex-col gap-4">
        <FilterBar
          label="Supported Spec:"
          options={specOptions}
          selected={specFilter}
          onChange={setSpecFilter}
        />
        <FilterBar
          label="License:"
          options={licenseOptions}
          selected={licenseFilter}
          onChange={setLicenseFilter}
        />
        <FilterBar
          label="Maturity:"
          options={maturityOptions}
          selected={maturityFilter}
          onChange={setMaturityFilter}
        />
      </div>

      {/* Results Count */}
      <p className="mb-4 text-sm text-gray-500">
        Showing {filtered.length} of {allTools.length} tools
      </p>

      {/* Card Grid */}
      {filtered.length === 0 ? (
        <div className="rounded-lg border border-gray-200 bg-white p-12 text-center">
          <p className="text-gray-500">
            No tools match your search criteria.
          </p>
        </div>
      ) : (
        <div className="grid gap-4 sm:grid-cols-1 lg:grid-cols-2">
          {filtered.map((tool) => (
            <ArtifactCard
              key={tool.id}
              title={tool.title}
              description={tool.description}
              tier="3"
              hostingType={tool.hostingType}
              status={tool.status}
              href={`/tools/${tool.id}`}
              metadata={[
                { label: "Vendor", value: tool.vendor },
                { label: "License", value: tool.licenseType },
                { label: "Maturity", value: tool.maturityLevel },
              ]}
            />
          ))}
        </div>
      )}
    </div>
  );
}
