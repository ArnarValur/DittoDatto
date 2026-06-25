# Relay — Cross-Session Handoff

## 2026-06-25 23:01 — BP Dark Mode: theme toggle on login + sidebar, deployed to Saturn
- **Session:** Added dark mode to Business Portal. Reused Marketplace's `isDarkModeProvider` pattern. Toggle on login screen (top-right icon) + sidebar footer (sun/moon next to logout). `DittoDashboardShell` gained optional `onThemeToggle`/`isDarkMode` (additive, no breaking changes). Defaults to dark. Cherry-picked commit from `track/bp-media-manager` to `develop`. 40 integration tests green. Deployed to Saturn from `develop` branch.
- **Tracks touched:** None (cross-cutting styling, no formal track)
- **Status:** Deployed and user-verified on Saturn at `:8003`.
- **Decisions:** None
- **⚠️ CRITICAL for next session:** (1) Currently on `develop` branch. (2) `track/bp-media-manager` has same dark mode commit (`4f8af50`) + Firebase/media manager code — do NOT deploy that branch to Saturn without Firebase config. (3) BP builds require `--dart-define=BP_PORTAL_PASS=test-portal-pass`.
- **Next:** (1) Grill EstablishmentPage. (2) Marketplace integration tests. (3) Media manager inline integration (on media-manager branch).

## 2026-06-25 20:36 — BP Establishment Page Preview: shared package + preview toggle + Saturn deploy
- **Session:** Created `packages/establishment_ui/` shared package (EstablishmentData model, EstablishmentPage with CustomScrollView + slivers, 4 section widgets). Researched legacy Nuxt EstablishmentPage (9 Vue components) for reference. Added preview toggle (👁️/✏️) to BP AppBar. Context-aware back arrow. 27 + 71 + 32 = 130 tests green. Deployed to Saturn at `/srv/dittodatto/business-portal/web/`. User confirmed preview visible.
- **Tracks touched:** `bp_establishment_preview_20260625`
- **Status:** Phases 1-3 ✅. Phase 4 partial (visual verification done, integration test for preview toggle pending). User wants to `/grill` the page next session.
- **Decisions:** None
- **⚠️ CRITICAL for next session:** (1) BP builds require `--dart-define=BP_PORTAL_PASS=test-portal-pass`. (2) Saturn deploy target: `saturn:/srv/dittodatto/business-portal/web/`. (3) Working on `develop` branch — merge to `main` when satisfied with preview feature.
- **Next:** (1) `/grill` the EstablishmentPage — expand sections, refine layout. (2) Marketplace integration tests. (3) BP feature buildout.

## 2026-06-25 16:12 — PM → Saturn E2E: login verified, APK distribution live, merged to main
- **Session:** Full PM→Saturn E2E session. Fixed Tailscale connectivity (`TAILNET_IP` → `0.0.0.0`). Applied `consumer_auth` schema to Saturn. Fixed Android cleartext + locale init. **User logged in on S21 as super_admin.** Set up APK distribution on `:8005` for Höddi. Merged branch to main, pushed, pruned.
- **Tracks touched:** `marketplace_foundation_20260624`, `auth_service_20260624`
- **Status:** On-device E2E login ✅. APK distribution ✅. Saturn web deploy + integration tests pending.
- **Decisions:** None
- **Next:** (1) Saturn web deploy at `:8004`. (2) Marketplace integration tests. (3) Profile features: change password + delete account. (4) Credential Manager / Vipps (future).

## 2026-06-25 14:44 — BP Establishment: bug fix + integration tests + UX tweaks + deploy
- **Session:** Fixed 3 bugs in establishment creation (NULL→NONE serialization, missing error handling, `is_published` no DEFAULT). Wrote 11 CRUD integration tests (32 total BP integration). Fixed update path. Applied schema fix to Saturn (both company DBs). UX: removed business type from edit view (locked at creation), fixed sidebar highlight for child routes. User verified data persistence via SDB query. 103 total tests green. Deployed to Saturn.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Phase 5 E2E task ✅. Remaining: responsive layout verification, coverage gate.
- **Decisions:** None
- **Next:** (1) BP responsive layout. (2) Marketplace session in parallel. (3) Tailscale connectivity for phone. (4) Apply consumer_auth schema to Saturn.

