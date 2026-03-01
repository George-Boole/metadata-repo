# DAF Metadata Repository - Claude Code Context

## Project Identity
- **Name**: DAF Metadata Repository (Prototype/Demo)
- **Purpose**: Demonstration prototype for leadership discussions — showcases a centralized metadata standards repository for the Department of the Air Force
- **Repo**: Local Windows dev → GitHub
- **PRD**: `tasks/prd-metadata-repository.md`

## Tech Stack
- **Framework**: Next.js 15 (App Router) + TypeScript
- **Styling**: Tailwind CSS 4
- **Data Layer**: Static JSON files in `src/data/` (migrating to Supabase pgvector + Neo4j AuraDB)
- **Vector DB**: Supabase pgvector (free tier, 500MB) — chunks + embeddings + auth
- **Graph DB**: Neo4j AuraDB Free (50K nodes / 175K relationships) — standards knowledge graph
- **LLM**: Multi-model — Claude Sonnet 4.6 / Gemini 2.5 Flash / Gemini 2.0 Flash (user-selectable)
- **Embeddings**: OpenAI text-embedding-3-small (512 dims via Matryoshka truncation)
- **Web Crawling**: Firecrawl (500 free credits) + Jina Reader API
- **Auth**: Next.js middleware shared password + Supabase Auth
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
│   │   ├── standards-brain/ # AI chatbot concept demo
│   │   ├── api-explorer/ # API concept demo page
│   │   └── search/       # Global search results
│   ├── components/       # Shared React components
│   ├── data/             # Static JSON mock data files
│   │   ├── guidance.json
│   │   ├── specs.json
│   │   ├── profiles.json
│   │   ├── tools.json
│   │   └── ontologies.json
│   ├── lib/              # Utility functions, types, search logic
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
- **Hybrid data layer** — static JSON for SSR browse pages + Supabase pgvector for RAG chunks + Neo4j for relationship graph
- **Dual hosting model** — artifacts are either "Stored" (content in repo) or "Linked" (pointer to external authoritative source)
- **Web-crawled content** — ODNI specs, NIEM, W3C, Dublin Core ingested by crawling source websites (not local files)
- **Multi-model RAG** — admin-selectable LLM (Claude Sonnet 4.6 / Gemini Flash), OpenAI embeddings, hybrid vector+graph retrieval
- **Always cite sources** — every RAG response includes clickable source references
- **Admin panel** — add content via URL or file upload, select LLM model, view ingestion status
- **Password-protected** — shared password via Next.js middleware for demo access

## Three-Tier Data Model
1. **Tier 1 — Authoritative Guidance**: DoD Instructions, memos, directives (DoDI 8320.02, 8320.07, 8310.01, 8330.01)
2. **Tier 2A — Technical Specs**: NIEM (with sub-specs), IC specs (IC-ISM, IC-EDH — mostly pointers), Dublin Core, W3C specs
3. **Tier 2B — Domain Profiles**: Organization-specific metadata profiles built from Tier 2A specs
4. **Tier 3 — Tagging/Labeling Tools**: Tools that apply metadata standards to data (DCAMPS-C, Purview, Varonis, Collibra). NOT metadata catalog tools.

## Current State
- **Phase**: Phase 0 account setup — blocked on `.env.local` key restoration
- **Last Completed**: All external accounts created (Vercel, Supabase, Neo4j, Anthropic, OpenAI, Google AI, Firecrawl). Vercel project deployed and linked locally.
- **What's Blocking**: `.env.local` was wiped by `vercel link` in Session 9. User needs to re-copy API keys from each service dashboard (or restore via OneDrive version history).
- **Implementation Plan**: `C:\Users\greg\.claude\plans\gentle-sleeping-kite.md` (detailed 8-phase plan)
- **Next Immediate Step**: User restores `.env.local` keys → push env vars to Vercel → begin Phase 1 (auth + database foundation)

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
