# DAF Metadata Repository - Claude Code Context

## Project Identity
- **Name**: DAF Metadata Repository (Prototype/Demo)
- **Purpose**: Demonstration prototype for leadership discussions — showcases a centralized metadata standards repository for the Department of the Air Force
- **Repo**: GitHub (George-Boole/metadata-repo), dev on macOS (Mac mini M-series)
- **PRD**: `tasks/prd-metadata-repository.md`

## Tech Stack
- **Framework**: Next.js 15 (App Router) + TypeScript
- **Styling**: Tailwind CSS 4
- **Data Layer**: Static JSON for browse pages + Supabase pgvector for RAG + Neo4j AuraDB for graph
- **Vector DB**: Supabase pgvector (free tier, 500MB) — chunks + embeddings + auth
- **Graph DB**: Neo4j AuraDB Free (50K nodes / 175K relationships) — standards knowledge graph
- **LLM**: Multi-model — Gemini 2.5 Flash (default) / Gemini 2.5 Flash Lite / Claude Sonnet 4.6 (admin-selectable)
- **Embeddings**: OpenAI text-embedding-3-small (512 dims via Matryoshka truncation)
- **Web Crawling**: Firecrawl (500 free credits) + Jina Reader API
- **Auth**: Multi-user (Supabase users table) + shared password fallback, HMAC-signed tokens
- **Hosting**: Vercel Hobby (free tier)
- **Linting**: ESLint with next/core-web-vitals
- **Runtime**: Node.js, npm

## Project Structure
```
metadata-repo/
├── src/
│   ├── app/              # Next.js App Router pages
│   │   ├── layout.tsx    # Root layout with DAF branding
│   │   ├── page.tsx      # Landing page / dashboard
│   │   ├── guidance/     # Tier 1: DoD guidance documents
│   │   ├── specs/        # Tier 2A: Technical specifications
│   │   ├── profiles/     # Tier 2B: Domain profiles
│   │   ├── tools/        # Tier 3: Tagging/labeling tools
│   │   ├── ontologies/   # Ontologies section
│   │   ├── standards-brain/ # RAG-powered AI chat (real, not mock)
│   │   ├── admin/          # Admin panel (sources, users, settings)
│   │   ├── api-explorer/ # API concept demo page
│   │   └── search/       # Global search results
│   ├── components/       # Shared React components (incl. GraphVisualization.tsx)
│   ├── lib/              # Utility functions, types, search logic
│   │   ├── auth.ts       # Multi-user auth (HMAC tokens, password hashing)
│   │   ├── data-server.ts # Supabase queries for browse pages
│   │   ├── supabase.ts   # Supabase client (server + browser)
│   │   ├── neo4j.ts      # Neo4j driver singleton
│   │   ├── embeddings.ts # OpenAI text-embedding-3-small (512-dim)
│   │   ├── ingest/       # Ingestion pipeline (crawl → chunk → embed → store → graph)
│   │   │   ├── pipeline.ts      # Main ingest + zip ingestion
│   │   │   ├── graph-extract.ts # LLM entity/relationship extraction
│   │   │   ├── graph-write.ts   # Write triples to Neo4j
│   │   │   ├── download.ts      # ZIP download + extraction
│   │   │   └── extractors/      # PDF, XSD, Schematron parsers
│   │   └── rag/          # RAG system (hybrid vector + graph retrieval)
│   │       ├── vector-search.ts    # Supabase hybrid search
│   │       ├── graph-search.ts     # Neo4j graph traversal
│   │       ├── hybrid-retriever.ts # Combined vector + graph
│   │       ├── prompt-builder.ts   # Context prompt with graph
│   │       └── model-resolver.ts   # Multi-model LLM routing
│   └── types/            # TypeScript type definitions
├── public/               # Static assets (logos, icons)
├── tasks/                # PRD and task tracking
│   └── prd-metadata-repository.md
├── docs/                 # Session logs and progress tracking
│   ├── SESSION_LOG.md
│   └── CHECKPOINT.md
└── CLAUDE.md             # This file
```

## Key Architecture Decisions
- **Supabase-first data layer** — all browse/detail pages query Supabase. No static JSON fallback. Neo4j for relationship graph.
- **Dual hosting model** — artifacts are either "Stored" (content in repo) or "Linked" (pointer to external authoritative source)
- **Web-crawled content** — ODNI specs, NIEM, W3C, Dublin Core ingested by crawling source websites (not local files)
- **ODNI deep ingestion** — ZIP packages downloaded, PDFs/XSDs/Schematron extracted and chunked for deep content
- **LLM graph extraction** — Gemini Flash extracts entities and relationships from ingested content, auto-populating Neo4j
- **Hybrid RAG retrieval** — vector similarity (0.7 weight) + keyword matching (0.3 weight) + Neo4j graph context. Graph-connected sources boosted.
- **Always cite sources** — every RAG response includes clickable source references
- **Admin panel** — add content via URL or file upload, select LLM model, view ingestion status
- **Password-protected** — shared password via Next.js middleware for demo access