## 2026-06-25 14:42 — Consumer Auth E2E: schema + cross-role RBAC + on-device + Tailscale connectivity
- **Session:** Defined `consumer_auth` RECORD ACCESS. Wrote 13 integration tests (24 total green). Debugged signup failure (test DB pollution). Discovered cross-role blocker (`AND role = 'customer'`) — user clarified hierarchical RBAC was always intent. Removed role gate from SIGNIN. Deployed to S21 via ADB reverse — user attempted login (failed correctly: test DB ≠ Saturn credentials). Identified Tailscale as connectivity layer for phone → Saturn SDB.
- **Tracks touched:** `auth_service_20260624`, `marketplace_foundation_20260624`
- **Status:** Auth schema complete + cross-role fix. On-device WebSocket path verified. Blocked on Saturn connectivity.
- **Decisions:** None
- **⚠️ CRITICAL for next session:** (1) Saturn's `consumer_auth` schema is OUTDATED — still has `AND role = 'customer'` gate. Must apply updated definition before any Saturn E2E. (2) Tailscale service `dittodatto` exposes tcp:8001-8005 but NOT SurrealDB port 8000. Need to add it or create a DB service. (3) `arnarvalur@avj.info` on Saturn may be NS-level OWNER user only — verify it has a `user` table record with `password_hash` before testing consumer_auth login. (4) Hierarchical RBAC: `super_admin > admin > business > customer` — higher roles include lower capabilities. (5) `username` UNIQUE index on `option<string>` can cause NULL collisions — review in security sweep.
- **Next:** (1) Tailscale: expose SDB port or create DB service. (2) Apply updated schema to Saturn. (3) Real E2E: phone → Saturn → signup/login. (4) Deploy BP + Marketplace to Saturn.

## 2026-06-25 13:44 — Marketplace Foundation: scaffold + consumer auth + on-device deploy + UX fix
- **Session:** Scaffolded `apps/marketplace/` Flutter project. Built 3-tab nav shell with GoRouter StatefulShellRoute. Login/signup/profile screens with Norwegian labels. Consumer auth in `ditto_auth`. Verified Android dev env — Samsung Galaxy S21 connected via ADB, release build deployed. Renamed app to "DittoDatto". Fixed bottom nav bar disappearing on auth screens (moved routes inside Profile branch: `/login` → `/profile/login`).
- **Tracks touched:** `marketplace_foundation_20260624`
- **Status:** Phase 1 ✅, Phase 2 partial (consumer auth code done, `consumer_auth` schema needed), Phase 3 ✅. Phase 4 remaining.
- **Decisions:** None
- **Next:** (1) Define `consumer_auth` RECORD ACCESS on `users/users`. (2) Test signup/login on-device. (3) Deploy BP to Saturn. (4) Marketplace Saturn deploy at :8004. (5) Swap in logo when ready.

## 2026-06-24 19:27 — ditto_auth: Phase 1 design + Phase 2 build + Phase 3 BP migration

