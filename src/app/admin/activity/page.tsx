"use client";

import { useEffect, useState, useCallback } from "react";

interface ActivityEvent {
  id: string;
  username: string;
  action: string;
  path: string | null;
  metadata: Record<string, unknown>;
  created_at: string;
}

interface UserSummary {
  username: string;
  display_name: string | null;
  role: string;
  created_at: string;
  last_login_at: string | null;
  login_count: number;
}

const ACTION_LABELS: Record<string, { label: string; color: string }> = {
  login: { label: "Login", color: "bg-green-100 text-green-800" },
  logout: { label: "Logout", color: "bg-gray-100 text-gray-800" },
  chat: { label: "Chat", color: "bg-blue-100 text-blue-800" },
  search: { label: "Search", color: "bg-purple-100 text-purple-800" },
  ingest_url: { label: "Ingest URL", color: "bg-amber-100 text-amber-800" },
  ingest_upload: { label: "File Upload", color: "bg-amber-100 text-amber-800" },
  admin_create_user: { label: "Create User", color: "bg-indigo-100 text-indigo-800" },
  admin_delete_user: { label: "Delete User", color: "bg-red-100 text-red-800" },
  admin_update_user: { label: "Update User", color: "bg-indigo-100 text-indigo-800" },
  admin_update_settings: { label: "Update Settings", color: "bg-indigo-100 text-indigo-800" },
  admin_delete_source: { label: "Delete Source", color: "bg-red-100 text-red-800" },
};

