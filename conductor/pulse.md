# Pulse — Current Project State

**Last Updated:** 2026-06-25 21:57
**Session Focus:** BP Media Manager PoC — Firebase Storage + SurrealDB metadata + gallery page

## 🚀 Active Tracks

- **BP Establishment Preview** (`bp_establishment_preview_20260625`) — **In-progress.** Phases 1-3 ✅, Phase 4 partial. Shared `packages/establishment_ui/` built (27 tests). Preview toggle deployed to Saturn. Remaining: grill + iterate on page sections, visual polish.
- **BP Media Manager** (`track/bp-media-manager` branch) — **PoC complete.** Firebase Storage backend (swappable), SurrealDB `media` table, gallery page with upload/delete/search/tags. 40 integration tests green. Needs: Firebase Storage rules configured ✅, establishment inline integration (follow-up).
- **Marketplace Foundation** (`marketplace_foundation_20260624`) — **In-progress.** Phases 1-3 ✅. Phase 4 partial: Saturn SDB connectivity ✅, on-device login ✅, **user-verified E2E** (login/logout/theme) ✅. Remaining: Saturn web deploy, integration tests.
- **Auth Service** (`auth_service_20260624`) — **In-progress.** Phases 1-3 ✅, Phase 4 consumer wiring ✅. Schema applied to Saturn ✅. Remaining: `bp_portal` hardening.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phase 5 E2E task ✅. Deployed to Saturn. Remaining: responsive layout verification, coverage gate.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed on Saturn.

## ✅ Recently Completed

- **2026-06-25 20:36** — **BP Establishment Preview:** Created `packages/establishment_ui/` shared package (EstablishmentData model, EstablishmentPage with CustomScrollView + slivers, 4 section widgets). Preview toggle (👁️/✏️) in BP AppBar. Back arrow context-aware. 27 package tests + 71 BP widget tests + 32 integration tests green. Deployed to Saturn. Legacy Nuxt code researched for reference.
- **2026-06-25 18:28** — **User-verified E2E on S21:** Login as `arnarvalur@avj.info` (super_admin) ✅, logout ✅, dark/light theme toggle ✅. Full consumer auth flow confirmed working against Saturn SDB over Tailscale mesh. Screenshots captured (light + dark mode profile screen).
- **2026-06-25 15:54** — PM → Saturn E2E: Changed `TAILNET_IP` from `127.0.0.1` to `100.87.99.59` in Saturn `.env` — all services now reachable from Tailscale mesh. Applied updated `consumer_auth` schema to Saturn (role-gate removed). Rebound Admin Panel caddy + BP portal caddy to Tailscale IP. Fixed Android cleartext WebSocket restriction (`network_security_config.xml`). Fixed `initializeDateFormatting('nb_NO')` crash on profile. **User logged in on S21 as `arnarvalur@avj.info` (super_admin) via marketplace → Saturn SDB.** Hierarchical RBAC verified E2E. Network topology diagram stored in `conductor/docs/`.
- **2026-06-25 14:44** — BP Establishment fix: NULL→NONE serialization (toJson strips null optional fields), try-catch error handling with Norwegian snackbar, `is_published DEFAULT false` schema fix, update path null stripping. 11 new CRUD integration tests. Sidebar highlight fixed (prefix matching for child routes). Business type removed from edit view (locked at creation). 71 widget + 32 integration = 103 tests green. Deployed to Saturn.
- **2026-06-25 14:42** — Cross-role RBAC fix: removed `AND role = 'customer'` from `consumer_auth` SIGNIN. All roles can now use the marketplace. 24/24 tests green. Deployed to S21 — user attempted login (InvalidCredentials because test DB credentials ≠ their real account). Identified friction: phone needs Tailscale connectivity to Saturn SDB for real E2E.
- **2026-06-25 14:00** — Consumer Auth wired: `DEFINE ACCESS consumer_auth` added to `schemas/users.surql` (SIGNUP + SIGNIN + role gate + 24h tokens). 13 new integration tests in `ditto_auth` (signup, signin, session restore, signout, role isolation). All 24 `ditto_auth` integration tests green (11 business + 13 consumer).
- **2026-06-25 13:44** — Marketplace Foundation: scaffolded Flutter project, built 3-tab nav shell, login/signup/profile screens, consumer auth in `ditto_auth`. On-device deploy to Samsung Galaxy S21. App renamed to "DittoDatto". Fixed bottom nav bar disappearing on login/signup.
- **2026-06-24 19:27** — Auth Service track: Phases 1-3 complete. `ditto_auth` package built, BP migrated.
- **2026-06-24 16:17** — Auth Service track: created with spec + plan + Phase 1 research. ADR-0019.
- **2026-06-24 15:12** — Grill session: ADR-0017, ADR-0018. Saturn DB wiped clean.
- **2026-06-23 20:21** — Deploy gate passed (50 admin + 21 BP tests green). Deployed both apps.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- ~~🔴 **Saturn SDB not reachable from phone.**~~ ✅ Fixed — `TAILNET_IP=0.0.0.0`, all ports reachable from Tailscale mesh.
- ~~🔴 **Saturn schema outdated.**~~ ✅ Fixed — `consumer_auth` OVERWRITE applied, role gate removed.
- 🟡 **No post-deploy verification.** Deploy gate tests logic against local DB, not the deployed product.
- 🟡 **No marketplace-level tests.** `apps/marketplace/test/` is empty — package-level tests cover auth logic.
- ~~🟡 **Marketplace not deployed to Saturn web.**~~ Deprioritized — Marketplace is native-only (Android/iOS) for now. APK distribution live on `:8005`.

