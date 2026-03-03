/**
 * Comprehensive site crawl test.
 *
 * Starts at the homepage, discovers every internal link and button,
 * visits each page, and checks for:
 *  - HTTP errors (4xx / 5xx)
 *  - Console errors
 *  - Empty content / zero-count indicators
 *  - Broken internal links (404s)
 *  - Missing headings
 *  - Elements that look like error states
 */

import { config } from "dotenv";
config({ path: ".env.local" });

import { test, expect, type Page } from "@playwright/test";

const SITE_PASSWORD = process.env.SITE_PASSWORD || "";

/* ── Helpers ──────────────────────────────────────────────── */

interface PageReport {
  url: string;
  status: number | null;
  consoleErrors: string[];
  issues: string[];
  links: string[];
  cardCount: number;
  bodySnippet: string;
}

const VISITED = new Set<string>();
const REPORTS: PageReport[] = [];
const BASE = "http://localhost:3000";

/** Normalise a URL to a pathname for dedup */
function toPath(url: string): string {
  try {
    const u = new URL(url, BASE);
    if (u.origin !== new URL(BASE).origin) return ""; // external
    return u.pathname;
  } catch {
    return "";
  }
}

/** Should we crawl this path? */
function shouldVisit(path: string): boolean {
  if (!path || path === "") return false;
  if (VISITED.has(path)) return false;
  // Skip API routes, login, admin (auth-gated), external anchors
  if (path.startsWith("/api/")) return false;
  if (path.startsWith("/login")) return false;
  if (path.startsWith("/admin")) return false;
  if (path === "#") return false;
  return true;
}

/** Collect all internal link hrefs on the current page */
async function collectLinks(page: Page): Promise<string[]> {
  const hrefs = await page.$$eval("a[href]", (anchors) =>
    anchors.map((a) => a.getAttribute("href") || ""),
  );
  const paths: string[] = [];
  for (const href of hrefs) {
    const path = toPath(href);
    if (path) paths.push(path);
  }
  return [...new Set(paths)];
}

/** Check a single page for issues */
async function auditPage(page: Page, path: string): Promise<PageReport> {
  VISITED.add(path);
  const report: PageReport = {
    url: path,
    status: null,
    consoleErrors: [],
    issues: [],
    links: [],
    cardCount: 0,
    bodySnippet: "",
  };

  // Listen for console errors
  const consoleHandler = (msg: import("playwright-core").ConsoleMessage) => {
    if (msg.type() === "error") {
      report.consoleErrors.push(msg.text());
    }
  };
  page.on("console", consoleHandler);

  // Navigate
  let response;
  try {
    response = await page.goto(`${BASE}${path}`, {
      waitUntil: "networkidle",
      timeout: 15_000,
    });
  } catch (e) {
    report.issues.push(`Navigation failed: ${e instanceof Error ? e.message : String(e)}`);
    page.off("console", consoleHandler);
    return report;
  }

  report.status = response?.status() ?? null;

  // Check HTTP status
  if (report.status && report.status >= 400) {
    report.issues.push(`HTTP ${report.status}`);
  }

  // Get body text for analysis
  const bodyText = (await page.textContent("body")) || "";
  report.bodySnippet = bodyText.substring(0, 300).replace(/\s+/g, " ").trim();

  // Check for Next.js error overlay / error boundary text
  if (bodyText.includes("Application error")) {
    report.issues.push("Application error detected on page");
  }
  if (bodyText.includes("This page could not be found")) {
    report.issues.push("404 page rendered");
  }
  if (bodyText.includes("Internal Server Error")) {
    report.issues.push("Internal Server Error on page");
  }

  // Check for zero counts on dashboard
  if (path === "/") {
    const statCards = await page.$$eval(
      "section a[href] p.text-3xl",
      (els) =>
        els.map((el) => ({
          text: el.textContent?.trim(),
          parent: el.closest("a")?.getAttribute("href"),
        })),
    );
    for (const card of statCards) {
      if (card.text === "0") {
        report.issues.push(
          `Dashboard shows 0 for card linking to ${card.parent}`,
        );
      }
    }

    // Report actual counts
    const countsInfo = statCards
      .map((c) => `${c.parent}=${c.text}`)
      .join(", ");
    if (countsInfo) {
      report.issues.push(`Dashboard counts: ${countsInfo}`);
    }
  }

  // Check browse pages for content
  const BROWSE_PAGES = [
    "/guidance",
    "/specs",
    "/tools",
    "/ontologies",
    "/profiles",
  ];
  if (BROWSE_PAGES.includes(path)) {
    // Count all visible cards (various selectors for different card types)
    const cardSelectors = [
      ".grid a",           // ArtifactCard (Link wrapping)
      ".grid > div",       // SourceList cards (div wrapping)
      ".space-y-4 > div",  // Specs list items
    ];
    let totalCards = 0;
    for (const sel of cardSelectors) {
      const count = await page.$$eval(sel, (els) => els.length);
      totalCards += count;
    }
    report.cardCount = totalCards;

    if (totalCards === 0) {
      report.issues.push(`Browse page has 0 visible cards/items`);
    }

    // Check the "Showing X of Y" text (non-blocking)
    const showingEl = await page.$("p.text-sm.text-gray-500");
    if (showingEl) {
      const showingText = await showingEl.textContent();
      if (showingText) {
        const match = showingText.match(/Showing (\d+) of (\d+)/);
        if (match) {
          const [, shown, total] = match;
          report.issues.push(`Shows "${shown} of ${total}" items`);
          if (total === "0") {
            report.issues.push(`ZERO ITEMS — page is empty`);
          }
        }
      }
    }
  }

  // For detail pages, verify they have content
  if (
    path.match(
      /^\/(guidance|specs|tools|ontologies|profiles|sources)\/[^/]+$/,
    )
  ) {
    const h1 = await page.$("h1");
    const h1Text = h1 ? await h1.textContent() : null;
    if (!h1Text) {
      report.issues.push("Detail page missing h1");
    }

    // Check for error states (use visible h1 text, not serialized JS data)
    const visibleText = await page.evaluate(() => {
      const main = document.querySelector("main");
      return main ? main.innerText : document.body.innerText;
    });
    if (
      visibleText.includes("Page Not Found") ||
      visibleText.includes("not found") ||
      visibleText.includes("Sign In")
    ) {
      report.issues.push("Page shows error/login instead of content");
    }
  }

  // Check for missing page heading (not on home page which uses different structure)
  if (path !== "/" && path !== "/search") {
    const h1 = await page.$("h1");
    if (!h1) {
      report.issues.push("No <h1> heading found");
    }
  }

  // Collect outgoing internal links
  report.links = await collectLinks(page);

  // Clean up listener
  page.off("console", consoleHandler);

  return report;
}

