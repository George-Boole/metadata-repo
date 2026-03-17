"use client";

import { useEffect, useState, useRef } from "react";

interface EntityResult {
  name: string;
  type: string;
}

const TYPE_COLORS: Record<string, string> = {
  Standard: "#3b82f6",
  Guidance: "#ef4444",
  Tool: "#f59e0b",
  Profile: "#8b5cf6",
  Ontology: "#10b981",
  Organization: "#6366f1",
  Entity: "#9ca3af",
};

interface EntityAutocompleteProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  label?: string;
}

export default function EntityAutocomplete({
  value,
  onChange,
  placeholder,
  label,
}: EntityAutocompleteProps) {
  const [suggestions, setSuggestions] = useState<EntityResult[]>([]);
  const [showDropdown, setShowDropdown] = useState(false);
  const [loading, setLoading] = useState(false);
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const containerRef = useRef<HTMLDivElement>(null);

  // Fetch suggestions on input change
  useEffect(() => {
    if (debounceRef.current) clearTimeout(debounceRef.current);

    if (value.trim().length < 2) {
      setSuggestions([]);
      setShowDropdown(false);
      return;
    }

    debounceRef.current = setTimeout(async () => {
      setLoading(true);
      try {
        const res = await fetch(`/api/graph/entities?q=${encodeURIComponent(value.trim())}`);
        if (res.ok) {
          const data = await res.json();
          setSuggestions(data.entities || []);
          setShowDropdown(data.entities?.length > 0);
        }
      } catch {
        // Silently fail
      } finally {
        setLoading(false);
      }
    }, 250);

    return () => {
      if (debounceRef.current) clearTimeout(debounceRef.current);
    };
  }, [value]);

  // Close dropdown on outside click
  useEffect(() => {
    function handleClick(e: MouseEvent) {
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) {
        setShowDropdown(false);
      }
    }
    document.addEventListener("mousedown", handleClick);
    return () => document.removeEventListener("mousedown", handleClick);
  }, []);

  function selectEntity(name: string) {
    onChange(name);
    setShowDropdown(false);
  }

  return (
    <div ref={containerRef} className="relative">
      {label && (
        <label className="block text-sm font-medium text-gray-700 mb-1">{label}</label>
      )}
      <div className="relative">
        <input
          type="text"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          onFocus={() => suggestions.length > 0 && setShowDropdown(true)}
          placeholder={placeholder}
          className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-blue-500 focus:outline-none"
        />
        {loading && (
          <div className="absolute right-2 top-1/2 -translate-y-1/2">
            <div className="h-4 w-4 animate-spin rounded-full border-2 border-gray-300 border-t-blue-500" />
          </div>
        )}
      </div>

      {showDropdown && suggestions.length > 0 && (
        <div className="absolute z-50 mt-1 w-full rounded-md border border-gray-200 bg-white shadow-lg max-h-60 overflow-y-auto">
          {suggestions.map((entity, i) => (
            <button
              key={`${entity.name}-${i}`}
              onClick={() => selectEntity(entity.name)}
              className="flex items-center gap-2 w-full px-3 py-2 text-sm text-left hover:bg-gray-50 border-b border-gray-100 last:border-0"
            >
              <span
                className="h-2 w-2 rounded-full shrink-0"
                style={{ backgroundColor: TYPE_COLORS[entity.type] || TYPE_COLORS.Entity }}
              />
              <span className="truncate font-medium text-gray-800">{entity.name}</span>
              <span className="shrink-0 text-xs text-gray-400">{entity.type}</span>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
