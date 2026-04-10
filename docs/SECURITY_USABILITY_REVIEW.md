# Security & Usability Review — DAF Metadata Repository

**Date**: 2026-04-10
**Scope**: Full codebase review (auth, API routes, ingestion pipeline, frontend, config/deps)

---

## Executive Summary

This review identified **7 critical**, **10 high**, **12 medium**, and **8 low** severity findings across authentication, API security, ingestion pipeline, frontend UX, and configuration. The most urgent issues are: timing-unsafe token comparison, weak password hashing (SHA-256 instead of PBKDF2/Argon2), SPARQL injection in Stardog queries, SSRF in the ingestion pipeline, and zip bomb vulnerability. The frontend is generally well-built with no XSS issues, but has accessibility gaps and silent error handling.

---

## CRITICAL FINDINGS

### C1. Timing-Unsafe Token Signature Comparison
**Files**: `src/lib/auth.ts:87`, `src/middleware.ts:58`
**Severity**: CRITICAL

Token HMAC signatures are compared using `===` string equality, which is vulnerable to timing attacks:

```typescript
// auth.ts:87 and middleware.ts:58
if (sig !== expected) return null;
```

An attacker can brute-force the HMAC signature character-by-character by measuring response time differences.

**Fix**: Use `crypto.subtle.timingSafeEqual()` or `crypto.timingSafeEqual()` with Buffer comparison.

---

### C2. Weak Password Hashing — SHA-256 Without Key Derivation
**File**: `src/lib/auth.ts:40-46`
**Severity**: CRITICAL

Passwords are hashed with a single round of SHA-256 + salt:

```typescript
const hash = await sha256(salt + password);
return `${salt}:${hash}`;
```

SHA-256 is extremely fast, allowing GPU/ASIC brute-force at billions of hashes/second. Industry standard requires a slow key derivation function.

**Fix**: Use PBKDF2 (available via `crypto.subtle.deriveBits()` with 310,000+ iterations), bcrypt, scrypt, or Argon2.

---

### C3. No Token Expiration Validation
**File**: `src/lib/auth.ts:61-96`
**Severity**: CRITICAL

Tokens include `iat` (issued-at) but it is never validated. The `verifyToken()` function only checks the HMAC signature, not whether the token has expired. A stolen token is valid indefinitely (the 7-day cookie `maxAge` is only enforced client-side and can be bypassed).

**Fix**: Validate `iat` in `verifyToken()`:
```typescript
const MAX_AGE_MS = 7 * 24 * 60 * 60 * 1000;
if (Date.now() - payload.iat > MAX_AGE_MS) return null;
```

---

### C4. SPARQL Injection in Stardog Search
**File**: `src/lib/rag/stardog-search.ts:31-33, 55-57`
**Severity**: CRITICAL

User query terms are interpolated directly into SPARQL queries with only basic quote escaping:

```typescript
const filterClauses = searchTerms
  .map((t) => `CONTAINS(LCASE(?label), LCASE("${t.replace(/"/g, '\\"')}"))`)
  .join(" || ");
