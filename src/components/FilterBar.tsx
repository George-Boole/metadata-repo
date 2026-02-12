"use client";

interface FilterOption {
  value: string;
  label: string;
  count?: number;
}

interface FilterBarProps {
  label?: string;
  options: FilterOption[];
  selected: string;
  onChange: (value: string) => void;
}

export default function FilterBar({
  label,
  options,
  selected,
  onChange,
}: FilterBarProps) {
  return (
    <div className="flex flex-wrap items-center gap-2">
      {label && (
        <span className="mr-1 text-sm font-medium text-gray-600">{label}</span>
      )}
      {options.map((opt) => {
        const isActive = selected === opt.value;
        return (
          <button
            key={opt.value}
            onClick={() => onChange(opt.value)}
            className={`rounded-full px-3 py-1 text-sm font-medium transition-colors ${
              isActive
                ? "bg-daf-navy text-white"
                : "bg-white text-gray-600 border border-gray-300 hover:bg-gray-50 hover:text-gray-900"
            }`}
          >
            {opt.label}
            {opt.count !== undefined && (
              <span
                className={`ml-1.5 text-xs ${
                  isActive ? "text-white/70" : "text-gray-400"
                }`}
              >
                ({opt.count})
              </span>
            )}
          </button>
        );
      })}
    </div>
  );
}