- **Session:** Built `ditto_auth` shared auth package (Phases 1-3 of auth service track). Phase 1: designed package API (`design.md`) — `AuthBackend` interface, `TenantConnection`, `BusinessAuthResult`, sealed exception hierarchy. Phase 2: hardened `bp_auth` schema (role gate + 15m/8h durations), scaffolded package (12 files), implemented business signin, token store, session restore. `WITH REFRESH` removed — Dart surrealdb SDK can't handle the response format change. Phase 3: migrated BP to `ditto_auth` — rewired `auth_provider.dart`, `establishment_providers.dart`, `portal_shell.dart`. All tests green (11 ditto_auth + 21 BP). Track paused until Marketplace foundation lands for consumer auth.
- **Tracks touched:** `auth_service_20260624`
- **Status:** Phase 1 ✅, Phase 2 (business) ✅, Phase 3 (migration) ✅. Track paused. Remaining: deploy to Saturn, consumer auth (Phase 4), `bp_portal` hardening.
- **Decisions:** None (ADR-0019 was recorded in prior session). Operational: `WITH REFRESH` deferred, AuthState stays in `mercury_client`, token durations are adjustable.
- **Next:** (1) Deploy BP with `ditto_auth` to Saturn. (2) Public Marketplace foundation (Android/iOS, signup/login/profile). (3) Resume auth track Phase 4 when Marketplace is ready.

## 2026-06-24 16:17 — Auth Service track: spec + plan + Phase 1 research (4/5)

- **Session:** Created Auth Service track (`auth_service_20260624`). Full spec interview (5 questions — scope, tech stack, client consumption, access topology, phasing). Approved spec + plan (4 phases). Ran Phase 1 research tasks 1-4 against SurrealDB 3.0.5 test DB. All verified: multi-access coexistence, SIGNUP with SCHEMAFULL, `WITH REFRESH` for token lifecycle, PASSHASH provisioning for `bp_portal`.
- **Tracks touched:** `auth_service_20260624`
- **Status:** Phase 1 in-progress (4/5 research tasks done, package API design remaining)
- **Decisions:** ADR-0019 (Auth Service Architecture — SurrealDB-native with intermediary escape hatch)
- **Next:** Complete Task 5 (package API design) → Phase 2 (build `ditto_auth` package + schema definitions)

## 2026-06-24 15:12 — Grill session: 2 ADRs, Saturn DB reset, Auth Service track proposed

- **Session:** Grill assessment + domain refinement. Diagnosed BP login failure (user role=customer, no company_slug, no tenant DB on Saturn). Fixed stale terminology across 4 docs. Ran full grill: explored multi-tenancy (DB-per-tenant confirmed), blueprint sync (symlink approved), bp_portal password strategy (shared dart-define for staging, backend proxy for production — informed by SurrealDB Sidekick agent). User proposed a NEW standalone Auth Service — auth is currently scattered (Admin does NS-level, BP does RECORD ACCESS) and should be consolidated. Auth was never in MercuryEngine and should not be. Vipps Login and BankID were *mentioned* as future possibilities only — NOT planned features (no API, no company registration). Saturn DB wiped clean and schemas re-applied. BP redeployed with `--dart-define=BP_PORTAL_PASS=test-portal-pass` and config error logging.
- **Tracks touched:** `bp_login_establishments_20260614`, `admin_panel_20260527`
- **Status:** Saturn DB clean (schemas only, no data). Both apps deployed. Auth Service track not yet created — next session.
- **Decisions:** ADR-0017 (Company DB Provisioning Architecture), ADR-0018 (Blueprint Bundling via Symlink)
- **⚠️ CRITICAL for next session:** (1) Saturn DB is EMPTY — only schemas and NS admin user `arnarvalur`/`admin123`. All data must come through Admin Panel UI. (2) No CLI CRUD rule is now in AGENTS.md — enforce it. (3) BP built with `BP_PORTAL_PASS=test-portal-pass`. (4) Auth Service track: user wants `/new-track` — it's a NEW service, NOT decoupled from MercuryEngine (auth was never there). Vipps/BankID are NOT planned features. (5) Blueprint symlink (ADR-0018) approved but not yet implemented.
- **Next:** `/new-track` for Auth Service. Clean E2E after Auth Service lands. Apply blueprint symlink.

---

## 2026-06-24 09:31 — Two deployment-only bugs fixed, trust at zero