/* ── Test ──────────────────────────────────────────────────── */

test("comprehensive site crawl — all pages, links, and content", async ({
  page,
}) => {
  // Authenticate before crawling (site is password-protected)
  if (SITE_PASSWORD) {
    const resp = await page.request.post(`${BASE}/api/auth`, {
      data: { password: SITE_PASSWORD },
    });
    if (resp.ok()) {
      // Extract set-cookie and add to browser context
      const setCookie = resp.headers()["set-cookie"];
      if (setCookie) {
        const match = setCookie.match(/daf-auth-token=([^;]+)/);
        if (match) {
          await page.context().addCookies([{
            name: "daf-auth-token",
            value: match[1],
            domain: "localhost",
            path: "/",
          }]);
        }
      }
      console.log("  Authenticated successfully");
    } else {
      console.log(`  Auth failed: ${resp.status()}`);
    }
  }

  // Seed the crawl queue with the homepage
  const queue: string[] = ["/"];

  // Also add known routes that might not be linked from home
  const KNOWN_ROUTES = [
    "/guidance",
    "/specs",
    "/profiles",
    "/tools",
    "/ontologies",
    "/standards-brain",
    "/api-explorer",
    "/search",
  ];
  for (const route of KNOWN_ROUTES) {
    if (!queue.includes(route)) queue.push(route);
  }

  // Known detail pages from static JSON to test
  const KNOWN_DETAIL_PAGES = [
    "/guidance/guid-8320-02",
    "/guidance/guid-8320-07",
    "/specs/spec-niem",
    "/specs/spec-dublin-core",
    "/specs/spec-ic-ism",
    "/tools/tool-dcamps-c",
    "/tools/tool-purview",
    "/tools/tool-collibra",
    "/ontologies/onto-jdo",
    "/ontologies/onto-owl2",
    "/ontologies/onto-daf-fabric",
    "/profiles/profile-af-isr",
    "/profiles/profile-afmc-logistics",
  ];
  for (const route of KNOWN_DETAIL_PAGES) {
    if (!queue.includes(route)) queue.push(route);
  }

  // Crawl loop
  while (queue.length > 0) {
    const path = queue.shift()!;
    if (!shouldVisit(path)) continue;

    const report = await auditPage(page, path);
    REPORTS.push(report);

    // Add discovered links to queue (limit crawl depth)
    if (REPORTS.length < 100) {
      for (const link of report.links) {
        if (shouldVisit(link)) {
          queue.push(link);
        }
      }
    }
  }

  // ── Print full report ──────────────────────────────────────
  console.log("\n" + "=".repeat(72));
  console.log("  SITE CRAWL REPORT");
  console.log("=".repeat(72));
  console.log(`  Pages visited: ${REPORTS.length}`);

  const pagesWithIssues = REPORTS.filter((r) =>
    r.issues.some(
      (i) =>
        i.startsWith("HTTP") ||
        i.includes("error") ||
        i.includes("ZERO") ||
        i.includes("0 visible") ||
        i.includes("not found") ||
        i.includes("missing") ||
        i.includes("Navigation failed"),
    ),
  );
  console.log(`  Pages with problems: ${pagesWithIssues.length}`);
  console.log(
    `  Pages with console errors: ${REPORTS.filter((r) => r.consoleErrors.length > 0).length}`,
  );
  console.log("=".repeat(72));

  // Per-page details
  for (const r of REPORTS) {
    const hasProblems =
      r.issues.some(
        (i) =>
          i.startsWith("HTTP 4") ||
          i.startsWith("HTTP 5") ||
          i.includes("error") ||
          i.includes("ZERO") ||
          i.includes("0 visible") ||
          i.includes("not found") ||
          i.includes("missing") ||
          i.includes("Navigation failed"),
      ) || r.consoleErrors.length > 0;

    const icon = hasProblems ? "FAIL" : " OK ";
    console.log(`\n[${icon}] ${r.url}  (HTTP ${r.status})`);

    for (const issue of r.issues) {
      const prefix = issue.startsWith("Dashboard counts") ||
        issue.startsWith("Shows ") ? "     INFO" : "     ISSUE";
      console.log(`  ${prefix}: ${issue}`);
    }
    if (hasProblems && r.bodySnippet) {
      console.log(`     BODY: ${r.bodySnippet}`);
    }
    if (r.consoleErrors.length > 0) {
      for (const err of r.consoleErrors) {
        console.log(`  CONSOLE: ${err.substring(0, 200)}`);
      }
    }
    if (r.cardCount > 0) {
      console.log(`     INFO: ${r.cardCount} cards/items rendered`);
    }
    console.log(`     INFO: ${r.links.length} internal links on page`);
  }

  // ── Summary of broken pages ───────────────────────────────
  const httpErrors = REPORTS.filter(
    (r) => r.status !== null && r.status >= 400,
  );
  if (httpErrors.length > 0) {
    console.log("\n" + "-".repeat(72));
    console.log("  BROKEN PAGES (HTTP 4xx/5xx):");
    console.log("-".repeat(72));
    for (const r of httpErrors) {
      console.log(`  ${r.url} -> HTTP ${r.status}`);
    }
  }

  const emptyPages = REPORTS.filter((r) =>
    r.issues.some((i) => i.includes("0 visible") || i.includes("ZERO")),
  );
  if (emptyPages.length > 0) {
    console.log("\n" + "-".repeat(72));
    console.log("  EMPTY PAGES (no content):");
    console.log("-".repeat(72));
    for (const r of emptyPages) {
      console.log(`  ${r.url}`);
    }
  }

  console.log("\n" + "=".repeat(72));
  console.log("  CRAWL COMPLETE");
  console.log("=".repeat(72) + "\n");

  // ── Assertions ────────────────────────────────────────────

  // Critical: no HTTP 500 errors
  const serverErrors = REPORTS.filter(
    (r) => r.status !== null && r.status >= 500,
  );
  expect(
    serverErrors.length,
    `Server errors:\n${serverErrors.map((r) => `  ${r.url}: HTTP ${r.status}`).join("\n")}`,
  ).toBe(0);

  // Critical: no HTTP 404 errors
  const notFound = REPORTS.filter(
    (r) => r.status === 404 || r.issues.some((i) => i.includes("404")),
  );
  if (notFound.length > 0) {
    console.log(
      `\nWARNING: ${notFound.length} pages returned 404:\n` +
        notFound.map((r) => `  ${r.url}`).join("\n"),
    );
  }
  expect.soft(notFound.length, "404 pages found").toBe(0);

  // Warning: no zero-count dashboard cards
  const zeroCards = REPORTS.filter((r) =>
    r.issues.some((i) => i.includes("shows 0 for card")),
  );
  if (zeroCards.length > 0) {
    console.log(
      `\nWARNING: Dashboard has zero-count cards:\n` +
        zeroCards
          .flatMap((r) => r.issues.filter((i) => i.includes("shows 0")))
          .join("\n"),
    );
  }
  expect.soft(zeroCards.length, "Zero-count dashboard cards").toBe(0);
});
