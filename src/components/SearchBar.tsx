"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

interface SearchBarProps {
  /** Controlled value (optional — if omitted, component manages its own state) */
  value?: string;
  onChange?: (value: string) => void;
  onSubmit?: (query: string) => void;
  placeholder?: string;
  /** When true, navigates to /search?q= on submit instead of calling onSubmit */
  navigateOnSubmit?: boolean;
  className?: string;
}

export default function SearchBar({
  value: controlledValue,
  onChange,
  onSubmit,
  placeholder = "Search all metadata standards...",
  navigateOnSubmit = false,
  className = "",
}: SearchBarProps) {
  const router = useRouter();
  const [internalValue, setInternalValue] = useState("");
  const value = controlledValue ?? internalValue;

  function handleChange(newVal: string) {
    if (onChange) onChange(newVal);
    else setInternalValue(newVal);
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    const q = value.trim();
    if (!q) return;
    if (navigateOnSubmit) {
      router.push(`/search?q=${encodeURIComponent(q)}`);
    }
    onSubmit?.(q);
  }

  function handleClear() {
    handleChange("");
  }

  return (
    <form onSubmit={handleSubmit} className={`relative ${className}`}>
      {/* Search Icon */}
      <svg
        className="absolute left-3 top-1/2 h-5 w-5 -translate-y-1/2 text-gray-400"
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
        value={value}
        onChange={(e) => handleChange(e.target.value)}
        placeholder={placeholder}
        className="w-full rounded-lg border border-gray-300 bg-white py-2.5 pl-10 pr-10 text-sm text-gray-900 placeholder-gray-400 shadow-sm focus:border-daf-light-blue focus:outline-none focus:ring-1 focus:ring-daf-light-blue"
      />

      {/* Clear Button */}
      {value && (
        <button
          type="button"
          onClick={handleClear}
          className="absolute right-3 top-1/2 -translate-y-1/2 rounded p-0.5 text-gray-400 hover:text-gray-600"
          aria-label="Clear search"
        >
          <svg
            className="h-4 w-4"
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={2}
            stroke="currentColor"
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      )}
    </form>
  );
}