- **Session:** BP login broken AGAIN. Found two bugs invisible to integration tests: (1) blueprint asset path `../../schemas/company-blueprint.surql` escaped web root in release builds — Caddy served index.html instead of SQL, (2) password mismatch — Admin provisions bp_portal with `bp-portal-default-pass` but BP was built with `test-portal-pass`. Fixed both. Copied blueprint to `apps/admin/assets/`, updated pubspec + providers. Aligned password to `test-portal-pass`. Deploy gate passed (50+21). Deployed both apps. Fixed rsync path (needs `/web/` subdir for Docker bind mounts). Restarted Caddy containers. Verified blueprint serves HTTP 200 with SurrealQL. Full auth chain verified via API. Cleaned orphaned registry entries. Provisioned House of the North via API. Reset Demo Business password to `admin123`. **User did NOT verify BP login — trust exhausted after a month of this pattern.**
- **Tracks touched:** `bp_login_establishments_20260614`, `admin_panel_20260527`
- **Status:** Both apps redeployed with fixes. BP login unverified by user. Systemic issue: tests test logic against local DB, never verify deployed product.
- **Decisions:** None
- **⚠️ CRITICAL for next session:** (1) DO NOT say "ready for E2E" until the DEPLOYED app has been verified via the post-deploy smoke script or by the user. (2) The blueprint file at `apps/admin/assets/company-blueprint.surql` is a COPY of `schemas/company-blueprint.surql` — keep in sync. (3) Deploy requires `rsync ... saturn:/srv/dittodatto/{app}/web/` (not `/srv/dittodatto/{app}/`). (4) After rsync, run `ssh saturn 'docker restart dittodatto-caddy dittodatto-portal-caddy'`. (5) A post-deploy smoke script was proposed but NOT built yet — build it FIRST next session.
- **Next:** User-verify BP login. Write post-deploy smoke script. Test company creation through Admin Panel form (not CLI).

---

## 2026-06-23 20:21 — Deploy gate + Saturn deployment

- **Session:** Ran deploy gate (50 admin + 21 BP integration tests all green). Built both apps `--release`. Deployed Admin Panel + Business Portal to Saturn via rsync.
- **Tracks touched:** `admin_panel_20260527`, `bp_login_establishments_20260614`
- **Status:** Both apps live on Saturn. Admin: `http://dittodatto:8002`, BP: `http://dittodatto:8003`. No code changes — deploy only.
- **Decisions:** None
- **Next:** Staging E2E: delete CLI company, re-create through form. BP E2E: login → establishments. Secure `bp_portal` password.

---

## 2026-06-23 20:07 — CRITICAL FIX: Company provisioning implemented

- **Session:** Fixed the critical provisioning gap. `createCompany` now auto-provisions tenant databases: creates `company_{slug}` DB, applies `company-blueprint.surql` (18 tables, 3 relations), creates `bp_portal` service user. `deleteCompany` auto-deprovisions. Discovered and fixed SurrealDB identifier quoting bug (hyphens = subtraction) and Dart WebSocket SDK multi-result limitation. Blueprint bundled as Flutter asset. Provider wired to pass it to the repository. 11 new integration tests including full E2E: create company → provision → BP authenticates → CRUD data. 50 total admin tests green.
- **Tracks touched:** `bp_login_establishments_20260614`, `admin_panel_20260527`
- **Status:** Provisioning blocker resolved. BP track fully unblocked. Admin test count 39 → 50.
- **Decisions:** None (follows existing ADR-0016 BP auth model)
- **Next:** Deploy to Saturn, delete CLI company, re-create through form. Then BP E2E: login → establishments CRUD. Secure `bp_portal` password (currently hardcoded).

---

## 2026-06-23 12:35 — CRITICAL: Company DB provisioning never built

