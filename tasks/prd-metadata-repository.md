# PRD: DAF Metadata Repository Prototype

## Introduction

The DAF Metadata Repository is a demonstration prototype that showcases how the Department of the Air Force could centrally organize, discover, and access metadata standards, guidance, and tooling. The repository presents a polished, read-only catalog of metadata artifacts organized into three tiers — from high-level DoD policy guidance, through technical specifications and domain profiles, down to tooling that tags and labels data according to those standards.

The prototype serves leadership discussions by making the concept tangible: stakeholders can see how a unified metadata repository would work, what it would contain, and how it could be accessed — both by humans through a web interface and by automated systems (DevSecOps pipelines, CI/CD) through a programmatic API.

A key concept the demo illustrates is the **dual hosting model**: some artifacts are held directly in the repository (with full content), while others are represented as **pointers/links to authoritative external sources**. This reflects how a real repository would work — not everything would be duplicated, but the repository would serve as a single catalog that knows where everything lives.

This is **not** a production system. It is a demonstration with representative mock data designed to communicate the vision, validate requirements, and build consensus. The API is a **simulated concept** — the UI demonstrates what programmatic access would look like, but no real functioning API backend is required.

## Goals

- Provide a polished, navigable web interface for browsing metadata artifacts across all three tiers
- Pre-load the repository with realistic mock data representing DoD guidance, technical specs, domain profiles, and tools
- Demonstrate the **concept** of dual access patterns: manual web browsing **and** programmatic API access (API is simulated/demo only)
- Illustrate the dual hosting model: artifacts can be **stored locally** in the repository or exist as **pointers to authoritative external sources**
- Communicate the value proposition of a centralized metadata repository to leadership audiences
- Show how artifacts relate across tiers (e.g., a domain profile references specific technical specs; guidance maps to relevant standards)
- Be fully runnable on a local machine in a browser — no cloud services, accounts, or internet connection required for the core demo
- Be simple enough to demo in a meeting without setup or explanation overhead

## User Stories

### US-001: Browse Tier 1 — Authoritative Guidance
**Description:** As a stakeholder, I want to browse high-level DoD instructions and authoritative guidance so that I can see what policy drives our metadata standards.

**Acceptance Criteria:**
- [ ] Tier 1 section displays a list of guidance documents including: DoDI 8320.02, DoDI 8320.07, DoDI 8310.01, DoDI 8330.01
- [ ] Each entry shows: title, document number, issuing authority, date, summary, and status (active/superseded)
- [ ] Each entry indicates whether the document is **stored in the repository** or is a **pointer to an external authoritative source** (with link)
- [ ] Clicking an entry opens a detail view with full description and links to related Tier 2A specs
- [ ] List is searchable by keyword and filterable by issuing authority and status
- [ ] Verify in browser

### US-002: Browse Tier 2A — Technical Specifications
**Description:** As a data steward or developer, I want to browse technical metadata specifications so that I can understand what standards are available for use.

**Acceptance Criteria:**
- [ ] Tier 2A section displays specifications including:
  - **NIEM** (National Information Exchange Model) with its sub-specifications
  - **IC specs** (publicly available): IC-ISM, IC-EDH, and others — primarily as pointers to authoritative sources
  - **Dublin Core** metadata standard
  - **W3C metadata specification** (e.g., DCAT, RDF/OWL, or similar)
- [ ] Each entry shows: name, version, managing organization, category, description, and hosting type (local/pointer)
- [ ] Pointer entries display a prominent external link icon and URL to the authoritative source
- [ ] Locally-stored entries show fuller detail including element/attribute summaries
- [ ] Detail view shows related guidance (Tier 1) and profiles that use it (Tier 2B)
- [ ] List is searchable and filterable by category and managing organization
- [ ] Verify in browser

### US-003: Browse Tier 2B — Domain Profiles
**Description:** As a data steward, I want to browse domain-specific metadata profiles so that I can see how organizations tailor standards for their particular use cases.

**Acceptance Criteria:**
- [ ] Tier 2B section displays domain profiles representing metadata "standards" from specific organizations
- [ ] Each profile shows: name, owning organization, domain, version, description, status, and which Tier 2A specs it incorporates
- [ ] Detail view shows a breakdown of which elements are drawn from which specs
- [ ] Visual indicator (badge/tag) showing the source spec for each element in a profile
- [ ] Verify in browser

### US-004: Browse Tier 3 — Tool Catalog
**Description:** As a developer or data steward, I want to browse tools that tag and label data according to metadata standards so that I can find tools that help apply our standards to actual data.

