"use client";

import { useState, useMemo } from "react";
import { getOntologies } from "@/lib/data";
import ArtifactCard from "@/components/ArtifactCard";
import SearchBar from "@/components/SearchBar";
import FilterBar from "@/components/FilterBar";
import { FictionalBadge } from "@/components/Badge";
import Link from "next/link";

const FICTIONAL_IDS = new Set(["onto-daf-fabric"]);

const allOntologies = getOntologies();

const typeOptions = [
  { value: "all", label: "All" },
  { value: "domain", label: "Domain" },
  { value: "foundational", label: "Foundational" },
  { value: "repository", label: "Repository" },
  { value: "internal", label: "Internal" },
];

export default function OntologiesPage() {
  const [search, setSearch] = useState("");
  const [typeFilter, setTypeFilter] = useState("all");

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim();
    return allOntologies.filter((onto) => {
      if (q) {
        const haystack = [
          onto.title,
          onto.description,
          onto.managingOrganization,
          onto.ontologyType,
          onto.format ?? "",
          onto.domain ?? "",
          ...onto.keywords,
        ]
          .join(" ")
          .toLowerCase();
        if (!haystack.includes(q)) return false;
      }
      if (typeFilter !== "all" && onto.ontologyType !== typeFilter) return false;
      return true;
    });
  }, [search, typeFilter]);

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">Ontologies</span>
      </nav>

      {/* Page Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="h-8 w-1 rounded-full bg-ontology" />
          <h1 className="text-2xl font-bold text-daf-dark-gray sm:text-3xl">
            Ontologies
          </h1>
        </div>
        <p className="ml-4 text-gray-600 max-w-3xl">
          Formal knowledge representations that define concepts and relationships
          within metadata domains. Ontologies enable semantic interoperability,
          automated reasoning, and consistent vocabulary across DAF systems.
        </p>
      </div>

      {/* Search */}
      <div className="mb-6">
        <SearchBar
          value={search}
          onChange={setSearch}
          placeholder="Search ontologies..."
        />
      </div>

      {/* Filters */}
      <div className="mb-6">
        <FilterBar
          label="Type:"
          options={typeOptions}
          selected={typeFilter}
          onChange={setTypeFilter}
        />
      </div>

      {/* Results Count */}
      <p className="mb-4 text-sm text-gray-500">
        Showing {filtered.length} of {allOntologies.length} ontologies
      </p>

      {/* Card Grid */}
      {filtered.length === 0 ? (
        <div className="rounded-lg border border-gray-200 bg-white p-12 text-center">
          <p className="text-gray-500">
            No ontologies match your search criteria.
          </p>
        </div>
      ) : (
        <div className="grid gap-4 sm:grid-cols-1 lg:grid-cols-2">
          {filtered.map((onto) => (
            <div key={onto.id} className="relative">
              {FICTIONAL_IDS.has(onto.id) && (
                <div className="absolute top-2 right-2 z-10">
                  <FictionalBadge />
                </div>
              )}
              <ArtifactCard
                title={onto.title}
                description={onto.description}
                tier="ontology"
                hostingType={onto.hostingType}
                status={onto.status}
                href={`/ontologies/${onto.id}`}
                metadata={[
                  {
                    label: "Type",
                    value:
                      onto.ontologyType.charAt(0).toUpperCase() +
                      onto.ontologyType.slice(1),
                  },
                  ...(onto.format
                    ? [{ label: "Format", value: onto.format }]
                    : []),
                  { label: "Org", value: onto.managingOrganization },
                ]}
              />
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
