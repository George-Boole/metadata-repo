import Link from "next/link";

export default function NotFound() {
  return (
    <div className="flex min-h-[60vh] items-center justify-center px-4">
      <div className="w-full max-w-md text-center">
        <p className="text-sm font-semibold uppercase tracking-widest text-[#1F8EED]">
          404
        </p>
        <h1 className="mt-2 text-3xl font-bold text-[#003B7B]">
          Page Not Found
        </h1>
        <p className="mt-3 text-sm text-gray-500">
          The page you are looking for does not exist or has been moved.
        </p>

        <div className="mt-8">
          <Link
            href="/"
            className="inline-flex items-center gap-2 rounded-lg bg-[#003B7B] px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-[#00538B]"
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
                d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18"
              />
            </svg>
            Return to Dashboard
          </Link>
        </div>
      </div>
    </div>
  );
}
