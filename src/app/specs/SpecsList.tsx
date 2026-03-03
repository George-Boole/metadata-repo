"use client";

import { useState, useMemo } from "react";
import SourceList from "@/components/SourceList";
import ArtifactCard from "@/components/ArtifactCard";
import SearchBar from "@/components/SearchBar";
import FilterBar from "@/components/FilterBar";
import type { TechnicalSpec } from "@/types";
import type { SourceItem } from "@/components/SourceList";

interface SpecsListProps {
  sources: SourceItem[];
  jsonSpecs: TechnicalSpec[];
}

export default function SpecsList({ sources, jsonSpecs }: SpecsListProps) {
  if (sources.length > 0) {
    return (
      <SourceList
        sources={sources}
        tier="2A"
        searchPlaceholder="Search specifications..."
        emptyMessage="No specifications match your search criteria."
      />
    );
  }

  return <SpecsJsonList specs={jsonSpecs} />;
}

function SpecsJsonList({ specs }: { specs: TechnicalSpec[] }) {
  const [search, setSearch] = useState("");
  const [categoryFilter, setCategoryFilter] = useState("all");
  const [orgFilter, setOrgFilter] = useState("all");

  const categories = useMemo(() => {
    const cats = Array.from(new Set(specs.map((s) => s.category))).sort();
    return [
      { value: "all", label: "All Categories", count: specs.length },
      ...cats.map((c) => ({
        value: c,
        label: c,
        count: specs.filter((s) => s.category === c).length,
      })),
    ];
  }, [specs]);

  const orgs = useMemo(() => {
    const orgSet = Array.from(
      new Set(specs.map((s) => s.managingOrganization)),
    ).sort();
    return [
      { value: "all", label: "All Organizations", count: specs.length },
      ...orgSet.map((o) => ({
        value: o,
        label: o,
        count: specs.filter((s) => s.managingOrganization === o).length,
      })),
    ];
  }, [specs]);

  const filtered = useMemo(() => {
    const q = search.toLowerCase();
    return specs.filter((s) => {
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
  }, [specs, search, categoryFilter, orgFilter]);

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
    <>
      <SearchBar
        value={search}
        onChange={setSearch}
        placeholder="Search specifications..."
        className="mb-6"
      />

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

      <p className="text-sm text-gray-500 mb-4">
        Showing {filtered.length} of {specs.length} specifications
      </p>

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
          {filtered
            .filter(
              (s) =>
                s.parentSpecId &&
                !parentSpecs.some((p) => p.id === s.parentSpecId),
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
    </>
  );
}