function formatDate(dateStr: string | null) {
  if (!dateStr) return "Never";
  const d = new Date(dateStr);
  return d.toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

function timeAgo(dateStr: string) {
  const now = Date.now();
  const then = new Date(dateStr).getTime();
  const diff = now - then;
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return "just now";
  if (mins < 60) return `${mins}m ago`;
  const hours = Math.floor(mins / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.floor(hours / 24);
  if (days < 7) return `${days}d ago`;
  return formatDate(dateStr);
}

function ActionBadge({ action }: { action: string }) {
  const info = ACTION_LABELS[action] || { label: action, color: "bg-gray-100 text-gray-800" };
  return (
    <span className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium ${info.color}`}>
      {info.label}
    </span>
  );
}

function MetadataDetail({ metadata }: { metadata: Record<string, unknown> }) {
  const entries = Object.entries(metadata).filter(([, v]) => v !== null && v !== undefined);
  if (entries.length === 0) return null;
  return (
    <span className="text-xs text-gray-400 ml-2">
      {entries.map(([k, v]) => `${k}: ${typeof v === "string" ? v : JSON.stringify(v)}`).join(", ")}
    </span>
  );
}

export default function AdminActivityPage() {
  const [events, setEvents] = useState<ActivityEvent[]>([]);
  const [users, setUsers] = useState<UserSummary[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [filterUser, setFilterUser] = useState("");
  const [filterAction, setFilterAction] = useState("");
  const [page, setPage] = useState(0);
  const PAGE_SIZE = 50;

  const fetchActivity = useCallback(async () => {
    setLoading(true);
    const params = new URLSearchParams();
    params.set("limit", String(PAGE_SIZE));
    params.set("offset", String(page * PAGE_SIZE));
    if (filterUser) params.set("username", filterUser);
    if (filterAction) params.set("action", filterAction);

    try {
      const res = await fetch(`/api/admin/activity?${params}`);
      const data = await res.json();
      setEvents(data.events || []);
      setTotal(data.total || 0);
      setUsers(data.users || []);
    } catch (err) {
      console.error("Failed to fetch activity:", err);
    } finally {
      setLoading(false);
    }
  }, [filterUser, filterAction, page]);

  useEffect(() => {
    fetchActivity();
  }, [fetchActivity]);

  const uniqueUsers = [...new Set(events.map((e) => e.username))].sort();
  const allActions = Object.keys(ACTION_LABELS);
  const totalPages = Math.ceil(total / PAGE_SIZE);

  return (
    <div className="space-y-6">
      {/* User Summary Cards */}
      <div>
        <h2 className="text-lg font-semibold text-daf-dark-gray mb-3">User Overview</h2>
        <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
          {users.map((u) => (
            <div
              key={u.username}
              className="rounded-lg border border-gray-200 bg-white p-4 shadow-sm"
            >
              <div className="flex items-center justify-between mb-2">
                <span className="font-medium text-daf-dark-gray truncate">
                  {u.display_name || u.username}
                </span>
                <span
                  className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-medium ${
                    u.role === "admin"
                      ? "bg-daf-navy text-white"
                      : "bg-gray-100 text-gray-700"
                  }`}
                >
                  {u.role}
                </span>
              </div>
              <div className="space-y-1 text-xs text-gray-500">
                <div className="flex justify-between">
                  <span>Created</span>
                  <span>{formatDate(u.created_at)}</span>
                </div>
                <div className="flex justify-between">
                  <span>Last Login</span>
                  <span>{formatDate(u.last_login_at)}</span>
                </div>
                <div className="flex justify-between">
                  <span>Login Count</span>
                  <span className="font-medium text-gray-700">{u.login_count ?? 0}</span>
                </div>
              </div>
              {filterUser !== u.username && (
                <button
                  onClick={() => {
                    setFilterUser(u.username);
                    setPage(0);
                  }}
                  className="mt-2 text-xs text-daf-blue hover:underline"
                >
                  View activity
                </button>
              )}
            </div>
          ))}
        </div>
      </div>

      {/* Activity Log */}
      <div>
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-3">
          <h2 className="text-lg font-semibold text-daf-dark-gray">
            Activity Log
            {total > 0 && (
              <span className="ml-2 text-sm font-normal text-gray-400">
                ({total} event{total !== 1 ? "s" : ""})
              </span>
            )}
          </h2>
          <div className="flex gap-2 flex-wrap">
            <select
              value={filterUser}
              onChange={(e) => {
                setFilterUser(e.target.value);
                setPage(0);
              }}
              className="rounded-md border border-gray-300 px-2 py-1 text-sm"
            >
              <option value="">All users</option>
              {uniqueUsers.map((u) => (
                <option key={u} value={u}>
                  {u}
                </option>
              ))}
            </select>
            <select
              value={filterAction}
              onChange={(e) => {
                setFilterAction(e.target.value);
                setPage(0);
              }}
              className="rounded-md border border-gray-300 px-2 py-1 text-sm"
            >
              <option value="">All actions</option>
              {allActions.map((a) => (
                <option key={a} value={a}>
                  {ACTION_LABELS[a].label}
                </option>
              ))}
            </select>
            {(filterUser || filterAction) && (
              <button
                onClick={() => {
                  setFilterUser("");
                  setFilterAction("");
                  setPage(0);
                }}
                className="rounded-md border border-gray-300 px-2 py-1 text-sm text-gray-500 hover:bg-gray-50"
              >
                Clear filters
              </button>
            )}
          </div>
        </div>

        {loading ? (
          <div className="flex items-center justify-center py-12 text-gray-400">
            Loading activity...
          </div>
        ) : events.length === 0 ? (
          <div className="rounded-lg border border-gray-200 bg-white p-8 text-center text-gray-400">
            No activity recorded yet. Events will appear here as users interact with the system.
          </div>
        ) : (
          <>
            <div className="rounded-lg border border-gray-200 bg-white shadow-sm overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b border-gray-100 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      <th className="px-4 py-2">Time</th>
                      <th className="px-4 py-2">User</th>
                      <th className="px-4 py-2">Action</th>
                      <th className="px-4 py-2 hidden sm:table-cell">Details</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-50">
                    {events.map((event) => (
                      <tr key={event.id} className="hover:bg-gray-50/50">
                        <td className="px-4 py-2.5 text-xs text-gray-500 whitespace-nowrap">
                          {timeAgo(event.created_at)}
                        </td>
                        <td className="px-4 py-2.5 font-medium text-gray-700 whitespace-nowrap">
                          {event.username}
                        </td>
                        <td className="px-4 py-2.5 whitespace-nowrap">
                          <ActionBadge action={event.action} />
                        </td>
                        <td className="px-4 py-2.5 text-xs text-gray-500 hidden sm:table-cell">
                          {event.path && (
                            <span className="text-gray-400 mr-1">{event.path}</span>
                          )}
                          <MetadataDetail metadata={event.metadata} />
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="flex items-center justify-between mt-3">
                <span className="text-xs text-gray-500">
                  Page {page + 1} of {totalPages}
                </span>
                <div className="flex gap-2">
                  <button
                    onClick={() => setPage((p) => Math.max(0, p - 1))}
                    disabled={page === 0}
                    className="rounded-md border border-gray-300 px-3 py-1 text-sm disabled:opacity-40 hover:bg-gray-50"
                  >
                    Previous
                  </button>
                  <button
                    onClick={() => setPage((p) => Math.min(totalPages - 1, p + 1))}
                    disabled={page >= totalPages - 1}
                    className="rounded-md border border-gray-300 px-3 py-1 text-sm disabled:opacity-40 hover:bg-gray-50"
                  >
                    Next
                  </button>
                </div>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}
