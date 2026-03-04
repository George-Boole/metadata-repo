/**
 * Bulk ingestion script for Tier 1 Authoritative Guidance sources.
 *
 * Covers 7 authority layers:
 *   1. Federal Statutes & OMB Policy
 *   2. DoD-Wide Directives (DoDD)
 *   3. DoD Instructions (DoDI)
 *   4. DoD Manuals (DoDM)
 *   5. DoD CIO Guidance
 *   6. DAF Policy Directives (AFPD)
 *   7. DAF Instructions & Manuals (DAFI/AFI/DAFMAN)
 *
 * Usage:
 *   npx tsx scripts/ingest-tier1-guidance.ts
 *   npx tsx scripts/ingest-tier1-guidance.ts --skip-existing
 *   npx tsx scripts/ingest-tier1-guidance.ts --only="8320"
 *   npx tsx scripts/ingest-tier1-guidance.ts --only="Data Strategy" --skip-existing
 *   npx tsx scripts/ingest-tier1-guidance.ts --layer=3
 *
 * Requires .env.local with Supabase, OpenAI, Neo4j, and Gemini keys.
 */

import { config } from "dotenv";
config({ path: ".env.local" });
import { ingestUrl } from "../src/lib/ingest/pipeline";
import { getSourceByUrl } from "../src/lib/data-server";

interface GuidanceJob {
  url: string;
  title: string;
  description: string;
  layer: number;
}

// ─── Layer 1: Federal Statutes & OMB Policy ─────────────────────────
const LAYER_1: GuidanceJob[] = [
  {
    url: "https://www.law.cornell.edu/uscode/text/44/3520",
    title: "44 USC §3520 — Chief Data Officers",
    description:
      "Federal statute establishing Chief Data Officer roles and responsibilities, including data governance, metadata management, and data inventory requirements across federal agencies.",
    layer: 1,
  },
  {
    url: "https://www.law.cornell.edu/uscode/text/44/chapter-35",
    title: "44 USC Chapter 35 — Coordination of Federal Information Policy",
    description:
      "Full chapter of federal statute governing information resource management, paperwork reduction, and information security across all federal agencies.",
    layer: 1,
  },
  {
    url: "https://www.whitehouse.gov/wp-content/uploads/legacy_drupal_files/omb/circulars/A130/a130revised.pdf",
    title: "OMB Circular A-130 — Managing Information as a Strategic Resource",
    description:
      "Office of Management and Budget policy establishing requirements for managing federal information resources, including metadata, data governance, and open data.",
    layer: 1,
  },
  {
    url: "https://www.congress.gov/bill/115th-congress/house-bill/4174/text",
    title: "OPEN Government Data Act (Evidence Act Title II)",
    description:
      "Federal law requiring agencies to publish data as open data with machine-readable metadata, standardized formats, and public data inventories.",
    layer: 1,
  },
];

// ─── Layer 2: DoD-Wide Directives (DoDD) ────────────────────────────
const LAYER_2: GuidanceJob[] = [
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodd/800001p.pdf",
    title: "DoDD 8000.01 — Management of the DoD Information Enterprise",
    description:
      "Top-level DoD directive establishing policy for managing the DoD Information Enterprise, including data as a strategic asset and interoperability requirements.",
    layer: 2,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodd/814001_2023.pdf",
    title: "DoDD 8140.01 — Cyberspace Workforce Management",
    description:
      "DoD directive establishing policy for identifying, recruiting, developing, and retaining the cyberspace workforce.",
    layer: 2,
  },
];

// ─── Layer 3: DoD Instructions (DoDI) ───────────────────────────────
const LAYER_3: GuidanceJob[] = [
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/831001p.pdf",
    title: "DoDI 8310.01 — IT Standards in the DoD",
    description:
      "Establishes policy and assigns responsibilities for the development, maintenance, and use of IT standards across the DoD.",
    layer: 3,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/832002p.pdf",
    title: "DoDI 8320.02 — Sharing Data, Information, and IT Services in the DoD",
    description:
      "Core DoD instruction mandating data sharing, metadata tagging, and the use of community-of-interest metadata standards.",
    layer: 3,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/832007p.pdf",
    title: "DoDI 8320.07 — Implementing the Sharing of Data, Information, and IT Services in the DoD",
    description:
      "Implementation guidance for DoDI 8320.02, covering metadata registries, data asset discovery, and interoperability requirements.",
    layer: 3,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/833001p.pdf",
    title: "DoDI 8330.01 — Interoperability of IT Including National Security Systems",
    description:
      "Establishes interoperability requirements for DoD IT systems, mandating standards-based data exchange and metadata tagging.",
    layer: 3,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/850001_2014.pdf",
    title: "DoDI 8500.01 — Cybersecurity",
    description:
      "Establishes the DoD cybersecurity program, including requirements for information assurance, risk management, and data protection.",
    layer: 3,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/851001p.pdf",
    title: "DoDI 8510.01 — Risk Management Framework for DoD IT",
    description:
      "Implements the Risk Management Framework (RMF) for DoD IT, replacing DIACAP. Covers security categorization, control selection, and continuous monitoring.",
    layer: 3,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/811001p.pdf",
    title: "DoDI 8110.01 — Mission Partner Environment Information Sharing",
    description:
      "Establishes policy for information sharing with mission partners, including metadata requirements for cross-domain data exchange.",
    layer: 3,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/501502p.pdf",
    title: "DoDI 5015.02 — DoD Records Management Program",
    description:
      "Establishes the DoD records management program, including metadata requirements for electronic records lifecycle management.",
    layer: 3,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/520048p.pdf",
    title: "DoDI 5200.48 — Controlled Unclassified Information (CUI)",
    description:
      "Establishes DoD CUI policy, including marking requirements, metadata for CUI categories, and dissemination controls.",
    layer: 3,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodi/832004p.pdf",
    title: "DoDI 8320.04 — Item Unique Identification Standards for Tangible Personal Property",
    description:
      "Establishes IUID policy for marking and tracking DoD assets with unique identifiers and associated metadata.",
    layer: 3,
  },
];

