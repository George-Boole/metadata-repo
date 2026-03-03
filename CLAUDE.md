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
│   ├── components/       # Shared React components
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
- **Phase**: Static JSON eliminated. All pages query Supabase. Graph RAG pipeline built. ODNI zip ingestion ready.
- **Last Completed**: Kill static JSON + graph extraction pipeline + ODNI deep ingestion + hybrid graph RAG. All browse pages (guidance, specs, profiles, tools, ontologies) are Supabase-only. Old detail pages redirect to `/sources/[id]`. Search is Supabase-only. Dashboard counts all from Supabase. LLM-based graph extraction auto-populates Neo4j during ingestion. Chat uses hybrid vector+graph retrieval.
- **Ingested Content**: 115 sources, ~5,196 chunks. ODNI zip deep ingestion ready to run (scripts/ingest-odni-zips.ts).
- **Browse Pages**: All 5 tiers query Supabase via SourceList. No JSON fallback. Fictional sources flagged via `metadata.fictional`.
- **Data Layer**: `src/lib/data-server.ts` (Supabase queries). Static JSON deleted. `src/lib/data.ts` and `src/lib/search.ts` deleted.
- **Graph Pipeline**: `src/lib/ingest/graph-extract.ts` (Gemini-based entity/relationship extraction) → `src/lib/ingest/graph-write.ts` (Neo4j write). Integrated into ingestion pipeline as step 7.5.
- **ODNI Zip Pipeline**: `src/lib/ingest/download.ts` + extractors (pdf, xsd, schematron) → `ingestZipContents()` in pipeline.ts. Script: `scripts/ingest-odni-zips.ts`.
- **RAG**: Hybrid retriever (`src/lib/rag/hybrid-retriever.ts`) combines vector search + graph search. Chat endpoint uses `buildHybridContextPrompt()` with graph relationship context.
- **Source Detail**: `/sources/[id]` shows graph cross-references (related entities, relationship types) with links to related source pages.
- **Models**: Gemini 2.0 Flash (default), Gemini 2.0 Flash Lite, Claude Sonnet 4.6 — selectable via admin panel.
- **Auth System**: Multi-user with roles. Login accepts username+password or shared password. HMAC-signed tokens.
- **Data Policy**: Only real data in databases. Fictional sources (profiles, DAF Data Fabric Ontology) marked with `metadata.fictional: true` and EXAMPLE badges.
- **Dev Environment**: macOS (Mac mini M-series), Node.js 25.7.0, Homebrew
- **Rate Limiting**: In-memory sliding window — chat 20/min, auth 5/min, ingest 10/min, admin 30/min
- **Error Handling**: Error boundaries at root, standards-brain, and admin levels. 404 page. API routes return generic error messages.
- **Pending Scripts**: Run `npx tsx scripts/backfill-graph.ts` to populate Neo4j from existing sources. Run `npx tsx scripts/ingest-odni-zips.ts` for deep ODNI content. Seed fictional profiles/ontologies into Supabase.
- **Next Step**: Seed missing profile/ontology sources into Supabase, run backfill + ODNI ingestion scripts, Vercel deploy, demo testing

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