- **Session:** Continued E2E verification. Added "same as owner" email checkbox to company form. User asked why BP login fails after creating company — discovered root cause: `createCompany` only writes to `companies/registry`, never provisions the actual company database (`company_{slug}`), blueprint schema, or `bp_portal` service user. This has been the missing piece causing weeks of BP login failures. Partial fix started and reverted per user request.
- **Tracks touched:** `admin_panel_20260527`
- **Status:** Critical gap identified. No provisioning code exists. Must be fixed before any BP E2E is possible.
- **Decisions:** None
- **Next:** Implement company DB provisioning in `createCompany`. Then clean E2E: create company → verify BP login works.

---

## 2026-06-23 12:25 — Stabilization: Test Isolation + Schema Gate + Deploy + E2E

- **Session:** Deep diagnostic confirmed recurring regression root cause: schema drift + concurrent test isolation. Fixed stats test (concurrency:1 in dart_test.yaml + delta-free assertions). Added Schema Gate as mandatory workflow step 3 — agents must read .surql before writing DB code. Added "E2E Means E2E" principle — no CLI hacks for form testing. Built + deployed both Admin Panel and Business Portal to Saturn. E2E verified: login ✅, dashboard ✅, company form ✅. CLI-created test company has bad owner_id (record link vs string) — need to delete and re-create through form.
- **Tracks touched:** `admin_panel_20260527`, `bp_login_establishments_20260614`
- **Status:** 39/39 admin + 92/92 BP tests green. Both apps deployed. Workflow hardened with 2 new guardrails.
- **Decisions:** None
- **Next:** Delete CLI company, create through form (clean E2E). Then BP E2E: login as business user → establishments CRUD.

---

## 2026-06-23 11:51 — Company Form Schema Mismatch Fix

- **Session:** Fixed 4 bugs preventing company creation from Admin Panel form: (1) OnboardingStatus enum mismatch (inProgress/completed → aiSuggested/verified/complete), (2) CompanyTier had enterprise not in schema, (3) CompanySocialLinks.website rejected by SCHEMAFULL, (4) form dbSlug missing company_ prefix. Removed "Fill Mock Data" button. Added 11 form round-trip integration tests.
- **Tracks touched:** `admin_panel_20260527`
- **Status:** 37/38 integration tests pass. 1 pre-existing stats test isolation failure. Committed as `b2baa9d`.
- **Decisions:** None

---

- **Session:** Diagnosed root cause of Flutter migration pain (AI code passes widget tests, breaks on real SurrealDB). Overhauled agent rules: dropped 2 generic book rules, added `surrealdb-dart.md` (9 foot-gun patterns) + `user-first.md` (ask-before-fumbling). Trimmed global `GEMINI.md` to essentials. Switched GH remote HTTPS→SSH, pushed branch.
- **Tracks touched:** None (cross-cutting infrastructure)
- **Status:** All committed and pushed to GH. 4 project-specific agent rules, all battle-tested.
- **Decisions:** None
- **Next:** Admin Panel E2E (create users → create company → verify BP login). Consider SurrealDB typed query helper.

---

## 2026-06-20 15:31 — Admin Panel Integration Test Suite + Deploy Gate

- **Session:** Built 28 integration tests for Admin Panel against real SurrealDB (users/companies/categories/stats CRUD + NS auth). First run caught 3 production bugs: (1) `updateUser` invalid MERGE+SET syntax, (2) `deleteCompany` record ID mismatch, (3) `createUser` phone missing NULL→NONE coercion. All fixed, tests green. Added `.agents/AGENTS.md` deploy gate rule — tests must pass before any deploy. Extended `test-db-seed.sh` with `testadmin` on `companies` namespace.
- **Tracks touched:** `admin_panel_20260527`
- **Status:** 28/28 integration tests green. Admin Panel deployed with all 3 fixes. Deploy gate rule enforced.
- **Decisions:** None (deploy gate is an operational rule, not an ADR)
- **Next:** Admin Panel E2E: create users → create company → verify BP login works.

---

