# Pulse — Current Project State

**Last Updated:** 2026-06-09 15:04
**Session Focus:** BP scaffold closure + security incident discovery in bin/ scripts.

## 🚀 Active Tracks

- **Admin Panel** (`admin_panel_20260527`) — In-progress. Auth fully functional with real SurrealDB namespace users. Web Storage fallback implemented to bypass Web Crypto crashes on non-secure HTTP. Premium Users screen completed. Categories screen upgraded with curated Material Icons selector, validation, and in-place reloads. Deployed to Saturn. Role management now fully supports administrative roles.

## ✅ Recently Completed

- **2026-06-09** — **Business Portal Scaffold Track COMPLETE.** Phase 3 (Verification & Compilation) passed: `flutter analyze` zero issues, `flutter build web --debug` success, `flutter build apk --debug` success. 22 tests green. Checkpoint: `eadc310`. Track closed.
- **2026-06-08** — **Business Portal RBAC & Tenant Auth Spec.** Clarified that the Business Portal operates on standard direct-to-SurrealDB WebSocket namespace authentication combined with a `business` role guard and tenant routing (`USE DB company_{slug}`). Recorded ADR-0013 to enforce this multi-tenant database isolation.
- **2026-06-08** — **Administrative Roles Support.** Enabled managing all 4 roles in the Admin Panel back-office Users screen. Updated repository and DB healing queries to protect admin/super_admin roles from being overwritten, verified via E2E integration test, and deployed to Saturn.
- **2026-06-08** — **Created Business Portal Scaffold Track.** Structured specifications and implementation plan (`plan.md`) for the first Business Portal development track. Registered the track in `tracks.md`.
- **2026-06-08** — **Business Portal Domain Refinement & PRD.** Completed the /grill session to establish the Business Portal domain, generated the business-portal-prd.md file, and recorded three new ADRs (ADR-0010, ADR-0011, and ADR-0012) governing real-time queries, connection alerts, and edge capabilities. Added StaffCapability to the ubiquitous glossary.
- **2026-06-08** — **Business Portal Technical Audits & Flutter Architecture Design.** Audited the Nuxt 3 Business Portal web application, the `@dittodatto/ui` shared package integration, and SurrealDB multi-tenant authentication/authorization flows. Formulated a cross-platform system design and Flutter architecture blueprint featuring Riverpod stream providers, responsive layouts, and OpenStreetMap rendering. Stored four comprehensive reports in the artifact directory.

