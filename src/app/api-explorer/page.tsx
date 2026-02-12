"use client";

import { useState } from "react";
import Link from "next/link";

/* ------------------------------------------------------------------ */
/*  Types for the API Explorer's own mock data                        */
/* ------------------------------------------------------------------ */

interface Endpoint {
  id: string;
  method: "GET";
  path: string;
  label: string;
  description: string;
  curlExample: string;
  response: object;
}

/* ------------------------------------------------------------------ */
/*  Mock endpoint definitions with realistic response data            */
/* ------------------------------------------------------------------ */

const ENDPOINTS: Endpoint[] = [
  {
    id: "guidance",
    method: "GET",
    path: "/api/guidance",
    label: "Guidance",
    description:
      "Returns all Tier 1 authoritative guidance documents — DoD Instructions, directives, and memos that establish metadata policy.",
    curlExample: `curl -X GET https://metadata.daf.mil/api/guidance \\
  -H "Accept: application/json" \\
  -H "Authorization: Bearer <token>"`,
    response: {
      data: [
        {
          id: "guid-001",
          tier: "1",
          title: "Sharing Data, Information, and Technology (IT) Services in the DoD",
          documentNumber: "DoDI 8320.02",
          issuingAuthority: "DoD CIO",
          issueDate: "2024-04-12",
          status: "active",
          hostingType: "linked",
          externalUrl: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/832002p.pdf",
          summary:
            "Establishes policy for data sharing across DoD, mandating use of metadata standards to enable discovery and interoperability.",
          relatedSpecIds: ["spec-niem", "spec-dublin-core"],
          keywords: ["data sharing", "interoperability", "metadata standards"],
        },
        {
          id: "guid-002",
          tier: "1",
          title: "DoD Data Strategy Implementation",
          documentNumber: "DoDI 8320.07",
          issuingAuthority: "DoD CIO",
          issueDate: "2023-08-15",
          status: "active",
          hostingType: "linked",
          externalUrl: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/832007p.pdf",
          summary:
            "Directs implementation of the DoD Data Strategy, including metadata tagging requirements for authoritative data sources.",
          relatedSpecIds: ["spec-niem", "spec-ic-ism"],
          keywords: ["data strategy", "metadata tagging", "authoritative data"],
        },
      ],
      meta: {
        total: 4,
        returned: 2,
        tier: "1",
        label: "Authoritative Guidance",
      },
    },
  },
  {
    id: "specs",
    method: "GET",
    path: "/api/specs",
    label: "Specifications",
    description:
      "Returns all Tier 2A technical specifications — metadata standards and exchange models used across the DoD.",
    curlExample: `curl -X GET https://metadata.daf.mil/api/specs \\
  -H "Accept: application/json" \\
  -H "Authorization: Bearer <token>"`,
    response: {
      data: [
        {
          id: "spec-niem",
          tier: "2A",
          title: "National Information Exchange Model (NIEM)",
          version: "6.0",
          managingOrganization: "NIEM Management Office",
          category: "Data Exchange",
          status: "active",
          hostingType: "stored",
          description:
            "A common vocabulary for information exchange across government. Defines reusable data components and schemas for structured data sharing.",
          elements: [
            "nc:PersonType",
            "nc:LocationType",
            "nc:ActivityType",
            "nc:DocumentType",
            "nc:OrganizationType",
          ],
          relatedGuidanceIds: ["guid-001", "guid-002"],
          relatedProfileIds: ["prof-af-intel", "prof-af-logistics"],
          keywords: ["NIEM", "data exchange", "XML schema", "information sharing"],
        },
        {
          id: "spec-ic-ism",
          tier: "2A",
          title: "Intelligence Community Information Security Marking (IC-ISM)",
          version: "13.0",
          managingOrganization: "ODNI",
          category: "Information Security Marking",
          status: "active",
          hostingType: "linked",
          externalUrl: "https://www.dni.gov/index.php/who-we-are/organizations/ic-cio/ic-cio-related-menus/ic-cio-related-links/ic-technical-specifications",
          description:
            "XML-based specification for applying classification and dissemination markings to intelligence information.",
          relatedGuidanceIds: ["guid-002"],
          relatedProfileIds: ["prof-af-intel"],
          keywords: ["IC-ISM", "classification", "security marking", "intelligence"],
        },
        {
          id: "spec-dublin-core",
          tier: "2A",
          title: "Dublin Core Metadata Element Set",
          version: "1.1",
          managingOrganization: "Dublin Core Metadata Initiative (DCMI)",
          category: "Descriptive Metadata",
          status: "active",
          hostingType: "linked",
          externalUrl: "https://www.dublincore.org/specifications/dublin-core/dces/",
          description:
            "A set of fifteen core metadata elements for cross-domain resource description. Widely adopted as a baseline metadata vocabulary.",
          elements: [
            "dc:title",
            "dc:creator",
            "dc:subject",
            "dc:description",
            "dc:date",
          ],
          relatedGuidanceIds: ["guid-001"],
          relatedProfileIds: ["prof-af-logistics"],
          keywords: ["Dublin Core", "descriptive metadata", "resource description"],
        },
      ],
      meta: {
        total: 8,
        returned: 3,
        tier: "2A",
        label: "Technical Specifications",
      },
    },
  },
  {
    id: "profiles",
    method: "GET",
    path: "/api/profiles",
    label: "Profiles",
    description:
      "Returns all Tier 2B domain profiles — organization-specific metadata profiles tailored from Tier 2A standards.",
    curlExample: `curl -X GET https://metadata.daf.mil/api/profiles \\
  -H "Accept: application/json" \\
  -H "Authorization: Bearer <token>"`,
    response: {
      data: [
        {
          id: "prof-af-intel",
          tier: "2B",
          title: "AF Intelligence Metadata Profile",
          owningOrganization: "AF/A2",
          domain: "Intelligence",
          version: "2.1",
          status: "active",
          hostingType: "stored",
          description:
            "Metadata profile for Air Force intelligence products, combining NIEM data elements with IC security markings.",
          incorporatedSpecs: [
            {
              specId: "spec-niem",
              specName: "NIEM",
              elementsUsed: ["nc:PersonType", "nc:LocationType", "nc:ActivityType"],
            },
            {
              specId: "spec-ic-ism",
              specName: "IC-ISM",
              elementsUsed: ["ism:ClassificationMarking", "ism:DisseminationControls"],
            },
          ],
          keywords: ["intelligence", "AF/A2", "security marking"],
        },
        {
          id: "prof-af-logistics",
          tier: "2B",
          title: "AF Logistics Data Profile",
          owningOrganization: "AF/A4",
          domain: "Logistics",
          version: "1.3",
          status: "active",
          hostingType: "stored",
          description:
            "Metadata profile for Air Force logistics and supply chain data, built on NIEM and Dublin Core.",
          incorporatedSpecs: [
            {
              specId: "spec-niem",
              specName: "NIEM",
              elementsUsed: ["nc:OrganizationType", "nc:DocumentType"],
            },
            {
              specId: "spec-dublin-core",
              specName: "Dublin Core",
              elementsUsed: ["dc:title", "dc:creator", "dc:date"],
            },
          ],
          keywords: ["logistics", "supply chain", "AF/A4"],
        },
      ],
      meta: {
        total: 5,
        returned: 2,
        tier: "2B",
        label: "Domain Profiles",
      },
    },
  },
  {
    id: "tools",
    method: "GET",
    path: "/api/tools",
    label: "Tools",
    description:
      "Returns all Tier 3 tagging and labeling tools — software that applies metadata standards to data assets.",
    curlExample: `curl -X GET https://metadata.daf.mil/api/tools \\
  -H "Accept: application/json" \\
  -H "Authorization: Bearer <token>"`,
    response: {
      data: [
        {
          id: "tool-dcamps",
          tier: "3",
          title: "DCAMPS-C (Data-Centric Automated Metadata & Protection System)",
          vendor: "Mundo Systems",
          capabilities: [
            "Automated classification marking",
            "IC-ISM attribute tagging",
            "Bulk metadata application",
            "Policy-based labeling",
          ],
          supportedSpecIds: ["spec-ic-ism", "spec-ic-edh"],
          licenseType: "Government",
          maturityLevel: "production",
          status: "active",
          hostingType: "linked",
          externalUrl: "https://mundosystems.com/dcamps",
          description:
            "Automated tool for applying IC security markings and metadata tags to documents and data in accordance with IC-ISM and IC-EDH standards.",
          keywords: ["DCAMPS", "classification", "automated tagging"],
        },
        {
          id: "tool-purview",
          tier: "3",
          title: "Microsoft Purview Data Governance",
          vendor: "Microsoft",
          capabilities: [
            "Sensitivity labeling",
            "Data classification",
            "Compliance tagging",
            "Automated metadata discovery",
          ],
          supportedSpecIds: ["spec-dublin-core"],
          licenseType: "Commercial",
          maturityLevel: "production",
          status: "active",
          hostingType: "linked",
          externalUrl: "https://learn.microsoft.com/en-us/purview/",
          description:
            "Enterprise data governance platform that enables sensitivity labeling, data classification, and compliance-driven metadata tagging.",
          keywords: ["Purview", "sensitivity label", "data governance"],
        },
      ],
      meta: {
        total: 4,
        returned: 2,
        tier: "3",
        label: "Tagging & Labeling Tools",
      },
    },
  },
  {
    id: "search",
    method: "GET",
    path: "/api/search?q=NIEM",
    label: "Search",
    description:
      'Searches across all tiers by keyword. The example below queries for "NIEM" and returns matching results from every tier.',
    curlExample: `curl -X GET "https://metadata.daf.mil/api/search?q=NIEM" \\
  -H "Accept: application/json" \\
  -H "Authorization: Bearer <token>"`,
    response: {
      query: "NIEM",
      results: [
        {
          id: "spec-niem",
          tier: "2A",
          title: "National Information Exchange Model (NIEM)",
          description: "A common vocabulary for information exchange across government.",
          matchField: "title",
          relevanceScore: 1.0,
        },
        {
          id: "guid-001",
          tier: "1",
          title: "Sharing Data, Information, and Technology (IT) Services in the DoD",
          description: "Mandates use of metadata standards including NIEM for data sharing.",
          matchField: "keywords",
          relevanceScore: 0.82,
        },
        {
          id: "prof-af-intel",
          tier: "2B",
          title: "AF Intelligence Metadata Profile",
          description: "Incorporates NIEM data elements for intelligence products.",
          matchField: "description",
          relevanceScore: 0.75,
        },
        {
          id: "prof-af-logistics",
          tier: "2B",
          title: "AF Logistics Data Profile",
          description: "Built on NIEM and Dublin Core for logistics data.",
          matchField: "description",
          relevanceScore: 0.68,
        },
      ],
      meta: {
        total: 4,
        query: "NIEM",
        tiers: { "1": 1, "2A": 1, "2B": 2, "3": 0 },
      },
    },
  },
];

