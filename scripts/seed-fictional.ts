import { config } from "dotenv";
config({ path: ".env.local" });

import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,
);

const FICTIONAL_PROFILES = [
  {
    title: "AF ISR Metadata Profile",
    url: "https://example.daf.mil/profiles/af-isr",
    tier: "2b",
    source_type: "crawl",
    status: "active",
    chunk_count: 0,
    metadata: {
      fictional: true,
      json_id: "profile-af-isr",
      description:
        "A comprehensive metadata profile for Air Force Intelligence, Surveillance, and Reconnaissance (ISR) data products. Defines required metadata elements for ISR collection reports, imagery products, signals intelligence summaries, and multi-INT fusion products.",
      domain: "Intelligence & Surveillance",
      owningOrganization: "AF/A2 (Deputy Chief of Staff for Intelligence, Surveillance, Reconnaissance, and Cyber Effects Operations)",
      version: "3.2",
    },
  },
  {
    title: "AFMC Logistics Data Profile",
    url: "https://example.daf.mil/profiles/afmc-logistics",
    tier: "2b",
    source_type: "crawl",
    status: "active",
    chunk_count: 0,
    metadata: {
      fictional: true,
      json_id: "profile-afmc-logistics",
      description:
        "Metadata profile governing data standards for Air Force Materiel Command logistics operations. Covers supply chain metadata, maintenance records, parts cataloging, and depot-level repair tracking.",
      domain: "Logistics & Sustainment",
      owningOrganization: "Air Force Materiel Command (AFMC)",
      version: "2.1",
    },
  },
  {
    title: "Space Force C2 Metadata Standard",
    url: "https://example.daf.mil/profiles/sf-c2",
    tier: "2b",
    source_type: "crawl",
    status: "active",
    chunk_count: 0,
    metadata: {
      fictional: true,
      json_id: "profile-sf-c2",
      description:
        "Defines metadata requirements for United States Space Force command and control (C2) data systems. Covers satellite operations metadata, space domain awareness data, orbital tracking information, and space-based communications metadata.",
      domain: "Space Operations & C2",
      owningOrganization: "United States Space Force (USSF) / Space Systems Command",
      version: "1.0",
    },
  },
  {
    title: "AFSOC Operations Data Profile",
    url: "https://example.daf.mil/profiles/afsoc-ops",
    tier: "2b",
    source_type: "crawl",
    status: "active",
    chunk_count: 0,
    metadata: {
      fictional: true,
      json_id: "profile-afsoc-ops",
      description:
        "Metadata profile for Air Force Special Operations Command operational data. Covers mission planning metadata, after-action report standards, special operations forces (SOF) activity tracking, and partner nation engagement records.",
      domain: "Special Operations",
      owningOrganization: "Air Force Special Operations Command (AFSOC)",
      version: "2.4",
    },
  },
  {
    title: "DAF Acquisition Metadata Framework",
    url: "https://example.daf.mil/profiles/daf-acquisition",
    tier: "2b",
    source_type: "crawl",
    status: "active",
    chunk_count: 0,
    metadata: {
      fictional: true,
      json_id: "profile-daf-acquisition",
      description:
        "Enterprise metadata framework for Department of the Air Force acquisition programs. Standardizes metadata for program documentation, contract deliverables, test and evaluation data, and cost estimates.",
      domain: "Acquisition & Procurement",
      owningOrganization: "SAF/AQ (Assistant Secretary of the Air Force for Acquisition, Technology & Logistics)",
      version: "0.9",
    },
  },
  {
    title: "AF Medical Service Metadata Profile",
    url: "https://example.daf.mil/profiles/af-medical",
    tier: "2b",
    source_type: "crawl",
    status: "active",
    chunk_count: 0,
    metadata: {
      fictional: true,
      json_id: "profile-af-medical",
      description:
        "Metadata profile for Air Force Medical Service (AFMS) health data systems. Standardizes metadata for patient records interoperability, medical logistics, and public health surveillance data.",
      domain: "Military Health",
      owningOrganization: "Air Force Medical Service (AFMS) / SG",
      version: "4.0",
    },
  },
];

const FICTIONAL_ONTOLOGY = {
  title: "DAF Data Fabric Ontology",
  url: "https://example.daf.mil/ontologies/daf-fabric",
  tier: "ontology",
  source_type: "crawl",
  status: "active",
  chunk_count: 0,
  metadata: {
    fictional: true,
    json_id: "onto-daf-fabric",
    description:
      "An internal ontology being developed to support the Department of the Air Force Data Fabric initiative. Defines the semantic relationships between data assets, metadata standards, organizational data stewards, and mission threads.",
  },
};

async function seed() {
  // Check what already exists
  const { data: existing } = await supabase
    .from("sources")
    .select("id, title, tier")
    .or("tier.eq.2b,tier.eq.ontology");

  console.log("Existing 2b/ontology sources:", existing?.length ?? 0);
  if (existing) {
    for (const s of existing) {
      console.log(`  - [${s.tier}] ${s.title}`);
    }
  }

  const existingTitles = new Set(existing?.map((s) => s.title) ?? []);

  // Insert fictional profiles (skip if already exists by title)
  let inserted = 0;
  for (const profile of FICTIONAL_PROFILES) {
    if (existingTitles.has(profile.title)) {
      console.log(`  SKIP (exists): ${profile.title}`);
      continue;
    }
    const { error } = await supabase.from("sources").insert(profile);
    if (error) {
      console.error(`  ERROR inserting ${profile.title}:`, error.message);
    } else {
      console.log(`  INSERT: ${profile.title}`);
      inserted++;
    }
  }

  // Insert fictional ontology
  if (existingTitles.has(FICTIONAL_ONTOLOGY.title)) {
    console.log(`  SKIP (exists): ${FICTIONAL_ONTOLOGY.title}`);
  } else {
    const { error } = await supabase.from("sources").insert(FICTIONAL_ONTOLOGY);
    if (error) {
      console.error(`  ERROR inserting ${FICTIONAL_ONTOLOGY.title}:`, error.message);
    } else {
      console.log(`  INSERT: ${FICTIONAL_ONTOLOGY.title}`);
      inserted++;
    }
  }

  console.log(`\nDone. Inserted ${inserted} fictional sources.`);

  // Final counts
  const { data: final } = await supabase.from("sources").select("tier");
  const counts: Record<string, number> = {};
  for (const r of final ?? []) {
    counts[r.tier ?? "null"] = (counts[r.tier ?? "null"] || 0) + 1;
  }
  console.log("Final tier counts:", counts);
}

seed().catch(console.error);