## 🧠 Session Memory

### Session 2026-06-25 21:57 — BP Media Manager PoC
- **Research**: Mapped legacy Nuxt media manager (`useMediaUpload.ts`, `media/index.vue`, `shared-types/media.ts`). Legacy used Firebase Storage + Firestore for metadata. User decided to reuse Firebase Storage for PoC, swap later for European sovereignty.
- **Schema**: Added `media` table to `company-blueprint.surql` (section 1.2) with SCHEMAFULL + MIME ASSERT + tags + timestamps.
- **Model**: `MediaItem` class with fromJson/toJson, validation (JPEG/PNG/WebP/SVG, max 10MB), Norwegian error messages.
- **Provider**: `media_providers.dart` — `FirebaseMediaStorage` is the **only** class that knows Firebase. Swappable backend. `MediaNotifier` (AsyncNotifier) handles CRUD + upload progress. Follows same SurrealDB query pattern as `establishment_providers.dart`.
- **Gallery UI**: `media_gallery_screen.dart` — responsive grid (2/3/4 cols), upload via `file_picker`, delete with confirm, search by filename, tag filter chips, empty state (Norwegian), loading skeleton, hover-to-reveal overlay.
- **Firebase setup**: Installed Firebase CLI + FlutterFire CLI. Ran `flutterfire configure` for project `cs-poc-4zmxog23jmy4io0d4yx6rj0`. User configured Storage rules (open for dev). Web app registered: `business_portal`.
- **Wiring**: `/media` route added, "Media" nav item (8th) added to shell. Firebase.initializeApp in main.dart.
- **Tests**: 8 new media integration tests (CREATE, SELECT, DELETE, MIME validation, model validation). 40 total integration tests green. Nav tests updated (7→8). Static analysis: 0 issues.
- **Branch**: `track/bp-media-manager` (1 commit: `c960bca`, +1761 lines).
- **Key architecture**: Storage backend abstracted — `FirebaseMediaStorage` can be replaced with Saturn file server or European S3-compatible store. Only one class to swap.

### Session 2026-06-25 20:36 — BP Establishment Page Preview
- Created `packages/establishment_ui/` shared package. Preview toggle in BP AppBar. 130 tests green. Deployed to Saturn.
- User wants to `/grill` the page next session.

> 📦 Full history: `conductor/pulse-archive/2026-06-25-pre-preview.md`

## 📋 Next Session Suggestions

1. 🔴 **Media Manager UI integration** — Wire media picker into establishment edit view (inline gallery for logo/cover/gallery images). Follow-up to the PoC.
2. 🔴 **Grill the EstablishmentPage** — `/grill` session to refine sections, add more fields (images via media manager, opening hours, social links).
3. 🔴 **Marketplace integration tests** — signup/login/logout/session restore/theme toggle/tab nav against real SDB.
4. 🟡 **BP feature buildout** — continue building Business Portal features beyond Establishments CRUD.
5. 🟡 **European sovereignty planning** — research Norwegian/European hosting alternatives for object storage (Saturn file server, Hetzner S3-compatible).
6. 🟢 **Logo:** User is working on a logo — swap when ready.