/* ------------------------------------------------------------------ */
/*  Tier color map (matches project design conventions)               */
/* ------------------------------------------------------------------ */

const TIER_COLORS: Record<string, string> = {
  "1": "bg-blue-100 text-blue-800",
  "2A": "bg-emerald-100 text-emerald-800",
  "2B": "bg-amber-100 text-amber-800",
  "3": "bg-violet-100 text-violet-800",
};

function TierBadge({ tier }: { tier: string }) {
  return (
    <span
      className={`inline-block text-xs font-semibold px-2 py-0.5 rounded ${TIER_COLORS[tier] ?? "bg-slate-100 text-slate-800"}`}
    >
      Tier {tier}
    </span>
  );
}

/* ------------------------------------------------------------------ */
/*  Component: JSON syntax highlighting (lightweight, no dependency)  */
/* ------------------------------------------------------------------ */

function JsonBlock({ data }: { data: object }) {
  const json = JSON.stringify(data, null, 2);
  return (
    <pre className="bg-slate-900 text-slate-100 rounded-lg p-4 text-sm leading-relaxed overflow-x-auto font-mono whitespace-pre">
      {json}
    </pre>
  );
}

/* ------------------------------------------------------------------ */
/*  Component: Curl command block                                     */
/* ------------------------------------------------------------------ */

