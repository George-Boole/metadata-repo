"use client";

import { useState, useMemo } from "react";
import { getProfiles } from "@/lib/data";
import type { DomainProfile } from "@/types";
import ArtifactCard from "@/components/ArtifactCard";
import SearchBar from "@/components/SearchBar";
import FilterBar from "@/components/FilterBar";
import Link from "next/link";

const allProfiles = getProfiles();

function extractUnique(profiles: DomainProfile[], key: keyof DomainProfile) {
  const set = new Set(profiles.map((p) => String(p[key])));
  return Array.from(set).sort();
}

const domains = extractUnique(allProfiles, "domain");
const orgs = extractUnique(allProfiles, "owningOrganization");

const domainOptions = [
  { value: "all", label: "All" },
  ...domains.map((d) => ({ value: d, label: d })),
];

const orgOptions = [
  { value: "all", label: "All" },
  ...orgs.map((o) => ({ value: o, label: o })),
];

const statusOptions = [
  { value: "all", label: "All" },
  { value: "active", label: "Active" },
  { value: "draft", label: "Draft" },
  { value: "superseded", label: "Superseded" },
];

export default function ProfilesPage() {
  const [search, setSearch] = useState("");
  const [domainFilter, setDomainFilter] = useState("all");
  const [orgFilter, setOrgFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim();
    return allProfiles.filter((profile) => {
      if (q) {
        const haystack = [
          profile.title,
          profile.description,
          profile.owningOrganization,
          profile.domain,
          ...profile.keywords,
        ]
          .join(" ")
          .toLowerCase();
        if (!haystack.includes(q)) return false;
      }
      if (domainFilter !== "all" && profile.domain !== domainFilter)
        return false;
      if (orgFilter !== "all" && profile.owningOrganization !== orgFilter)
        return false;
      if (statusFilter !== "all" && profile.status !== statusFilter)
        return false;
      return true;
    });
  }, [search, domainFilter, orgFilter, statusFilter]);

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">Profiles</span>
      </nav>

      {/* Page Header */}
      <div className="mb-8">
        <div className="flex items-center gap-3 mb-2">
          <div className="h-8 w-1 rounded-full bg-tier-2b" />
          <h1 className="text-2xl font-bold text-daf-dark-gray sm:text-3xl">
            Domain Profiles
          </h1>
        </div>
        <p className="ml-4 text-gray-600 max-w-3xl">
          Tier 2B domain-specific metadata profiles — organization-level
          standards that select and constrain elements from Tier 2A technical
          specifications for a particular mission domain.
        </p>
      </div>

      {/* Search */}
      <div className="mb-6">
        <SearchBar
          value={search}
          onChange={setSearch}
          placeholder="Search domain profiles..."
        />
      </div>

      {/* Filters */}
      <div className="mb-6 flex flex-col gap-4">
        <FilterBar
          label="Domain:"
          options={domainOptions}
          selected={domainFilter}
          onChange={setDomainFilter}
        />
        <FilterBar
          label="Organization:"
          options={orgOptions}
          selected={orgFilter}
          onChange={setOrgFilter}
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
        Showing {filtered.length} of {allProfiles.length} domain profiles
      </p>

      {/* Card Grid */}
      {filtered.length === 0 ? (
        <div className="rounded-lg border border-gray-200 bg-white p-12 text-center">
          <p className="text-gray-500">
            No domain profiles match your search criteria.
          </p>
        </div>
      ) : (
        <div className="grid gap-4 sm:grid-cols-1 lg:grid-cols-2">
          {filtered.map((profile) => (
            <ArtifactCard
              key={profile.id}
              title={profile.title}
              description={profile.description}
              tier="2B"
              hostingType={profile.hostingType}
              status={profile.status}
              href={`/profiles/${profile.id}`}
              metadata={[
                { label: "Org", value: profile.owningOrganization },
                { label: "Domain", value: profile.domain },
                { label: "Version", value: profile.version },
              ]}
            />
          ))}
        </div>
      )}
    </div>
  );
}
