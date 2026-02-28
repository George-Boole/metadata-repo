# Plan: DAF Metadata Repository — Production Deployment with Hybrid RAG

## Context

The DAF Metadata Repository is a working Next.js 15 prototype with static JSON data, mock chatbot, and 71 downloaded ODNI IC specs. The user wants to deploy it as a password-protected live site with a real hybrid RAG system (vector + knowledge graph + LLM) and an admin panel for content management. All content should live online (no local files dependency). The RAG must always cite sources with clickable references.

## Tech Stack (Final)

| Layer | Tool | Cost |
|-------|------|------|
| Hosting | Vercel Hobby (free) | $0 |
| Vector DB + Auth | Supabase pgvector (free, 500MB) | $0 |
| Graph DB | Neo4j AuraDB Free (50K nodes/175K rels) | $0 |
| LLM (selectable) | Claude Sonnet 4.6 / Gemini 2.5 Flash / Gemini 2.0 Flash | $0-21/mo |
| Embeddings | OpenAI text-embedding-3-small (512 dims) | ~$0.50 one-time |
| Web Crawling | Firecrawl (500 free credits) + Jina Reader | $0 |
| Auth | Next.js middleware shared password | $0 |

## Secrets Management

All API keys stored in `.env.local` (already gitignored). User will create the file locally and I'll provide the variable names. Keys also set in Vercel project settings for production. **No secrets in chat — user pastes directly into `.env.local` file.**

### Required Environment Variables

```
# Auth
SITE_PASSWORD=<user-chosen-demo-password>
AUTH_SECRET=<random-64-char-hex-string>

# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ...

# Neo4j AuraDB
NEO4J_URI=neo4j+s://xxxx.databases.neo4j.io
NEO4J_USER=neo4j
NEO4J_PASSWORD=<from-aura-setup>

# LLM Providers
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
GOOGLE_GENERATIVE_AI_API_KEY=AI...

# Web Crawling
FIRECRAWL_API_KEY=fc-...
```

## Phase 0: Account Setup (Session 8, Step 1)

Walk user through each account one at a time. User already has Vercel and Supabase accounts.

### 0.1 — Vercel: Add New Project (existing Hobby account)
1. Go to https://vercel.com → Dashboard (already logged in)
2. Click "Add New..." → "Project"
3. Import the `George-Boole/metadata-repo` repository from GitHub
4. Framework: auto-detected as Next.js — accept defaults
5. Click "Deploy" — initial deploy works with current static site
6. Note: env vars added in step 0.7 after all keys collected
7. **Result**: Live URL at `metadata-repo-xxx.vercel.app`

### 0.2 — Supabase: New Organization + Project (existing account)
1. Go to https://supabase.com → Dashboard (already logged in)
2. Click your org dropdown (top-left) → "New Organization"
3. Name: "DAF Prototypes" (or similar), select Free plan
4. Inside the new org, click "New Project"
5. Name: "daf-metadata-repo", Region: "US East (North Virginia)", generate DB password
6. **IMPORTANT**: Save the generated DB password — needed for direct DB access
7. Wait for project to finish provisioning (~2 min)
8. Go to Settings → API → copy `Project URL` and `anon/public key`
9. Go to Settings → API → copy `service_role key` (secret — for server-side only)
10. **Keys to save**: `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`
11. New org gets its own 2-project free tier limit, completely independent from existing orgs

### 0.3 — Neo4j AuraDB Free
1. Go to https://neo4j.com/cloud/aura-free → Create free account
2. Create new AuraDB Free instance (name: "daf-standards-graph")
3. **IMPORTANT**: Save the auto-generated password immediately — shown only once
4. Wait for instance to be "Running" (~2 min)
5. Copy connection URI from instance details
6. **Keys to save**: `NEO4J_URI`, `NEO4J_USER` (always "neo4j"), `NEO4J_PASSWORD`

### 0.4 — API Keys (Existing Accounts)
1. **Anthropic**: Go to https://console.anthropic.com → API Keys → Create new key → name "daf-metadata-repo"
2. **OpenAI**: Go to https://platform.openai.com → API Keys → Create new key → name "daf-metadata-repo"
3. **Google AI**: Go to https://aistudio.google.com → Get API Key → Create key
4. **Keys to save**: `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `GOOGLE_GENERATIVE_AI_API_KEY`

### 0.5 — Firecrawl
1. Go to https://firecrawl.dev → Sign up
2. Go to API Keys → Copy key
3. **Key to save**: `FIRECRAWL_API_KEY`

### 0.6 — Create `.env.local`
1. I create the file with placeholder variable names
2. User opens it in their editor and pastes each key value
3. Generate `AUTH_SECRET` via: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`
4. User chooses `SITE_PASSWORD` (the demo shared password)