**Note:** Tier 3 focuses specifically on tools for **metadata tagging and labeling** — tools that apply metadata standards to data (e.g., classification marking, security labeling, attribute tagging). This is distinct from metadata catalog/repository tools that store metadata itself.

**Acceptance Criteria:**
- [ ] Tier 3 section displays a catalog of tagging/labeling tools including: Mundo Systems DCAMPS-C, Microsoft Purview, a Varonis product, and Collibra (more to be added)
- [ ] Each entry shows: name, vendor, description, tagging/labeling capabilities, supported specs, license type, and maturity level
- [ ] Detail view shows what standards the tool can tag against (linked to Tier 2A), integration approach, and use case notes
- [ ] List is searchable and filterable by supported spec and tool category
- [ ] Verify in browser

### US-005: Cross-Tier Navigation and Relationships
**Description:** As any user, I want to navigate between related artifacts across tiers so that I can understand how guidance, specs, profiles, and tools connect.

**Acceptance Criteria:**
- [ ] Guidance documents (Tier 1) link to the specs (Tier 2A) they mandate or reference
- [ ] Specs (Tier 2A) link to guidance that references them and profiles that use them
- [ ] Profiles (Tier 2B) link to the specs they incorporate
- [ ] Tools (Tier 3) link to the specs they support
- [ ] Breadcrumb or navigation trail shows the user's path through related artifacts
- [ ] Verify in browser

### US-006: Global Search
**Description:** As any user, I want to search across all tiers from a single search bar so that I can quickly find any artifact regardless of which tier it belongs to.

**Acceptance Criteria:**
- [ ] Search bar prominently displayed on the main page and accessible from all views
- [ ] Results grouped by tier with clear tier labels
- [ ] Search covers title, description, keywords, and document numbers
- [ ] Results are relevant and ordered by match quality
- [ ] Verify in browser

### US-007: API Access Concept Demo
**Description:** As a presenter, I want to show stakeholders what programmatic API access to the repository would look like so that they understand the DevSecOps/CI-CD integration value.

**Acceptance Criteria:**
- [ ] An "API Explorer" page in the UI that demonstrates the concept of programmatic access
- [ ] Shows example endpoints for each tier: `/api/guidance`, `/api/specs`, `/api/profiles`, `/api/tools`
- [ ] Displays example request/response pairs (mock JSON) showing what a CI/CD query would look like
- [ ] Interactive demo: user can select an endpoint and see a simulated JSON response with mock data
- [ ] Includes narrative text explaining how a DevSecOps pipeline could use the API to validate metadata compliance
- [ ] No actual backend API implementation required — this is a UI-driven concept demonstration
- [ ] Verify in browser

### US-008: Dashboard / Landing Page
**Description:** As a leadership stakeholder, I want a landing page that summarizes the repository at a glance so that I immediately understand its scope and value.

**Acceptance Criteria:**
- [ ] Landing page shows summary counts for each tier (e.g., "4 Guidance Documents, 8 Technical Specs, 5 Domain Profiles, 6 Tools")
- [ ] Visual overview or diagram showing the three-tier structure and how they relate
- [ ] Quick-access cards or links to each tier's browse view
- [ ] Visual distinction between locally-stored artifacts and pointer/linked artifacts
- [ ] Clean, professional design with DAF branding
- [ ] Verify in browser

## Functional Requirements

- FR-1: The system must display a navigable catalog of metadata artifacts organized into four categories: Guidance (Tier 1), Technical Specs (Tier 2A), Domain Profiles (Tier 2B), and Tagging/Labeling Tools (Tier 3)
- FR-2: Each artifact must have a list view (summary card) and a detail view (full information)
- FR-3: Each tier's list view must support keyword search and category-appropriate filtering
- FR-4: The system must show cross-references between artifacts in different tiers (clickable links)
- FR-5: The system must provide a global search that spans all tiers and returns grouped results
- FR-6: Each artifact must indicate its **hosting type**: "Stored" (content held in the repository) or "Linked" (pointer to an authoritative external source with URL)
- FR-7: Linked/pointer artifacts must display a prominent external link to the authoritative source
- FR-8: The system must include an **API Explorer** page that demonstrates the concept of programmatic access with example endpoints, mock request/response pairs, and interactive simulated queries
- FR-9: The system must include a landing page with summary statistics, tier overview, and DAF branding
- FR-10: All artifact data must be pre-loaded as static mock data (no user-generated content)
- FR-11: The UI must be responsive and professionally styled, suitable for presentation to senior leadership
- FR-12: The entire application must run locally on a single machine with no external dependencies — `git clone`, `npm install`, `npm run dev`, open browser