// ─── Layer 4: DoD Manuals (DoDM) ────────────────────────────────────
const LAYER_4: GuidanceJob[] = [
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodm/520001m_vol1.pdf",
    title: "DoDM 5200.01 Vol 1 — Information Security Program: Overview, Classification, Declassification",
    description:
      "DoD manual covering classification marking, metadata for classified information, and security marking requirements.",
    layer: 4,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodm/520001m_vol4.pdf",
    title: "DoDM 5200.01 Vol 4 — Information Security Program: Controlled Unclassified Information",
    description:
      "DoD manual covering CUI marking and handling procedures, metadata requirements for CUI categories and dissemination controls.",
    layer: 4,
  },
  {
    url: "https://www.esd.whs.mil/Portals/54/Documents/DD/issuances/dodm/818001m.pdf",
    title: "DoDM 8180.01 — DoD IT Planning for Electronic Records Management",
    description:
      "DoD manual for planning IT systems that manage electronic records, including metadata schemas for records management.",
    layer: 4,
  },
];

// ─── Layer 5: DoD CIO Guidance (non-issuance) ───────────────────────
const LAYER_5: GuidanceJob[] = [
  {
    url: "https://media.defense.gov/2020/Oct/08/2002514180/-1/-1/0/DOD-DATA-STRATEGY.PDF",
    title: "DoD Data Strategy (2020)",
    description:
      "DoD-wide data strategy establishing data as a strategic asset. Defines principles: visible, accessible, understandable, linked, trustworthy, interoperable, secure.",
    layer: 5,
  },
  {
    url: "https://www.ai.mil/Portals/137/Documents/Resources%20Page/DoD%20Metadata%20Guidance.pdf",
    title: "DoD Metadata Guidance",
    description:
      "CDAO guidance on metadata standards and best practices for the DoD, covering discovery metadata, structural metadata, and operational metadata.",
    layer: 5,
  },
  {
    url: "https://www.ai.mil/Portals/137/Documents/Resources%20Page/Federated%20Data%20Catalog%20-%20Minimum%20Metadata%20Requirements.pdf",
    title: "Federated Data Catalog — Minimum Metadata Requirements",
    description:
      "CDAO specification defining the minimum metadata fields required for registering data assets in the DoD Federated Data Catalog.",
    layer: 5,
  },
  {
    url: "https://www.ai.mil/Portals/137/Documents/Resources%20Page/DoD%20Data%20Stewardship%20Guidebook.pdf",
    title: "DoD Data Stewardship Guidebook",
    description:
      "CDAO guidebook for establishing and operating data stewardship programs, including metadata management responsibilities.",
    layer: 5,
  },
  {
    url: "https://www.disa.mil/-/media/Files/DISA/About/Publication/DISA-Data-Lifecycle-Management-Guidebook-FINAL.pdf",
    title: "DISA Data Lifecycle Management Guidebook",
    description:
      "DISA guidebook covering data lifecycle management from creation through disposition, including metadata requirements at each phase.",
    layer: 5,
  },
];

// ─── Layer 6: DAF Policy Directives (AFPD) ──────────────────────────
const LAYER_6: GuidanceJob[] = [
  {
    url: "https://static.e-publishing.af.mil/production/1/saf_cio_a6/publication/afpd17-1/afpd_17-1.pdf",
    title: "AFPD 17-1 — Information Dominance Governance and Management",
    description:
      "Air Force policy directive establishing governance for IT, cybersecurity, and information management across the DAF.",
    layer: 6,
  },
  {
    url: "https://static.e-publishing.af.mil/production/1/saf_cio_a6/publication/afpd33-3/afpd33-3.pdf",
    title: "AFPD 33-3 — Information Management",
    description:
      "Air Force policy directive on information management, covering records, data standards, and information sharing requirements.",
    layer: 6,
  },
  {
    url: "https://static.e-publishing.af.mil/production/1/saf_co/publication/afpd90-70/afpd90-70.pdf",
    title: "AFPD 90-70 — Enterprise Data Management",
    description:
      "Air Force policy directive establishing enterprise data management policy, including metadata standards and data governance.",
    layer: 6,
  },
];

