"use client";

import { useState, useMemo } from "react";
import { getSpecs } from "@/lib/data";
import type { TechnicalSpec } from "@/types";
import ArtifactCard from "@/components/ArtifactCard";
import SearchBar from "@/components/SearchBar";
import FilterBar from "@/components/FilterBar";

export default function SpecsPage() {
  const allSpecs = getSpecs();
  const [search, setSearch] = useState("");
  const [categoryFilter, setCategoryFilter] = useState("all");
  const [orgFilter, setOrgFilter] = useState("all");

  // Build filter options from data
  const categories = useMemo(() => {
    const cats = Array.from(new Set(allSpecs.map((s) => s.category))).sort();
    return [
      { value: "all", label: "All Categories", count: allSpecs.length },
      ...cats.map((c) => ({
        value: c,
        label: c,
        count: allSpecs.filter((s) => s.category === c).length,
      })),
    ];
  }, [allSpecs]);

  const orgs = useMemo(() => {
    const orgSet = Array.from(
      new Set(allSpecs.map((s) => s.managingOrganization))
    ).sort();
    return [
      { value: "all", label: "All Organizations", count: allSpecs.length },
      ...orgSet.map((o) => ({
        value: o,
        label: o,
        count: allSpecs.filter((s) => s.managingOrganization === o).length,
      })),
    ];
  }, [allSpecs]);

  // Filter specs
  const filtered = useMemo(() => {
    const q = search.toLowerCase();
    return allSpecs.filter((s) => {
      if (categoryFilter !== "all" && s.category !== categoryFilter)
        return false;
      if (orgFilter !== "all" && s.managingOrganization !== orgFilter)
        return false;
      if (
        q &&
        !s.title.toLowerCase().includes(q) &&
        !s.description.toLowerCase().includes(q) &&
        !s.keywords.some((k) => k.toLowerCase().includes(q))
      )
        return false;
      return true;
    });
  }, [allSpecs, search, categoryFilter, orgFilter]);

  // Separate parent specs (no parentSpecId) and sub-specs
  const parentSpecs = filtered.filter((s) => !s.parentSpecId);
  const subSpecsByParent = useMemo(() => {
    const map = new Map<string, TechnicalSpec[]>();
    for (const s of filtered) {
      if (s.parentSpecId) {
        const existing = map.get(s.parentSpecId) || [];
        existing.push(s);
        map.set(s.parentSpecId, existing);
      }
    }
    return map;
  }, [filtered]);

  return (
    <div>
      {/* Page Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="h-8 w-1.5 rounded-full bg-tier-2a" />
          <h1 className="text-3xl font-bold text-daf-dark-gray">
            Technical Specifications
          </h1>
        </div>
        <p className="text-gray-600 ml-5">
          Tier 2A — Standards and specifications that define metadata formats,
          vocabularies, and exchange protocols used across the Department of the
          Air Force.
        </p>
      </div>

      {/* Search */}
      <SearchBar
        value={search}
        onChange={setSearch}
        placeholder="Search specifications..."
        className="mb-6"
      />

      {/* Filters */}
      <div className="space-y-3 mb-8">
        <FilterBar
          label="Category:"
          options={categories}
          selected={categoryFilter}
          onChange={setCategoryFilter}
        />
        <FilterBar
          label="Organization:"
          options={orgs}
          selected={orgFilter}
          onChange={setOrgFilter}
        />
      </div>

      {/* Results count */}
      <p className="text-sm text-gray-500 mb-4">
        Showing {filtered.length} of {allSpecs.length} specifications
      </p>

      {/* Specs Grid — parents with grouped sub-specs */}
      {filtered.length === 0 ? (
        <div className="rounded-lg border border-gray-200 bg-white p-12 text-center">
          <p className="text-gray-500">
            No specifications match your filters.
          </p>
        </div>
      ) : (
        <div className="space-y-4">
          {parentSpecs.map((spec) => {
            const subs = subSpecsByParent.get(spec.id) || [];
            return (
              <div key={spec.id}>
                <ArtifactCard
                  title={spec.title}
                  description={spec.description}
                  tier="2A"
                  hostingType={spec.hostingType}
                  status={spec.status}
                  href={`/specs/${spec.id}`}
                  metadata={[
                    { label: "Version", value: spec.version },
                    { label: "Org", value: spec.managingOrganization },
                    { label: "Category", value: spec.category },
                  ]}
                />
                {/* Sub-specs indented under parent */}
                {subs.length > 0 && (
                  <div className="ml-8 mt-2 space-y-2 border-l-2 border-tier-2a/30 pl-4">
                    <span className="text-xs font-medium text-tier-2a uppercase tracking-wide">
                      Sub-specifications
                    </span>
                    {subs.map((sub) => (
                      <ArtifactCard
                        key={sub.id}
                        title={sub.title}
                        description={sub.description}
                        tier="2A"
                        hostingType={sub.hostingType}
                        status={sub.status}
                        href={`/specs/${sub.id}`}
                        metadata={[
                          { label: "Version", value: sub.version },
                          { label: "Org", value: sub.managingOrganization },
                          { label: "Category", value: sub.category },
                        ]}
                      />
                    ))}
                  </div>
                )}
              </div>
            );
          })}

          {/* Show orphan sub-specs whose parent didn't match filter */}
          {filtered
            .filter(
              (s) =>
                s.parentSpecId &&
                !parentSpecs.some((p) => p.id === s.parentSpecId)
            )
            .map((spec) => (
              <ArtifactCard
                key={spec.id}
                title={spec.title}
                description={spec.description}
                tier="2A"
                hostingType={spec.hostingType}
                status={spec.status}
                href={`/specs/${spec.id}`}
                metadata={[
                  { label: "Version", value: spec.version },
                  { label: "Org", value: spec.managingOrganization },
                  { label: "Category", value: spec.category },
                ]}
              />
            ))}
        </div>
      )}
    </div>
  );
}
