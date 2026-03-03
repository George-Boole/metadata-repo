/**
 * Comprehensive ODNI IC Technical Specifications ZIP deep ingestion.
 * Downloads standalone ZIP packages for all 60+ IC specs that have them,
 * extracts PDFs/XSDs/Schematron, chunks, embeds, stores, and graph-extracts.
 *
 * Each spec is matched to its existing Supabase source by URL.
 * Specs already deep-ingested (>100 chunks) are skipped unless --force is passed.
 *
 * Usage:
 *   npx tsx scripts/ingest-odni-zips.ts              # skip already-done
 *   npx tsx scripts/ingest-odni-zips.ts --force       # re-process all
 *   npx tsx scripts/ingest-odni-zips.ts --only ISM    # process single spec by code
 *   npx tsx scripts/ingest-odni-zips.ts --batch 1/4   # process batch 1 of 4 (for parallel runs)
 */
import { config } from "dotenv";
config({ path: ".env.local" });
import { getSupabaseServer } from "../src/lib/supabase";
import { ingestZipContents } from "../src/lib/ingest/pipeline";

const BASE = "https://www.dni.gov/files/documents/CIO/ICEA";
const ODNI_BASE = "https://www.dni.gov/index.php/who-we-are/organizations/ic-cio/ic-technical-specifications";

interface OdniSpec {
  code: string;      // Short code for logging and --only filter
  sourceUrl: string; // Exact URL in Supabase sources table
  zipUrl: string;    // Full download URL for standalone ZIP
}

