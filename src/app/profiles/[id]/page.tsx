import { notFound } from "next/navigation";
import Link from "next/link";
import { getProfiles, getProfileById } from "@/lib/data";
import { StatusBadge, HostingBadge, TierBadge } from "@/components/Badge";

export function generateStaticParams() {
  return getProfiles().map((p) => ({ id: p.id }));
}

/** Colors for spec element chips — cycles through a palette */
const SPEC_COLORS = [
  "bg-blue-100 text-blue-800",
  "bg-emerald-100 text-emerald-800",
  "bg-amber-100 text-amber-800",
  "bg-purple-100 text-purple-800",
  "bg-rose-100 text-rose-800",
  "bg-cyan-100 text-cyan-800",
];

export default async function ProfileDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const profile = getProfileById(id);
  if (!profile) notFound();

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <Link href="/profiles" className="hover:text-daf-light-blue">
          Profiles
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">{profile.title}</span>
      </nav>

      {/* Back link */}
      <Link
        href="/profiles"
        className="mb-6 inline-flex items-center gap-1 text-sm text-daf-light-blue hover:text-daf-blue"
      >
        <svg
          className="h-4 w-4"
          fill="none"
          viewBox="0 0 24 24"
          strokeWidth={2}
          stroke="currentColor"
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            d="M15.75 19.5L8.25 12l7.5-7.5"
          />
        </svg>
        Back to Profiles
      </Link>

      {/* Header Card */}
      <div className="mt-4 rounded-lg border border-gray-200 border-l-4 border-l-tier-2b bg-white p-6 shadow-sm">
        <div className="flex flex-wrap items-start justify-between gap-3 mb-4">
          <h1 className="text-2xl font-bold text-daf-dark-gray">
            {profile.title}
          </h1>
          <div className="flex items-center gap-2">
            <StatusBadge status={profile.status} />
            <HostingBadge type={profile.hostingType} />
          </div>
        </div>

        <div className="mb-6">
          <TierBadge tier="2B" />
        </div>

        {/* Metadata Grid */}
        <dl className="grid grid-cols-1 gap-4 sm:grid-cols-3 mb-6">
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Owning Organization
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray">
              {profile.owningOrganization}
            </dd>
          </div>
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Domain
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray">
              {profile.domain}
            </dd>
          </div>
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Version
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray">
              v{profile.version}
            </dd>
          </div>
        </dl>

        {/* Description */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
            Description
          </h2>
          <p className="text-gray-700 leading-relaxed">{profile.description}</p>
        </div>

        {/* Keywords */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
            Keywords
          </h2>
          <div className="flex flex-wrap gap-2">
            {profile.keywords.map((kw) => (
              <span
                key={kw}
                className="rounded-full bg-tier-2b-bg px-3 py-1 text-xs font-medium text-tier-2b"
              >
                {kw}
              </span>
            ))}
          </div>
        </div>

        {/* External Link */}
        {profile.hostingType === "linked" && profile.externalUrl && (
          <a
            href={profile.externalUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 rounded-lg bg-daf-blue px-5 py-2.5 text-sm font-medium text-white shadow-sm hover:bg-daf-navy transition-colors"
          >
            <svg
              className="h-4 w-4"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth={2}
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"
              />
            </svg>
            View Original Document
          </a>
        )}
      </div>

      {/* Incorporated Specifications */}
      {profile.incorporatedSpecs.length > 0 && (
        <div className="mt-8">
          <h2 className="text-lg font-bold text-daf-dark-gray mb-4">
            Incorporated Specifications
          </h2>
          <div className="grid gap-4">
            {profile.incorporatedSpecs.map((inc, idx) => (
              <div
                key={inc.specId}
                className="rounded-lg border border-gray-200 border-l-4 border-l-tier-2a bg-white p-5 shadow-sm"
              >
                <div className="flex items-center justify-between mb-3">
                  <Link
                    href={`/specs/${inc.specId}`}
                    className="text-base font-semibold text-daf-dark-gray hover:text-daf-light-blue transition-colors"
                  >
                    {inc.specName}
                    <svg
                      className="ml-1 inline h-4 w-4"
                      fill="none"
                      viewBox="0 0 24 24"
                      strokeWidth={2}
                      stroke="currentColor"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        d="M8.25 4.5l7.5 7.5-7.5 7.5"
                      />
                    </svg>
                  </Link>
                </div>
                <div className="flex flex-wrap gap-2">
                  {inc.elementsUsed.map((el) => (
                    <span
                      key={el}
                      className={`rounded-full px-3 py-1 text-xs font-medium ${SPEC_COLORS[idx % SPEC_COLORS.length]}`}
                    >
                      {el}
                    </span>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
