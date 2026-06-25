# Pulse — Current Project State

**Last Updated:** 2026-06-25 23:01
**Session Focus:** BP Dark Mode — theme toggle on login screen + sidebar footer, deployed to Saturn

## 🚀 Active Tracks

- **BP Establishment Preview** (`bp_establishment_preview_20260625`) — **In-progress.** Phases 1-3 ✅, Phase 4 partial. Shared `packages/establishment_ui/` built (27 tests). Preview toggle deployed to Saturn. Remaining: grill + iterate on page sections, visual polish.
- **Marketplace Foundation** (`marketplace_foundation_20260624`) — **In-progress.** Phases 1-3 ✅. Phase 4 partial: Saturn SDB connectivity ✅, on-device login ✅, **user-verified E2E** (login/logout/theme) ✅. Remaining: Saturn web deploy, integration tests.
- **Auth Service** (`auth_service_20260624`) — **In-progress.** Phases 1-3 ✅, Phase 4 consumer wiring ✅. Schema applied to Saturn ✅. Remaining: `bp_portal` hardening.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phase 5 E2E task ✅. Deployed to Saturn. Remaining: responsive layout verification, coverage gate.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed on Saturn.

## ✅ Recently Completed

- **2026-06-25 23:01** — **BP Dark Mode:** Added `isDarkModeProvider` + `DittoTheme.dark` to Business Portal. Toggle on login screen (top-right) + sidebar footer (sun/moon icon). Reused Marketplace pattern. `DittoDashboardShell` gained optional `onThemeToggle`/`isDarkMode` params (shared package, additive only). Defaults to dark. Cherry-picked from `track/bp-media-manager` to `develop`. 40 integration tests green. Deployed to Saturn. First deploy crashed (Firebase init from media-manager branch) — fixed by building from `develop`.
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

### Session 2026-06-25 23:01 — BP Dark Mode Toggle
- Reused Marketplace's `isDarkModeProvider` pattern (Notifier + NotifierProvider). BP defaults to dark (`build() => true`).
- `DittoDashboardShell` in shared `ditto_design` package: added optional `onThemeToggle` + `isDarkMode` params. Purely additive — Admin Panel unaffected.
- Login screen: sun/moon icon in top-right via Stack + Positioned.
- Sidebar footer: sun/moon icon between username and logout button. Norwegian tooltips ("Lyst tema" / "Mørkt tema").
- First deploy failed — was on `track/bp-media-manager` branch (Firebase `initializeApp` crashes without Firebase config on Saturn). Fixed by cherry-picking dark mode commit to `develop` and building from there.
- **⚠️ Branch note**: Dark mode commit exists on both `track/bp-media-manager` (`4f8af50`) and `develop` (`0311fd7`).

### Session 2026-06-25 20:36 — BP Establishment Page Preview
- **Track created**: `bp_establishment_preview_20260625` — researched legacy Nuxt `EstablishmentPage` (9 Vue components found in `DittoDatto-old/packages/ui/components/establishment/`). User shared screenshots of the old preview page as reference.
- **`packages/establishment_ui/` created**: Shared package with `EstablishmentData` model (decoupled from SurrealDB), `EstablishmentType` enum (Norwegian labels), and `EstablishmentPage` widget (CustomScrollView + slivers). 4 section widgets: `EstablishmentGalleryPlaceholder`, `EstablishmentInfoBar`, `EstablishmentAboutGrid`, `EstablishmentContactSection`.
- **Design decisions**: Single scrollable page (no horizontal tabs), gallery placeholder (media manager coming), `AboutSection` → `AboutGrid` rename, preview reads current form state (WYSIWYG).
- **BP integration**: Preview toggle button (👁️/✏️) added to AppBar next to "Lagre". Swaps main content between edit form and `EstablishmentPage`. Back arrow context-aware (exits preview first, then navigates away).
- **Tests**: 27 establishment_ui tests (model + widget), 71 BP widget tests, 32 BP integration tests — all green.
- **Deploy**: Saturn path is `/srv/dittodatto/business-portal/web/` (Caddy container `dittodatto-portal-caddy` at `:8003`). First deploy missed dart-define — rebuilt with `--dart-define=BP_PORTAL_PASS=test-portal-pass`. User confirmed preview visible.
- **⚠️ Deploy note**: BP builds require `--dart-define=BP_PORTAL_PASS=test-portal-pass`. The correct rsync target is `saturn:/srv/dittodatto/business-portal/web/`.
- **User wants**: Next session to `/grill` the establishment page — expand sections, refine layout, iterate on the design.

### Session 2026-06-25 15:54 — PM → Saturn E2E Login
- **Tailscale mesh connectivity fixed**: Changed `TAILNET_IP` to `0.0.0.0`. Applied `consumer_auth` schema to Saturn. E2E login verified on S21. APK distribution live on `:8005`. Merged branch to main.
- **Key facts**: Saturn deploy path for BP: `/srv/dittodatto/business-portal/web/`. Caddy container: `dittodatto-portal-caddy` → `:8003`.

> 📦 Full history: `conductor/pulse-archive/2026-06-25-pre-preview.md`

## 📋 Next Session Suggestions

1. 🔴 **Grill the EstablishmentPage** — `/grill` session to refine sections, add more fields (images, opening hours, social links), expand Dart model, iterate layout/design.
2. 🔴 **Marketplace integration tests** — signup/login/logout/session restore/theme toggle/tab nav against real SDB.
3. 🟡 **BP feature buildout** — continue building Business Portal features beyond Establishments CRUD. Path to MercuryEngine integration.
4. 🟡 **MercuryEngine integration** — plug in booking engine once BP reaches sufficient feature maturity. Deferred until BP is ready.
5. 🟢 **Logo:** User is working on a logo — swap when ready.
