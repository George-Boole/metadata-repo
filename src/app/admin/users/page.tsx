"use client";

import { useEffect, useState } from "react";

interface User {
  id: string;
  username: string;
  role: string;
  display_name: string | null;
  created_at: string;
}

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [showAdd, setShowAdd] = useState(false);
  const [newUsername, setNewUsername] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [newDisplayName, setNewDisplayName] = useState("");
  const [newRole, setNewRole] = useState<"user" | "admin">("user");
  const [submitting, setSubmitting] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editDisplayName, setEditDisplayName] = useState("");
  const [editRole, setEditRole] = useState<"user" | "admin">("user");
  const [editPassword, setEditPassword] = useState("");
  const [editSubmitting, setEditSubmitting] = useState(false);

  async function loadUsers() {
    const res = await fetch("/api/admin/users");
    const data = await res.json();
    setUsers(data.users || []);
    setLoading(false);
  }

  useEffect(() => {
    loadUsers();
  }, []);

  async function handleAdd(e: React.FormEvent) {
    e.preventDefault();
    setSubmitting(true);
    setMessage(null);

    try {
      const res = await fetch("/api/admin/users", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          username: newUsername,
          password: newPassword,
          display_name: newDisplayName || undefined,
          role: newRole,
        }),
      });

      const data = await res.json();
      if (res.ok) {
        setMessage(`User "${newUsername}" created`);
        setNewUsername("");
        setNewPassword("");
        setNewDisplayName("");
        setNewRole("user");
        loadUsers();
      } else {
        setMessage(`Error: ${data.error}`);
      }
    } catch (err) {
      setMessage(`Error: ${err}`);
    } finally {
      setSubmitting(false);
    }
  }

  async function handleDelete(id: string, username: string) {
    if (!confirm(`Delete user "${username}"?`)) return;

    const res = await fetch(`/api/admin/users/${id}`, { method: "DELETE" });
    if (res.ok) loadUsers();
  }

  function startEdit(user: User) {
    setEditingId(user.id);
    setEditDisplayName(user.display_name || "");
    setEditRole(user.role as "user" | "admin");
    setEditPassword("");
    setMessage(null);
  }

  function cancelEdit() {
    setEditingId(null);
    setEditPassword("");
  }

  async function handleEdit(e: React.FormEvent, userId: string) {
    e.preventDefault();
    setEditSubmitting(true);
    setMessage(null);

    try {
      const body: Record<string, string> = {
        display_name: editDisplayName,
        role: editRole,
      };
      if (editPassword) body.password = editPassword;

      const res = await fetch(`/api/admin/users/${userId}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });

      const data = await res.json();
      if (res.ok) {
        setMessage("User updated");
        setEditingId(null);
        setEditPassword("");
        loadUsers();
      } else {
        setMessage(`Error: ${data.error}`);
      }
    } catch (err) {
      setMessage(`Error: ${err}`);
    } finally {
      setEditSubmitting(false);
    }
  }

  return (
    <div className="space-y-6">
      {/* Info Banner */}
      <div className="rounded-lg border border-blue-200 bg-blue-50 p-4 text-sm text-blue-800">
        Users created here can log in with their username and password.
        The shared site password always grants admin access.
      </div>

      {message && (
        <div
          className={`rounded-lg border p-3 text-sm ${
            message.startsWith("Error")
              ? "border-red-200 bg-red-50 text-red-700"
              : "border-green-200 bg-green-50 text-green-700"
          }`}
        >
          {message}
        </div>
      )}

      {/* Add User Form */}
      <div className="rounded-lg border border-gray-200 bg-white shadow-sm">
        <button
          onClick={() => setShowAdd(!showAdd)}
          className="flex w-full items-center justify-between p-4 text-left"
        >
          <span className="font-medium text-daf-dark-gray">Add User</span>
          <svg
            className={`h-5 w-5 text-gray-400 transition ${showAdd ? "rotate-180" : ""}`}
            fill="none"
            viewBox="0 0 24 24"
            strokeWidth={2}
            stroke="currentColor"
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
          </svg>
        </button>

        {showAdd && (
          <form onSubmit={handleAdd} className="border-t border-gray-200 p-4 space-y-3">
            <div className="grid gap-3 sm:grid-cols-2">
              <div>
                <label className="block text-sm font-medium text-gray-700">
                  Username
                </label>
                <input
                  type="text"
                  value={newUsername}
                  onChange={(e) => setNewUsername(e.target.value)}
                  placeholder="jsmith"
                  required
                  autoComplete="off"
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">
                  Password
                </label>
                <input
                  type="password"
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  placeholder="Set password"
                  required
                  autoComplete="new-password"
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                />
              </div>
            </div>
            <div className="grid gap-3 sm:grid-cols-2">
              <div>
                <label className="block text-sm font-medium text-gray-700">
                  Display Name{" "}
                  <span className="font-normal text-gray-400">(optional)</span>
                </label>
                <input
                  type="text"
                  value={newDisplayName}
                  onChange={(e) => setNewDisplayName(e.target.value)}
                  placeholder="John Smith"
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">
                  Role
                </label>
                <select
                  value={newRole}
                  onChange={(e) => setNewRole(e.target.value as "user" | "admin")}
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                >
                  <option value="user">User</option>
                  <option value="admin">Admin</option>
                </select>
              </div>
            </div>
            <button
              type="submit"
              disabled={submitting || !newUsername || !newPassword}
              className="rounded-lg bg-daf-navy px-4 py-2 text-sm font-medium text-white hover:bg-daf-blue disabled:opacity-50"
            >
              {submitting ? "Creating..." : "Create User"}
            </button>
          </form>
        )}
      </div>

      {/* Users Table */}
      <div className="rounded-lg border border-gray-200 bg-white shadow-sm overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-gray-400">Loading users...</div>
        ) : users.length === 0 ? (
          <div className="p-8 text-center text-gray-400">
            No users yet. Anyone can log in with the shared site password as
            admin. Add named users above for individual access.
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-left text-xs font-medium uppercase text-gray-500">
                <tr>
                  <th className="px-4 py-3">Username</th>
                  <th className="hidden sm:table-cell px-4 py-3">Display Name</th>
                  <th className="px-4 py-3">Role</th>
                  <th className="hidden sm:table-cell px-4 py-3">Created</th>
                  <th className="px-4 py-3" />
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {users.map((user) => (
                  <tr key={user.id} className="hover:bg-gray-50">
                    {editingId === user.id ? (
                      <td colSpan={5} className="px-4 py-3">
                        <form
                          onSubmit={(e) => handleEdit(e, user.id)}
                          className="space-y-3"
                        >
                          <div className="text-xs font-medium text-gray-500 uppercase mb-2">
                            Editing: {user.username}
                          </div>
                          <div className="grid gap-3 sm:grid-cols-3">
                            <div>
                              <label className="block text-xs font-medium text-gray-600">
                                Display Name
                              </label>
                              <input
                                type="text"
                                value={editDisplayName}
                                onChange={(e) => setEditDisplayName(e.target.value)}
                                placeholder="Display name"
                                className="mt-1 w-full rounded border border-gray-300 px-2 py-1.5 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                              />
                            </div>
                            <div>
                              <label className="block text-xs font-medium text-gray-600">
                                Role
                              </label>
                              <select
                                value={editRole}
                                onChange={(e) =>
                                  setEditRole(e.target.value as "user" | "admin")
                                }
                                className="mt-1 w-full rounded border border-gray-300 px-2 py-1.5 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                              >
                                <option value="user">User</option>
                                <option value="admin">Admin</option>
                              </select>
                            </div>
                            <div>
                              <label className="block text-xs font-medium text-gray-600">
                                New Password{" "}
                                <span className="font-normal text-gray-400">
                                  (leave blank to keep)
                                </span>
                              </label>
                              <input
                                type="password"
                                value={editPassword}
                                onChange={(e) => setEditPassword(e.target.value)}
                                placeholder="New password"
                                autoComplete="new-password"
                                className="mt-1 w-full rounded border border-gray-300 px-2 py-1.5 text-sm focus:border-daf-blue focus:outline-none focus:ring-1 focus:ring-daf-blue"
                              />
                            </div>
                          </div>
                          <div className="flex gap-2">
                            <button
                              type="submit"
                              disabled={editSubmitting}
                              className="rounded bg-daf-navy px-3 py-1.5 text-xs font-medium text-white hover:bg-daf-blue disabled:opacity-50"
                            >
                              {editSubmitting ? "Saving..." : "Save"}
                            </button>
                            <button
                              type="button"
                              onClick={cancelEdit}
                              className="rounded border border-gray-300 px-3 py-1.5 text-xs font-medium text-gray-600 hover:bg-gray-50"
                            >
                              Cancel
                            </button>
                          </div>
                        </form>
                      </td>
                    ) : (
                      <>
                        <td className="px-4 py-3 font-medium text-daf-dark-gray whitespace-nowrap">
                          {user.username}
                        </td>
                        <td className="hidden sm:table-cell px-4 py-3 text-gray-500">
                          {user.display_name || "\u2014"}
                        </td>
                        <td className="px-4 py-3">
                          <span
                            className={`rounded-full px-2 py-0.5 text-xs font-medium whitespace-nowrap ${
                              user.role === "admin"
                                ? "bg-purple-100 text-purple-700"
                                : "bg-gray-100 text-gray-600"
                            }`}
                          >
                            {user.role}
                          </span>
                        </td>
                        <td className="hidden sm:table-cell px-4 py-3 text-gray-400 text-xs whitespace-nowrap">
                          {new Date(user.created_at).toLocaleDateString()}
                        </td>
                        <td className="px-4 py-3 text-right whitespace-nowrap">
                          <button
                            onClick={() => startEdit(user)}
                            className="text-xs text-daf-blue hover:text-daf-navy mr-3"
                          >
                            Edit
                          </button>
                          <button
                            onClick={() => handleDelete(user.id, user.username)}
                            className="text-xs text-red-500 hover:text-red-700"
                          >
                            Delete
                          </button>
                        </td>
                      </>
                    )}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