## Three-Tier Data Model
1. **Tier 1 — Authoritative Guidance**: DoD Instructions, memos, directives (DoDI 8320.02, 8320.07, 8310.01, 8330.01)
2. **Tier 2A — Technical Specs**: NIEM (with sub-specs), IC specs (IC-ISM, IC-EDH — mostly pointers), Dublin Core, W3C specs
3. **Tier 2B — Domain Profiles**: Organization-specific metadata profiles built from Tier 2A specs
4. **Tier 3 — Tagging/Labeling Tools**: Tools that apply metadata standards to data (DCAMPS-C, Purview, Varonis, Collibra). NOT metadata catalog tools.

## Current State
- **Phase**: Deployed to Vercel. Dual graph backends (Neo4j + Stardog). Knowledge Graph Explorer with Sigma.js visualization. Admin panel fully functional.
- **Last Completed**: Session 21 — Sigma.js graph visualization upgrade, enhanced Stardog capabilities (reasoning, explain, path finder), clickable graph nodes, graph stats dashboard.
- **Ingested Content**: ~155+ sources, ~31,000+ chunks. 31 Tier 1 guidance sources (~1,243 chunks). 95 tier-2a sources with 29,207 chunks. All 67 ODNI IC specs deep-ingested. ISO 11179 parts 3/31/32/33/34/35 uploaded (~766 chunks).
- **Neo4j Graph**: 7,432 entities, 9,928 RELATES_TO, 19,190 MENTIONS, 112 Source nodes. Canonical entities have rich aliases (IC-ISM: 118 aliases, IC-TDF: 53, IC-ID: 26, IC-EDH: 20).
- **Stardog Graph**: 50,734 triples synced from Neo4j. Parallel backend — all ingestion flows to both Neo4j + Stardog. OWL 2 RL reasoning available. SPARQL 1.1 property paths enabled.
- **Knowledge Graph Explorer**: `/knowledge-graph` with 5 tabs: Graph Visualization (Sigma.js WebGL), Path Finder (multi-hop SPARQL property paths), Platform Comparison, SPARQL Explorer (with reasoning toggle + explain plan), Statistics (combined Neo4j + Stardog with hub analysis).
- **Graph Visualization**: Sigma.js (WebGL) replaced react-force-graph-2d. ForceAtlas2 layout, smart label density, hover highlighting, node sizing by connection count, type-based color coding, entity type filter buttons. Clickable nodes navigate to `/sources/[id]`.
- **Browse Pages**: All 5 tiers query Supabase via SourceList. Source cards fully clickable (link to `/sources/[id]`). Descriptions visible on cards. No JSON fallback. Fictional sources flagged via `metadata.fictional`.
- **Data Layer**: `src/lib/data-server.ts` (Supabase queries). Static JSON deleted.
- **Admin Panel**: URL ingestion + drag-and-drop file upload. Stardog toggle (show/hide on public site). Upload features: queue-based UI with per-file progress, cancel button, dismiss button. Client-side PDF text extraction via `pdfjs-dist` v4.10.38 for files >4.5 MB. Content-based dedup via SHA-256 hash. Supports PDF, TXT, MD, CSV, XML, XSD, SCH, JSON.
- **Graph Pipeline**: `src/lib/ingest/graph-extract.ts` (Gemini 2.5 Flash entity/relationship extraction) → `src/lib/ingest/graph-write.ts` (Neo4j MERGE write) + `src/lib/ingest/stardog-write.ts` (RDF write). Integrated into ingestion pipeline.
- **ODNI Zip Pipeline**: `src/lib/ingest/download.ts` + extractors (pdf via pdf-parse v1.1.1, xsd, schematron) → `ingestZipContents()` in pipeline.ts. Smart filtering: PDFs always, XSDs >5KB, Schematron >10KB.
- **RAG**: Hybrid retriever (`src/lib/rag/hybrid-retriever.ts`) combines vector search + Neo4j graph search + Stardog graph search. Chat endpoint uses `buildHybridContextPrompt()` with graph relationship context. Standards Brain `useChat` uses stable `id: "standards-brain"` to prevent race condition on first message.
- **Source Detail**: `/sources/[id]` shows graph cross-references (related entities, relationship types) with links to related source pages.
- **Models**: Gemini 2.5 Flash (default), Claude Sonnet 4.6 — selectable via admin panel.
- **Auth System**: Multi-user with roles. Login accepts username+password or shared password. HMAC-signed tokens.
- **Data Policy**: Only real data in databases. Fictional sources (profiles, DAF Data Fabric Ontology) marked with `metadata.fictional: true` and EXAMPLE badges.
- **Dev Environment**: macOS (Mac mini M-series), Node.js 25.7.0, Homebrew
- **Rate Limiting**: In-memory sliding window — chat 20/min, auth 5/min, ingest 10/min, admin 30/min
- **Error Handling**: Error boundaries at root, standards-brain, and admin levels. 404 page. API routes return generic error messages.
- **Hosting**: Deployed on Vercel Hobby tier. Auto-deploys from GitHub main branch.
- **Next Step**: Demo testing, verify Stardog on production, content gap analysis