function CurlBlock({ command }: { command: string }) {
  return (
    <pre className="bg-slate-800 text-emerald-400 rounded-lg p-4 text-sm leading-relaxed overflow-x-auto font-mono whitespace-pre">
      <span className="text-slate-500 select-none">$ </span>
      {command}
    </pre>
  );
}

/* ------------------------------------------------------------------ */
/*  Component: DevSecOps Narrative Section                            */
/* ------------------------------------------------------------------ */

function DevSecOpsNarrative() {
  return (
    <section className="mt-12 border-t border-slate-200 pt-10">
      <h2 className="text-2xl font-bold text-slate-900 mb-6">
        DevSecOps &amp; CI/CD Integration Value
      </h2>

      <div className="grid md:grid-cols-2 gap-8 mb-10">
        {/* Left column: narrative */}
        <div className="space-y-4 text-slate-700 leading-relaxed">
          <p>
            A programmatic API to the Metadata Repository transforms it from a
            reference catalog into an <strong>active component of the software
            delivery pipeline</strong>. Automated systems can query the
            repository at build, deploy, and runtime to verify that data
            conforms to required metadata standards.
          </p>
          <p>
            This enables a <strong>shift-left approach to metadata
            compliance</strong>: issues are caught during development rather
            than discovered during accreditation or after deployment. The
            repository becomes the single source of truth that both human
            users and automated tooling reference.
          </p>
          <p>
            Key integration scenarios include:
          </p>
          <ul className="list-disc pl-5 space-y-2">
            <li>
              <strong>Pipeline compliance gates</strong> &mdash; CI/CD jobs
              query the API to retrieve required metadata schemas, then
              validate data artifacts against those schemas before allowing
              promotion to the next environment.
            </li>
            <li>
              <strong>Automated tagging verification</strong> &mdash; Tools
              in Tier 3 can be configured to pull the latest standard
              definitions from the API, ensuring tagging rules stay current
              without manual updates.
            </li>
            <li>
              <strong>Audit and reporting</strong> &mdash; Governance
              dashboards can query the API to generate compliance reports
              across organizational data assets.
            </li>
          </ul>
        </div>

        {/* Right column: workflow diagram */}
        <div className="bg-slate-50 rounded-xl border border-slate-200 p-6">
          <h3 className="text-sm font-semibold text-slate-500 uppercase tracking-wider mb-5">
            Example: CI/CD Compliance Gate
          </h3>
          <div className="space-y-0">
            {/* Step 1 */}
            <WorkflowStep
              number={1}
              title="Developer pushes code + data artifacts"
              detail="Pipeline triggers on commit to main branch"
              color="bg-blue-600"
            />
            <WorkflowArrow />
            {/* Step 2 */}
            <WorkflowStep
              number={2}
              title="Pipeline queries Metadata Repository API"
              detail="GET /api/specs — retrieves required schemas for the data domain"
              color="bg-emerald-600"
            />
            <WorkflowArrow />
            {/* Step 3 */}
            <WorkflowStep
              number={3}
              title="Validation engine checks data artifacts"
              detail="Compares data attributes against retrieved metadata schemas"
              color="bg-amber-600"
            />
            <WorkflowArrow />
            {/* Step 4 */}
            <WorkflowStep
              number={4}
              title="Compliance result: Pass or Fail"
              detail="Non-compliant data blocks deployment; report generated for review"
              color="bg-violet-600"
            />
          </div>

          {/* Example pipeline snippet */}
          <div className="mt-8">
            <h4 className="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-3">
              Pipeline Snippet (conceptual)
            </h4>
            <pre className="bg-slate-900 text-slate-300 rounded-lg p-4 text-xs leading-relaxed overflow-x-auto font-mono whitespace-pre">
{`# .gitlab-ci.yml  (or GitHub Actions equivalent)
metadata-compliance-check:
  stage: validate
  script:
    - |
      # Fetch required metadata schemas from the repository
      SCHEMAS=$(curl -s https://metadata.daf.mil/api/specs \\
        -H "Authorization: Bearer $REPO_TOKEN")

      # Validate data artifacts against the schemas
      python validate_metadata.py \\
        --schemas "$SCHEMAS" \\
        --data-dir ./data/

      # Exit code 0 = compliant, non-zero = violations found
  rules:
    - if: $CI_COMMIT_BRANCH == "main"`}
            </pre>
          </div>
        </div>
      </div>
    </section>
  );
}