// All 64 ODNI IC specs with public ZIP packages, organized by directory era.
// Matched against Supabase sources by exact URL.
const ODNI_SPECS: OdniSpec[] = [
  // === Dec2022 releases (most current) ===
  {
    code: "ISM",
    sourceUrl: `${ODNI_BASE}/information-security-marking-metadata`,
    zipUrl: `${BASE}/Dec2022/ISM/ISM-Public-Standalone.zip`,
  },
  {
    code: "IC-EDH",
    sourceUrl: `${ODNI_BASE}/ic-enterprise-data-header`,
    zipUrl: `${BASE}/Dec2022/IC-EDH/IC-EDH-Public-Standalone.zip`,
  },
  {
    code: "IC-TDF",
    sourceUrl: `${ODNI_BASE}/trusted-data-format`,
    zipUrl: `${BASE}/Dec2022/IC-TDF/IC-TDF-Public-Standalone.zip`,
  },
  {
    code: "IC-GENC",
    sourceUrl: `${ODNI_BASE}/geopolitical-entities-names-and-codes`,
    zipUrl: `${BASE}/Dec2022/IC-GENC/IC-GENC-Public-Standalone.zip`,
  },
  {
    code: "ANLYS",
    sourceUrl: `${ODNI_BASE}/analysis-assertion`,
    zipUrl: `${BASE}/Dec2022/ANLYS/ANLYS-Public-Standalone.zip`,
  },
  {
    code: "AUTHCAT",
    sourceUrl: `${ODNI_BASE}/authority-category`,
    zipUrl: `${BASE}/Dec2022/AUTHCAT/AUTHCAT-Public-Standalone.zip`,
  },
  {
    code: "BOE",
    sourceUrl: `${ODNI_BASE}/body-of-evidence`,
    zipUrl: `${BASE}/Dec2022/BOE/BOE-Public-Standalone.zip`,
  },
  {
    code: "CEM",
    sourceUrl: `${ODNI_BASE}/contextual-entity-markup`,
    zipUrl: `${BASE}/Dec2022/CEM/CEM-Public-Standalone.zip`,
  },
  {
    code: "CDSM",
    sourceUrl: `${ODNI_BASE}/cross-domain-system-manifest-assertion`,
    zipUrl: `${BASE}/Dec2022/CDSM/CDSM-Public-Standalone.zip`,
  },
  {
    code: "CDSM-TDF",
    sourceUrl: `${ODNI_BASE}/cross-domain-system-manifest-tdf`,
    zipUrl: `${BASE}/Dec2022/CDSM-TDF/CDSM-TDF-Public-Standalone.zip`,
  },
  {
    code: "DED",
    sourceUrl: `${ODNI_BASE}/data-element-definition`,
    zipUrl: `${BASE}/Dec2022/DED/DED-Public-Standalone.zip`,
  },
  {
    code: "DHZM",
    sourceUrl: `${ODNI_BASE}/digitalhazmat-assertion`,
    zipUrl: `${BASE}/Dec2022/DHZM/DHZM-Public-Standalone.zip`,
  },
  {
    code: "DHZM-TDF",
    sourceUrl: `${ODNI_BASE}/digitalhazmat-tdf`,
    zipUrl: `${BASE}/Dec2022/DHZM-TDF/DHZM-TDF-Public-Standalone.zip`,
  },
  {
    code: "DHZMC-TDF",
    sourceUrl: `${ODNI_BASE}/digitalhazmat-commercial-tdf`,
    zipUrl: `${BASE}/Dec2022/DHZMC-TDF/DHZMC-TDF-Public-Standalone.zip`,
  },
  {
    code: "DOMEX",
    sourceUrl: `${ODNI_BASE}/document-and-media-exploitation`,
    zipUrl: `${BASE}/Dec2022/DOMEX/DOMEX-Public-Standalone.zip`,
  },
  {
    code: "FAC",
    sourceUrl: `${ODNI_BASE}/fine-access-control`,
    zipUrl: `${BASE}/Dec2022/FAC/FAC-Public-Standalone.zip`,
  },
  {
    code: "IRM",
    sourceUrl: `${ODNI_BASE}/information-resource-metadata`,
    zipUrl: `${BASE}/Dec2022/IRM/IRM-Public-Standalone.zip`,
  },
  {
    code: "ISM-ACES",
    sourceUrl: `${ODNI_BASE}/information-security-marking-access`,
    zipUrl: `${BASE}/Dec2022/ISM-ACES/ISM-ACES-Public-Standalone.zip`,
  },
  {
    code: "ISMCAT",
    sourceUrl: `${ODNI_BASE}/information-security-marking-country`,
    zipUrl: `${BASE}/Dec2022/ISMCAT/ISMCAT-Public-Standalone.zip`,
  },
  {
    code: "ITS-MS",
    sourceUrl: `${ODNI_BASE}/information-transport-service-messaging-service`,
    zipUrl: `${BASE}/Dec2022/ITS-MS/ITS-MS-Public-Standalone.zip`,
  },
  {
    code: "IC-Docbook",
    sourceUrl: `${ODNI_BASE}/intelligence-community-docbook`,
    zipUrl: `${BASE}/Dec2022/IC-Docbook/IC-Docbook-Public-Standalone.zip`,
  },
  {
    code: "IC-ID",
    sourceUrl: `${ODNI_BASE}/intelligence-community-identifier`,
    zipUrl: `${BASE}/Dec2022/IC-ID/IC-ID-Public-Standalone.zip`,
  },
  {
    code: "IC-SF",
    sourceUrl: `${ODNI_BASE}/intelligence-community-specification-framework`,
    zipUrl: `${BASE}/Dec2022/IC-SF/IC-SF-Public-Standalone.zip`,
  },
  {
    code: "PUBS",
    sourceUrl: `${ODNI_BASE}/intelligence-publications`,
    zipUrl: `${BASE}/Dec2022/PUBS/PUBS-Public-Standalone.zip`,
  },
  {
    code: "MIME",
    sourceUrl: `${ODNI_BASE}/media-type-controlled-vocabulary`,
    zipUrl: `${BASE}/Dec2022/MIME/MIME-Public-Standalone.zip`,
  },
  {
    code: "MN",
    sourceUrl: `${ODNI_BASE}/mission-need`,
    zipUrl: `${BASE}/Dec2022/MN/MN-Public-Standalone.zip`,
  },
  {
    code: "MNT",
    sourceUrl: `${ODNI_BASE}/mission-need-taxonomy`,
    zipUrl: `${BASE}/Dec2022/MNT/MNT-Public-Standalone.zip`,
  },
  {
    code: "PM",
    sourceUrl: `${ODNI_BASE}/production-metrics`,
    zipUrl: `${BASE}/Dec2022/PM/PM-Public-Standalone.zip`,
  },
  {
    code: "PMA",
    sourceUrl: `${ODNI_BASE}/production-metrics-assertion`,
    zipUrl: `${BASE}/Dec2022/PMA/PMA-Public-Standalone.zip`,
  },
  {
    code: "RevRecall",
    sourceUrl: `${ODNI_BASE}/revision-recall`,
    zipUrl: `${BASE}/Dec2022/RevRecall/RevRecall-Public-Standalone.zip`,
  },
  {
    code: "ROLE",
    sourceUrl: `${ODNI_BASE}/role`,
    zipUrl: `${BASE}/Dec2022/ROLE/ROLE-Public-Standalone.zip`,
  },
  {
    code: "ISM-Rollup",
    sourceUrl: `${ODNI_BASE}/rollup-guidance-for-ism`,
    zipUrl: `${BASE}/Dec2022/ISM-Rollup/ISM-Rollup-Public-Standalone.zip`,
  },
  {
    code: "SRC",
    sourceUrl: `${ODNI_BASE}/source-citations`,
    zipUrl: `${BASE}/Dec2022/SRC/SRC-Public-Standalone.zip`,
  },
  {
    code: "BASE-TDF",
    sourceUrl: `${ODNI_BASE}/trusted-data-format-base`,
    zipUrl: `${BASE}/Dec2022/BASE-TDF/BASE-TDF-Public-Standalone.zip`,
  },
  {
    code: "USAgency",
    sourceUrl: `${ODNI_BASE}/us-agency-acronyms`,
    zipUrl: `${BASE}/Dec2022/USAgency/USAgency-Public-Standalone.zip`,
  },
  {
    code: "UIAS",
    sourceUrl: `${ODNI_BASE}/unified-identity-attribute-set`,
    zipUrl: `${BASE}/Dec2022/UIAS/UIAS-Public-Standalone.zip`,
  },
  {
    code: "UIAS-APCS",
    sourceUrl: `${ODNI_BASE}/unified-identity-attribute-set-attribute-practice-compliance-statements`,
    zipUrl: `${BASE}/Dec2022/UIAS-APCS/UIAS-APCS-Public-Standalone.zip`,
  },
  {
    code: "VIRT",
    sourceUrl: `${ODNI_BASE}/virtual-coverage`,
    zipUrl: `${BASE}/Dec2022/VIRT/VIRT-Public-Standalone.zip`,
  },
  {
    code: "Whitelist",
    sourceUrl: `${ODNI_BASE}/whitelist-guidance-for-ism`,
    zipUrl: `${BASE}/Dec2022/Whitelist/Whitelist-Public-Standalone.zip`,
  },
  {
    code: "FSD",
    sourceUrl: `${ODNI_BASE}/idam-full-service-directory`,
    zipUrl: `${BASE}/Dec2022/FSD/FSD-Public-Standalone.zip`,
  },

  // === Jan2021 releases ===
  {
    code: "ADD-ERM",
    sourceUrl: `${ODNI_BASE}/abstract-data-definition-erm`,
    zipUrl: `${BASE}/Jan2021/ADD-ERM/ADD-ERM-Public-Standalone.zip`,
  },
  {
    code: "CSR",
    sourceUrl: `${ODNI_BASE}/community-shared-resources`,
    zipUrl: `${BASE}/Jan2021/CSR/CSR-Public-Standalone.zip`,
  },
  {
    code: "ERM",
    sourceUrl: `${ODNI_BASE}/electronic-records-management`,
    zipUrl: `${BASE}/Jan2021/ERM/ERM-Public-Standalone.zip`,
  },
  {
    code: "INTDIS",
    sourceUrl: `${ODNI_BASE}/intelligence-discipline`,
    zipUrl: `${BASE}/Jan2021/INTDIS/INTDIS-Public-Standalone.zip`,
  },
  {
    code: "ITS-OM",
    sourceUrl: `${ODNI_BASE}/information-transport-service-organization-messaging`,
    zipUrl: `${BASE}/Jan2021/ITS-OM/ITS-OM-Public-Standalone.zip`,
  },
  {
    code: "LIC",
    sourceUrl: `${ODNI_BASE}/license`,
    zipUrl: `${BASE}/Jan2021/LIC/LIC-Public-Standalone.zip`,
  },
  {
    code: "MAC",
    sourceUrl: `${ODNI_BASE}/multi-audience-collections`,
    zipUrl: `${BASE}/Jan2021/MAC/MAC-Public-Standalone.zip`,
  },
  {
    code: "NTK",
    sourceUrl: `${ODNI_BASE}/need-to-know-metadata`,
    zipUrl: `${BASE}/Jan2021/NTK/NTK-Public-Standalone.zip`,
  },
  {
    code: "NTK-ACES",
    sourceUrl: `${ODNI_BASE}/need-to-know-access-control-encoding-specification`,
    zipUrl: `${BASE}/Jan2021/NTK-ACES/NTK-ACES-Public-Standalone.zip`,
  },
  {
    code: "USGovAgency",
    sourceUrl: `${ODNI_BASE}/us-government-agency`,
    zipUrl: `${BASE}/Jan2021/USAgency/USAgency-Public-Standalone.zip`,
  },
  {
    code: "WSS-TS",
    sourceUrl: `${ODNI_BASE}/web-security-standards-guidance-token-services`,
    zipUrl: `${BASE}/Jan2021/WSS-TS/WSS-TS-Public-Standalone.zip`,
  },

  // === Older releases (India/Golf_Hotel/Juliet/Foxtrot/misc) ===
  {
    code: "ARH",
    sourceUrl: `${ODNI_BASE}/access-rights-and-handling`,
    zipUrl: `${BASE}/India/ARH-_V3_Public.zip`,
  },
  {
    code: "ICO-ACES",
    sourceUrl: `${ODNI_BASE}/intelligence-community-access-control`,
    zipUrl: `${BASE}/India/ICO-V1-ACES-Public.zip`,
  },
  {
    code: "ICO-NTK",
    sourceUrl: `${ODNI_BASE}/intelligence-community-only-need-to-know`,
    zipUrl: `${BASE}/India/ICO-V10-NTK-Public.zip`,
  },
  {
    code: "OC-NTK",
    sourceUrl: `${ODNI_BASE}/orcon-need-to-know-access`,
    zipUrl: `${BASE}/India/OC-NTK-ACES-V1-Public.zip`,
  },
  {
    code: "BRK-SRCH",
    sourceUrl: `${ODNI_BASE}/cdr-brokered-search`,
    zipUrl: `${BASE}/India/BRK-V2-SRCH-Public.zip`,
  },
  {
    code: "AUDIT",
    sourceUrl: `${ODNI_BASE}/enterprise-audit`,
    zipUrl: `${BASE}/AUDITPublic-V4-20111214.zip`,
  },
  {
    code: "ATOM",
    sourceUrl: `${ODNI_BASE}/cdr-atom-results-set`,
    zipUrl: `${BASE}/Golf_Hotel/ATOMPublic.zip`,
  },
  {
    code: "CDR-RA",
    sourceUrl: `${ODNI_BASE}/cdr-reference-architecture`,
    zipUrl: `${BASE}/Golf_Hotel/CDR-RAPublic.zip`,
  },
  {
    code: "CDR-SF",
    sourceUrl: `${ODNI_BASE}/cdr-specification-framework`,
    zipUrl: `${BASE}/Golf_Hotel/CDR-SFPublic.zip`,
  },
  {
    code: "WSS-HLG",
    sourceUrl: `${ODNI_BASE}/wss-high-level-guidance`,
    zipUrl: `${BASE}/Golf_Hotel/WSS-HLGPublic.zip`,
  },
  {
    code: "DELIVER",
    sourceUrl: `${ODNI_BASE}/cdr-deliver`,
    zipUrl: `${BASE}/Juliet/DELIVER-Public.zip`,
  },
  {
    code: "MANAGE",
    sourceUrl: `${ODNI_BASE}/cdr-manage-component`,
    zipUrl: `${BASE}/Juliet/MANAGE-Public.zip`,
  },
  {
    code: "QM",
    sourceUrl: `${ODNI_BASE}/cdr-query-management`,
    zipUrl: `${BASE}/Juliet/QM-Public.zip`,
  },
  {
    code: "WSS-SIGENC",
    sourceUrl: `${ODNI_BASE}/wss-xml-signature-and-xml-encryption`,
    zipUrl: `${BASE}/Juliet/WSS-SIGENC-Public.zip`,
  },
  {
    code: "RR-ID",
    sourceUrl: `${ODNI_BASE}/rr-end-to-end-identity-propagation`,
    zipUrl: `${BASE}/RR-IDPublic.zip`,
  },
  {
    code: "RR-SM",
    sourceUrl: `${ODNI_BASE}/rr-security-markings`,
    zipUrl: `${BASE}/Foxtrot/RR-SMPublic.zip`,
  },
];