## Autonomy Rules
Claude operates at MAXIMUM autonomy **within this repository**:

### DO Freely (No Confirmation Needed)
- Create, edit, delete any files inside this repo
- Install npm packages
- Run `npm run dev`, `npm run build`, `npm run lint`, and any test commands
- Run any read-only commands (git status, git log, git diff, ls, etc.)
- Create git commits with descriptive messages
- Create and switch git branches
- Push to remote (after initial remote is set up)
- Modify mock data, components, pages, styles — anything in the codebase
- Add new directories and restructure the project as needed
- Use browser/playwright MCP tools to test the running app on localhost
- Use any MCP tools for research, documentation lookup, or code assistance

### ASK First
- Dropping/deleting the git repository itself
- Force-push or rewriting published git history
- Any actions that affect files OUTSIDE this repo directory
- Adding paid services or external API dependencies
- Major architectural changes that contradict the PRD (e.g., adding a database)

### ALWAYS
- Run `npm run build` before committing to verify the build passes
- Update `docs/SESSION_LOG.md` at end of session with what was accomplished
- Update the "Current State" section of this CLAUDE.md when phase/status changes
- Keep mock data realistic — use real standard names, document numbers, and organizations
- Prefer editing existing files over creating new ones where reasonable

### NEVER
- Commit .env files, secrets, or credentials
- Read, display, or echo contents of `.env` files in chat
- Execute commands or modify files outside this repository
- Install packages globally on the user's system
- Run destructive git commands (reset --hard, clean -f) without asking

## Coding Conventions
- **Components**: Functional React components with TypeScript
- **Styling**: Tailwind CSS utility classes; no separate CSS modules unless necessary
- **File naming**: kebab-case for files, PascalCase for components
- **Imports**: Use `@/*` alias for src-relative imports
- **Data access**: Import from `@/data/*.json` or utility functions in `@/lib/`
- **Types**: Centralize shared types in `@/types/`
- **Commit messages**: `type: description` (feat/fix/chore/test/docs/style)

## Agent Teaming
This project actively uses Claude Code multiagent teams (TeamCreate + Task tool) for parallelizable work. Use teams when:
- A task can be decomposed into 3+ independent subtasks (e.g., editing separate pages/components)
- Multiple data files or sections need simultaneous updates
- Research + implementation can proceed in parallel

**When NOT to use teams**: Single-file edits, sequential tasks with tight dependencies, quick fixes.

### Team Protocol
- Create a team with `TeamCreate`, create tasks with `TaskCreate`, spawn agents with `Task` tool (set `team_name` and `name`)
- Each agent works in isolation via `isolation: "worktree"` when editing overlapping files
- Agents read CLAUDE.md and SESSION_LOG.md before starting work
- Agents claim tasks via TaskUpdate before working on them
- Agents avoid conflicting file edits by working on separate features/pages
- Leader verifies build passes after merging all agent work

## Context Window Management

### Session Handoff Protocol
- **ALWAYS** update `docs/SESSION_LOG.md` at end of every session
- **ALWAYS** update `CLAUDE.md` Current State section if phase/status changed

### Mid-Session Checkpoint Protocol
When working on a long task (3+ chunks in one session), periodically write `docs/CHECKPOINT.md`:
```markdown
# Checkpoint - [timestamp]
## Currently Working On
[story ID and description]
## What's Done Since Session Start
[list of completed items]
## What's In Progress
[partially done work, what files are modified, what remains]
## Next Steps (if context resets)
[exactly what to do next to resume]
```
This file is ephemeral — overwrite it each time. It exists only to recover if a session is interrupted.

### Key Files to Read at Session Start
1. `CLAUDE.md` (this file) — project context + rules
2. `tasks/prd-metadata-repository.md` — full PRD with user stories
3. `docs/SESSION_LOG.md` — what happened in prior sessions
4. `docs/CHECKPOINT.md` (if exists) — interrupted work state