// ─── Layer 7: DAF Instructions & Manuals ─────────────────────────────
const LAYER_7: GuidanceJob[] = [
  {
    url: "https://static.e-publishing.af.mil/production/1/saf_co/publication/dafi90-7001/dafi90-7001.pdf",
    title: "DAFI 90-7001 — Enterprise Data Management",
    description:
      "Department of the Air Force instruction implementing AFPD 90-70 for enterprise data management, metadata tagging, and data quality.",
    layer: 7,
  },
  {
    url: "https://static.e-publishing.af.mil/production/1/saf_cn/publication/afi33-322/afi33-322.pdf",
    title: "AFI 33-322 — Records Management and Information Governance",
    description:
      "Air Force instruction on records management, including metadata requirements for electronic records and information governance.",
    layer: 7,
  },
  {
    url: "https://static.e-publishing.af.mil/production/1/saf_cn/publication/afi17-130/afi17-130.pdf",
    title: "AFI 17-130 — Cybersecurity Program Management",
    description:
      "Air Force instruction implementing DoD cybersecurity policy, covering RMF, security controls, and system authorization.",
    layer: 7,
  },
  {
    url: "https://static.e-publishing.af.mil/production/1/saf_cn/publication/dafman17-1203/dafman17-1203.pdf",
    title: "DAFMAN 17-1203 — IT Asset Management",
    description:
      "DAF manual for IT asset management, covering hardware/software inventory metadata and lifecycle tracking.",
    layer: 7,
  },
  {
    url: "https://static.e-publishing.af.mil/production/1/saf_aa/publication/dodi5200.48_dafi16-1403/dodi5200.48_dafi16-1403.pdf",
    title: "DoDI 5200.48 / DAFI 16-1403 — CUI (DAF Supplement)",
    description:
      "DAF supplement to DoDI 5200.48 implementing CUI marking, metadata, and handling procedures specific to the Air Force.",
    layer: 7,
  },
];

// ─── All layers combined ─────────────────────────────────────────────
const ALL_JOBS: GuidanceJob[] = [
  ...LAYER_1,
  ...LAYER_2,
  ...LAYER_3,
  ...LAYER_4,
  ...LAYER_5,
  ...LAYER_6,
  ...LAYER_7,
];

const LAYER_NAMES: Record<number, string> = {
  1: "Federal Statutes & OMB Policy",
  2: "DoD-Wide Directives (DoDD)",
  3: "DoD Instructions (DoDI)",
  4: "DoD Manuals (DoDM)",
  5: "DoD CIO Guidance",
  6: "DAF Policy Directives (AFPD)",
  7: "DAF Instructions & Manuals",
};

async function main() {
  const skipExisting = process.argv.includes("--skip-existing");
  const onlyFilter = process.argv.find((a) => a.startsWith("--only="))?.split("=")[1];
  const layerFilter = process.argv.find((a) => a.startsWith("--layer="))?.split("=")[1];

  let jobs = ALL_JOBS;

  if (layerFilter) {
    const layerNum = parseInt(layerFilter, 10);
    jobs = jobs.filter((j) => j.layer === layerNum);
    console.log(`Filtering to Layer ${layerNum}: ${LAYER_NAMES[layerNum]}\n`);
  }

  if (onlyFilter) {
    jobs = jobs.filter((j) => j.title.toLowerCase().includes(onlyFilter.toLowerCase()));
    console.log(`Filtering to titles matching: "${onlyFilter}"\n`);
  }

  console.log(`Starting Tier 1 guidance ingestion: ${jobs.length} sources`);
  if (skipExisting) console.log("  (skipping already-ingested sources)");
  console.log();

  let success = 0;
  let skipped = 0;
  let failed = 0;

  for (const [i, job] of jobs.entries()) {
    const layerLabel = `L${job.layer}`;
    console.log(`[${i + 1}/${jobs.length}] [${layerLabel}] ${job.title}`);
    console.log(`  URL: ${job.url}`);

    if (skipExisting) {
      try {
        const existing = await getSourceByUrl(job.url);
        if (existing) {
          console.log(`  SKIP (already ingested — ${existing.chunk_count} chunks)\n`);
          skipped++;
          continue;
        }
      } catch {
        // getSourceByUrl failed — proceed with ingestion
      }
    }

    try {
      const result = await ingestUrl({
        url: job.url,
        title: job.title,
        tier: "1",
        sourceType: "guidance",
      });

      if (result.status === "success") {
        console.log(`  OK — ${result.chunkCount} chunks\n`);
        success++;
      } else {
        console.log(`  FAILED — ${result.error}\n`);
        failed++;
      }
    } catch (err) {
      console.log(`  ERROR — ${err}\n`);
      failed++;
    }

    // Rate limit: 2s between sources
    if (i < jobs.length - 1) {
      await new Promise((r) => setTimeout(r, 2000));
    }
  }

  console.log("\n═══════════════════════════════════════════");
  console.log(`Done: ${success} succeeded, ${failed} failed, ${skipped} skipped`);
  console.log(`Total: ${jobs.length} sources`);
  console.log("═══════════════════════════════════════════");

  process.exit(failed > 0 ? 1 : 0);
}

main();
