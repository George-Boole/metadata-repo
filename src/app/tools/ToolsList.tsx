"use client";

import { useState, useMemo } from "react";
import SourceList from "@/components/SourceList";
import ArtifactCard from "@/components/ArtifactCard";
import SearchBar from "@/components/SearchBar";
import FilterBar from "@/components/FilterBar";
import { getSpecById } from "@/lib/data";
import type { TaggingTool } from "@/types";
import type { SourceItem } from "@/components/SourceList";

interface ToolsListProps {
  sources: SourceItem[];
  jsonTools: TaggingTool[];
}

export default function ToolsList({ sources, jsonTools }: ToolsListProps) {
  if (sources.length > 0) {
    return (
      <SourceList
        sources={sources}
        tier="3"
        searchPlaceholder="Search tagging and labeling tools..."
        emptyMessage="No tools match your search criteria."
      />
    );
  }

  return <ToolsJsonList tools={jsonTools} />;
}

function ToolsJsonList({ tools }: { tools: TaggingTool[] }) {
  const [search, setSearch] = useState("");
  const [specFilter, setSpecFilter] = useState("all");
  const [licenseFilter, setLicenseFilter] = useState("all");
  const [maturityFilter, setMaturityFilter] = useState("all");

  const supportedSpecs = useMemo(() => {
    const map = new Map<string, string>();
    for (const tool of tools) {
      for (const specId of tool.supportedSpecIds) {
        if (!map.has(specId)) {
          const spec = getSpecById(specId);
          if (spec) map.set(specId, spec.title);
        }
      }
    }
    return Array.from(map.entries()).sort(([, a], [, b]) =>
      a.localeCompare(b),
    );
  }, [tools]);

  const specOptions = [
    { value: "all", label: "All" },
    ...supportedSpecs.map(([id, name]) => ({ value: id, label: name })),
  ];

  const licenseOptions = [
    { value: "all", label: "All" },
    ...Array.from(new Set(tools.map((t) => t.licenseType)))
      .sort()
      .map((l) => ({ value: l, label: l })),
  ];

  const maturityOptions = [
    { value: "all", label: "All" },
    { value: "production", label: "Production" },
    { value: "emerging", label: "Emerging" },
    { value: "experimental", label: "Experimental" },
  ];

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim();
    return tools.filter((tool) => {
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
  }, [tools, search, specFilter, licenseFilter, maturityFilter]);

  return (
    <>
      <div className="mb-6">
        <SearchBar
          value={search}
          onChange={setSearch}
          placeholder="Search tagging and labeling tools..."
        />
      </div>

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

      <p className="mb-4 text-sm text-gray-500">
        Showing {filtered.length} of {tools.length} tools
      </p>

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
    </>
  );
}
