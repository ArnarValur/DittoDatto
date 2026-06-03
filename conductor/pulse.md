# Pulse — Current Project State

**Last Updated:** 2026-06-03 20:12
**Session Focus:** Admin Panel — Upgraded Categories screen with form validation, try-catch database exceptions, pagination, and premium UI styling, compiled & deployed to Saturn.

## 🚀 Active Tracks

- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional with real SurrealDB namespace users. Web Storage fallback implemented to bypass Web Crypto crashes on non-secure HTTP. Premium Users screen and Categories screen completed (form validation, try-catch error banners, pagination, monospace ID display, horizontal scrolling). Deployed to Saturn.

## ✅ Recently Completed

- **2026-06-03** — **Categories screen form validation & pagination.** Upgraded [categories_screen.dart](file:///home/solmundur/Projects/DittoDatto/apps/admin/lib/features/categories/categories_screen.dart) with full client-side Form validation, try-catch database error banner display, horizontal scroll support, a monospace-styled truncated ID column, and a pagination bar. Created [categories_form_test.dart](file:///home/solmundur/Projects/DittoDatto/apps/admin/test/categories_form_test.dart) to verify validation and submission.
- **2026-06-03** — **Validated Email & Role Editing in Edit User Dialog.** Restructured the Edit User dialog in [users_screen.dart](file:///home/solmundur/Projects/DittoDatto/apps/admin/lib/features/users/users_screen.dart) to include validated Email and Role fields, successfully saving updates to SurrealDB via `updateUser`.
- **2026-06-03** — **Company owner update synchronization.** Added logic in `SurrealAdminRepository.updateCompany` to atomically update user profiles when a company owner changes (removing old owner slug/memberships and setting new owner credentials).
- **2026-06-03** — **Phone field clearing fallback.** Addressed optional field clearing crash under SurrealDB 3.0 schema typing by mapping null/empty phone updates to `none` via conditional query expressions in `SurrealAdminRepository.updateUser`.
- **2026-06-03** — **Users table layout update.** Replaced duplicated Email column with a dedicated Phone column in `users_screen.dart` to make user contact information directly visible.
- **2026-06-01** — **Recursive null-remover logic.** Developed a deep JSON null-remover in `SurrealAdminRepository` to satisfy strict SurrealDB 3.0 schema constraints against nested null fields (like `social_links`).
- **2026-06-01** — **Staging timezone coercion fix.** Modified timestamp fields in repository transactions to utilize `.toUtc().toIso8601String()`, solving coercion crashes in SurrealDB 3.0.
- **2026-06-01** — **Nested payload verification test.** Created `apps/admin/bin/test_null_remover.dart` and verified recursive null-stripping logic successfully creates companies under staging database limits.
- **2026-06-01** — **Users screen premium redesign.** Redesigned table layout to match mockup (initials badges, subtext email, options menu, truncated IDs). Excluded administrative accounts from back-office lists.
- **2026-06-01** — **Staging Web HTTP Secure Context fix.** Solved browser Web Crypto initialization crashes under non-secure HTTP Origin by introducing conditional compile-time `WebStorage` localStorage fallback.
- **2026-06-01** — **SurrealDB search & manual registration.** Implemented dynamic case-insensitive text search and manual user provisioning in `SurrealAdminRepository`.
- **2026-06-01** — **Verification logging.** Created verification log registry and playbooks under `conductor/tests/admin-panel/verification-log.md`.

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- **Admin Panel deployed:** `http://dittodatto:8002` — Caddy serves from `/srv/dittodatto/admin-panel/web/`, proxies `/rpc` to SurrealDB.
- **Deploy command:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both `companies` and `users` namespaces). Legacy `arnar`/`hoddi` still exist on server.
- **Database is empty** — no records. Real data created via Admin Panel.
- **Schemas source of truth:** `schemas/` at project root
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`. Global sequential numbering.
- **bootstrap.surql** — schema and namespace user definitions only. No fabricated data.
- *2026-06-03 - 20:05* — Added Email and Role dropdown editing to Edit User dialog, validating required fields before submitting to `updateUser`. _(operational)_
- *2026-06-01 - 13:38* — Implemented recursive JSON null-remover for database payloads to support strict schema typing of optional nested maps (e.g. social_links) in SurrealDB 3.0. _(operational)_
- *2026-06-01 - 13:21* — Form-filled datetime columns standardized to UTC with explicit Z suffixes to pass type::datetime restrictions in SurrealDB 3.0. _(operational)_
- *2026-06-01 - 00:10* — Restricted back-office Users screen list and role modification options to `customer` and `business` only. _(operational)_
- *2026-06-01 - 00:12* — Bypass Web Crypto secure-context crashes on Web targets by introducing conditional WebStorage fallback using standard window.localStorage under HTTP. _(operational)_
- *2026-06-01 - 00:44* — Sweep null-valued entries from database query maps to satisfy strict none | string constraints on SurrealDB tables. _(operational)_
- *2026-06-01 - 00:47* — Completely remove unused "Company Slug" fields from Add/Edit User dialogue forms to simplify back-office UX. _(operational)_
- *2026-06-01 - 00:49* — Transition list notifier state updates to fetch in-place, preventing full-screen re-render unmounts and animation layout race conditions. _(operational)_

## 📋 Next Session Suggestions

1. 🖥️ **Verify owner update and phone clearing** — confirm on the live UI on Saturn that when changing company owner, the User profile is updated atomically, and clearing the phone field works without database errors.
2. 🧹 **Remove legacy namespace users** — `arnar` and `hoddi` still exist on Saturn. Delete if no longer needed.
3. 📦 **Inbox real data path** — Message thread repository interface wiring.
