# Checkpoint — 2026-03-01 (Session 11)

## Current State
Phases 1-6 code complete. Ingestion pipeline, RAG chat, admin panel with user management all built. Build passes clean (58 pages). Pushed to GitHub, Vercel auto-deploying.

## What's Done This Session
- **Ingestion pipeline** (`src/lib/ingest/`): crawl (Jina Reader + Firecrawl fallback) → chunk (markdown-aware, token-counted) → embed (OpenAI text-embedding-3-small, 512-dim) → store (Supabase chunks + Neo4j Source nodes)
- **RAG chat** (`src/lib/rag/` + `/api/chat`): vector search via match_chunks RPC, multi-model (Claude Sonnet 4.6 / Gemini 2.5 Flash / Gemini 2.0 Flash), streaming via Vercel AI SDK v6
- **Standards Brain**: replaced mock Q&A with real `useChat()` streaming chat, using AI SDK v6 `UIMessage` parts API
- **Admin panel** (`/admin`): dashboard stats, source management with ingest-by-URL, user management (create/delete users with roles), LLM model selector, system prompt editor
- **Auth evolution**: multi-user login (username + password from users table) + shared password fallback (grants admin). Signed tokens with HMAC-SHA256 containing username + role. Middleware enforces admin-only access to `/admin` and `/api/admin` routes.
- **Supabase migrations**: `users` table (username, password_hash, role, display_name), unique constraint on `sources.url`
- **NPM packages**: `@mendable/firecrawl-js`

## Key Architecture Notes
- AI SDK v6 breaking changes: `useChat()` returns `{ messages, sendMessage, status }` instead of `{ input, handleInputChange, handleSubmit, isLoading }`. Messages use `parts[]` array instead of `content` string. Server uses `convertToModelMessages()` + `toUIMessageStreamResponse()`.
- Zod v4: uses `.issues` instead of `.errors` on `ZodError`
- Firecrawl SDK v4: method is `app.scrape()` not `app.scrapeUrl()`, returns `Document` directly (no success wrapper)
- OpenAI embeddings called directly via fetch (AI SDK's embedding wrapper doesn't support dimensions parameter)

## Next Session Plan
1. **Initialize Neo4j schema**: POST to `/api/setup/neo4j` after deploy (schema constraints + indexes)
2. **Ingest real content** (Phase 7): Use admin panel or API to crawl authoritative URLs
   - Start with a few test URLs to verify the pipeline end-to-end
   - Then bulk ingest: ODNI specs (71 manifest URLs), NIEM, Dublin Core, W3C, DoD guidance
3. **Test Standards Brain**: Ask questions about ingested content, verify citations
4. **Polish** (Phase 8): rate limiting, error handling, mobile responsiveness
5. **Update CLAUDE.md** current state section