```

The `nameFilter` (line 55-57) is also built via string interpolation and used in `FILTER(?fromName IN (...))` clauses. A crafted query could escape the string context and inject arbitrary SPARQL.

**Fix**: Use parameterized SPARQL queries via the Stardog client's query binding API.

---

### C5. SSRF Vulnerability in Ingestion Pipeline
**Files**: `src/app/api/ingest/route.ts:7-8`, `src/lib/ingest/download.ts:12-13`
**Severity**: CRITICAL

The ingest endpoint accepts any URL with only format validation (`z.string().url()`). No checks for:
- Internal/private IP addresses (127.0.0.1, 10.x, 172.16.x, 169.254.169.254)
- Protocol restrictions (file://, data://)
- Redirect following to internal hosts

The ZIP download function (`download.ts:13`) uses bare `fetch(url)` with default redirect following.

**Fix**: Validate URL protocol (https/http only), resolve DNS and block private IP ranges, set `redirect: 'manual'` or limit redirect count, add timeouts.

---

### C6. Zip Bomb / Decompression Bomb Vulnerability
**File**: `src/lib/ingest/download.ts:18-19`
**Severity**: CRITICAL

No size limits on ZIP decompression:

```typescript
const arrayBuffer = await response.arrayBuffer();  // No Content-Length check
const zip = await JSZip.loadAsync(arrayBuffer);     // No decompression limit
```

A 42KB zip can decompress to 4GB+, causing OOM on Vercel functions.

**Fix**: Check `Content-Length` before downloading, cap total download size (e.g. 50MB), track cumulative decompressed size per zip, cap per-file extracted size.

---

### C7. Auth Bypass When AUTH_SECRET Not Set
**File**: `src/middleware.ts:76-80`
**Severity**: CRITICAL

```typescript
const authSecret = process.env.AUTH_SECRET;
if (!authSecret) {
  // No auth configured — allow all
  return NextResponse.next();
}
```

If `AUTH_SECRET` is missing from environment variables (misconfiguration, env reset, new deployment), the entire auth system is bypassed and all routes including admin are publicly accessible.

**Fix**: Fail closed — return 500 or redirect to an error page when AUTH_SECRET is missing in production. Never silently allow all.

---

## HIGH SEVERITY FINDINGS

### H1. Header Injection — `x-user` Identity Spoofing
**Files**: `src/middleware.ts:99-100`, `src/app/api/conversations/route.ts:11,34`
**Severity**: HIGH

Middleware sets `x-user` on the response headers, but API routes read it from the request headers. The conversations route defaults to `"admin"` when the header is missing:

```typescript
const username = request.headers.get("x-user") || "admin";
```

If middleware is bypassed or headers pass through a proxy, an attacker can set `x-user: admin` to impersonate administrators.

**Fix**: Re-verify the auth token directly in each API route instead of trusting middleware-set headers, or use a server-side session store.

---

### H2. No Server-Side Auth Check in Admin API Routes
**Files**: All routes under `src/app/api/admin/`
**Severity**: HIGH

Admin routes rely solely on middleware for role checking. None of the individual route handlers verify authentication or authorization. If middleware is misconfigured, bypassed, or not applied to a new route, admin data is exposed.

**Fix**: Add explicit auth verification in each admin route handler using `getSession()` and checking `role === "admin"`.

---

### H3. Shared Password Grants Full Admin — No Audit Trail
**File**: `src/app/api/auth/route.ts:76-87`
**Severity**: HIGH

Anyone with the shared `SITE_PASSWORD` gets `admin` role, and all shared-password logins appear as user `"admin"` — no individual audit trail.

**Fix**: Give shared-password logins a lower-privilege role (e.g., `"viewer"`), or require user-based login for admin access.

---

### H4. Plaintext Shared Password Comparison
**File**: `src/lib/auth.ts:100-103`
**Severity**: HIGH

```typescript
return password === sitePassword;
```

The shared password is stored in plaintext in the environment variable and compared with `===` (also timing-unsafe). If the env var leaks, the password is immediately compromised.

**Fix**: Store a hash of the site password in the env variable, compare using constant-time hash comparison.

---

### H5. XXE Risk in XML Parsers
**Files**: `src/lib/ingest/extractors/xsd.ts:4-8`, `src/lib/ingest/extractors/schematron.ts:4-8`
**Severity**: HIGH

XMLParser is instantiated without explicit entity processing controls:

```typescript
const parser = new XMLParser({
  ignoreAttributes: false,
  attributeNamePrefix: "@_",
  textNodeName: "#text",
});
```

While fast-xml-parser 5.x has safer defaults than 4.x, best practice is to explicitly disable entity processing.

**Fix**: Add `processEntities: false` and `htmlEntities: false` to parser config.

---

### H6. No Download Size Limits
**File**: `src/lib/ingest/download.ts:18`
**Severity**: HIGH

`response.arrayBuffer()` downloads the entire response into memory with no size check. An attacker-controlled URL can return gigabytes of data.

**Fix**: Check `Content-Length` header, stream with size tracking, abort when limit exceeded.

---

### H7. No CSRF Protection on Auth Endpoints
**File**: `src/app/api/auth/route.ts:32-111`
**Severity**: HIGH

POST `/api/auth` accepts credentials without CSRF token validation. While `sameSite: "lax"` provides partial protection, explicit CSRF tokens are the standard.

**Fix**: Generate and validate a CSRF token on the login form.

---

### H8. Rate Limiting Bypass via `x-forwarded-for` Spoofing
**File**: `src/lib/rate-limit.ts:69-73`
**Severity**: HIGH

```typescript
export function getClientId(request: Request): string {
  const forwarded = request.headers.get("x-forwarded-for");
  if (forwarded) return forwarded.split(",")[0].trim();
  return "unknown";
}
```

Clients can send arbitrary `x-forwarded-for` headers. Note: Vercel strips untrusted headers, so this is primarily a concern in non-Vercel deployments or local development.

**Fix**: On Vercel, use `request.ip` or the verified `x-real-ip` header. Add a fallback IP extraction strategy.

---

### H9. LLM Prompt Injection via Ingested Content
**Files**: `src/lib/rag/prompt-builder.ts:40-49`, `src/lib/ingest/graph-extract.ts:21-74`
**Severity**: HIGH

Ingested content (PDFs, web pages) flows directly into LLM prompts without sanitization:
- RAG context chunks are concatenated into system prompts verbatim
- Graph entity extraction sends ingested text to LLM without prompt injection filtering

An attacker who controls ingested content (via URL or file upload) could inject instructions that manipulate LLM responses.

**Fix**: Add prompt injection detection/filtering on ingested content, use clear delimiters between system instructions and retrieved context, implement output validation.

---

### H10. No Password Complexity Requirements
**File**: `src/app/api/admin/users/route.ts`
**Severity**: HIGH

User creation accepts any password with no length or complexity validation. Combined with weak SHA-256 hashing, single-character passwords are trivially crackable.

**Fix**: Enforce minimum 12 characters with mixed character types.

---

## MEDIUM SEVERITY FINDINGS

### M1. In-Memory Rate Limiting Resets on Deploy/Restart
**File**: `src/lib/rate-limit.ts:16-48`

Rate limits stored in `Map` are lost on every Vercel deployment or function cold start. Multi-instance deployments don't share state.

**Fix**: Use Redis, Supabase, or Vercel KV for persistent rate limiting if brute-force protection is important.

---

### M2. No Security Headers (CSP, X-Frame-Options, HSTS)
**File**: `next.config.ts`

The Next.js config is essentially empty. No Content-Security-Policy, X-Frame-Options, X-Content-Type-Options, or Strict-Transport-Security headers are configured.

**Fix**: Add security headers via `next.config.ts` `headers()` or middleware.

---

### M3. Error Messages Leak Database Details
**Files**: Multiple API routes (e.g., `src/app/api/admin/sources/[id]/route.ts`)

Some routes return raw Supabase error messages: `{ error: error.message }`. This can reveal schema details, constraint names, and table structure.

**Fix**: Log detailed errors server-side, return generic error messages to clients.

---

### M4. File Upload Size Error Message Incorrect
**File**: `src/app/api/ingest/upload/route.ts:27`

Error says "File exceeds 50 MB limit" but the actual limit is 4.5 MB (`MAX_FILE_SIZE = 4.5 * 1024 * 1024`).

**Fix**: `error: "File exceeds 4.5 MB limit"`.

---

### M5. No Token Invalidation on Logout
**File**: `src/app/api/auth/route.ts:113-120`

Logout only clears the client-side cookie. A stolen token remains valid for the full 7-day lifetime.

**Fix**: Maintain a server-side token blocklist (Redis/DB) checked in `verifyToken()`.

---

### M6. Base64-Encoded Token Payload (Not Encrypted)
**File**: `src/lib/auth.ts:72`

Token payloads are base64-encoded (not encrypted), exposing username, role, and timestamp in cookies/logs. While HMAC ensures integrity, the data is visible.

**Fix**: Encrypt the payload before signing, or accept the risk since the data is low-sensitivity.

---

### M7. GET /api/auth Leaks Username
**File**: `src/app/api/auth/route.ts:25-29`

Returns `{ username, role }` for authenticated users. Minor information disclosure.

**Fix**: Return only `{ authenticated: true }` unless the client specifically needs identity.

---

### M8. No Timeout on Fetch Operations
**Files**: `src/lib/ingest/download.ts:13`, `src/lib/ingest/crawl.ts:12-31`

No explicit timeouts on `fetch()` calls. Slow or hanging servers tie up serverless function execution time.

**Fix**: Use `AbortController` with a 30-second timeout.

---

### M9. SPARQL Read-Query Validation Bypass
**Files**: `src/app/api/admin/stardog/query/route.ts`, `src/app/api/graph/stardog/query/route.ts`

The SPARQL query type check (`trimmed.startsWith("SELECT")`) can be bypassed with leading comments: `/* comment */ DELETE ...`.

**Fix**: Strip all comments before checking query type, or use a SPARQL parser to determine query type.

---

### M10. Unbounded Pagination on Admin Endpoints
**File**: `src/app/api/admin/activity/route.ts:15-16`

No upper bound on the `limit` query parameter. `?limit=1000000` fetches the entire activity log.

**Fix**: Cap `limit` at 500.

---

### M11. No Rate Limiting on Settings Endpoint
**File**: `src/app/api/settings/route.ts`

Public endpoint with no auth or rate limiting. Could be polled rapidly.

---

### M12. Silent Error Handling in Frontend
**Files**: `src/components/EntityAutocomplete.tsx:58-59`, `src/app/search/page.tsx:62`

Network errors are silently caught — users see empty results instead of error messages.

**Fix**: Add error state with user-visible feedback (toast notifications or inline messages).

---

## LOW SEVERITY FINDINGS

### L1. No `aria-label` on SVG Icons
**Files**: Multiple components (`Badge.tsx`, `Navbar.tsx`, `page.tsx`, `login/page.tsx`)

SVG icons throughout the app lack accessibility labels for screen readers.

### L2. Form Fields Missing `htmlFor` Association
**File**: `src/app/admin/users/page.tsx`

Input labels not explicitly linked to form fields.

### L3. Graph Visualization Not Keyboard-Accessible
**File**: `src/components/GraphVisualization.tsx`

Sigma.js WebGL canvas lacks keyboard navigation and ARIA descriptions.

### L4. Mobile Responsiveness Gaps
Admin tables and chat height calculations may not render well on mobile viewports.

### L5. Search Results Lack Relevance Indicators
**File**: `src/app/search/page.tsx`

Results sorted by tier only, no relevance scoring or empty-result suggestions.

### L6. Admin Fallback User "admin" May Not Exist in DB
**File**: `src/app/api/auth/route.ts:85`

Shared password login creates tokens for username "admin" which may not have a database record.

### L7. `pdf-parse` v1.1.1 Has Known Vulnerabilities
**File**: `package.json:28`

`pdf-parse` v1.1.1 is outdated and has known security advisories.

### L8. No Logout Token Blocklist
Logged-out tokens remain valid until the 7-day maxAge expires.

---

## POSITIVE FINDINGS

These areas are implemented correctly:

- **No XSS**: No `dangerouslySetInnerHTML` usage. React's built-in escaping handles all rendering.
- **No SQL Injection**: All Supabase queries use the JS client with parameterized queries.
- **No Cypher Injection**: All Neo4j queries use parameterized queries via `runCypher()`.
- **HttpOnly Cookies**: Auth tokens stored in httpOnly cookies (JS cannot access them).
- **SameSite=Lax**: Partial CSRF protection on cookies.
- **Env Var Separation**: Server secrets properly server-side. Only `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` exposed to client (by design).
- **No Hardcoded Secrets**: All credentials come from environment variables.
- **.gitignore**: Properly excludes `.env`, `.env*.local`, `node_modules`.
- **Rate Limiting**: Applied to auth (5/min), chat (20/min), ingest (10/min), admin (30/min).
- **Activity Logging**: Good audit trail for login, ingestion, and admin operations.
- **Zod Validation**: API inputs validated with Zod schemas.
- **Error Boundaries**: React error boundaries at root, standards-brain, and admin levels.

---

## RECOMMENDED PRIORITY ACTIONS

### Immediate (Before Production Use)
1. **C1**: Switch to timing-safe comparison for HMAC verification
2. **C2**: Upgrade password hashing to PBKDF2 with 310K+ iterations
3. **C3**: Add token expiration validation
4. **C4**: Parameterize SPARQL queries
5. **C7**: Fail closed when AUTH_SECRET is missing

### Short-Term (Next Sprint)
6. **C5/C6**: Add SSRF protections and zip bomb limits to ingestion
7. **H1/H2**: Fix header injection and add server-side auth to admin routes
8. **H5**: Add explicit XXE protection to XML parsers
9. **M2**: Add security headers (CSP, HSTS, X-Frame-Options)
10. **H10**: Add password complexity requirements

### Medium-Term
11. **H3/H4**: Rework shared password to non-admin role
12. **M1**: Move rate limiting to persistent storage
13. **M5**: Implement token blocklist for logout
14. **M8**: Add timeouts to all fetch operations
15. Address accessibility findings (L1-L3)
