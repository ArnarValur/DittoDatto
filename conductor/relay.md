# Relay — Cross-Session Handoff

## 2026-06-27 23:17 — Marketplace Foundation Phase 4 Closure
- **Session:** Wrote 32 tests (7 integration + 25 widget) for marketplace auth. Fixed Row→Wrap overflow in login/signup screens. Backfilled track docs (spec.md, plan.md). Closed track — moved to Completed in tracks.md, updated pulse.md.
- **Tracks touched:** marketplace_foundation_20260624 (completed)
- **Status:** Marketplace Foundation fully closed. Auth Service Phase 4 unblocked. Only Auth Service remains active.
- **Decisions:** None
- **Next:** (1) Review Auth Service Phase 4 — consumer auth live, may be ready to graduate. (2) Read CRM + Comms research docs. (3) EstablishmentPage UI polish. (4) Marketplace Discovery track.

## 2026-06-27 17:10 — Chapter 1 Graduations + CRM Research
- **Session:** Graduated Admin Panel Chapter 1 + Business Portal Chapter 1 (merged 2 tracks). Dispatched 3 research agents for CRM domain (Noona analysis + Flutter architecture + communication infrastructure). User stepping away for dinner.
- **Tracks touched:** admin_panel_20260527 (completed), bp_login_establishments_20260614 (completed), bp_establishment_preview_20260625 (completed)
- **Status:** 3 Chapter 1 tracks graduated this session + Media Manager (prior). Only Marketplace Foundation + Auth Service remain active. 2/3 research docs written, 1 in-flight.
- **Decisions:** None
- **⚠️ REMIND USER:** Auth Service Phase 4 — user suspects it may already be done. Review tonight.
- **Next:** (1) Review Auth Service Phase 4 status. (2) Read CRM + Comms research docs. (3) EstablishmentPage UI polish grill. (4) Marketplace tests.

## 2026-06-27 16:39 — Business Portal Chapter 1 Graduation
- **Session:** Merged and graduated `bp_login_establishments_20260614` + `bp_establishment_preview_20260625` as BP Chapter 1. User confirmed login, establishments CRUD, preview toggle, media all working on Saturn. UI polish deferred to Chapter 2 re-grill.
- **Tracks touched:** bp_login_establishments_20260614 (completed), bp_establishment_preview_20260625 (completed)
- **Status:** BP Chapter 1 closed. Admin Panel Chapter 1 also closed earlier this session. Active tracks: Marketplace Foundation + Auth Service only.
- **Decisions:** None
- **Next:** (1) EstablishmentPage UI polish grill (BP Chapter 2). (2) Marketplace tests. (3) E2E checklist (user-driven). (4) Admin Panel Chapter 2 when ready.

## 2026-06-27 16:33 — Admin Panel Chapter 1 Graduation
- **Session:** User confirmed Admin Panel login/logout, Users, Companies, Categories all working on Saturn. Track `admin_panel_20260527` graduated as Chapter 1 complete. Inbox + advanced features deferred to future re-grill as independent track.
- **Tracks touched:** admin_panel_20260527 (completed)
- **Status:** Admin Panel Chapter 1 closed. 50 integration tests, deployed at `:8002`.
- **Decisions:** None
- **Next:** (1) EstablishmentPage UI polish grill. (2) E2E checklist. (3) Marketplace tests. (4) Admin Panel Chapter 2 re-grill (Inbox + advanced features) when ready.