### 0.7 — Set Vercel Environment Variables
1. Go to Vercel project → Settings → Environment Variables
2. Add each variable from `.env.local`
3. Redeploy

## Phase 1: Auth + Database Foundation

### Files to create:
- `src/middleware.ts` — cookie-based auth gate (redirects unauthenticated to /login)
- `src/app/login/page.tsx` — login form with DAF branding
- `src/app/api/auth/route.ts` — POST: validate password, set httpOnly cookie
- `src/lib/auth.ts` — requireAuth() and requireAdmin() helpers
- `src/lib/supabase.ts` — Supabase client singleton (server + browser)
- `src/lib/neo4j.ts` — Neo4j driver singleton

### Supabase Migrations (run via MCP or SQL editor):
- Enable `vector` and `pg_trgm` extensions
- Create `sources` table (id, url, title, source_type, tier, status, chunk_count, metadata, timestamps)
- Create `chunks` table (id, source_id FK, content, embedding vector(512), chunk_type, source_url, source_title, tier, heading, metadata, fts tsvector)
- Create `app_settings` table (key, value jsonb)
- Create HNSW index on chunks.embedding
- Create `match_chunks()` RPC function for vector similarity search
- Seed app_settings with default model config

### Neo4j Setup:
- Create uniqueness constraints on node id properties
- Create indexes on common query properties

### Verify:
- Deploy to Vercel, confirm login gate works
- Confirm Supabase tables created
- Confirm Neo4j instance accessible

## Phase 2: Seed Existing Data

### Files to create:
- `src/lib/embeddings.ts` — OpenAI embedding helper (single + batch)
- `src/lib/seed.ts` — reads static JSON, populates Supabase + Neo4j
- `src/app/api/seed/route.ts` — one-time POST endpoint

### What gets seeded:
- All guidance.json entries → sources table + Guidance nodes in Neo4j
- All specs.json entries → sources table + Standard nodes + cross-ref relationships
- All profiles.json entries → sources table + Profile nodes + INCORPORATES rels
- All tools.json entries → sources table + Tool nodes + SUPPORTS rels
- All ontologies.json entries → sources table + Ontology nodes
- Embed all descriptions → chunks table with vectors
- Build all cross-tier relationships in Neo4j (MANDATES, REFERENCES, etc.)

### Verify:
- Query Supabase: confirm source count matches JSON totals
- Query Neo4j: confirm node/relationship counts
- Test vector similarity search via RPC

## Phase 3: RAG Chat — Vector Search

### Files to create:
- `src/lib/rag/vector-search.ts` — Supabase match_chunks() wrapper
- `src/lib/rag/prompt-builder.ts` — system prompt with context + citation instructions
- `src/lib/rag/model-resolver.ts` — maps model name → AI SDK provider
- `src/app/api/chat/route.ts` — streaming chat endpoint (Vercel AI SDK `streamText`)

### Files to modify:
- `src/app/standards-brain/page.tsx` — replace mock Q&A with `useChat()` hook, keep existing UI shell

### NPM packages to install:
```
ai @ai-sdk/react @ai-sdk/anthropic @ai-sdk/google @ai-sdk/openai
@supabase/supabase-js neo4j-driver zod
```

### Citation strategy:
- System prompt instructs LLM: "Cite sources using `[Source Title](url)` format"
- Existing `formatMessageContent()` already renders `[text](url)` as `<Link>` components
- Each retrieved chunk carries `source_url` and `source_title` metadata
- Context blocks passed to LLM are tagged: `[Source: Title | url]`

### Verify:
- Ask questions in Standards Brain, get streaming responses with citations
- Citations render as clickable links to repo pages

## Phase 4: Graph-Enhanced Hybrid RAG

### Files to create:
- `src/lib/rag/graph-search.ts` — entity extraction + Cypher traversal
- `src/lib/rag/hybrid-retriever.ts` — parallel vector + graph, merge + deduplicate