## 2026-06-20 12:26 — Saturn DB Wipe + Admin Panel NULL→NONE Fix + Deploy

- **Session:** Wiped Saturn DB clean (all company DBs + user records removed). Re-applied schemas from source of truth (users, registry, discovery). Created 2 NS OWNER users (arnarvalur, gurkudrengur, pw admin123). Fixed Admin Panel CREATE user query — was sending NULL for optional fields (`company_slug`, `vipps_sub`) which SurrealDB `option<string>` rejects. Verified fix against real Saturn DB. Rebuilt + deployed Admin Panel. Removed oasai references from conductor. Quality audit scored overnight work 8.2/10.
- **Tracks touched:** `bp_login_establishments_20260614`, `admin_panel_20260527`
- **Status:** Saturn DB is clean. Admin Panel deployed with fix. User creation verified on real DB. Ready for Admin Panel E2E (create users → create company → test BP login).
- **Decisions:** None
- **Next:** Log into Admin Panel as `arnarvalur` → create users → create company → BP E2E.

---

## 2026-06-20 12:05 — Quality Audit + platform→registry Fix + Saturn DB Assessment

- **Session:** Quality-audited overnight Gemini 3.5 work (scored 8.2/10). Fixed 4 stale `platform`→`registry` references in README, seed script, platform.surql (commit `12511cf`). Seed script was broken — would apply schemas to wrong DB name. User inspected Saturn DB via Surrealist: `company_dittodatto-as` has only 1 table (missing blueprint), `merkurial-studio` in registry with no company DB, stale Surrealist connection. User wants DB wipe + clean re-provision before continuing E2E.
- **Tracks touched:** `bp_login_establishments_20260614` (indirectly — schema infra)
- **Status:** Schema refs fixed. Saturn DB cleanup blocker identified. E2E paused until DB is clean.
- **Decisions:** None
- **Next:** Decide on Saturn DB wipe strategy. Write provisioning script or manual wipe + re-apply schemas. Then resume E2E.

---

## 2026-06-20 02:29 — Gemini 3.5 Session Audit + Database Cleanup + Schema Fix

- **Session:** Audited Gemini 3.5 Flash session (c962aebc) — found scope creep (Admin Panel touched without being asked), hallucinated APIs, uncommitted code. All code reviewed and committed in 6 logical groups. Fixed `opening_schedule` schema blocker (DEFAULT {}) on both company DBs on Saturn. Dropped legacy `users/profiles` DB on Saturn. Fixed `init.surql` naming (platform→registry). Updated stale ADR-0002 (profiles→users) and ADR-0016 (username→email). Fixed scrollspy 200px magic number with dynamic offset calculation. Discarded Gemini 3.5 artifacts (.saropa/, reports/, history.txt changes). 138 tests green.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Schema blocker resolved. DB clean. All Phase 5 code committed. Ready for E2E verification tomorrow morning.
- **Decisions:** None
- **Next:** E2E verification: login → create establishment → verify persistence → scrollspy edit view. Then BP web build + deploy to Saturn.

---

## 2026-06-19 22:50 — Phase 5 Layout Implemented & Schema Validation Blockage

- **Session:** Implemented Phase 5 layout updates (sidebar identity header/footer, reordered navigation to put Inbox at index 1, Login screen branding cleanups, and refactored establishment edit screen from tabs to scrollable card sections using `DittoScrollspyLayout`). Resolved Riverpod state sync issue in `surrealConnectionProvider`. Investigated and diagnosed establishment creation disappearance/failure on schema-applied database `company_house-of-the-north` due to missing required `opening_schedule` field in creation JSON.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Phase 5 layout implemented and compilation/tests green (92 tests passing). Staged web build deployed to Saturn. Blocked on database schema modification for `opening_schedule`.
- **Decisions:** None (no ADRs recorded)
- **Next:** Fix database schema for `opening_schedule` to define `DEFAULT {}` or make it optional (`TYPE option<object>`), then run E2E verification.