// Specs with NO ZIP available (PDF-only or deprecated):
// - Abstract Data Definition (PDF only: IC-ADD 9 Aug 2011.pdf)
// - DoD Discovery Metadata (no public release)
// - Multi Audience Tearline (deprecated, replaced by Multi Audience Collections)
// - CDR Retrieve (PDFs only)
// - CDR Search (PDFs only)
// - CDR Keyword Query Language (PDF only)

async function ingestOdniZips() {
  const supabase = getSupabaseServer();
  const force = process.argv.includes("--force");
  const onlyFilter = process.argv.find((a) => a.startsWith("--only="))?.split("=")[1]
    || (process.argv.includes("--only") ? process.argv[process.argv.indexOf("--only") + 1] : null);
  const batchArg = process.argv.find((a) => a.startsWith("--batch"))
    ? (process.argv.find((a) => a.startsWith("--batch="))?.split("=")[1]
      || process.argv[process.argv.indexOf("--batch") + 1])
    : null;

  let specs = onlyFilter
    ? ODNI_SPECS.filter((s) => s.code.toLowerCase() === onlyFilter.toLowerCase())
    : [...ODNI_SPECS];

  // Batch support: --batch N/M splits specs into M equal batches, processes batch N
  if (batchArg) {
    const [batchNum, totalBatches] = batchArg.split("/").map(Number);
    if (!batchNum || !totalBatches || batchNum < 1 || batchNum > totalBatches) {
      console.error(`Invalid --batch format. Use --batch N/M (e.g., --batch 1/4)`);
      process.exit(1);
    }
    const batchSize = Math.ceil(specs.length / totalBatches);
    const start = (batchNum - 1) * batchSize;
    const end = Math.min(start + batchSize, specs.length);
    specs = specs.slice(start, end);
    console.log(`Batch ${batchNum}/${totalBatches}: specs ${start + 1}-${end} of ${ODNI_SPECS.length}`);
  }

  if (specs.length === 0) {
    console.error(`No spec found matching "${onlyFilter}". Available: ${ODNI_SPECS.map((s) => s.code).join(", ")}`);
    process.exit(1);
  }

  console.log(`Processing ${specs.length} ODNI specs${force ? " (force mode)" : ""}${onlyFilter ? ` (filter: ${onlyFilter})` : ""}...\n`);

  let processed = 0;
  let skipped = 0;
  let errors = 0;

  for (let i = 0; i < specs.length; i++) {
    const spec = specs[i];
    console.log(`\n[${i + 1}/${specs.length}] ${spec.code}`);

    // Find source by exact URL
    const { data: sources } = await supabase
      .from("sources")
      .select("id, url, title, chunk_count")
      .eq("url", spec.sourceUrl)
      .limit(1);

    if (!sources || sources.length === 0) {
      console.log(`  No source found for URL: ${spec.sourceUrl}`);
      skipped++;
      continue;
    }

    const source = sources[0];

    // Skip if already has deep content (>100 chunks beyond landing page crawl)
    if (!force && source.chunk_count > 100) {
      console.log(`  ${source.title} — already has ${source.chunk_count} chunks, skipping`);
      skipped++;
      continue;
    }

    console.log(`  ${source.title} (${source.chunk_count} chunks)`);

    try {
      const result = await ingestZipContents(
        source.id,
        source.url,
        source.title,
        spec.zipUrl,
        "2a",
      );

      console.log(`  Done: ${result.filesProcessed} files, ${result.totalChunks} new chunks`);
      console.log(`  ${source.chunk_count} → ${source.chunk_count + result.totalChunks} chunks`);
      processed++;
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      console.error(`  ERROR: ${msg}`);
      errors++;
    }

    // Rate limit between specs (embedding + Gemini API calls)
    if (i < specs.length - 1) {
      await new Promise((resolve) => setTimeout(resolve, 2000));
    }
  }

  console.log(`\n========================================`);
  console.log(`ODNI ZIP ingestion complete!`);
  console.log(`  Processed: ${processed}`);
  console.log(`  Skipped:   ${skipped}`);
  console.log(`  Errors:    ${errors}`);
  console.log(`========================================`);
  process.exit(0);
}

ingestOdniZips();
