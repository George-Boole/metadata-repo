# Product Requirements Document: DAF Metadata Standards Repository

**Version**: 1.0
**Date**: 2026-03-19
**Author**: DAF Metadata Repository Team
**Status**: Draft — For Internal Review Board Submission
**Classification**: UNCLASSIFIED

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Background & Problem Statement](#2-background--problem-statement)
3. [System Overview](#3-system-overview)
4. [Data Model & Taxonomy](#4-data-model--taxonomy)
5. [Functional Capabilities](#5-functional-capabilities)
6. [Content Currently Indexed](#6-content-currently-indexed)
7. [Non-Functional Requirements](#7-non-functional-requirements)
8. [API Surface](#8-api-surface)
9. [User Roles & Workflows](#9-user-roles--workflows)
10. [Success Metrics](#10-success-metrics)
11. [Appendix A: Palantir Foundry Capability Mapping](#appendix-a-palantir-foundry-capability-mapping)
12. [Appendix B: Glossary](#appendix-b-glossary)
13. [Appendix C: Technical Architecture](#appendix-c-technical-architecture)

---

## 1. Executive Summary

The Department of the Air Force (DAF) lacks a centralized, searchable catalog of the metadata standards, policy guidance, technical specifications, and tooling that govern how data is described, tagged, and exchanged across the enterprise. Today, these artifacts are scattered across dozens of authoritative sources — defense.gov, dni.gov, niem.gov, w3c.org, ISO, and individual program offices — with no single system that indexes them, shows how they relate to one another, or helps practitioners discover which standards apply to their mission.

A working prototype has been built and deployed that proves the concept of a unified DAF Metadata Standards Repository. The prototype is not a mockup — it is a fully functional system with:

- **155+ indexed sources** spanning DoD guidance, IC technical specifications, W3C/ISO standards, and metadata tagging tools
- **31,000+ searchable content chunks** with vector embeddings for semantic search
- **7,400+ knowledge graph entities** with 29,000+ relationships mapping how standards interconnect
- **An AI-powered assistant ("Standards Brain")** that answers natural-language questions about metadata standards with cited sources
- **Interactive knowledge graph visualization** revealing non-obvious connections between standards
- **A complete admin panel** for content ingestion, user management, and system configuration

This document captures the full functional scope of the prototype to serve as the specification for a production implementation within the DAF instance of Palantir Foundry. The prototype validates the requirements; the Foundry implementation would deliver them at enterprise scale with proper security, accreditation, and integration into the DAF data ecosystem.

---

## 2. Background & Problem Statement

### 2.1 Current State

Metadata standards within the DoD and Intelligence Community are developed, published, and maintained by numerous organizations:

| Source | Examples | Location |
|--------|----------|----------|
| Office of the Secretary of Defense | DoDI 8320.02, DoDI 8320.07, DoDI 8310.01, DoDI 8330.01, DoDD 8000.01 | defense.gov |
| Office of the Director of National Intelligence | IC-ISM, IC-EDH, IC-TDF, IC-ID (67+ IC Technical Specifications) | dni.gov |
| National Information Exchange Model (NIEM) | NIEM 6.0, Core/Domain schemas, conformance rules | niem.gov |
| World Wide Web Consortium (W3C) | RDF, OWL, SKOS, DCAT, SPARQL | w3.org |
| ISO | ISO 11179 (parts 3, 31–35), Dublin Core (ISO 15836) | iso.org |
| Individual service branches and commands | Organization-specific metadata profiles | Various |
| Commercial vendors | DCAMPS-C, Microsoft Purview, Varonis, Collibra, Titus, Boldon James | Vendor sites |

### 2.2 Pain Points

1. **No single catalog exists.** A data steward trying to determine which metadata standards apply to a new system must manually search across multiple websites, PDF libraries, and organizational repositories.

2. **Cross-references are invisible.** DoDI 8320.02 mandates the use of certain IC specifications, which in turn reference W3C standards — but discovering this chain requires reading each document individually. There is no system that maps these relationships.

3. **Discovery is manual and slow.** Finding whether a specific standard addresses a particular need (e.g., "which standard handles security classification markings for intelligence products?") requires expert knowledge or extensive manual research.

4. **No programmatic access.** DevSecOps pipelines and automated compliance checks cannot query a central catalog to validate metadata conformance — the standards exist only as human-readable documents.

5. **Domain profiles are undocumented.** Organization-specific adaptations of base standards (e.g., how AF ISR tailors IC-ISM for their mission) are often tribal knowledge, not formally cataloged alongside the standards they derive from.

### 2.3 Prototype Origin

The prototype was conceived to make the concept of a centralized metadata repository tangible for leadership audiences. Initial requirements called for a static demo with mock data. Over 21 development sessions, it evolved into a fully functional system with real data persistence, AI-powered discovery, and knowledge graph capabilities — validating not just the concept but the specific functional requirements described in this document.

---

## 3. System Overview

### 3.1 Conceptual Architecture

The system organizes metadata artifacts into a tiered taxonomy and provides multiple access patterns for discovery:

```
                    ┌─────────────────────────────────┐
                    │        Web Interface             │
                    │  (Browse, Search, Standards Brain,│
                    │   Knowledge Graph, Admin Panel)  │
                    └──────────────┬──────────────────┘
                                   │
                    ┌──────────────┴──────────────────┐
                    │         API Layer                │
                    │  (REST endpoints for all         │
                    │   operations)                    │
                    └──────────────┬──────────────────┘
                                   │
              ┌────────────────────┼────────────────────┐
              │                    │                     │
    ┌─────────┴────────┐ ┌────────┴─────────┐ ┌────────┴─────────┐
    │  Relational +    │ │  Property Graph  │ │  RDF Triplestore │
    │  Vector Store    │ │  (Knowledge      │ │  (Semantic        │
    │  (Source records,│ │   Graph)         │ │   Reasoning)     │
    │   chunks,        │ │                  │ │                  │
    │   embeddings,    │ │  Entities,       │ │  OWL/SKOS        │
    │   users, config) │ │  Relationships,  │ │  vocabulary,     │
    │                  │ │  Aliases         │ │  SPARQL queries  │
    └──────────────────┘ └──────────────────┘ └──────────────────┘
```

### 3.2 Four-Tier Artifact Model

All metadata artifacts are classified into one of four tiers, plus a standalone Ontologies category:

| Tier | Name | Description | Examples |
|------|------|-------------|----------|
| **1** | Authoritative Guidance | DoD-level policy documents that mandate or reference metadata standards | DoDI 8320.02, DoDI 8320.07, DoDD 8000.01 |
| **2A** | Technical Specifications | The actual metadata standards and specifications | NIEM 6.0, IC-ISM, Dublin Core, RDF/OWL |
| **2B** | Domain Profiles | Organization-specific adaptations of Tier 2A specs for particular mission domains | ISR metadata profile, Logistics profile |
| **3** | Tagging & Labeling Tools | Software tools that apply metadata standards to data assets | DCAMPS-C, Microsoft Purview, Collibra |
| **--** | Ontologies | Knowledge representation structures (standalone, cross-cutting) | OWL 2, SKOS, RDF Schema |

### 3.3 Dual Hosting Model

Each artifact in the catalog uses one of two hosting strategies:

- **Stored**: Full content is ingested into the repository. The system holds searchable text, embeddings, and graph entities extracted from the source material. Used when the authoritative source permits content ingestion (e.g., publicly available IC specifications, W3C standards).

- **Linked**: The repository holds metadata about the artifact (title, description, tier, relationships) and a pointer (URL) to the authoritative external source. Used when content should not be duplicated or when the authoritative source maintains the canonical version. The external link is prominently displayed.

This dual model is a core architectural principle: the repository serves as a **catalog that knows where everything lives**, not necessarily a copy of everything.

### 3.4 Access Patterns

The system supports two primary access patterns:

1. **Human access via web interface** — Browse by tier, search across all content, ask natural-language questions via the AI assistant, explore the knowledge graph visually.

2. **Programmatic access via API** — REST endpoints for search, source retrieval, graph queries, and content ingestion. The prototype includes a concept demonstration ("API Explorer") showing how DevSecOps pipelines could query the catalog for compliance validation.

---

## 4. Data Model & Taxonomy

### 4.1 Entity Types

Each artifact type carries common fields plus tier-specific attributes.

#### Common Fields (All Artifacts)

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Unique identifier |
| `title` | String | Display name of the artifact |
| `description` | Text | Summary description |
| `status` | Enum | `active`, `superseded`, or `draft` |
| `hostingType` | Enum | `stored` (content in repository) or `linked` (pointer to external source) |
| `externalUrl` | URL (optional) | Authoritative source URL (present when hostingType is `linked`) |
| `keywords` | String[] | Tags for search and categorization |

#### Tier 1 — Authoritative Guidance

| Field | Type | Description |
|-------|------|-------------|
| `documentNumber` | String | Official document identifier (e.g., "DoDI 8320.02") |
| `issuingAuthority` | String | Issuing organization (e.g., "DoD CIO") |
| `issueDate` | Date | Publication or last revision date |
| `summary` | Text | Policy summary |
| `relatedSpecIds` | ID[] | Links to Tier 2A specifications this guidance mandates or references |

#### Tier 2A — Technical Specifications

| Field | Type | Description |
|-------|------|-------------|
| `version` | String | Specification version number |
| `managingOrganization` | String | Organization responsible for the specification |
| `category` | String | Functional category (e.g., "Information Security Marking", "Data Exchange") |
| `elements` | String[] | Key elements/components of the spec (for stored specs) |
| `relatedGuidanceIds` | ID[] | Links to Tier 1 guidance that references this spec |
| `relatedProfileIds` | ID[] | Links to Tier 2B profiles that incorporate this spec |
| `parentSpecId` | ID (optional) | Parent specification for hierarchical specs (e.g., NIEM sub-specs) |

#### Tier 2B — Domain Profiles

| Field | Type | Description |
|-------|------|-------------|
| `owningOrganization` | String | Organization that maintains the profile |
| `domain` | String | Mission domain (e.g., "Intelligence Sharing", "Logistics") |
| `version` | String | Profile version |
| `incorporatedSpecs` | Object[] | Array of specs used: `{ specId, specName, elementsUsed[] }` |

#### Tier 3 — Tagging & Labeling Tools

| Field | Type | Description |
|-------|------|-------------|
| `vendor` | String | Tool vendor/manufacturer |
| `capabilities` | String[] | Tagging/labeling capabilities |
| `supportedSpecIds` | ID[] | Links to Tier 2A specs this tool can apply |
| `licenseType` | String | Licensing model |
| `maturityLevel` | Enum | `production`, `emerging`, or `experimental` |
| `integrationNotes` | Text (optional) | Notes on how the tool integrates with workflows |

#### Ontologies

| Field | Type | Description |
|-------|------|-------------|
| `version` | String | Ontology version |
| `managingOrganization` | String | Maintaining organization |
| `ontologyType` | Enum | `domain`, `foundational`, `repository`, or `internal` |
| `format` | String (optional) | Serialization format (OWL, SKOS, RDF, etc.) |
| `domain` | String (optional) | Subject domain |
| `relatedSpecIds` | ID[] | Links to related Tier 2A specifications |

### 4.2 Relationship Types

The knowledge graph captures six directed relationship types between entities:

| Relationship | Direction | Meaning | Example |
|-------------|-----------|---------|---------|
| **MANDATES** | Guidance → Spec | A policy document requires use of a standard | DoDI 8320.02 → IC-ISM |
| **REFERENCES** | Any → Any | One artifact cites or references another | IC-ISM → IC-EDH |
| **IMPLEMENTS** | Profile/Tool → Spec | A profile or tool implements a standard | DCAMPS-C → IC-ISM |
| **SUPPORTS** | Tool → Spec | A tool supports (but may not fully implement) a specification | Microsoft Purview → Dublin Core |
| **CHILD_OF** | Spec → Spec | Hierarchical parent-child relationship | NIEM Core → NIEM 6.0 |
| **PART_OF** | Element → Spec | An element or component belongs to a larger spec | Element → IC-ISM |

Additionally, the graph tracks:
- **MENTIONS**: Links source documents to entities they reference (auto-extracted during ingestion)
- **Aliases**: Entities maintain an alias list for matching (e.g., IC-ISM has 118 known aliases including "Information Security Marking", "ISM", "security marking standard", etc.)

### 4.3 Source Record Model

Each ingested source is tracked as a record with the following schema:

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Auto-generated unique identifier |
| `url` | Text (unique) | Source URL or upload identifier |
| `title` | Text | Display title |
| `source_type` | Text | Content type: `webpage`, `pdf`, `zip`, `xsd`, `schematron`, `txt`, `csv`, `json`, `xml` |
| `tier` | Text | Tier classification: `1`, `2a`, `2b`, `3`, `ontology` |
| `status` | Text | Ingestion status: `active`, `pending`, `error` |
| `chunk_count` | Integer | Number of text chunks generated |
| `error_message` | Text | Error details if ingestion failed |
| `metadata` | JSON | Extensible metadata: description, fictional flag, token estimates, content hash |
| `created_at` | Timestamp | Ingestion timestamp |
| `updated_at` | Timestamp | Last modification timestamp |

### 4.4 RDF/OWL Vocabulary

The knowledge graph uses a formal RDF vocabulary for semantic representation:

- **Namespace**: `https://daf-metadata.mil/ontology/`
- **Entity classification**: `rdf:type` → `daf:Standard`, `daf:Guidance`, `daf:Tool`, `daf:Profile`, `daf:Ontology`, `daf:Organization`
- **Naming**: `skos:prefLabel` (primary name), `skos:altLabel` (aliases)
- **Source references**: `dct:references` (Dublin Core Terms)
- **Relationship namespace**: `daf:rel/` prefix (e.g., `daf:rel/MANDATES`, `daf:rel/IMPLEMENTS`)

The vocabulary supports OWL 2 RL reasoning, enabling inference of transitive and symmetric relationships at query time.

---

## 5. Functional Capabilities

### 5.1 Content Browsing & Discovery

#### 5.1.1 Tier Browse Pages

Each tier has a dedicated browse page displaying all artifacts in that category as a card grid. Each card shows:
- Title and description excerpt
- Tier badge (color-coded: Tier 1 red, 2A blue, 2B purple, 3 orange, Ontology green)
- Status badge (Active/Superseded/Draft)
- Hosting type badge (Stored/Linked with external link icon for linked artifacts)
- Chunk count (for stored artifacts, indicating content depth)

Cards are fully clickable, navigating to the source detail page.

#### 5.1.2 Source Detail Pages

Each source has a detail page showing:
- Full title, description, tier classification, and status
- External URL link for linked artifacts
- Ingestion metadata (chunk count, source type, timestamps)
- **Graph cross-references**: Related entities extracted from the knowledge graph, with relationship types (MANDATES, REFERENCES, etc.) and links to related source pages
- Content statistics

#### 5.1.3 Global Search

A search bar is accessible from all pages (embedded in the navigation bar). Search operates across all tiers simultaneously:
- **Hybrid search**: Combines vector similarity (70% weight) with keyword matching (30% weight) for queries that span semantic and lexical boundaries
- **Results grouped by tier**: Clear tier labels and color coding in results
- **Fields searched**: Title, description, keywords, document numbers, full ingested content
- **Source diversity**: Results are distributed across sources (not dominated by a single document)

#### 5.1.4 Landing Page / Dashboard

The landing page provides an at-a-glance overview:
- Summary statistics (counts per tier, total sources, total chunks)
- Visual representation of the four-tier structure
- Quick-access cards linking to each tier's browse page
- Prominent link to the Standards Brain AI assistant
- DAF branding and professional government-appropriate aesthetic

### 5.2 AI-Powered Standards Assistant ("Standards Brain")

The Standards Brain is a conversational AI interface that answers natural-language questions about metadata standards using retrieval-augmented generation (RAG).

#### 5.2.1 Hybrid Retrieval System

When a user asks a question, three search strategies execute in parallel:

1. **Vector search**: The query is embedded using the same model as ingested content (512-dimensional vectors). A hybrid search function combines cosine similarity with full-text keyword matching, returning the most relevant content chunks. Similarity threshold: 0.25. Up to 12 chunks retrieved, capped at 3 per source for diversity.

2. **Property graph search**: Query terms are extracted using a tiered strategy:
   - Known standard patterns recognized via regex (e.g., "DoDI ####.##", "IC-*", "NIEM", "Dublin Core")
   - Acronyms (2–8 character all-caps tokens)
   - Multi-word phrases (excluding function words)
   - Individual significant words (7+ characters, excluding stopwords)

   Extracted terms are matched against entity names and aliases in the knowledge graph. Matched entities trigger a 1-hop relationship traversal, returning connected entities and their source documents.

3. **RDF/SPARQL graph search**: Similar entity extraction, executed against the RDF triplestore using SPARQL queries over `skos:prefLabel` and `skos:altLabel`. Supports OWL 2 RL reasoning for inferred relationships.

Results from all three backends are merged. Source chunks connected to graph-matched entities are boosted in the final ranking.

#### 5.2.2 Response Generation

- **Streaming responses**: The LLM generates responses token-by-token, displayed in real-time
- **Source citations**: Every response includes clickable citations in `[Source Title](URL)` format linking to the original source
- **Context window**: Retrieved chunks are formatted with source attribution and tier labels, providing the LLM with grounded context
- **Graph context**: Entity relationships from the knowledge graph are included in the prompt, enabling the LLM to answer questions about how standards relate to each other

#### 5.2.3 Conversation Management

- Conversations are persisted with unique IDs
- Users can view conversation history and continue previous threads
- Conversations are auto-titled from the first user message
- Individual conversations can be deleted

#### 5.2.4 Model Selection

- Multiple LLM providers supported (currently Gemini 2.5 Flash and Claude Sonnet 4.6)
- Active model is admin-selectable via the settings panel
- Model routing handles provider-specific API differences transparently
- Fallback logic if the primary model is unavailable

#### 5.2.5 Configurable System Prompt

The system prompt that guides the AI assistant's behavior is stored in the database and editable by administrators. This allows tuning the assistant's persona, response format, and domain focus without code changes.

### 5.3 Knowledge Graph & Visualization

#### 5.3.1 Interactive Graph Visualization

A WebGL-rendered graph visualization displays entities and their relationships:
- **Force-directed layout**: Entities self-organize based on connectivity (ForceAtlas2 algorithm)
- **Node sizing**: Nodes scale proportionally to their connection count (hub entities appear larger)
- **Color coding**: Six entity types each have a distinct color (Standard, Guidance, Tool, Profile, Ontology, Organization)
- **Entity type filters**: Toggle buttons to show/hide entity types
- **Hover highlighting**: Hovering over a node highlights its direct connections
- **Click navigation**: Clicking a node navigates to its source detail page
- **Zoom/pan controls**: Full interactive navigation of the graph space
- **Smart label density**: Labels are shown based on zoom level to prevent visual clutter

#### 5.3.2 Path Finder

Users can discover how two entities are connected through multi-hop traversal:
- **Entity selection**: Autocomplete search for start and end entities by name
- **Hop count**: Configurable 1–5 hop maximum
- **Path display**: Shows the chain of entities and relationship types connecting start to end
- **SPARQL property paths**: Uses SPARQL 1.1 property path syntax for efficient multi-hop queries

#### 5.3.3 SPARQL Explorer

An interactive query editor for advanced users:
- **Pre-built example queries**: Common queries available for one-click execution (e.g., "find all standards mandated by a specific guidance document")
- **Custom query authoring**: Full SPARQL 1.1 query editor
- **Reasoning toggle**: Enable/disable OWL 2 RL reasoning at query time to see inferred vs. explicit results
- **Explain plans**: View the query execution plan with cost analysis for performance tuning
- **Read-only enforcement**: Write operations (INSERT, DELETE) are blocked at the API level

#### 5.3.4 Platform Comparison

A comparison view showing how the same data appears across the property graph and RDF triplestore backends, illustrating their complementary strengths.

#### 5.3.5 Statistics Dashboard

Aggregate analytics across the knowledge graph:
- **Hub analysis**: Most-connected entities ranked by relationship count
- **Entity counts by type**: Breakdown of Standards, Guidance, Tools, Profiles, Organizations
- **Relationship distribution**: Counts by relationship type (MANDATES, REFERENCES, etc.)
- **Source density**: Chunks per source, sources per tier
- **Combined statistics**: Merged view from both graph backends

### 5.4 Content Ingestion Pipeline

The system supports multiple content ingestion methods, each feeding into a unified processing pipeline.

#### 5.4.1 URL-Based Ingestion

Content is crawled from web URLs using two engines:
- **Primary engine**: Converts web pages to clean markdown (handles JavaScript-rendered content)
- **Fallback engine**: Alternative crawler for pages that fail with the primary engine
- **Auto mode**: Tries the primary engine first, falls back automatically on failure

#### 5.4.2 File Upload

Direct file upload supports multiple formats:

| Format | Handling |
|--------|----------|
| PDF | Server-side text extraction; client-side extraction for files exceeding serverless size limits |
| TXT, MD | Direct text ingestion |
| CSV | Tabular data ingestion |
| XML, XSD | Schema parsing with element/type extraction |
| Schematron (.sch) | Validation rule parsing |
| JSON | Structured data ingestion |

Features:
- Drag-and-drop upload interface
- Multi-file upload queue with per-file progress tracking
- Cancel and dismiss controls per file
- Content-based deduplication via SHA-256 hash (prevents re-ingestion of identical content)

#### 5.4.3 ZIP Package Extraction

For packaged content (e.g., IC specification packages distributed as ZIPs):
- Automatic download and extraction
- Smart filtering by file type and size:
  - PDFs: Always processed
  - XSD schemas: Processed if >5 KB (filters out trivial schemas)
  - Schematron rules: Processed if >10 KB
- Each extracted file is processed through the full pipeline independently

#### 5.4.4 Processing Pipeline

Every piece of content, regardless of ingestion method, passes through the same pipeline:

```
Source Content
    │
    ▼
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────────┐
│  Crawl / │     │  Chunk   │     │  Embed   │     │ Store Vectors│
│  Extract ├────►│  Content ├────►│  Chunks  ├────►│ (Relational  │
│  Text    │     │          │     │          │     │  + Vector DB)│
└──────────┘     └──────────┘     └──────────┘     └──────────────┘
                                                           │
                                                           ▼
                                  ┌──────────┐     ┌──────────────┐
                                  │  Write   │◄────┤ LLM Entity   │
                                  │  Graph   │     │ Extraction   │
                                  │  Triples │     │              │
                                  └──────────┘     └──────────────┘
```

**Step 1 — Text Extraction**: Web pages are converted to markdown. PDFs are parsed to plain text. XML schemas are parsed for element definitions. Schematron files are parsed for validation rules.

**Step 2 — Chunking**: Content is split into searchable chunks using a heading-aware strategy:
- Split first by markdown headings (h1–h3)
- Large sections are subdivided at paragraph boundaries
- Default chunk size: ~500 tokens with 50-token overlap between adjacent chunks
- Hard-split safety for content exceeding embedding model limits (8,192 tokens)

**Step 3 — Embedding**: Each chunk is embedded into a 512-dimensional vector using a text embedding model. Chunks are prepended with source metadata (`[Source: title | Tier | Type | URL]`) before embedding to improve cross-domain retrieval.

**Step 4 — Vector Storage**: Source records and chunks with embeddings are stored in the relational/vector database. Source records are upserted by URL; chunks are replaced on re-ingestion.

**Step 5 — Entity Extraction**: An LLM analyzes the concatenated content (first 32K characters) and extracts:
- **Entities**: Named standards, tools, organizations, and guidance documents with type classification and aliases
- **Relationships**: Directed relationships between entities with type classification and evidence text
- Extraction is validated against a strict schema (max 15 entities per extraction, no filenames/URIs/boilerplate)

**Step 6 — Graph Write**: Extracted entities and relationships are written to both graph backends:
- Property graph: Entities merged by name/alias (prevents duplicates), relationships created with evidence metadata
- RDF triplestore: Entities and relationships written as RDF triples using the DAF ontology vocabulary

Graph write failures are non-fatal — the source is still searchable via vector search even if graph extraction fails.

### 5.5 Administration

#### 5.5.1 Admin Dashboard

Summary statistics at a glance:
- Total sources by status (active, pending, error)
- Total content chunks
- Total registered users
- Graph entity and relationship counts

#### 5.5.2 Source Management

- **Add by URL**: Enter a URL and optional metadata (title, tier, source type, crawl engine preference) to trigger the ingestion pipeline
- **Upload files**: Drag-and-drop multi-file upload with format validation
- **View sources**: Table of all sources with status, tier, chunk count, and error messages
- **Delete sources**: Remove a source and cascade-delete all associated chunks
- **Status monitoring**: See which sources are active, pending ingestion, or failed with error details

#### 5.5.3 User Management

- **Create users**: Username, password, display name, role assignment
- **Role-based access**: Two roles — `admin` (full access) and `user` (browse/search/chat only)
- **User listing**: View all users with role, creation date, last login, and login count
- **Edit/delete users**: Modify user details or remove accounts

#### 5.5.4 System Settings

- **Active LLM model**: Select which language model the Standards Brain uses (e.g., switch between models for cost/quality tradeoffs)
- **System prompt editor**: Edit the AI assistant's system prompt to tune behavior, persona, and response format
- **Feature toggles**: Enable/disable optional features (e.g., RDF triplestore integration on the public site)

#### 5.5.5 Activity Audit Log

All significant user actions are logged:

| Action Type | Description |
|-------------|-------------|
| `login` | User authentication events |
| `logout` | Session termination |
| `chat` | Standards Brain queries |
| `search` | Search operations |
| `ingest_url` | URL-based content ingestion |
| `ingest_upload` | File upload ingestion |
| `admin_*` | Administrative operations (user changes, settings changes, source management) |

Each log entry records: username, action type, request path, metadata (JSON), and timestamp. The admin panel provides a paginated, filterable view of the activity log.

### 5.6 Authentication & Access Control

#### 5.6.1 Authentication

- **Multi-user authentication**: Users log in with username and password
- **Shared password fallback**: A site-wide password can be configured for simplified demo access (grants admin role)
- **Token-based sessions**: Authentication produces a signed token (HMAC-SHA256) stored as an HTTP-only cookie with 7-day expiry
- **Token payload**: Contains subject (username), role, and issued-at timestamp

#### 5.6.2 Authorization

- **Route protection**: All routes require authentication except the login page and authentication endpoint
- **Role enforcement**: Admin routes (admin panel, admin API endpoints) require the `admin` role
- **User context propagation**: Authenticated user identity and role are passed to downstream API handlers via request headers

#### 5.6.3 Rate Limiting

In-memory sliding window rate limiting protects against abuse:

| Endpoint Category | Limit |
|-------------------|-------|
| Chat (Standards Brain) | 20 requests/minute |
| Authentication | 5 requests/minute |
| Content Ingestion | 10 requests/minute |
| Admin Operations | 30 requests/minute |

Rate-limited responses return HTTP 429 with a `Retry-After` header.

---

## 6. Content Currently Indexed

The prototype has been populated with real-world content to validate the system at meaningful scale.

### 6.1 Tier 1 — Authoritative Guidance

**31 sources | ~1,243 chunks**

Includes DoD Instructions, DoD Directives, and memoranda related to metadata and data management policy:
- DoDI 8320.02 (Sharing Data, Information, and Technology Services)
- DoDI 8320.07 (Implementing the Government Information Sharing Environment)
- DoDI 8310.01 (Information Technology Standards)
- DoDI 8330.01 (Interoperability of IT and NSS)
- DoDD 8000.01 (Management of the DoD Information Enterprise)
- DoDI 8500.01 (Cybersecurity)
- DoDI 5015.02 (Records Management)
- Additional guidance documents

### 6.2 Tier 2A — Technical Specifications

**95 sources | ~29,207 chunks**

The largest tier, containing deep-ingested technical specifications:

- **67 ODNI IC Technical Specifications** (deep-ingested from ZIP packages including PDFs, XSD schemas, and Schematron rules):
  - IC-ISM (Information Security Marking) — 118 known aliases, canonical hub entity
  - IC-EDH (Enterprise Data Header) — 20 aliases
  - IC-TDF (Trusted Data Format) — 53 aliases
  - IC-ID (Identity) — 26 aliases
  - Plus 63 additional IC specifications covering data encoding and service specifications

- **NIEM 6.0** (National Information Exchange Model) with sub-specifications

- **W3C Standards**: RDF 1.2, OWL 2, SKOS, DCAT 3, SHACL, SPARQL 1.1

- **ISO Standards**: ISO 11179 parts 3, 31, 32, 33, 34, 35 (Metadata Registries)

- **Dublin Core** (Dublin Core Metadata Element Set)

- **DDMS** (DoD Discovery Metadata Specification)

### 6.3 Tier 2B — Domain Profiles

Placeholder content with fictional representative profiles (marked with "EXAMPLE" badges) demonstrating the concept:
- AF ISR Metadata Profile
- AFMC Logistics Data Profile
- Space Force C2 Profile
- AFSOC Operations Profile
- DAF Acquisition Profile
- AF Medical Profile

**Note**: In a production deployment, this tier would be populated with real organization-specific metadata profiles provided by the respective program offices.

### 6.4 Tier 3 — Tagging & Labeling Tools

Six metadata tagging/labeling tools cataloged:
- Mundo Systems DCAMPS-C
- Microsoft Purview
- Varonis Data Classification
- Collibra Data Governance
- Titus Classification
- Boldon James Classifier

### 6.5 Ontologies

Foundational and domain ontologies:
- OWL 2 (Web Ontology Language)
- RDF Schema
- SKOS (Simple Knowledge Organization System)
- Additional domain-specific ontologies

### 6.6 Knowledge Graph Statistics

| Metric | Count |
|--------|-------|
| Graph entities | 7,432 |
| RELATES_TO relationships | 9,928 |
| MENTIONS relationships | 19,190 |
| Source nodes | 112 |
| RDF triples | 50,734 |
| Canonical entities with rich aliases | IC-ISM (118), IC-TDF (53), IC-ID (26), IC-EDH (20) |

---

## 7. Non-Functional Requirements

### 7.1 Performance

| Requirement | Specification |
|-------------|---------------|
| Chat response initiation | Streaming begins within 2–4 seconds of query submission |
| Search results | Returned within 1–2 seconds |
| Graph visualization | WebGL rendering supports thousands of nodes with interactive frame rates |
| Content ingestion | Single URL: 10–30 seconds. Bulk ZIP package: 2–5 minutes depending on file count. |
| Rate limiting | Per-endpoint sliding window limits (see Section 5.6.3) |

### 7.2 Security

| Requirement | Specification |
|-------------|---------------|
| Authentication | Token-based with cryptographic signing (HMAC-SHA256) |
| Authorization | Role-based access control (admin/user) enforced at middleware level |
| Password storage | Salted SHA-256 hashing (never stored in plaintext) |
| API security | Rate limiting on all endpoints. SPARQL queries restricted to read-only (SELECT, ASK, DESCRIBE, CONSTRUCT). Write operations rejected with HTTP 403. |
| Credential management | All secrets stored as environment variables, never in source code. `.env` files excluded from version control. |
| Session management | HTTP-only cookies with 7-day expiry |

### 7.3 Data Quality

| Requirement | Specification |
|-------------|---------------|
| Content deduplication | SHA-256 hash-based prevention of duplicate ingestion |
| Entity extraction validation | Schema-validated extraction (Zod) with rules excluding filenames, URIs, version numbers, and boilerplate |
| Entity consolidation | Alias-based entity merging to prevent duplicate graph nodes |
| Minimum content threshold | Content shorter than 50 characters is rejected |
| File type validation | Extension and content-type checking on upload |

### 7.4 Audit & Compliance

| Requirement | Specification |
|-------------|---------------|
| Activity logging | All user actions logged with username, action type, path, metadata, and timestamp |
| Login tracking | Login count and last-login timestamp maintained per user |
| Admin action audit | All administrative operations (user changes, settings changes, source management) logged |

### 7.5 Availability & Resilience

| Requirement | Specification |
|-------------|---------------|
| Error handling | Error boundaries at page level prevent cascading failures |
| Graceful degradation | Graph backend failures are non-fatal — vector search continues operating |
| 404 handling | Custom not-found page for invalid routes |
| API error responses | Generic error messages returned to clients (no internal details leaked) |

---

## 8. API Surface

The system exposes the following REST API endpoints. In a Foundry implementation, these would map to OSDK actions, functions, and object queries.

### 8.1 Authentication

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/auth` | None | Authenticate with username/password or shared password. Returns signed token in cookie. |
| GET | `/api/auth` | Token | Check current session validity and return user info. |
| DELETE | `/api/auth` | Token | Log out (clear session cookie). |

### 8.2 Chat (Standards Brain)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/chat` | User | Send a message and receive a streaming RAG-powered response. Input: `{ messages[], conversationId? }`. Output: Server-sent event stream. |

### 8.3 Search

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/search?q=...` | User | Hybrid search across all tiers. Returns sources grouped by tier with relevance ranking. |

### 8.4 Content Ingestion

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/ingest` | User | Ingest content from URL. Input: `{ url, tier?, source_type?, title?, crawl_engine? }`. Returns: `{ sourceId, url, title, chunkCount, status }`. |
| POST | `/api/ingest/upload` | User | Upload a file for ingestion. Multipart form data with file, tier, and optional metadata. |

### 8.5 Knowledge Graph

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/graph/entities` | User | List all graph entities (for visualization and autocomplete). |
| GET | `/api/graph/neo4j` | User | Property graph statistics (entity count, relationship types, source count). |
| GET | `/api/graph/neo4j/data` | User | Full graph data for visualization (nodes and edges). |
| GET | `/api/graph/stardog` | User | RDF triplestore statistics (triple count, entity count, reasoning availability). |
| GET | `/api/graph/stardog/data` | User | RDF graph data for visualization. |
| POST | `/api/graph/stardog/query` | User | Execute a custom SPARQL query with optional reasoning. Read-only enforced. |
| POST | `/api/graph/stardog/graph` | User | Get SPARQL query explain plan. |

### 8.6 Conversations

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/conversations` | User | List user's conversations. |
| POST | `/api/conversations` | User | Create a new conversation. |
| GET | `/api/conversations/[id]` | User | Get conversation details. |
| DELETE | `/api/conversations/[id]` | User | Delete a conversation. |
| GET | `/api/conversations/[id]/messages` | User | Get all messages in a conversation. |
| POST | `/api/conversations/[id]/messages` | User | Save a message to a conversation. |

### 8.7 Administration

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/api/admin/stats` | Admin | Aggregate statistics (source counts, chunk counts, user counts). |
| GET | `/api/admin/sources` | Admin | List all sources with pagination. |
| GET | `/api/admin/sources/[id]` | Admin | Get source details. |
| DELETE | `/api/admin/sources/[id]` | Admin | Delete a source and cascade-delete chunks. |
| GET | `/api/admin/users` | Admin | List all users. |
| POST | `/api/admin/users` | Admin | Create or update a user. |
| DELETE | `/api/admin/users/[id]` | Admin | Delete a user. |
| GET | `/api/admin/settings` | Admin | Read system settings (active model, system prompt). |
| POST | `/api/admin/settings` | Admin | Update system settings. |
| GET | `/api/admin/activity` | Admin | View activity log with filtering by username and action type. |

### 8.8 Setup (One-Time Initialization)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/setup/neo4j` | Admin | Initialize property graph schema (constraints, indexes). |
| POST | `/api/setup/chat-tables` | Admin | Create conversation and message storage tables. |

---

## 9. User Roles & Workflows

### 9.1 Data Steward / Standards Practitioner

**Goal**: Find the right metadata standards for their mission and understand how they interrelate.

Typical workflows:
1. **Browse by tier**: Navigate to Tier 2A → Technical Specifications to see what standards are available.
2. **Search for a standard**: Type "security marking" in the search bar → find IC-ISM, IC-EDH, and related specs across tiers.
3. **Ask the AI assistant**: Open Standards Brain → "Which standards are required for marking intelligence products for release?" → receive a cited answer with links to source documents.
4. **Explore relationships**: Open the Knowledge Graph → find IC-ISM → see that DoDI 8320.02 mandates it, DCAMPS-C implements it, and it references IC-EDH → click through to each related artifact.
5. **Trace a policy chain**: Use Path Finder → start: "DoDI 8320.02", end: "Dublin Core" → discover the multi-hop connection through intermediate standards.

### 9.2 Administrator

**Goal**: Keep the repository current with the latest standards and manage user access.

Typical workflows:
1. **Ingest new content**: Admin panel → Sources → enter URL of a newly published DoDI → system crawls, chunks, embeds, and extracts graph entities automatically.
2. **Upload a specification package**: Admin panel → Sources → drag-and-drop a ZIP file containing PDFs and schemas → system extracts and processes each file.
3. **Manage users**: Admin panel → Users → create accounts for team members with appropriate roles.
4. **Monitor system health**: Admin panel → Dashboard → check source status (any failures?), review activity log.
5. **Tune the AI assistant**: Admin panel → Settings → edit the system prompt to improve response quality for specific domains.

### 9.3 Leadership / Stakeholder

**Goal**: Understand the scope and value of centralized metadata management.

Typical workflows:
1. **Landing page overview**: View the dashboard showing how many standards are cataloged across each tier.
2. **Visual exploration**: Open the Knowledge Graph → see the network of interconnected standards → understand the complexity of the metadata landscape.
3. **AI demo**: Ask the Standards Brain a mission-relevant question → see how AI-powered discovery could save hours of manual research.
4. **Cross-reference demo**: Click through from a guidance document → to the specs it mandates → to the tools that implement those specs.

### 9.4 Developer / Integrator

**Goal**: Understand how to integrate the metadata catalog into automated workflows.

Typical workflows:
1. **API Explorer**: View the API concept demonstration showing example endpoints and response formats.
2. **Search API**: Query `/api/search?q=classification+marking` to find relevant standards programmatically.
3. **Graph queries**: Use SPARQL Explorer to build queries like "find all tools that implement standards mandated by DoDI 8320.02."

---

## 10. Success Metrics

These metrics were validated against the prototype and should be preserved as acceptance criteria for the production implementation.

| Metric | Target | Validation |
|--------|--------|------------|
| Tier comprehension | A new user understands the four-tier structure within 60 seconds of viewing the landing page | User testing with leadership audience |
| Artifact discoverability | Any specific artifact can be found within 3 clicks or 1 search query | Tested with all major standards |
| AI citation accuracy | Standards Brain responses cite relevant sources with working links | Tested with 4+ representative queries across domains |
| Cross-reference visibility | The knowledge graph reveals non-obvious connections between standards that would require manual research to discover | Validated with multi-hop path finding |
| Ingestion reliability | Content from a new URL is fully indexed (searchable + graph-connected) in under 60 seconds | Tested with diverse source types |
| Graph coverage | Entity extraction correctly identifies standards and their relationships in >80% of ingested content | Validated against known relationship inventory |

---

## Appendix A: Palantir Foundry Capability Mapping

The following table maps each prototype capability to its likely Foundry equivalent. This is intended as a starting point for architectural planning, not a prescriptive implementation specification.

| Prototype Capability | Current Implementation | Suggested Foundry Equivalent | Notes |
|----------------------|----------------------|------------------------------|-------|
| **Relational data storage** | Supabase (PostgreSQL) | Foundry Datasets (Phonograph) | Source records, user data, settings, activity logs → structured datasets |
| **Vector embeddings & search** | Supabase pgvector (512-dim OpenAI embeddings) | AIP Vector Index / AIP Semantic Search | Chunk embeddings for RAG retrieval. Evaluate Foundry's native vector capabilities vs. external embedding service. |
| **Property knowledge graph** | Neo4j AuraDB (7,400+ entities, 29,000+ relationships) | Foundry Ontology | Core capability match. Entities → Object Types. Relationships → Link Types. Aliases → Object properties. Ontology is Foundry's central strength. |
| **RDF triplestore + reasoning** | Stardog Cloud (50K+ triples, OWL 2 RL reasoning) | Foundry Ontology + Logic Functions | Foundry Ontology covers most graph needs. OWL reasoning could be replicated via Logic Functions for inference rules. SPARQL queries → Object Search API or Functions. |
| **AI chat assistant (RAG)** | Vercel AI SDK + Gemini/Claude | AIP Logic + AIP Assist | AIP provides native RAG capabilities. System prompt configuration → AIP configuration. Multi-model routing → AIP model selection. |
| **LLM entity extraction** | Gemini 2.5 Flash via `generateObject()` | AIP Logic Functions | Structured extraction during ingestion. Zod schemas → AIP function input/output schemas. |
| **Web application** | Next.js 15 (React) | Workshop Application | Workshop provides drag-and-drop UI building with native Ontology integration. Alternative: Slate for custom React components. |
| **Graph visualization** | Sigma.js (WebGL, ForceAtlas2) | Workshop Graph Widget / Object Explorer | Workshop has built-in graph visualization widgets. May need custom widget for Path Finder and SPARQL Explorer features. |
| **Content ingestion pipeline** | Custom Node.js pipeline (crawl → chunk → embed → extract → store) | Pipeline Builder + Transforms | Each pipeline stage → a Transform. Scheduling, monitoring, and retry logic are native to Pipeline Builder. |
| **Web crawling** | Firecrawl + Jina Reader | Data Connection (External) + Transforms | Foundry Data Connection can pull from external URLs. Custom transform for HTML-to-text conversion. |
| **File upload & parsing** | Next.js API routes + pdf-parse + custom XML parsers | Foundry Data Connection (Manual Upload) + Transforms | Native file upload to Foundry datasets. PDF/XML parsing via Transforms (Python or Java). |
| **User authentication** | HMAC-signed tokens + Supabase users table | Multipass (Foundry native auth) | Foundry handles auth natively. User/group management via Multipass. Role-based access via Foundry permissions. |
| **Role-based access control** | Admin/User roles, middleware enforcement | Foundry Groups + Marking Schemes | Foundry's native RBAC is more granular than the prototype. Can implement per-tier or per-source access controls. |
| **Activity audit logging** | Custom `user_activity_log` table | Foundry Audit Logs | Native capability — all actions in Foundry are automatically audited. |
| **Rate limiting** | In-memory sliding window | Foundry API Gateway / Platform limits | Foundry manages API rate limiting at the platform level. |
| **Search (hybrid)** | Vector similarity + keyword matching | AIP Semantic Search + Object Search | AIP for semantic search. Object Search API for structured queries across the Ontology. |
| **API access** | REST endpoints (Next.js API routes) | OSDK (Ontology Software Development Kit) | OSDK generates type-safe API clients for any language. REST alternative via Foundry API Gateway. |
| **Conversation persistence** | Supabase `conversations` + `chat_messages` tables | Foundry Datasets or AIP native conversation storage | If using AIP Assist, conversation management may be handled natively. |
| **System configuration** | Supabase `app_settings` table | Foundry Configuration / Workshop variables | Admin-tunable settings stored as Foundry configuration objects. |

### Key Foundry Advantages for This Use Case

1. **Ontology as first-class primitive**: The four-tier artifact model maps directly to Foundry Object Types and Link Types, with native search, visualization, and permissioning.

2. **AIP integration**: Foundry's AIP provides native RAG, embeddings, and LLM capabilities within the platform's security boundary — no external API keys or third-party LLM services required.

3. **Enterprise auth and RBAC**: Multipass provides SSO integration, group-based permissions, and per-object access controls that far exceed the prototype's simple admin/user model.

4. **Pipeline orchestration**: Pipeline Builder provides scheduling, dependency management, retry logic, and monitoring for the ingestion pipeline — capabilities that are custom-built in the prototype.

5. **Audit and compliance**: All actions in Foundry are automatically audited, meeting DoD compliance requirements without custom logging infrastructure.

6. **Accreditation**: The DAF Foundry instance operates within an accredited security boundary, eliminating the need to separately accredit the metadata repository.

---

## Appendix B: Glossary

| Term | Definition |
|------|------------|
| **AIP** | Artificial Intelligence Platform — Palantir's integrated AI/ML capability within Foundry |
| **Chunk** | A segment of text extracted from a source document, typically 300–500 tokens, used as the unit of search and retrieval |
| **DCAT** | Data Catalog Vocabulary — a W3C standard for describing datasets in data catalogs |
| **DCAMPS-C** | Data-Centric Automated Metadata and Publishing System - Cloud — a metadata tagging tool by Mundo Systems |
| **DoDI** | Department of Defense Instruction — a policy directive issued by the Secretary of Defense or designee |
| **DoDD** | Department of Defense Directive — a higher-level policy document establishing policy and organization |
| **Dublin Core** | A set of fifteen core metadata elements for describing resources (ISO 15836) |
| **Embedding** | A numerical vector representation of text that captures semantic meaning, enabling similarity search |
| **Foundry** | Palantir Foundry — a data integration and analytics platform |
| **Hybrid RAG** | Retrieval-Augmented Generation using multiple search strategies (vector + graph + keyword) to provide context to a language model |
| **IC-EDH** | Intelligence Community Enterprise Data Header — a standard for metadata headers on intelligence products |
| **IC-ISM** | Intelligence Community Information Security Marking — the standard for security classification markings |
| **IC-TDF** | Intelligence Community Trusted Data Format — a standard for trusted data exchange |
| **ISO 11179** | International standard for metadata registries |
| **Knowledge Graph** | A network of entities and relationships representing structured knowledge about a domain |
| **LLM** | Large Language Model — an AI model trained to understand and generate human language |
| **Multipass** | Palantir's identity and access management service within Foundry |
| **NIEM** | National Information Exchange Model — a common vocabulary for information sharing across government |
| **Ontology** | A formal representation of knowledge as a set of concepts, their properties, and relationships within a domain. In Foundry context, also refers to the platform's semantic data layer. |
| **OSDK** | Ontology Software Development Kit — Palantir's tool for generating type-safe API clients from Foundry Ontology definitions |
| **OWL** | Web Ontology Language — a W3C standard for defining ontologies on the Semantic Web |
| **pgvector** | A PostgreSQL extension for storing and querying vector embeddings |
| **RAG** | Retrieval-Augmented Generation — a technique that grounds LLM responses in retrieved source documents |
| **RDF** | Resource Description Framework — a W3C standard for describing resources as subject-predicate-object triples |
| **SKOS** | Simple Knowledge Organization System — a W3C standard for representing taxonomies and controlled vocabularies |
| **SPARQL** | SPARQL Protocol and RDF Query Language — the query language for RDF data |
| **Triplestore** | A database optimized for storing and querying RDF triples (subject-predicate-object statements) |
| **Vector Search** | A search technique that finds content semantically similar to a query by comparing embedding vectors |
| **Workshop** | Palantir's low-code application builder within Foundry |

---

## Appendix C: Technical Architecture

### Current Prototype Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                          Users                                       │
│                                                                      │
│    Data Stewards    Administrators    Leadership    Developers        │
└─────────┬───────────────┬──────────────┬─────────────┬──────────────┘
          │               │              │             │
          ▼               ▼              ▼             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     Web Application Layer                            │
│                                                                      │
│  ┌──────────┐ ┌──────────┐ ┌───────────┐ ┌────────┐ ┌───────────┐  │
│  │ Browse   │ │ Standards│ │ Knowledge │ │ Admin  │ │ API       │  │
│  │ Pages    │ │ Brain    │ │ Graph     │ │ Panel  │ │ Explorer  │  │
│  │ (5 tiers)│ │ (AI Chat)│ │ (5 tabs)  │ │        │ │ (Concept) │  │
│  └──────────┘ └──────────┘ └───────────┘ └────────┘ └───────────┘  │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐    │
│  │                    Search (Hybrid)                            │    │
│  │            Vector (70%) + Keyword (30%)                      │    │
│  └──────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────┬───────────────────────────────────┘
                                  │
                    ┌─────────────┼──────────────┐
                    │             │              │
                    ▼             ▼              ▼
          ┌─────────────┐ ┌────────────┐ ┌────────────┐
          │  Supabase   │ │   Neo4j    │ │  Stardog   │
          │  (Postgres  │ │  AuraDB    │ │  Cloud     │
          │  + pgvector)│ │            │ │            │
          │             │ │  Property  │ │  RDF       │
          │  Sources    │ │  Graph     │ │  Triplestore│
          │  Chunks     │ │  7,432     │ │  50,734    │
          │  Embeddings │ │  entities  │ │  triples   │
          │  Users      │ │  29,118    │ │  OWL 2 RL  │
          │  Settings   │ │  relations │ │  Reasoning │
          │  Activity   │ │            │ │            │
          │  Chats      │ │            │ │            │
          └─────────────┘ └────────────┘ └────────────┘
                    ▲             ▲              ▲
                    │             │              │
                    └─────────────┼──────────────┘
                                  │
                    ┌─────────────┴──────────────┐
                    │    Ingestion Pipeline       │
                    │                             │
                    │  Crawl → Chunk → Embed →    │
                    │  Store → Extract → Graph    │
                    └─────────────────────────────┘
                                  ▲
                                  │
                    ┌─────────────┴──────────────┐
                    │     Content Sources          │
                    │                              │
                    │  URLs (defense.gov, dni.gov, │
                    │  niem.gov, w3c.org, iso.org) │
                    │  File Uploads (PDF, XSD,     │
                    │  Schematron, TXT, CSV, JSON)  │
                    │  ZIP Packages (ODNI specs)    │
                    └──────────────────────────────┘
```

### External Service Dependencies (Prototype)

| Service | Purpose | Foundry Equivalent |
|---------|---------|-------------------|
| Supabase (PostgreSQL + pgvector) | Relational storage, vector search, user management | Foundry Datasets, AIP Vector Index |
| Neo4j AuraDB | Property graph (knowledge graph) | Foundry Ontology |
| Stardog Cloud | RDF triplestore with reasoning | Foundry Ontology + Logic Functions |
| OpenAI API | Text embeddings (text-embedding-3-small, 512 dims) | AIP Embeddings |
| Google AI (Gemini) | LLM for chat and entity extraction | AIP Models |
| Anthropic (Claude) | LLM for chat (alternative model) | AIP Models |
| Firecrawl / Jina Reader | Web crawling for content ingestion | Data Connection + Transforms |
| Vercel | Application hosting and deployment | Foundry Workshop / Slate |

---

*This document was generated from the working DAF Metadata Repository prototype (v21, deployed March 2026). All capability descriptions reflect implemented, tested functionality — not planned features. The prototype source code is available for reference during the Foundry implementation planning process.*