---

## 2026-06-19 20:42 — Infra Prep + Phase 5 Design Planning

- **Session:** Rebuilt Admin Panel + deployed to Saturn. Applied company-blueprint to `company_house-of-the-north` (18 tables + 3 relations). Stored DB root creds in gitignored `conductor/docs/keys/saturn-db-root.env`. Researched professional portal UX patterns and Flutter theming architecture. Designed Phase 5 plan: sidebar identity (company top, full name bottom), login cleanup (email+password only), tabs → scrollable card sections with scrollspy, sticky top bar. Theme switching explicitly deferred to Phase 6.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Phase 5 implementation plan approved. Ready for implementation in new session.
- **Decisions:** None (design decisions recorded in Pulse session memory, no ADRs)
- **Next:** Implement Phase 5 (reference `implementation_plan.md` artifact from conversation `96918de2-7254-451b-96f1-2a81bef1a195`). Then Phase 6 theme session.

---

- **Session:** Enforced global maintenance redirect both server-side and client-side on the public landing page. Revamped the Norwegian coming-soon page to fix browser emoji clipping and removed the Merkurial Studio footer. Built the container locally and deployed to Cloud Run.
- **Tracks touched:** None
- **Status:** Deployed and verified live at dittodatto.no.
- **Decisions:** None
- **Next:** Rebuild Admin Panel. Apply company-blueprint to `company_house-of-the-north`. Phase 5 of BP track.

---

## 2026-06-19 17:09 — BP Auth Email Validation + Permissions Fix

- **Session:** Fixed email validation hole (username prefix → full email matching in `bp_auth` SIGNIN). Fixed SCHEMAFULL RECORD ACCESS permissions (table needs explicit `PERMISSIONS FOR select WHERE id = $auth.id`). All 46 tests green before deployment.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Deployed and user-verified on Saturn. BP login works E2E.
- **Decisions:** None
- **Next:** Rebuild Admin Panel. Apply company-blueprint to `company_house-of-the-north`. Phase 5.

---

## 2026-06-19 15:38 — BP Auth Full-Stack Fix

- **Session:** Fixed the fundamental auth plumbing end-to-end. DB consolidation (`users/profiles` → `users/users`), argon2 password hashing in Admin Panel, password fields in Create/Edit User dialogs, Saturn DB migration (3 users with password_hash + DEFINE ACCESS bp_auth + bp_portal service users on 2 company DBs). BP rebuilt with `BP_PORTAL_PASS=test-portal-pass`.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Code-complete. Build staged on Saturn at `/tmp/bp-web-deploy/`. Needs `sudo rsync` to deploy. Admin Panel also needs rebuild+redeploy.
- **Decisions:** None (ADR-0016 already covers this architecture)
- **Next:** Deploy BP → E2E login as Demo Dude → verify correct company loads. Rebuild Admin Panel. Apply company-blueprint schema to `company_house-of-the-north`.

---

## 2026-06-14 15:30 — BP Login + Establishments Phases 1–4

- **Session:** Implemented Stitch Enterprise Slate light theme, Norwegian login redesign, Establishments list screen with card grid + tab filters, create dialog, and 4-tab edit view.
- **Tracks touched:** `bp_login_establishments_20260614`
- **Status:** Phases 1–4 complete. 94 tests green. 7 commits on `track/bp-login-establishments`.
- **Next:** Auth verification, Phase 5 integration, deploy to Saturn.

---

## 2026-06-09 16:30 — Business Portal E2E Steel Thread & Saturn Deployment

- **Session:** Verified Business Portal login E2E against Saturn SurrealDB. Built and deployed to Saturn port 8003.
- **Status:** Login works. Portal live at `http://dittodatto:8003`.
- **Next:** Establishments CRUD track.

---

> 📦 Pre-portal relay history: `conductor/pulse-archive/2026-06-09-pre-portal.md`
