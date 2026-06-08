# Pulse — Current Project State

**Last Updated:** 2026-06-08 03:10
**Session Focus:** Business Portal technical audits (web application, UI layer integration, SurrealDB data flows) and Flutter cross-platform architecture design.

## 🚀 Active Tracks

- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional with real SurrealDB namespace users. Web Storage fallback implemented to bypass Web Crypto crashes on non-secure HTTP. Premium Users screen completed. Categories screen upgraded with curated Material Icons selector, validation, and in-place reloads. Deployed to Saturn.

## ✅ Recently Completed

- **2026-06-08** — **Business Portal Technical Audits & Flutter Architecture Design.** Audited the Nuxt 3 Business Portal web application, the `@dittodatto/ui` shared package integration, and SurrealDB multi-tenant authentication/authorization flows. Formulated a cross-platform system design and Flutter architecture blueprint featuring Riverpod stream providers, responsive layouts, and OpenStreetMap rendering. Stored four comprehensive reports in the artifact directory.

- **2026-06-05** — **Material Icon Picker & Validation in Category Dialog.** Upgraded the Categories screen in [categories_screen.dart](file:///home/solmundur/Projects/DittoDatto/apps/admin/lib/features/categories/categories_screen.dart) with a curated grid selector for Google Material Icons, required-field form validation, async progress indicators during database saves, error boundary display, and smooth in-place pagination reloads. Deployed to Saturn.
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

- **Saved technical audit reports:** [business_portal_audit.md](file:///home/solmundur/.gemini/antigravity/brain/9fdfa47f-3246-4d7a-8336-4a35f57444ee/business_portal_audit.md), [ui_package_audit.md](file:///home/solmundur/.gemini/antigravity/brain/9fdfa47f-3246-4d7a-8336-4a35f57444ee/ui_package_audit.md), [database_flow_design.md](file:///home/solmundur/.gemini/antigravity/brain/9fdfa47f-3246-4d7a-8336-4a35f57444ee/database_flow_design.md), and [flutter_architecture_design.md](file:///home/solmundur/.gemini/antigravity/brain/9fdfa47f-3246-4d7a-8336-4a35f57444ee/flutter_architecture_design.md). _(operational)_
- **PostIt (State Management):** Investigate whether to adopt Riverpod 2.x or BLoC + GetIt for managing Firestore real-time streams in the Flutter app. _(operational)_
- **PostIt (Offline Cache):** Decide on enabling Firestore offline client caching for Web targets or keeping it memory-only. _(operational)_
- **PostIt (Maps Engine):** Determine if we should adopt OpenStreetMap (`flutter_map`) to avoid billing/keys or stick with native Google Maps. _(operational)_

- **Admin Panel deployed:** `http://dittodatto:8002` — Caddy serves from `/srv/dittodatto/admin-panel/web/`, proxies `/rpc` to SurrealDB.
- **Deploy command:** `rsync -avz --delete apps/admin/build/web/ saturn:/srv/dittodatto/admin-panel/web/`
- **SurrealDB root creds:** `dittodatto_root` / stored in Bitwarden
- **Namespace users:** `arnarvalur` and `gurkudrengur` (ROLES OWNER on both `companies` and `users` namespaces). Legacy `arnar`/`hoddi` still exist on server.
- **Database is empty** — no records. Real data created via Admin Panel.
- **Schemas source of truth:** `schemas/` at project root
- **ADR structure:** Platform-wide at `adr/` root, domain-scoped in `adr/{admin-panel,business-portal,marketplace,mercury-engine}/`. Global sequential numbering.
- **bootstrap.surql** — schema and namespace user definitions only. No fabricated data.
- *2026-06-05 - 02:45* — Chosen static curated set of Google Material Icons in the frontend mapped to simple DB keys over a dynamic database-driven icon manager. _(operational)_
- *2026-06-03 - 20:05* — Added Email and Role dropdown editing to Edit User dialog, validating required fields before submitting to `updateUser`. _(operational)_
- *2026-06-01 - 13:38* — Implemented recursive JSON null-remover for database payloads to support strict schema typing of optional nested maps (e.g. social_links) in SurrealDB 3.0. _(operational)_
- *2026-06-01 - 13:21* — Form-filled datetime columns standardized to UTC with explicit Z suffixes to pass type::datetime restrictions in SurrealDB 3.0. _(operational)_
- *2026-06-01 - 00:10* — Restricted back-office Users screen list and role modification options to `customer` and `business` only. _(operational)_
- *2026-06-01 - 00:12* — Bypass Web Crypto secure-context crashes on Web targets by introducing conditional WebStorage fallback using standard window.localStorage under HTTP. _(operational)_
- *2026-06-01 - 00:44* — Sweep null-valued entries from database query maps to satisfy strict none | string constraints on SurrealDB tables. _(operational)_
- *2026-06-01 - 00:47* — Completely remove unused "Company Slug" fields from Add/Edit User dialogue forms to simplify back-office UX. _(operational)_
- *2026-06-01 - 00:49* — Transition list notifier state updates to fetch in-place, preventing full-screen re-render unmounts and animation layout race conditions. _(operational)_

## 📋 Next Session Suggestions

1. 🧠 **Investigate Flutter Architecture Questions** — Review Riverpod vs BLoC options, Web client offline cache configurations, and OSM vs Google Maps.
2. 🧹 **Clean up shared UI CSS duplication** — Resolve `@dittodatto/ui` config issues to prevent CSS variables duplication in the Business Portal.
3. 📦 **Database & Auth Integration** — Review isolated `company_{slug}` databases and cross-namespace string references in staging.
4. 🖥️ **Verify Category CRUD & owner switch** — Verify creating, editing, and deleting categories with the icon picker, and changing company owners atomically on Saturn staging UI.
