import Link from "next/link";
import { getGuidance, getSpecs, getProfiles, getTools } from "@/lib/data";
import { HostingBadge } from "@/components/Badge";

export default function Home() {
  const guidance = getGuidance();
  const specs = getSpecs();
  const profiles = getProfiles();
  const tools = getTools();

  return (
    <div className="min-h-screen">
      {/* ── Hero Section ──────────────────────────────────────── */}
      <section className="bg-gradient-to-br from-daf-navy via-daf-blue to-daf-navy text-white">
        <div className="mx-auto max-w-7xl px-4 py-16 sm:px-6 sm:py-20 lg:px-8 lg:py-24">
          <div className="text-center">
            <p className="text-sm font-semibold uppercase tracking-widest text-white/60">
              Department of the Air Force
            </p>
            <h1 className="mt-3 text-4xl font-bold tracking-tight sm:text-5xl lg:text-6xl">
              Metadata Repository
            </h1>
            <p className="mx-auto mt-5 max-w-2xl text-lg text-white/80 sm:text-xl">
              Centralized catalog of metadata standards, guidance, and tooling
              for the Department of the Air Force
            </p>
          </div>
        </div>
      </section>

      {/* ── Summary Statistics Bar ────────────────────────────── */}
      <section className="-mt-6 relative z-10">
        <div className="mx-auto max-w-5xl px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-4 sm:gap-4">
            <Link href="/guidance" className="rounded-lg border-l-4 border-tier-1 bg-white p-4 shadow-md transition hover:shadow-lg hover:scale-[1.02]">
              <p className="text-3xl font-bold text-tier-1">{guidance.length}</p>
              <p className="mt-1 text-sm font-medium text-daf-dark-gray">
                Guidance Documents
              </p>
            </Link>
            <Link href="/specs" className="rounded-lg border-l-4 border-tier-2a bg-white p-4 shadow-md transition hover:shadow-lg hover:scale-[1.02]">
              <p className="text-3xl font-bold text-tier-2a">{specs.length}</p>
              <p className="mt-1 text-sm font-medium text-daf-dark-gray">
                Technical Specs
              </p>
            </Link>
            <Link href="/profiles" className="rounded-lg border-l-4 border-tier-2b bg-white p-4 shadow-md transition hover:shadow-lg hover:scale-[1.02]">
              <p className="text-3xl font-bold text-tier-2b">{profiles.length}</p>
              <p className="mt-1 text-sm font-medium text-daf-dark-gray">
                Domain Profiles
              </p>
            </Link>
            <Link href="/tools" className="rounded-lg border-l-4 border-tier-3 bg-white p-4 shadow-md transition hover:shadow-lg hover:scale-[1.02]">
              <p className="text-3xl font-bold text-tier-3">{tools.length}</p>
              <p className="mt-1 text-sm font-medium text-daf-dark-gray">
                Tagging Tools
              </p>
            </Link>
          </div>
        </div>
      </section>

      {/* ── Three-Tier Visual Overview ────────────────────────── */}
      <section className="py-16">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h2 className="text-2xl font-bold text-daf-dark-gray sm:text-3xl">
              Three-Tier Standards Architecture
            </h2>
            <p className="mx-auto mt-3 max-w-2xl text-daf-gray">
              DAF metadata standards are organized in a layered architecture
              where higher tiers mandate the use of lower-tier specifications.
            </p>
          </div>

          <div className="mt-12 flex flex-col items-center gap-2">
            {/* Tier 1 */}
            <Link
              href="/guidance"
              className="group w-full max-w-3xl rounded-xl border-2 border-tier-1/30 bg-tier-1-bg p-6 shadow-sm transition hover:border-tier-1/60 hover:shadow-md"
            >
              <div className="flex items-start gap-4">
                <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-lg bg-tier-1 text-white font-bold text-lg">
                  T1
                </div>
                <div>
                  <h3 className="text-lg font-bold text-tier-1 group-hover:underline">
                    Authoritative Guidance
                  </h3>
                  <p className="mt-1 text-sm text-daf-dark-gray">
                    DoD instructions and directives that mandate metadata
                    standards across the enterprise. These top-level policies
                    drive all subordinate standards adoption.
                  </p>
                  <p className="mt-2 text-xs font-medium text-tier-1">
                    {guidance.length} documents &mdash; DoDI 8320.02, 8320.07,
                    8310.01, 8330.01 and more
                  </p>
                </div>
              </div>
            </Link>

            {/* Arrow down */}
            <div className="flex flex-col items-center text-daf-gray">
              <svg className="h-8 w-8" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 4.5v15m0 0l6.75-6.75M12 19.5l-6.75-6.75" />
              </svg>
              <span className="text-xs font-medium">mandates</span>
            </div>

            {/* Tier 2A & 2B side-by-side */}
            <div className="grid w-full max-w-3xl grid-cols-1 gap-3 sm:grid-cols-2">
              <Link
                href="/specs"
                className="group rounded-xl border-2 border-tier-2a/30 bg-tier-2a-bg p-6 shadow-sm transition hover:border-tier-2a/60 hover:shadow-md"
              >
                <div className="flex items-start gap-4">
                  <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-lg bg-tier-2a text-white font-bold text-sm">
                    T2A
                  </div>
                  <div>
                    <h3 className="text-lg font-bold text-tier-2a group-hover:underline">
                      Technical Specifications
                    </h3>
                    <p className="mt-1 text-sm text-daf-dark-gray">
                      The actual standards &mdash; NIEM, IC-ISM, Dublin Core,
                      DCAT, and more.
                    </p>
                    <p className="mt-2 text-xs font-medium text-tier-2a">
                      {specs.length} specifications
                    </p>
                  </div>
                </div>
              </Link>

              <Link
                href="/profiles"
                className="group rounded-xl border-2 border-tier-2b/30 bg-tier-2b-bg p-6 shadow-sm transition hover:border-tier-2b/60 hover:shadow-md"
              >
                <div className="flex items-start gap-4">
                  <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-lg bg-tier-2b text-white font-bold text-sm">
                    T2B
                  </div>
                  <div>
                    <h3 className="text-lg font-bold text-tier-2b group-hover:underline">
                      Domain Profiles
                    </h3>
                    <p className="mt-1 text-sm text-daf-dark-gray">
                      Organization-specific metadata profiles built from Tier 2A
                      specs.
                    </p>
                    <p className="mt-2 text-xs font-medium text-tier-2b">
                      {profiles.length} profiles
                    </p>
                  </div>
                </div>
              </Link>
            </div>

            {/* Arrow between 2A/2B */}
            <div className="flex flex-col items-center text-daf-gray">
              <span className="text-xs font-medium">informs</span>
              <svg className="h-6 w-6 rotate-180" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 4.5v15m0 0l6.75-6.75M12 19.5l-6.75-6.75" />
              </svg>
              <svg className="h-8 w-8" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 4.5v15m0 0l6.75-6.75M12 19.5l-6.75-6.75" />
              </svg>
              <span className="text-xs font-medium">implements</span>
            </div>

            {/* Tier 3 */}
            <Link
              href="/tools"
              className="group w-full max-w-3xl rounded-xl border-2 border-tier-3/30 bg-tier-3-bg p-6 shadow-sm transition hover:border-tier-3/60 hover:shadow-md"
            >
              <div className="flex items-start gap-4">
                <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-lg bg-tier-3 text-white font-bold text-lg">
                  T3
                </div>
                <div>
                  <h3 className="text-lg font-bold text-tier-3 group-hover:underline">
                    Tagging &amp; Labeling Tools
                  </h3>
                  <p className="mt-1 text-sm text-daf-dark-gray">
                    Software tools that apply metadata standards to data assets
                    &mdash; DCAMPS-C, Microsoft Purview, Varonis, Collibra, and more.
                  </p>
                  <p className="mt-2 text-xs font-medium text-tier-3">
                    {tools.length} tools
                  </p>
                </div>
              </div>
            </Link>
          </div>
        </div>
      </section>

      {/* ── Quick Access Cards ────────────────────────────────── */}
      <section className="bg-white py-16">
        <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <h2 className="text-2xl font-bold text-daf-dark-gray sm:text-3xl">
            Browse the Repository
          </h2>
          <p className="mt-2 text-daf-gray">
            Explore metadata standards by category.
          </p>

          <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {/* Guidance Card */}
            <Link
              href="/guidance"
              className="group rounded-lg border border-gray-200 p-6 transition hover:border-tier-1/50 hover:shadow-lg"
            >
              <div className="flex items-center gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-tier-1-bg">
                  <svg className="h-5 w-5 text-tier-1" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25" />
                  </svg>
                </div>
                <div>
                  <h3 className="font-semibold text-daf-dark-gray group-hover:text-tier-1">
                    Authoritative Guidance
                  </h3>
                  <p className="text-sm text-daf-gray">Tier 1</p>
                </div>
              </div>
              <p className="mt-3 text-sm text-daf-dark-gray">
                DoD instructions, directives, and memos that mandate metadata
                standards and data-sharing policies.
              </p>
              <p className="mt-3 text-sm font-semibold text-tier-1">
                {guidance.length} documents &rarr;
              </p>
            </Link>

            {/* Specs Card */}
            <Link
              href="/specs"
              className="group rounded-lg border border-gray-200 p-6 transition hover:border-tier-2a/50 hover:shadow-lg"
            >
              <div className="flex items-center gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-tier-2a-bg">
                  <svg className="h-5 w-5 text-tier-2a" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M17.25 6.75L22.5 12l-5.25 5.25m-10.5 0L1.5 12l5.25-5.25m7.5-3l-4.5 16.5" />
                  </svg>
                </div>
                <div>
                  <h3 className="font-semibold text-daf-dark-gray group-hover:text-tier-2a">
                    Technical Specifications
                  </h3>
                  <p className="text-sm text-daf-gray">Tier 2A</p>
                </div>
              </div>
              <p className="mt-3 text-sm text-daf-dark-gray">
                The actual standards &mdash; NIEM, IC-ISM, IC-EDH, Dublin Core,
                DCAT, DDMS, and ISO 11179.
              </p>
              <p className="mt-3 text-sm font-semibold text-tier-2a">
                {specs.length} specifications &rarr;
              </p>
            </Link>

            {/* Profiles Card */}
            <Link
              href="/profiles"
              className="group rounded-lg border border-gray-200 p-6 transition hover:border-tier-2b/50 hover:shadow-lg"
            >
              <div className="flex items-center gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-tier-2b-bg">
                  <svg className="h-5 w-5 text-tier-2b" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M3.75 21h16.5M4.5 3h15M5.25 3v18m13.5-18v18M9 6.75h1.5m-1.5 3h1.5m-1.5 3h1.5m3-6H15m-1.5 3H15m-1.5 3H15M9 21v-3.375c0-.621.504-1.125 1.125-1.125h3.75c.621 0 1.125.504 1.125 1.125V21" />
                  </svg>
                </div>
                <div>
                  <h3 className="font-semibold text-daf-dark-gray group-hover:text-tier-2b">
                    Domain Profiles
                  </h3>
                  <p className="text-sm text-daf-gray">Tier 2B</p>
                </div>
              </div>
              <p className="mt-3 text-sm text-daf-dark-gray">
                Organization-specific metadata profiles &mdash; ISR, Logistics,
                Space Force C2, AFSOC, Acquisition, and Medical.
              </p>
              <p className="mt-3 text-sm font-semibold text-tier-2b">
                {profiles.length} profiles &rarr;
              </p>
            </Link>

            {/* Tools Card */}
            <Link
              href="/tools"
              className="group rounded-lg border border-gray-200 p-6 transition hover:border-tier-3/50 hover:shadow-lg"
            >
              <div className="flex items-center gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-tier-3-bg">
                  <svg className="h-5 w-5 text-tier-3" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M11.42 15.17l-5.385 3.17A2.25 2.25 0 013 16.236V7.764a2.25 2.25 0 013.035-2.104l5.385 3.17m0 6.34l5.385 3.17A2.25 2.25 0 0021 16.236V7.764a2.25 2.25 0 00-3.035-2.104l-5.385 3.17m-1.16 0a2.25 2.25 0 000-6.34" />
                  </svg>
                </div>
                <div>
                  <h3 className="font-semibold text-daf-dark-gray group-hover:text-tier-3">
                    Tagging &amp; Labeling Tools
                  </h3>
                  <p className="text-sm text-daf-gray">Tier 3</p>
                </div>
              </div>
              <p className="mt-3 text-sm text-daf-dark-gray">
                Software tools that apply metadata standards to data &mdash;
                DCAMPS-C, Purview, Varonis, Collibra, and more.
              </p>
              <p className="mt-3 text-sm font-semibold text-tier-3">
                {tools.length} tools &rarr;
              </p>
            </Link>

            {/* API Explorer Card */}
            <Link
              href="/api-explorer"
              className="group rounded-lg border border-gray-200 p-6 transition hover:border-daf-light-blue/50 hover:shadow-lg"
            >
              <div className="flex items-center gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-50">
                  <svg className="h-5 w-5 text-daf-light-blue" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M6.75 7.5l3 2.25-3 2.25m4.5 0h3m-9 8.25h13.5A2.25 2.25 0 0021 18V6a2.25 2.25 0 00-2.25-2.25H5.25A2.25 2.25 0 003 6v12a2.25 2.25 0 002.25 2.25z" />
                  </svg>
                </div>
                <div>
                  <h3 className="font-semibold text-daf-dark-gray group-hover:text-daf-light-blue">
                    API Explorer
                  </h3>
                  <p className="text-sm text-daf-gray">Concept Demo</p>
                </div>
              </div>
              <p className="mt-3 text-sm text-daf-dark-gray">
                Interactive demo showing how a REST API could expose the
                repository programmatically for system-to-system integration.
              </p>
              <p className="mt-3 text-sm font-semibold text-daf-light-blue">
                Try it out &rarr;
              </p>
            </Link>
          </div>
        </div>
      </section>

      {/* ── Hosting Model Callout ─────────────────────────────── */}
      <section className="py-16">
        <div className="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8">
          <div className="rounded-xl border border-gray-200 bg-white p-8 shadow-sm">
            <h2 className="text-xl font-bold text-daf-dark-gray">
              Dual Hosting Model
            </h2>
            <p className="mt-2 text-sm text-daf-gray">
              Artifacts in this repository use one of two hosting approaches,
              indicated by a badge on each item.
            </p>

            <div className="mt-6 grid gap-6 sm:grid-cols-2">
              <div className="rounded-lg border border-blue-200 bg-blue-50/50 p-5">
                <div className="mb-3">
                  <HostingBadge type="stored" />
                </div>
                <h3 className="font-semibold text-daf-dark-gray">
                  Stored Artifacts
                </h3>
                <p className="mt-1 text-sm text-daf-dark-gray">
                  Full content is maintained directly within this repository.
                  Includes detailed element listings, summaries, and version
                  history. Ideal for standards the DAF actively manages.
                </p>
              </div>

              <div className="rounded-lg border border-amber-200 bg-amber-50/50 p-5">
                <div className="mb-3">
                  <HostingBadge type="linked" />
                </div>
                <h3 className="font-semibold text-daf-dark-gray">
                  Linked Artifacts
                </h3>
                <p className="mt-1 text-sm text-daf-dark-gray">
                  A pointer to the authoritative external source. The repository
                  stores metadata about the artifact but links to the canonical
                  URL for full content. Used for externally managed standards.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ── Footer Tagline ────────────────────────────────────── */}
      <section className="border-t border-gray-200 bg-white py-8">
        <div className="mx-auto max-w-7xl px-4 text-center sm:px-6 lg:px-8">
          <p className="text-sm text-daf-gray">
            DAF Metadata Repository &mdash; Prototype for leadership
            demonstration purposes. Not an official DoD system.
          </p>
        </div>
      </section>
    </div>
  );
}
