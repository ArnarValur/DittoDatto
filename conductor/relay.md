# Relay — Cross-Session Handoff

Timestamped entries for context continuity between sessions.

## 2026-06-03 20:05 — User Email & Role Dialog Restructuring

- **Session:** Restructured Edit User Dialog to support validated email and role field editing, and compiled & deployed to Saturn.
- **Tracks touched:** `admin_panel_20260527`
- **Status:** In progress. Edit User Dialog is fully functional and validated. All tests green.
- **Decisions:** None
- **Next:** Browser-verify owner switch, phone clearing, and email updates on Saturn staging UI.

---

## 2026-06-03 15:40 — Company Owner Update Sync & Optional Phone Clearing

- **Tracks:** `admin_panel_20260527` (in progress)
- Resolved company owner update desynchronization by adding atomic User profile update inside `SurrealAdminRepository.updateCompany` (removing membership from old owner and adding to new owner).
- Resolved optional phone field clearing crash under SurrealDB 3.0 schema typing by mapping null/empty phone updates to `none` via conditional query expressions in `SurrealAdminRepository.updateUser`.
- Replaced duplicated Email column with a dedicated Phone column on the Users table layout in `users_screen.dart`.
- Recompiled and pushed updated release assets to Saturn staging server at `/srv/dittodatto/admin-panel/web/` and restarted Caddy.
- **Decisions:** None
- **Next:** Browser-verify owner switch and phone clearing on Saturn staging.

---

## 2026-06-01 13:40 — Staging Timezone & Recursive Null Coercion Fix

- **Tracks:** `admin_panel_20260527` (in progress)
- Implemented recursive `_removeNullsFromMap` and `_removeNullsFromList` cleaners to strip all deep null values (like optional unpopulated nested maps in `social_links`) before SurrealDB injection.
- Standardized form-filled datetime columns in `surreal_admin_repository.dart` to strictly utilize `.toUtc().toIso8601String()`, solving timezone coercion crashes.
- Created and successfully verified a standalone integration test `apps/admin/bin/test_null_remover.dart` replicating exact layout form payloads with nested nulls against Saturn.
- Recompiled and pushed updated release assets to Saturn staging server at `/srv/dittodatto/admin-panel/web/`.
- **Decisions:** None
- **Next:** Complete cache clearance in browser (Ctrl + F5 or DevTools clear) to bypass old `main.dart.js` cache, and verify manual creation.

---

## 2026-06-01 00:50 — User Dialog Staging NULL Sweep & Safe Transitions

- **Tracks:** `admin_panel_20260527` (in progress)
- Resolved the SurrealDB `Expected none | string but found NULL` crash on manual user creation by filtering null-valued fields (`removeWhere((k, v) => v == null)`) from payload JSON maps, allowing empty fields to correctly evaluate to `none`.
- Completely removed "Company Slug" input fields from both the Add User and Edit User dialog layouts to simplify UX as requested.
- Refactored `UsersNotifier` state transitions to fetch reloads in-place instead of calling `ref.invalidateSelf()`, avoiding full-screen unmount/re-render animations and layout crashes.
- Standardized `_normalizeRecord` in `SurrealAdminRepository` to safely parse list-wrapped database results alongside maps.
- Recompiled and deployed built production web app to Saturn staging server successfully.
- **Decisions:** None
- **Next:** Browser-verify User CRUD creation, editing, role toggling, and deletion on Saturn staging server.

---

## 2026-06-01 00:20 — Users Premium Redesign + Staging Web Crypto Fix

- **Tracks:** `admin_panel_20260527` (in progress)
- Fully redesigned Users screen to match visual mockup (avatar initials, truncated IDs, subtext emails, options PopupMenu).
- Restricted Users list and role management to only `customer` and `business` roles.
- Resolved browser Web Crypto initialization crashes under non-secure HTTP Origin by introducing platform-agnostic WebStorage unencrypted fallback.
- Added dynamic case-insensitive text search and manual user creation dialog.
- Created `conductor/tests/admin-panel/verification-log.md` registry.
- Deployed built production web app to Saturn staging server successfully.
- **Decisions:** ADR-0008 (Admin Panel Users Scope Isolation), ADR-0009 (Web Storage HTTP Fallback)
- **Next:** Browser-verify all other screens (Companies, Categories, Dashboard) on Saturn. Remove legacy staging users.

---

## 2026-05-30 17:44 — Auth infrastructure + persistence

- **Tracks:** `admin_panel_20260527` (in progress)
- Fixed GoRouter recreation bug → single instance with refreshListenable
- Switched AuthNotifier from Notifier to AsyncNotifier (eliminates restore race)
- Added JWT persistence via FlutterSecureStorage (survives page reload, 1h TTL)
- Created namespace users `arnarvalur` and `gurkudrengur` on both namespaces
- Cleaned bootstrap.surql to schema-only
- Tests green (3/3), deployed to Saturn
- **Decisions:** ADR-0007 (admin auth infrastructure)
- **Next:** Browser-verify CRUD screens. Remove legacy `arnar`/`hoddi` namespace users if no longer needed.

---

- **Tracks:** `admin_panel_20260527` (in progress)
- Removed all mock code: MockAdminRepository, MockAuthService, USE_MOCKS flag
- Fixed login autofill: AutofillGroup, autofillHints, finishAutofillContext
- Migrated schemas to `schemas/` at project root (titan→companies, enceladus→users)
- Purged fake seed data from Saturn Hub (all tables empty)
- Built + deployed to Saturn. Login verified working via browser.
- Grilled admin-panel: PRD v1.2, dashboard deprioritized, category model confirmed
- Created ADR subdirectories (admin-panel, business-portal, marketplace, mercury-engine)
- Audited all 6 ADRs — no contradictions with current decisions
- 0 ADRs
- **Next:** Fix auth bug: SurrealDB Dart signin() doesn't throw on bad creds — any email gets past login but queries fail. Test with `arnar@dittodatto.no`/`admin123` first. Then browser-verify CRUD screens, create real records, clean up test file.

---

## 2026-05-30 14:49 — Admin Panel audit + conductor cleanup

- **Tracks:** `admin_panel_20260527` (in progress)
- Full audit: 3 subagents audited auth, CRUD/data layer, SurrealDB infrastructure
- Audit artifact produced with truth table of what's real vs mock vs fiction
- Purged informal language from 8 files
- Trimmed context.md glossary to one-line entries
- Rewrote relay.md to bullet-point facts
- Removed all legacy references from context.md
- Fixed metadata.json description to reflect actual state
- 0 ADRs
- **Next:** User regrilling project context, then Admin Panel implementation

---

## 2026-05-30 13:35 — Conductor standardization + Admin Panel revert

- **Tracks:** `admin_panel_20260527` (in progress)
- Standardized `.agents/workflows/` with templates
- Removed redundant `conductor-init.md` from workspace
- Reverted `metadata.json` status to `in_progress`
- 0 ADRs
- **Next:** `/grill admin-panel` to align scope and verify progress