### Files to modify:
- `src/app/api/chat/route.ts` — use hybrid retriever instead of vector-only

### Verify:
- Ask relationship questions ("What does DoDI 8320.02 mandate?")
- Confirm graph context enriches answers beyond what vector search alone provides

## Phase 5: Web Crawling Ingestion Pipeline

### Files to create:
- `src/lib/ingest/crawl.ts` — Firecrawl wrapper
- `src/lib/ingest/parsers/pdf-parser.ts`
- `src/lib/ingest/parsers/xml-parser.ts`
- `src/lib/ingest/parsers/html-parser.ts`
- `src/lib/ingest/parsers/index.ts` — dispatcher
- `src/lib/ingest/chunker.ts` — token-counted chunking with overlap
- `src/lib/ingest/pipeline.ts` — orchestrator: crawl → parse → chunk → embed → store
- `src/app/api/ingest/route.ts` — POST endpoint

### NPM packages:
```
@mendable/firecrawl-js cheerio pdf-parse fast-xml-parser tiktoken
```

### Key design: Crawl ODNI website directly
- Use the manifest URLs from `scripts/odni-spec-manifest.json` to crawl dni.gov spec pages
- Firecrawl fetches each page, returns clean markdown
- Chunks stored in pgvector with `source_url` pointing back to dni.gov
- No local file storage needed — everything lives in the database
- For freshness: re-crawl sources with status 'stale' (admin can trigger)

### Verify:
- Ingest a real ODNI spec page URL
- Confirm chunks in Supabase, nodes in Neo4j
- Ask Standards Brain about the ingested spec, confirm it answers correctly with citations

## Phase 6: Admin Panel

### Files to create:
- `src/app/admin/layout.tsx` — admin layout with sidebar nav
- `src/app/admin/page.tsx` — dashboard with stats (source count, chunk count, by tier/status)
- `src/app/admin/sources/page.tsx` — source list table with filters
- `src/app/admin/sources/new/page.tsx` — add source form (URL input + file upload + tier selector)
- `src/app/admin/settings/page.tsx` — model selector dropdown + system prompt editor
- `src/app/api/admin/sources/route.ts` — GET list, POST add
- `src/app/api/admin/sources/[id]/route.ts` — GET detail, PATCH, DELETE
- `src/app/api/admin/stats/route.ts` — GET dashboard stats
- `src/app/api/admin/settings/route.ts` — GET/PATCH settings

### Files to modify:
- `src/components/Navbar.tsx` — add Admin link

### Verify:
- Full admin workflow: add source URL → trigger ingest → see in source list → ask about it in chat

## Phase 7: Bulk Content Ingestion

### Content to ingest:
1. **71 ODNI IC specs** — crawl all page URLs from manifest via Firecrawl
2. **NIEM** — crawl niem.github.io and reference.niem.gov
3. **Dublin Core** — crawl dublincore.org/specifications
4. **W3C DCAT** — crawl w3.org/TR/vocab-dcat
5. **W3C RDF/OWL/SKOS** — crawl relevant W3C spec pages
6. **DoD guidance docs** — crawl linked URLs from guidance.json

### Verify:
- Standards Brain can answer detailed questions about any ingested content
- All answers cite sources with working URLs

## Phase 8: Polish + Deploy

- Rate limiting on /api/chat (protect LLM costs)
- Graceful fallback if Neo4j unavailable (vector-only mode)
- Error handling for crawl failures
- Loading states and streaming UI polish
- Mobile responsiveness check
- Final `npm run build` verification
- Push to GitHub → Vercel auto-deploys
- Update CLAUDE.md and SESSION_LOG.md

## Free Tier Budget

| Service | Limit | Est. Usage | Headroom |
|---------|-------|------------|----------|
| Supabase | 500MB | ~60MB | 88% free |
| Neo4j AuraDB | 50K nodes / 175K rels | ~5K / ~15K | 90% free |
| Vercel | 100GB bandwidth | ~1GB/mo | 99% free |
| Firecrawl | 500 credits | ~200 credits | 60% free |
| OpenAI embeddings | pay per use | ~$0.50 total | N/A |

512-dim embeddings (Matryoshka truncation) keep Supabase storage 3x smaller than full 1536-dim.

## Immediate Next Step

Start with Phase 0: walk through account creation one at a time, collecting keys into `.env.local`.