function WorkflowStep({
  number,
  title,
  detail,
  color,
}: {
  number: number;
  title: string;
  detail: string;
  color: string;
}) {
  return (
    <div className="flex items-start gap-3">
      <div
        className={`flex-shrink-0 w-7 h-7 rounded-full ${color} text-white text-sm font-bold flex items-center justify-center`}
      >
        {number}
      </div>
      <div>
        <p className="text-sm font-semibold text-slate-800">{title}</p>
        <p className="text-xs text-slate-500 mt-0.5">{detail}</p>
      </div>
    </div>
  );
}

function WorkflowArrow() {
  return (
    <div className="flex items-center pl-3 py-1">
      <div className="w-0.5 h-5 bg-slate-300 ml-[11px]" />
    </div>
  );
}

/* ------------------------------------------------------------------ */
/*  Page component                                                    */
/* ------------------------------------------------------------------ */

export default function ApiExplorerPage() {
  const [selectedId, setSelectedId] = useState<string>(ENDPOINTS[0].id);
  const selected = ENDPOINTS.find((e) => e.id === selectedId)!;

  return (
    <div className="min-h-screen bg-slate-50">
      {/* Header bar */}
      <header className="bg-slate-900 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex items-center justify-between">
          <Link href="/" className="text-lg font-bold tracking-tight hover:text-slate-300 transition-colors">
            DAF Metadata Repository
          </Link>
          <span className="text-sm text-slate-400">Prototype</span>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        {/* Page title */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-slate-900 mb-3">
            API Explorer
          </h1>
          <p className="text-lg text-slate-600 max-w-3xl leading-relaxed">
            This page demonstrates what programmatic access to the DAF Metadata
            Repository would look like. A RESTful API enables DevSecOps
            pipelines, CI/CD workflows, and automated tools to query metadata
            standards, validate compliance, and integrate repository data
            directly into operational processes.
          </p>
          <p className="text-sm text-slate-500 mt-2">
            Select an endpoint below to see an example request and simulated
            JSON response.
          </p>
        </div>

        {/* Two-column layout: sidebar + content */}
        <div className="flex flex-col lg:flex-row gap-8">
          {/* Sidebar: endpoint list */}
          <nav className="lg:w-72 flex-shrink-0">
            <div className="bg-white rounded-xl border border-slate-200 overflow-hidden">
              <div className="bg-slate-800 text-white px-4 py-3">
                <h2 className="text-sm font-semibold tracking-wider uppercase">
                  Endpoints
                </h2>
              </div>
              <ul className="divide-y divide-slate-100">
                {ENDPOINTS.map((ep) => (
                  <li key={ep.id}>
                    <button
                      onClick={() => setSelectedId(ep.id)}
                      className={`w-full text-left px-4 py-3 transition-colors ${
                        selectedId === ep.id
                          ? "bg-blue-50 border-l-4 border-blue-600"
                          : "hover:bg-slate-50 border-l-4 border-transparent"
                      }`}
                    >
                      <span className="text-xs font-bold text-emerald-700 font-mono">
                        {ep.method}
                      </span>{" "}
                      <span
                        className={`text-sm font-mono ${
                          selectedId === ep.id
                            ? "text-blue-900 font-semibold"
                            : "text-slate-700"
                        }`}
                      >
                        {ep.path}
                      </span>
                      <p className="text-xs text-slate-500 mt-0.5">
                        {ep.label}
                      </p>
                    </button>
                  </li>
                ))}
              </ul>
            </div>

            {/* Base URL info */}
            <div className="mt-4 bg-white rounded-xl border border-slate-200 p-4">
              <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">
                Base URL
              </h3>
              <code className="text-sm font-mono text-slate-800 break-all">
                https://metadata.daf.mil
              </code>
              <p className="text-xs text-slate-400 mt-2">
                Hypothetical production endpoint. All responses shown are
                simulated mock data.
              </p>
            </div>

            {/* Auth info */}
            <div className="mt-4 bg-white rounded-xl border border-slate-200 p-4">
              <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">
                Authentication
              </h3>
              <p className="text-xs text-slate-600 leading-relaxed">
                API access would require a valid Bearer token issued through
                the DAF identity provider. Tokens would carry organization and
                clearance-level claims to scope data access appropriately.
              </p>
            </div>
          </nav>

          {/* Main content: selected endpoint detail */}
          <div className="flex-1 min-w-0">
            <div className="bg-white rounded-xl border border-slate-200 overflow-hidden">
              {/* Endpoint header */}
              <div className="bg-slate-800 text-white px-6 py-4 flex items-center gap-3">
                <span className="bg-emerald-500/20 text-emerald-300 text-xs font-bold font-mono px-2.5 py-1 rounded">
                  {selected.method}
                </span>
                <span className="text-lg font-mono">{selected.path}</span>
              </div>

              <div className="p-6 space-y-8">
                {/* Description */}
                <div>
                  <h3 className="text-sm font-semibold text-slate-500 uppercase tracking-wider mb-2">
                    Description
                  </h3>
                  <p className="text-slate-700 leading-relaxed">
                    {selected.description}
                  </p>
                </div>

                {/* Example request */}
                <div>
                  <h3 className="text-sm font-semibold text-slate-500 uppercase tracking-wider mb-3">
                    Example Request
                  </h3>
                  <CurlBlock command={selected.curlExample} />
                </div>

                {/* Response */}
                <div>
                  <div className="flex items-center gap-3 mb-3">
                    <h3 className="text-sm font-semibold text-slate-500 uppercase tracking-wider">
                      Simulated Response
                    </h3>
                    <span className="text-xs font-mono bg-emerald-100 text-emerald-700 px-2 py-0.5 rounded">
                      200 OK
                    </span>
                  </div>

                  {/* Tier badges for items in the response */}
                  {"data" in selected.response &&
                    Array.isArray(
                      (selected.response as Record<string, unknown>).data
                    ) && (
                      <div className="flex gap-2 mb-3 flex-wrap">
                        {(
                          (selected.response as Record<string, unknown>)
                            .data as Array<Record<string, string>>
                        ).map((item) => (
                          <TierBadge key={item.id} tier={item.tier} />
                        ))}
                      </div>
                    )}

                  {"results" in selected.response &&
                    Array.isArray(
                      (selected.response as Record<string, unknown>).results
                    ) && (
                      <div className="flex gap-2 mb-3 flex-wrap">
                        {(
                          (selected.response as Record<string, unknown>)
                            .results as Array<Record<string, string>>
                        ).map((item) => (
                          <TierBadge key={item.id} tier={item.tier} />
                        ))}
                      </div>
                    )}

                  <JsonBlock data={selected.response} />
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* DevSecOps narrative section */}
        <DevSecOpsNarrative />
      </main>

      {/* Footer */}
      <footer className="border-t border-slate-200 mt-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 text-center text-sm text-slate-400">
          DAF Metadata Repository &mdash; Prototype / Concept Demonstration
        </div>
      </footer>
    </div>
  );
}
