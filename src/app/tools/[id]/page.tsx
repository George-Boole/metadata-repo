import { notFound } from "next/navigation";
import Link from "next/link";
import { getTools, getToolById, getSpecById } from "@/lib/data";
import { StatusBadge, HostingBadge, TierBadge } from "@/components/Badge";

export function generateStaticParams() {
  return getTools().map((t) => ({ id: t.id }));
}

export default async function ToolDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const tool = getToolById(id);
  if (!tool) notFound();

  const supportedSpecs = tool.supportedSpecIds
    .map((specId) => {
      const spec = getSpecById(specId);
      return spec ? { id: spec.id, title: spec.title } : null;
    })
    .filter((s): s is { id: string; title: string } => s !== null);

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <Link href="/tools" className="hover:text-daf-light-blue">
          Tools
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray font-medium">{tool.title}</span>
      </nav>

      {/* Back link */}
      <Link
        href="/tools"
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
        Back to Tools
      </Link>

      {/* Header Card */}
      <div className="mt-4 rounded-lg border border-gray-200 border-l-4 border-l-tier-3 bg-white p-6 shadow-sm">
        <div className="flex flex-wrap items-start justify-between gap-3 mb-4">
          <h1 className="text-2xl font-bold text-daf-dark-gray">
            {tool.title}
          </h1>
          <div className="flex items-center gap-2">
            <StatusBadge status={tool.status} />
            <HostingBadge type={tool.hostingType} />
          </div>
        </div>

        <div className="mb-6">
          <TierBadge tier="3" />
        </div>

        {/* Metadata Grid */}
        <dl className="grid grid-cols-1 gap-4 sm:grid-cols-3 mb-6">
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Vendor
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray">
              {tool.vendor}
            </dd>
          </div>
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              License Type
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray">
              {tool.licenseType}
            </dd>
          </div>
          <div className="rounded-md bg-gray-50 p-3">
            <dt className="text-xs font-medium uppercase text-gray-500">
              Maturity Level
            </dt>
            <dd className="mt-1 text-sm font-semibold text-daf-dark-gray capitalize">
              {tool.maturityLevel}
            </dd>
          </div>
        </dl>

        {/* Description */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
            Description
          </h2>
          <p className="text-gray-700 leading-relaxed">{tool.description}</p>
        </div>

        {/* Capabilities */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
            Capabilities
          </h2>
          <div className="flex flex-wrap gap-2">
            {tool.capabilities.map((cap) => (
              <span
                key={cap}
                className="rounded-full bg-tier-3-bg px-3 py-1 text-xs font-medium text-tier-3"
              >
                {cap}
              </span>
            ))}
          </div>
        </div>

        {/* Integration Notes */}
        {tool.integrationNotes && (
          <div className="mb-6">
            <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
              Integration Notes
            </h2>
            <p className="text-gray-700 leading-relaxed">
              {tool.integrationNotes}
            </p>
          </div>
        )}

        {/* Keywords */}
        <div className="mb-6">
          <h2 className="text-sm font-semibold uppercase text-gray-500 mb-2">
            Keywords
          </h2>
          <div className="flex flex-wrap gap-2">
            {tool.keywords.map((kw) => (
              <span
                key={kw}
                className="rounded-full bg-tier-3-bg px-3 py-1 text-xs font-medium text-tier-3"
              >
                {kw}
              </span>
            ))}
          </div>
        </div>

        {/* External Link */}
        {tool.hostingType === "linked" && tool.externalUrl && (
          <a
            href={tool.externalUrl}
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
            View Vendor Page
          </a>
        )}
      </div>

      {/* Supported Standards */}
      {supportedSpecs.length > 0 && (
        <div className="mt-8">
          <h2 className="text-lg font-bold text-daf-dark-gray mb-4">
            Supported Standards
          </h2>
          <div className="grid gap-3">
            {supportedSpecs.map((spec) => (
              <Link
                key={spec.id}
                href={`/specs/${spec.id}`}
                className="flex items-center justify-between rounded-lg border border-gray-200 border-l-4 border-l-tier-2a bg-white p-4 shadow-sm hover:shadow-md transition-shadow"
              >
                <h3 className="font-semibold text-daf-dark-gray">
                  {spec.title}
                </h3>
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
