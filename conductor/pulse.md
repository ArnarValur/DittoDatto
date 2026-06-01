# Pulse — Current Project State

**Last Updated:** 2026-06-01 13:40
**Session Focus:** Admin Panel — Resolved UTC datetime coercion and nested map null-coercion using recursive JSON sanitizers in the SurrealAdminRepository.

## 🚀 Active Tracks

- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional with real SurrealDB namespace users. Web Storage fallback implemented to bypass Web Crypto crashes on non-secure HTTP. Premium Users screen completed (checkbox selections, truncated IDs, initials badges, restricted role promotions, case-insensitive SurrealDB search, manual user registration without company slug fields, and try-catch form validation/loading). Deployed to Saturn.

## ✅ Recently Completed

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
- *2026-06-01 - 13:38* — Implemented recursive JSON null-remover for database payloads to support strict schema typing of optional nested maps (e.g. social_links) in SurrealDB 3.0. _(operational)_
- *2026-06-01 - 13:21* — Form-filled datetime columns standardized to UTC with explicit Z suffixes to pass type::datetime restrictions in SurrealDB 3.0. _(operational)_
- *2026-06-01 - 00:10* — Restricted back-office Users screen list and role modification options to `customer` and `business` only. _(operational)_
- *2026-06-01 - 00:12* — Bypass Web Crypto secure-context crashes on Web targets by introducing conditional WebStorage fallback using standard window.localStorage under HTTP. _(operational)_
- *2026-06-01 - 00:44* — Sweep null-valued entries from database query maps to satisfy strict none | string constraints on SurrealDB tables. _(operational)_
- *2026-06-01 - 00:47* — Completely remove unused "Company Slug" fields from Add/Edit User dialogue forms to simplify back-office UX. _(operational)_
- *2026-06-01 - 00:49* — Transition list notifier state updates to fetch in-place, preventing full-screen re-render unmounts and animation layout race conditions. _(operational)_

## 📋 Next Session Suggestions

1. 🖥️ **Verify Companies screen CRUD on Saturn** — clear browser local data/cache completely (or disable browser cache) and confirm that manual creation works perfectly from the live UI without caching issues.
2. 🖥️ **Add Cache-Busting Headers in Caddyfile** — configure Caddy on Saturn to explicitly prevent aggressive browser caching on `main.dart.js` for development.
3. 🧹 **Remove legacy namespace users** — `arnar` and `hoddi` still exist on Saturn. Delete if no longer needed.
4. 📦 **Inbox real data path** — Message thread repository interface wiring.

