import Link from "next/link";
import { notFound } from "next/navigation";
import {
  getSpecs,
  getSpecById,
  getRelatedGuidance,
  getRelatedProfiles,
  getToolsForSpec,
  getSubSpecs,
} from "@/lib/data";
import { TierBadge, HostingBadge, StatusBadge } from "@/components/Badge";

export function generateStaticParams() {
  return getSpecs().map((s) => ({ id: s.id }));
}

export default async function SpecDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const spec = getSpecById(id);
  if (!spec) notFound();

  const relatedGuidance = getRelatedGuidance(id);
  const relatedProfiles = getRelatedProfiles(id);
  const supportingTools = getToolsForSpec(id);
  const subSpecs = getSubSpecs(id);
  const parentSpec = spec.parentSpecId
    ? getSpecById(spec.parentSpecId)
    : undefined;

  return (
    <div>
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <Link href="/specs" className="hover:text-daf-light-blue">
          Specifications
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray">{spec.title}</span>
      </nav>

      {/* Header */}
      <div className="mb-8 rounded-lg border border-gray-200 border-l-4 border-l-tier-2a bg-white p-6 shadow-sm">
        <div className="flex flex-wrap items-start justify-between gap-3 mb-4">
          <h1 className="text-2xl font-bold text-daf-dark-gray">
            {spec.title}
          </h1>
          <div className="flex items-center gap-2">
            <StatusBadge status={spec.status} />
            <HostingBadge type={spec.hostingType} />
          </div>
        </div>

        <div className="flex flex-wrap items-center gap-3 mb-4">
          <TierBadge tier="2A" />
          <span className="text-sm text-gray-600">
            <span className="font-medium">Version:</span> {spec.version}
          </span>
          <span className="text-sm text-gray-600">
            <span className="font-medium">Organization:</span>{" "}
            {spec.managingOrganization}
          </span>
          <span className="text-sm text-gray-600">
            <span className="font-medium">Category:</span> {spec.category}
          </span>
        </div>

        {parentSpec && (
          <p className="text-sm text-gray-500 mb-4">
            Sub-specification of{" "}
            <Link
              href={`/specs/${parentSpec.id}`}
              className="font-medium text-tier-2a hover:underline"
            >
              {parentSpec.title}
            </Link>
          </p>
        )}

        <p className="text-gray-700 leading-relaxed">{spec.description}</p>

        {/* External link for linked specs */}
        {spec.hostingType === "linked" && spec.externalUrl && (
          <a
            href={spec.externalUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="mt-4 inline-flex items-center gap-2 rounded-lg bg-tier-2a px-4 py-2 text-sm font-medium text-white hover:bg-tier-2a/90"
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
            View at Source
          </a>
        )}
      </div>

      {/* Elements */}
      {spec.elements && spec.elements.length > 0 && (
        <section className="mb-8">
          <h2 className="text-lg font-semibold text-daf-dark-gray mb-3">
            Key Elements
          </h2>
          <div className="flex flex-wrap gap-2">
            {spec.elements.map((el) => (
              <span
                key={el}
                className="rounded-full bg-tier-2a-bg px-3 py-1 text-sm font-medium text-tier-2a"
              >
                {el}
              </span>
            ))}
          </div>
        </section>
      )}

      {/* Sub-specs */}
      {subSpecs.length > 0 && (
        <section className="mb-8">
          <h2 className="text-lg font-semibold text-daf-dark-gray mb-3">
            Sub-specifications
          </h2>
          <div className="space-y-2">
            {subSpecs.map((sub) => (
              <Link
                key={sub.id}
                href={`/specs/${sub.id}`}
                className="flex items-center justify-between rounded-lg border border-gray-200 bg-white p-4 shadow-sm hover:shadow-md"
              >
                <div>
                  <h3 className="font-medium text-daf-dark-gray">
                    {sub.title}
                  </h3>
                  <p className="text-sm text-gray-500 line-clamp-1">
                    {sub.description}
                  </p>
                </div>
                <div className="flex items-center gap-2 ml-4 shrink-0">
                  <span className="text-xs text-gray-400">v{sub.version}</span>
                  <HostingBadge type={sub.hostingType} />
                </div>
              </Link>
            ))}
          </div>
        </section>
      )}

      {/* Related Guidance */}
      {relatedGuidance.length > 0 && (
        <section className="mb-8">
          <h2 className="text-lg font-semibold text-daf-dark-gray mb-3">
            Related Guidance
          </h2>
          <div className="space-y-2">
            {relatedGuidance.map((g) => (
              <Link
                key={g.id}
                href={`/guidance/${g.id}`}
                className="flex items-center justify-between rounded-lg border border-gray-200 border-l-4 border-l-tier-1 bg-white p-4 shadow-sm hover:shadow-md"
              >
                <div>
                  <h3 className="font-medium text-daf-dark-gray">{g.title}</h3>
                  <p className="text-sm text-gray-500">
                    {g.documentNumber} — {g.issuingAuthority}
                  </p>
                </div>
                <StatusBadge status={g.status} />
              </Link>
            ))}
          </div>
        </section>
      )}

      {/* Domain Profiles Using This Spec */}
      {relatedProfiles.length > 0 && (
        <section className="mb-8">
          <h2 className="text-lg font-semibold text-daf-dark-gray mb-3">
            Domain Profiles Using This Spec
          </h2>
          <div className="space-y-2">
            {relatedProfiles.map((p) => (
              <Link
                key={p.id}
                href={`/profiles/${p.id}`}
                className="flex items-center justify-between rounded-lg border border-gray-200 border-l-4 border-l-tier-2b bg-white p-4 shadow-sm hover:shadow-md"
              >
                <div>
                  <h3 className="font-medium text-daf-dark-gray">{p.title}</h3>
                  <p className="text-sm text-gray-500">
                    {p.owningOrganization} — {p.domain}
                  </p>
                </div>
                <StatusBadge status={p.status} />
              </Link>
            ))}
          </div>
        </section>
      )}

      {/* Tools Supporting This Spec */}
      {supportingTools.length > 0 && (
        <section className="mb-8">
          <h2 className="text-lg font-semibold text-daf-dark-gray mb-3">
            Tools Supporting This Spec
          </h2>
          <div className="space-y-2">
            {supportingTools.map((t) => (
              <Link
                key={t.id}
                href={`/tools/${t.id}`}
                className="flex items-center justify-between rounded-lg border border-gray-200 border-l-4 border-l-tier-3 bg-white p-4 shadow-sm hover:shadow-md"
              >
                <div>
                  <h3 className="font-medium text-daf-dark-gray">{t.title}</h3>
                  <p className="text-sm text-gray-500">
                    {t.vendor} — {t.licenseType}
                  </p>
                </div>
                <StatusBadge status={t.status} />
              </Link>
            ))}
          </div>
        </section>
      )}

      {/* Keywords */}
      {spec.keywords.length > 0 && (
        <section>
          <h2 className="text-lg font-semibold text-daf-dark-gray mb-3">
            Keywords
          </h2>
          <div className="flex flex-wrap gap-2">
            {spec.keywords.map((kw) => (
              <span
                key={kw}
                className="rounded-full bg-gray-100 px-3 py-1 text-xs text-gray-600"
              >
                {kw}
              </span>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}