## 2026-06-27 16:23 — E2E Checklist + User Verification
- **Session:** Created 45-scenario E2E checklist (`conductor/docs/media-manager-e2e-checklist.md`). User tested on Saturn — upload, selection, removal, preview rendering all confirmed working. Layout crude but functional. Deploy dart-define fix shipped (AGENTS.md permanently updated).
- **Tracks touched:** bp_establishment_preview_20260625
- **Status:** Media pipeline fully functional E2E. User will work through checklist gradually. EstablishmentPage UI polish explicitly deferred to next session grill.
- **Decisions:** None
- **Next:** (1) Re-grill EstablishmentPage for UI polish + distinct layout modes (user's explicit next). (2) Continue E2E checklist. (3) Marketplace tests.

## 2026-06-27 14:17 — Preview Media Wiring + Deploy Dart-Define Fix
- **Session:** Wired media fields (logoUrl, coverUrl, galleryUrls, coverLayoutMode) through EstablishmentData into shared EstablishmentPage preview. New EstablishmentGallerySection + logo avatar in EstablishmentInfoBar. Fixed deploy script missing `--dart-define` flags — added `DART_DEFINES` map. AGENTS.md updated with permanent deployment rules ("No Ad-Hoc Commands, No Questions"). Redeployed to Saturn.
- **Tracks touched:** bp_establishment_preview_20260625
- **Status:** Media fields wired end-to-end. 44 tests green. Deployed + verified. Distinct bento/showcase/spotlight layouts deferred to EstablishmentPage grill.
- **Decisions:** None
- **Next:** (1) Re-grill EstablishmentPage for distinct layout modes. (2) Marketplace tests. (3) BP Preview Phase 4 integration test.

## 2026-06-27 13:42 — MediaPicker Integration + Deploy Fix
- **Session:** Wired MediaPickerWidget into establishment edit view (Bilder scrollspy section with cover layout mode, cover/gallery/logo pickers). Fixed deploy pipeline — root cause was rsync to wrong Saturn path (`/home/arnar/...` vs Caddy's `/srv/dittodatto/...`). Created `deploy-to-saturn.sh` with canonical paths + hash verification.
- **Tracks touched:** bp_login_establishments_20260614
- **Status:** Bilder section live on Saturn. Deploy script committed. 172 tests green. Minor polish pending (missing icon).
- **Decisions:** None (ADR-level). Deploy path canonicalized as operational fix.
- **Next:** (1) Fix missing icon in Bilder nav. (2) Preview media support (Task 5). (3) Marketplace tests. (4) BP Preview Phase 4.

## 2026-06-27 05:32 — Post-Deploy Smoke Test
- **Session:** Built `scripts/post-deploy-smoke.sh` — curls each Saturn surface + Hub health. Tested live (3/3 green, Marketplace skipped). Wired into deploy gate (AGENTS.md step 5). Cleared long-standing "no post-deploy verification" blocker.
- **Tracks touched:** None (cross-cutting infra)
- **Status:** Deploy gate now has 6 steps: test-db-up → tests → build+rsync → smoke → test-db-down. Smoke script committed (`e159889`).
- **Decisions:** None
- **Next:** (1) Wire `MediaPickerWidget` into establishment edit. (2) Marketplace tests. (3) BP Establishment Preview Phase 4.

## 2026-06-27 05:21 — Media Gallery V2 Redesign + Graduation
- **Session:** Redesigned gallery from filter-chip grid to Netflix-style category rows. Built `MediaCategoryRow`, `MediaDetailModal`, `MediaGalleryV2Page`. Added `updateName`/`updateTags` to repository + notifier. Feature-flagged V1/V2 toggle. 235 tests green. Deployed to Saturn. User verified E2E and graduated Media Manager.
- **Tracks touched:** `media_manager_package_20260626` (graduated — V2 polish pass)
- **Status:** Media Manager complete and graduated. V2 layout live on Saturn. Branch merged to `develop`.
- **Decisions:** None
- **Next:** (1) Wire `MediaPickerWidget` into establishment edit. (2) Marketplace tests. (3) BP Establishment Preview Phase 4.

## 2026-06-27 04:53 — Media Manager Test Coverage + CORS Fix + Merge
- **Session:** Wrote 100 package tests (storage backend, filter bar, grid tile, gallery page filtering, picker modal selection) + 9 new MediaRepository integration tests + 7 MediaUploadStateNotifier unit tests. Fixed Firebase Storage CORS for Saturn (port was 8883→8003). Merged `track/bp-media-manager` to `develop`. Installed `gcloud` SDK on Saturn.
- **Tracks touched:** `media_manager_package_20260626` (completed — test + polish pass)
- **Status:** All tests green. Branch merged. CORS applied. User has uploaded visuals ready to verify.
- **Decisions:** None
- **⚠️ CRITICAL for next session:** (1) BP on Saturn is port **8003** (not 8883). Admin Panel is **8002**. Caddy configs at `/srv/saturn-docker/portal-caddy/Caddyfile` and `/srv/dittodatto/caddy/Caddyfile`. (2) `gcloud` SDK installed at `~/google-cloud-sdk/` on Saturn, authenticated as `arnarvalur@avj.info`, project `cs-poc-4zmxog23jmy4io0d4yx6rj0`. (3) Firebase Storage bucket: `cs-poc-4zmxog23jmy4io0d4yx6rj0.firebasestorage.app`.
- **Next:** (1) Verify media upload + thumbnail display E2E on Saturn. (2) Wire picker into establishment edit. (3) User has visuals to work with.

## 2026-06-27 04:03 — Firebase Storage Fix on Saturn + Deploy Finalization
- **Session:** Fixed Firebase Storage on Saturn. Root cause: stale `.dart_tool` web plugin registrant was missing `FirebaseCoreWeb` and `FirebaseStorageWeb` registration. `flutter clean` regenerated it. Also added Firebase JS SDK compat scripts to `web/index.html`. Removed try-catch from `Firebase.initializeApp()`. User confirmed login works on Saturn.
- **Tracks touched:** `media_manager_package_20260626` (completed — post-deploy fix)
- **Status:** Firebase inits properly on Saturn. Media Manager fully deployed and functional.
- **Decisions:** None
- **⚠️ CRITICAL for next session:** (1) After adding Firebase deps to a monorepo workspace, `flutter clean` is REQUIRED to regenerate web plugin registrant. (2) `web/index.html` needs Firebase JS SDK compat scripts. (3) BP builds require `--dart-define=BP_PORTAL_PASS=test-portal-pass`. (4) `rsync` must use `--checksum`. (5) Branch `track/bp-media-manager` not yet merged to develop.
- **Next:** (1) Media Manager unit + integration + E2E tests with polish. (2) Test actual upload E2E on Saturn. (3) Wire picker into establishment edit. (4) Merge branch to develop.

## 2026-06-27 03:43 — Media Manager: Phase 4 BP Wiring + Track Complete + Deploy
- **Session:** Completed Phase 4 of Media Manager track. Wired BP to import from `packages/media_manager/`: rewrote `media_providers.dart` (Riverpod glue using `MediaRepository`), replaced `media_gallery_screen.dart` (800→50 lines), deleted `media_model.dart`. `FirebaseMediaStorage` stays as BP-specific concrete backend. 169 tests green (51 pkg + 72 widget + 46 integration). Deployed to Saturn via deploy gate. User confirmed category picker dialog renders correctly. Firebase Storage blocker identified — `Firebase.initializeApp()` fails on Saturn, uploads silently disabled.
- **Tracks touched:** `media_manager_package_20260626` (completed)
- **Status:** Track complete. All 4 phases done. Branch `track/bp-media-manager` deployed but not yet merged to develop.
- **Decisions:** None
- **⚠️ CRITICAL for next session:** (1) Firebase Storage uploads DON'T WORK on Saturn — `Firebase.initializeApp()` fails. Options: authorize Saturn's domain in Firebase Console, or build non-Firebase `MediaStorageBackend`. (2) Branch `track/bp-media-manager` needs merge to develop. (3) BP builds require `--dart-define=BP_PORTAL_PASS=test-portal-pass`. (4) `rsync` for Flutter web deploys MUST use `--checksum`. (5) After rsync: `ssh saturn 'docker restart dittodatto-portal-caddy'`.
- **Next:** (1) Fix Firebase Storage on Saturn (or swap backend). (2) Wire `MediaPickerWidget` into establishment edit. (3) Merge branch to develop.

## 2026-06-27 03:09 — Media Manager: SwanFlutter Patterns + Session Close
- **Session:** Incorporated 3 SwanFlutter-inspired patterns into `packages/media_manager/`: error taxonomy (MediaError + MediaErrorCode), fromExtension() on MediaCategory, clearCache()/getThumbnailUrl() on MediaStorageBackend. Package now at 51 tests green, 0 analysis errors. Pulse.md was corrupted (1400 lines of duplicated junk from a prior agent) — cleaned up.
- **Tracks touched:** `media_manager_package_20260626`
- **Status:** Phases 1-3 complete + patterns incorporated. Phase 4 (BP wiring) deferred to next session.
- **Decisions:** None
- **Next:** (1) Wire BP to import from `packages/media_manager/`. (2) Wire `MediaPickerWidget` into establishment edit. (3) Merge branch to develop.

## 2026-06-26 15:06 — Media Manager: Grill + Package Extraction (Phases 1-3)
- **Session:** Grilled media manager design. Created ADR-0021. Scaffolded `packages/media_manager/` with full data layer, gallery page, inline picker, and modal picker. 37 package tests green. Investigated SwanFlutter `media_manager` for architecture patterns — three patterns queued for incorporation (error taxonomy, fromExtension, cache management).
- **Tracks touched:** `media_manager_package_20260626`
- **Status:** Phases 1-3 complete. Phase 4 (BP wiring) remaining. 37 tests, 0 analysis issues.
- **Decisions:** ADR-0021 (Media Manager as Shared Package with Abstract Storage Backend)
- **Next:** (1) Incorporate 3 SwanFlutter patterns. (2) Wire BP to import from package. (3) Run full 118 BP + 37 package test suite.

## 2026-06-26 00:22 — BP Media Manager: Saturn Deploy + Firebase Fix
- **Session:** Deployed BP Media Manager to Saturn. Deploy gate passed (118 tests). Discovered `rsync -avz` silently skips same-size files with different content — fixed with `--checksum`. Firebase.initializeApp() crashed the app on Saturn (white screen) — wrapped in try-catch so app loads with media uploads gracefully disabled.
- **Tracks touched:** `track/bp-media-manager` (branch)
- **Status:** Deployed to Saturn at `http://dittodatto:8003`. Media in sidebar position 3. 46 integration + 72 widget = 118 tests green.
- **Decisions:** None
- **⚠️ CRITICAL for next session:** (1) Firebase Storage rules are open for dev — tighten before production. (2) `rsync` for Flutter web deploys **must** use `--checksum` flag (not just `-avz`). (3) Firebase init is try-catch'd — uploads will silently fail on Saturn. (4) BP builds require `--dart-define=BP_PORTAL_PASS=test-portal-pass`. (5) Branch `track/bp-media-manager` not yet merged to develop.
- **Next:** (1) Polish media manager UI + integrate upload UX. (2) Wire media picker into establishment edit view. (3) Merge branch to develop.

## 2026-06-26 00:09 — BP Media Manager: Category Organization
- **Session:** Added `category` field to SurrealDB `media` table (7 enum values: general/logo/cover/gallery/staff/service/menu). Built `MediaCategory` Dart enum with Norwegian labels. Category picker dialog before upload, filter chips in gallery, always-visible category badge on grid tiles. Moved Media to sidebar position 3 (after Establishments). 6 new integration tests.
- **Tracks touched:** `track/bp-media-manager` (branch)
- **Status:** Category org complete. 46 integration + 47 widget = 93 tests green. 0 static analysis issues. Commit `e935482` (+274 lines).
- **Decisions:** None
- **Next:** (1) Wire media picker into establishment edit view (categories are ready). (2) Merge `track/bp-media-manager` to develop. (3) Deploy to Saturn. (4) Grill EstablishmentPage with media integration.

## 2026-06-25 21:57 — BP Media Manager PoC: Firebase Storage + SurrealDB metadata + gallery page
- **Session:** Built standalone Media Gallery page for Flutter BP. Firebase Storage for image bytes (swappable backend), SurrealDB `media` table for metadata. Installed Firebase CLI + FlutterFire CLI. Generated `firebase_options.dart`. User configured Storage rules. Full feature: responsive grid, multi-file upload with progress, delete with confirm, search, tag filter, empty/loading states. Norwegian UI copy.
- **Tracks touched:** `track/bp-media-manager` (branch, not formal conductor track)
- **Status:** PoC complete. 40 integration tests green. 0 static analysis issues. Branch: `track/bp-media-manager` (commit `c960bca`, +1761 lines).
- **Decisions:** None (ADR-level). Pulse: Firebase Storage as PoC engine, European sovereignty as future goal, storage backend abstracted for swap.
- **⚠️ CRITICAL for next session:** (1) Firebase Storage rules are open for dev — tighten before production. (2) BP builds require `--dart-define=BP_PORTAL_PASS=test-portal-pass`. (3) `FirebaseMediaStorage` is the only Firebase-aware class — swap for European hosting later. (4) Branch not merged to develop yet.
- **Next:** (1) Wire media picker into establishment edit view (inline gallery for logo/cover/gallery). (2) Grill EstablishmentPage with media integration. (3) Test gallery E2E manually.

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
