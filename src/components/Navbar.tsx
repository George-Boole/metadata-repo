"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useState } from "react";

const NAV_LINKS = [
  { href: "/", label: "Dashboard" },
  { href: "/guidance", label: "Guidance" },
  { href: "/specs", label: "Specifications" },
  { href: "/profiles", label: "Profiles" },
  { href: "/tools", label: "Tools" },
  { href: "/api-explorer", label: "API Explorer" },
];

export default function Navbar() {
  const pathname = usePathname();
  const router = useRouter();
  const [searchQuery, setSearchQuery] = useState("");
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  function handleSearchSubmit(e: React.FormEvent) {
    e.preventDefault();
    const q = searchQuery.trim();
    if (q) {
      router.push(`/search?q=${encodeURIComponent(q)}`);
      setSearchQuery("");
    }
  }

  function isActive(href: string) {
    if (href === "/") return pathname === "/";
    return pathname.startsWith(href);
  }

  return (
    <header className="bg-daf-navy text-white shadow-lg">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="flex h-16 items-center justify-between">
          {/* Logo / Title */}
          <Link href="/" className="flex items-center gap-3 shrink-0">
            <div className="flex h-9 w-9 items-center justify-center rounded bg-white/15 text-sm font-bold">
              DAF
            </div>
            <div className="hidden sm:block">
              <div className="text-base font-semibold leading-tight">
                Metadata Repository
              </div>
              <div className="text-xs text-white/60 leading-tight">
                Department of the Air Force
              </div>
            </div>
          </Link>

          {/* Desktop Nav Links */}
          <nav className="hidden lg:flex items-center gap-1">
            {NAV_LINKS.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className={`rounded px-3 py-2 text-sm font-medium transition-colors ${
                  isActive(link.href)
                    ? "bg-white/20 text-white"
                    : "text-white/80 hover:bg-white/10 hover:text-white"
                }`}
              >
                {link.label}
              </Link>
            ))}
          </nav>

          {/* Search + Mobile Menu Button */}
          <div className="flex items-center gap-3">
            {/* Search Form */}
            <form
              onSubmit={handleSearchSubmit}
              className="hidden sm:flex items-center"
            >
              <div className="relative">
                <svg
                  className="absolute left-2.5 top-1/2 h-4 w-4 -translate-y-1/2 text-white/50"
                  fill="none"
                  viewBox="0 0 24 24"
                  strokeWidth={2}
                  stroke="currentColor"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"
                  />
                </svg>
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search standards..."
                  className="w-48 rounded-md border border-white/20 bg-white/10 py-1.5 pl-9 pr-3 text-sm text-white placeholder-white/50 focus:border-white/40 focus:bg-white/15 focus:outline-none"
                />
              </div>
            </form>

            {/* Mobile Menu Toggle */}
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="lg:hidden rounded p-2 text-white/80 hover:bg-white/10 hover:text-white"
              aria-label="Toggle menu"
            >
              <svg
                className="h-5 w-5"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={2}
                stroke="currentColor"
              >
                {mobileMenuOpen ? (
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M6 18L18 6M6 6l12 12"
                  />
                ) : (
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
                  />
                )}
              </svg>
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Menu */}
      {mobileMenuOpen && (
        <div className="border-t border-white/10 lg:hidden">
          <div className="space-y-1 px-4 py-3">
            {NAV_LINKS.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                onClick={() => setMobileMenuOpen(false)}
                className={`block rounded px-3 py-2 text-sm font-medium ${
                  isActive(link.href)
                    ? "bg-white/20 text-white"
                    : "text-white/80 hover:bg-white/10 hover:text-white"
                }`}
              >
                {link.label}
              </Link>
            ))}
            {/* Mobile Search */}
            <form onSubmit={handleSearchSubmit} className="pt-2">
              <div className="relative">
                <svg
                  className="absolute left-2.5 top-1/2 h-4 w-4 -translate-y-1/2 text-white/50"
                  fill="none"
                  viewBox="0 0 24 24"
                  strokeWidth={2}
                  stroke="currentColor"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z"
                  />
                </svg>
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search standards..."
                  className="w-full rounded-md border border-white/20 bg-white/10 py-1.5 pl-9 pr-3 text-sm text-white placeholder-white/50 focus:border-white/40 focus:bg-white/15 focus:outline-none"
                />
              </div>
            </form>
          </div>
        </div>
      )}
    </header>
  );
}
