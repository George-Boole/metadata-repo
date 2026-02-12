import { notFound } from "next/navigation";
import Link from "next/link";
import { getGuidance, getGuidanceById, getRelatedSpecs } from "@/lib/data";
import { StatusBadge, HostingBadge, TierBadge } from "@/components/Badge";

export function generateStaticParams() {
  return getGuidance().map((doc) => ({ id: doc.id }));
}

export default async function GuidanceDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const doc = getGuidanceById(id);
  if (!doc) notFound();

  const relatedSpecs = getRelatedSpecs(doc.id);

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <Link href="/guidance" className="hover:text-daf-light-blue">
          Guidance
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">{doc.title}</span>
      </nav>

      {/* Back link */}
      <Link
        href="/guidance"
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
        Back to Guidance
      </Link>

      {/* Header Card */}
      <div className="mt-4 rounded-lg border border-gray-200 border-l-4 border-l-tier-1 bg-white p-6 shadow-sm">
        <div className="flex flex-wrap items-start justify-between gap-3 mb-4">
          <div>
            <h1 className="text-2xl font-bold text-daf-dark-gray">
              {doc.title}
            </h1>
            <p className="mt-1 text-lg text-gray-500 font-medium">
              {doc.documentNumber}
            </p>
          </div>
          <div className="flex items-center gap-2">
            <StatusBadge status={doc.status} />
            <HostingBadge type={doc.hostingType} />
          </div>
        </div>

        <div className="mb-6">
          <TierBadge tier="1" />
        </div>

        {/* Metadata Grid */}
        <dl className="grid grid-cols-1 gap-4 sm:grid-cols-3 mb-6">
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Issuing Authority
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray">
              {doc.issuingAuthority}
            </dd>
          </div>
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Issue Date
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray">
              {doc.issueDate}
            </dd>
          </div>
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Hosting
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray capitalize">
              {doc.hostingType}
            </dd>
          </div>
        </dl>

        {/* Description */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
            Description
          </h2>
          <p className="text-gray-700 leading-relaxed">{doc.description}</p>
        </div>

        {/* Summary */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
            Summary
          </h2>
          <p className="text-gray-700 leading-relaxed">{doc.summary}</p>
        </div>

        {/* Keywords */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
            Keywords
          </h2>
          <div className="flex flex-wrap gap-2">
            {doc.keywords.map((kw) => (
              <span
                key={kw}
                className="rounded-full bg-tier-1-bg px-3 py-1 text-xs font-medium text-tier-1"
              >
                {kw}
              </span>
            ))}
          </div>
        </div>

        {/* External Link */}
        {doc.hostingType === "linked" && doc.externalUrl && (
          <a
            href={doc.externalUrl}
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

      {/* Related Technical Specifications */}
      {relatedSpecs.length > 0 && (
        <div className="mt-8">
          <h2 className="text-lg font-bold text-daf-dark-gray mb-4">
            Related Technical Specifications
          </h2>
          <div className="grid gap-3">
            {relatedSpecs.map((spec) => (
              <Link
                key={spec.id}
                href={`/specs/${spec.id}`}
                className="flex items-center justify-between rounded-lg border border-gray-200 border-l-4 border-l-tier-2a bg-white p-4 shadow-sm hover:shadow-md transition-shadow"
              >
                <div>
                  <h3 className="font-semibold text-daf-dark-gray">
                    {spec.title}
                  </h3>
                  <p className="mt-1 text-sm text-gray-500">
                    {spec.category} &middot; v{spec.version} &middot;{" "}
                    {spec.managingOrganization}
                  </p>
                </div>
                <svg
                  className="h-5 w-5 flex-shrink-0 text-gray-400"
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
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