- **2026-06-05** — **Material Icon Picker & Validation in Category Dialog.** Upgraded the Categories screen in [categories_screen.dart](file:///home/solmundur/Projects/DittoDatto/apps/admin/lib/features/categories/categories_screen.dart) with a curated grid selector for Google Material Icons, required-field form validation, async progress indicators during database saves, error boundary display, and smooth in-place pagination reloads. Deployed to Saturn.
- **2026-06-03** — **Validated Email & Role Editing in Edit User Dialog.** Restructured the Edit User dialog in [users_screen.dart](file:///home/solmundur/Projects/DittoDatto/apps/admin/lib/features/users/users_screen.dart) to include validated Email and Role fields, successfully saving updates to SurrealDB via `updateUser`.
- **2026-06-03** — **Company owner update synchronization.** Added logic in `SurrealAdminRepository.updateCompany` to atomically update user profiles when a company owner changes (removing old owner slug/memberships and setting new owner credentials).
- **2026-06-03** — **Phone field clearing fallback.** Addressed optional field clearing crash under SurrealDB 3.1 schema typing by mapping null/empty phone updates to `none` via conditional query expressions in `SurrealAdminRepository.updateUser`.
- **2026-06-03** — **Users table layout update.** Replaced duplicated Email column with a dedicated Phone column in `users_screen.dart` to make user contact information directly visible.
- **2026-06-01** — **Recursive null-remover logic.** Developed a deep JSON null-remover in `SurrealAdminRepository` to satisfy strict SurrealDB 3.1 schema constraints against nested null fields (like `social_links`).
- **2026-06-01** — **Staging timezone coercion fix.** Modified timestamp fields in repository transactions to utilize `.toUtc().toIso8601String()`, solving coercion crashes in SurrealDB 3.1.
- **2026-06-01** — **Nested payload verification test.** Created `apps/admin/bin/test_null_remover.dart` and verified recursive null-stripping logic successfully creates companies under staging database limits.
- **2026-06-01** — **Users screen premium redesign.** Redesigned table layout to match mockup (initials badges, subtext email, options menu, truncated IDs). Excluded administrative accounts from back-office lists.
- **2026-06-01** — **Staging Web HTTP Secure Context fix.** Solved browser Web Crypto initialization crashes under non-secure HTTP Origin by introducing conditional compile-time `WebStorage` localStorage fallback.
- **2026-06-01** — **SurrealDB search & manual registration.** Implemented dynamic case-insensitive text search and manual user provisioning in `SurrealAdminRepository`.
- **2026-06-01** — **Verification logging.** Created verification log registry and playbooks under `conductor/tests/admin-panel/verification-log.md`.

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- *2026-06-09 - 15:04* — 🚨 **Security: hardcoded credentials discovered** in `apps/admin/bin/promote_admins.dart`, `test_admin_roles.dart`, and `sync_users.dart`. Created by Gemini 3.5 session `d16cccc8` on 2026-06-08. Commit `64baa3e`. Post-mortem extracted. Needs: repo-wide secrets scan + remediation + review of all code from that session. _(operational)_
- *2026-06-09 - 08:53* — Completed Phase 3 of Business Portal scaffold: `flutter analyze` zero issues, `flutter build web --debug` success (27.3s), `flutter build apk --debug` success (37.7s). 22/22 tests green. Checkpoint: `eadc310`. Track closed. _(operational)_
- *2026-06-09 - 01:15* — Completed Phase 2 of Business Portal scaffold: GoRouter with auth redirect guard (4 tests), LoginScreen with form validation (6 tests), PortalShell with DittoDashboardShell and 7 nav items (5 tests), navigation toggle verification (7 tests). All 22 tests green, zero lint issues. Commits: `78f7c56`, `b8e1b01`, `6f8076a`, `5965b38`, checkpoint `4a24f3f`. _(operational)_
- *2026-06-08 - 20:17* — Manage all roles in Admin UI: Allowed the back-office Users screen to list and edit all 4 roles (customer, business, admin, super_admin) to facilitate platform administration. _(operational)_
- *2026-06-08 - 20:17* — Conditional SurrealQL role protection: Implemented conditional expressions (IF role = "admin" OR role = "super_admin" THEN role ELSE ... END) in repository operations to safeguard administrative accounts. _(operational)_
- *2026-06-08 - 12:25* — Closed interface: Business Portal always requires Login first. Operator onboarding flow prioritizes Establishments setup (outlets configuration) before managing services, staff, and bookings. _(operational)_
- **Saved technical audit reports:** [business_portal_audit.md](file:///home/solmundur/.gemini/antigravity/brain/9fdfa47f-3246-4d7a-8336-4a35f57444ee/business_portal_audit.md), [ui_package_audit.md](file:///home/solmundur/.gemini/antigravity/brain/9fdfa47f-3246-4d7a-8336-4a35f57444ee/ui_package_audit.md), [database_flow_design.md](file:///home/solmundur/.gemini/antigravity/brain/9fdfa47f-3246-4d7a-8336-4a35f57444ee/database_flow_design.md), and [flutter_architecture_design.md](file:///home/solmundur/.gemini/antigravity/brain/9fdfa47f-3246-4d7a-8336-4a35f57444ee/flutter_architecture_design.md). _(operational)_
- **PostIt (State Management):** Investigate whether to adopt Riverpod 2.x or BLoC + GetIt for managing SurrealDB real-time Live Queries in the Flutter app. _(operational)_
- **PostIt (Offline Cache):** Decide on implementing custom local database caching (using Drift/SQLite or Hive) vs direct-only connection. _(operational)_
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
- *2026-06-01 - 13:38* — Implemented recursive JSON null-remover for database payloads to support strict schema typing of optional nested maps (e.g. social_links) in SurrealDB 3.1. _(operational)_
- *2026-06-01 - 13:21* — Form-filled datetime columns standardized to UTC with explicit Z suffixes to pass type::datetime restrictions in SurrealDB 3.1. _(operational)_
- *2026-06-01 - 00:10* — Restricted back-office Users screen list and role modification options to `customer` and `business` only. _(operational)_
- *2026-06-01 - 00:12* — Bypass Web Crypto secure-context crashes on Web targets by introducing conditional WebStorage fallback using standard window.localStorage under HTTP. _(operational)_
- *2026-06-01 - 00:44* — Sweep null-valued entries from database query maps to satisfy strict none | string constraints on SurrealDB tables. _(operational)_
- *2026-06-01 - 00:47* — Completely remove unused "Company Slug" fields from Add/Edit User dialogue forms to simplify back-office UX. _(operational)_
- *2026-06-01 - 00:49* — Transition list notifier state updates to fetch in-place, preventing full-screen re-render unmounts and animation layout race conditions. _(operational)_

## 📋 Next Session Suggestions

1. 🚨 **Security audit: repo-wide secrets scan** — Grep entire repo for hardcoded passwords/creds. Remediate `bin/` scripts. Review blast radius of Gemini 3.5 session `d16cccc8` (commit `64baa3e`).
2. 🧪 **Deploy & Browser-test the Business Portal** — Deploy web build to Saturn and manually verify the login flow + shell navigation in a real browser.
3. 🏗️ **Start Establishments CRUD Track** — Begin the next Business Portal feature track: outlet management (create, edit, list establishments).
4. 🔬 **Resolve open PostIts** — State management (Riverpod vs BLoC), offline caching strategy, maps engine decision.
