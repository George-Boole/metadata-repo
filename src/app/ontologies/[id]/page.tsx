import Link from "next/link";
import { notFound } from "next/navigation";
import { getOntologies, getOntologyById, getSpecsForOntology } from "@/lib/data";
import { TierBadge, HostingBadge, StatusBadge } from "@/components/Badge";

export function generateStaticParams() {
  return getOntologies().map((o) => ({ id: o.id }));
}

export default async function OntologyDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const ontology = getOntologyById(id);
  if (!ontology) notFound();

  const relatedSpecs = getSpecsForOntology(id);

  return (
    <div>
      {/* Breadcrumb */}
      <nav className="mb-6 text-sm text-gray-500">
        <Link href="/" className="hover:text-daf-light-blue">
          Dashboard
        </Link>
        <span className="mx-2">/</span>
        <Link href="/ontologies" className="hover:text-daf-light-blue">
          Ontologies
        </Link>
        <span className="mx-2">/</span>
        <span className="text-daf-dark-gray">{ontology.title}</span>
      </nav>

      {/* Header */}
      <div className="mb-8 rounded-lg border border-gray-200 border-l-4 border-l-ontology bg-white p-6 shadow-sm">
        <div className="flex flex-wrap items-start justify-between gap-3 mb-4">
          <h1 className="text-2xl font-bold text-daf-dark-gray">
            {ontology.title}
          </h1>
          <div className="flex items-center gap-2">
            <StatusBadge status={ontology.status} />
            <HostingBadge type={ontology.hostingType} />
          </div>
        </div>

        <div className="flex flex-wrap items-center gap-3 mb-4">
          <TierBadge tier="ontology" />
          <span className="text-sm text-gray-600">
            <span className="font-medium">Version:</span> {ontology.version}
          </span>
          <span className="text-sm text-gray-600">
            <span className="font-medium">Organization:</span>{" "}
            {ontology.managingOrganization}
          </span>
          <span className="text-sm text-gray-600">
            <span className="font-medium">Type:</span>{" "}
            {ontology.ontologyType.charAt(0).toUpperCase() + ontology.ontologyType.slice(1)}
          </span>
          {ontology.format && (
            <span className="text-sm text-gray-600">
              <span className="font-medium">Format:</span> {ontology.format}
            </span>
          )}
          {ontology.domain && (
            <span className="text-sm text-gray-600">
              <span className="font-medium">Domain:</span> {ontology.domain}
            </span>
          )}
        </div>

        <p className="text-gray-700 leading-relaxed">{ontology.description}</p>

        {/* External link for linked ontologies */}
        {ontology.hostingType === "linked" && ontology.externalUrl && (
          <a
            href={ontology.externalUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="mt-4 inline-flex items-center gap-2 rounded-lg bg-ontology px-4 py-2 text-sm font-medium text-white hover:bg-ontology/90"
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

      {/* Related Specifications */}
      {relatedSpecs.length > 0 && (
        <section className="mb-8">
          <h2 className="text-lg font-semibold text-daf-dark-gray mb-3">
            Related Specifications
          </h2>
          <div className="space-y-2">
            {relatedSpecs.map((s) => (
              <Link
                key={s.id}
                href={`/specs/${s.id}`}
                className="flex items-center justify-between rounded-lg border border-gray-200 border-l-4 border-l-tier-2a bg-white p-4 shadow-sm hover:shadow-md"
              >
                <div>
                  <h3 className="font-medium text-daf-dark-gray">{s.title}</h3>
                  <p className="text-sm text-gray-500">
                    {s.managingOrganization} &mdash; {s.category}
                  </p>
                </div>
                <StatusBadge status={s.status} />
              </Link>
            ))}
          </div>
        </section>
      )}

      {/* Keywords */}
      {ontology.keywords.length > 0 && (
        <section>
          <h2 className="text-lg font-semibold text-daf-dark-gray mb-3">
            Keywords
          </h2>
          <div className="flex flex-wrap gap-2">
            {ontology.keywords.map((kw) => (
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