## Non-Goals (Out of Scope)

- **No real API backend** — the API is a concept demonstration only; no functioning REST endpoints are required
- **No authentication or access control** — this is an open demo, not a secured system
- **No data editing or creation** — the catalog is read-only with pre-loaded mock data
- **No real document storage** — locally "stored" artifacts contain mock summary content, not actual full documents or PDFs
- **No real-time data** — all data is static mock data, not synced with any live systems
- **No workflow or approval processes** — no governance workflow for adding/updating standards
- **No compliance validation engine** — no actual metadata validation is performed
- **No user accounts or personalization** — no saved searches, favorites, or role-based views

## Design Considerations

- **DAF branding** — use Department of the Air Force identity elements (logo, color palette) for a professional, authentic feel
- **Professional, government-appropriate aesthetic** — clean, understated design; no flashy animations or consumer-app patterns. Think: modern government dashboard
- **Stored vs. Linked visual language** — clear, consistent visual distinction between artifacts stored in the repo and those that are pointers to external sources (e.g., a "Stored" badge vs. an "External Link" badge with URL)
- **Information density** — leadership audiences want to see the breadth of the repository; prioritize scannable lists and summary views over deep detail
- **Tier color coding** — use subtle, distinct colors or icons for each tier to aid navigation (e.g., blue for guidance, green for specs, orange for profiles, purple for tools)
- **Responsive layout** — must look good projected in a conference room (large screen) and on a laptop
- **Typography and spacing** — prioritize readability; use a clear type hierarchy for document titles, metadata fields, and descriptions

## Technical Considerations

- **Tech stack**: Next.js (App Router) with Tailwind CSS — provides the UI in a single project, easy to deploy and demo
- **Data layer**: Static JSON files in the project (no database needed for a read-only demo)
- **Mock data**: 5-8 artifacts per tier using real standard names and document numbers. Specific initial data:
  - **Tier 1**: DoDI 8320.02, DoDI 8320.07, DoDI 8310.01, DoDI 8330.01 (more to be added later including memos and DoDDs)
  - **Tier 2A**: NIEM (with sub-specs), publicly available IC specs (IC-ISM, IC-EDH, etc. — mostly as pointers), Dublin Core, a W3C metadata spec (e.g., DCAT)
  - **Tier 2B**: Representative organization-specific metadata profiles (to be detailed later)
  - **Tier 3**: Mundo Systems DCAMPS-C, Microsoft Purview, a Varonis product, Collibra (more to be added later). Focus is on tools that **tag/label data** according to standards, not metadata catalog tools.
- **API Explorer**: Client-side only — mock JSON responses rendered in the UI, no actual API routes needed
- **Primary deployment: local** — must run entirely on a local machine via `npm run dev` and be viewable in a browser at `localhost`. No external services, databases, or API keys required. Optionally deployable to Vercel or similar for sharing a link, but local-first is the priority.
- **Accessibility**: Basic WCAG compliance — semantic HTML, keyboard navigation, sufficient contrast

## Success Metrics

- A leadership stakeholder can understand the three-tier structure within 60 seconds of viewing the landing page
- A user can find any specific artifact (by name or keyword) within 3 clicks or one search
- The API Explorer page clearly communicates the value of programmatic access to a non-technical audience
- A viewer can immediately distinguish between stored artifacts and external pointers
- The demo can be set up and running locally in under 2 minutes (`git clone` → `npm install` → `npm run dev`)
- The prototype generates productive discussion about requirements for a real metadata repository

## Open Questions (Resolved)

1. ~~Mock data depth~~ — **Resolved**: 5-8 per tier. User will provide specific artifacts as development progresses.
2. ~~Specific standards~~ — **Resolved**: NIEM (with sub-specs), IC specs (publicly available, mostly pointers), Dublin Core, W3C metadata spec. Details to be refined later.
3. ~~Specific guidance~~ — **Resolved**: DoDI 8320.02, 8320.07, 8310.01, 8330.01 to start. More memos and DoDDs to follow.
4. ~~Branding~~ — **Resolved**: DAF branding.
5. ~~API demo page~~ — **Resolved**: Yes, include an interactive API Explorer page as a concept demonstration.

## Remaining Open Questions

1. **Tier 2B specifics**: Which organizations' metadata profiles should be represented? (User to provide later)
2. **Tier 3 additions**: Initial tools identified (DCAMPS-C, Purview, Varonis, Collibra). User may add more later.
3. **DAF branding assets**: Do we have access to official DAF logos/color specs, or should we approximate?
