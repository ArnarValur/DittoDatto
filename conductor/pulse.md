# Pulse — Current Project State

**Last Updated:** 2026-06-25 14:44
**Session Focus:** BP Establishment Bug Fix — NULL→NONE, error handling, integration tests, UX tweaks, deploy

## 🚀 Active Tracks

- **Marketplace Foundation** (`marketplace_foundation_20260624`) — **In-progress.** Phase 1 ✅, Phase 2 ✅ (consumer_auth + cross-role RBAC + 24 tests), Phase 3 ✅. Remaining: Saturn SDB connectivity via Tailscale, on-device E2E against Saturn, Saturn deploy.
- **Auth Service** (`auth_service_20260624`) — **In-progress.** Phases 1-3 ✅, Phase 2 consumer tasks ✅. Phase 4 consumer wiring ✅. Cross-role RBAC fix applied. Remaining: apply schema to Saturn, `bp_portal` hardening.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Phase 5 E2E task ✅: NULL→NONE fix, error handling, 11 CRUD integration tests (32 total), sidebar highlight fix, business type locked in edit view. Deployed to Saturn. Remaining: responsive layout verification, coverage gate.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed on Saturn.

## ✅ Recently Completed

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

- 🔴 **Saturn SDB not reachable from phone.** Tailscale service `dittodatto` exposes tcp:8001-8005 (web apps) but NOT SurrealDB's port (8000). Phone needs Tailscale or a new service endpoint for SDB.
- 🔴 **Saturn schema outdated.** `consumer_auth` on Saturn still has the old `AND role = 'customer'` gate. Need to apply updated definition.
- 🟡 **No post-deploy verification.** Deploy gate tests logic against local DB, not the deployed product.
- 🟡 **No marketplace-level tests.** `apps/marketplace/test/` is empty — package-level tests cover auth logic.

## 🧠 Session Memory

### Session 2026-06-25 14:44 — BP Establishment Bug Fix + Integration Tests
- **3 bugs fixed in establishment creation**: (1) `toJson()` sent null for optional fields — SCHEMAFULL rejects JSON null for `option<T>`. Fixed by only including non-null keys. (2) `_handleSave` and `create()` had no try-catch — errors went uncaught to console. Added error handling with Norwegian snackbar. (3) `is_published` lacked `DEFAULT false` in schema — required explicit value on create.
- **Update path also fixed**: `updateEstablishment` MERGE had the same null serialization issue.
- **11 CRUD integration tests written**: CREATE (5 — store/restaurant/venue/full fields/NULL→NONE regression), READ (2 — SELECT all/fromJson round-trip), UPDATE (1 — MERGE preserves untouched fields), DELETE (1), Schema validation (2 — invalid type ASSERT, slug UNIQUE). All against real SurrealDB.
- **Schema applied to Saturn**: `DEFINE FIELD OVERWRITE is_published ON establishment TYPE bool DEFAULT false` on both `company_dittodatto-as` and `company_merkurial-studio`.
- **UX tweaks**: (1) Business type selector removed from edit view — type is set at creation, cannot change (each type maps to a different booking system). (2) Sidebar highlight fixed — child routes (e.g. `/establishments/:id`) now correctly highlight parent nav item via prefix matching instead of exact match.
- **User verified data persistence**: Queried Saturn SDB — DittoDatto AS establishment has all fields correctly saved including updated_at timestamp.

### Session 2026-06-25 14:42 — Cross-role RBAC + Tailscale connectivity
- **Hierarchical RBAC applied**: Removed role gate from `consumer_auth` SIGNIN. All roles (`customer`, `business`, `admin`, `super_admin`) can now sign into the marketplace. User clarified: roles are hierarchical — higher includes lower. This was always the intent, not a design reversal.
- **On-device deploy confirmed working**: S21 connected via ADB reverse, app talks to local SDB. User attempted login with their Saturn credentials → failed correctly (local DB doesn't have those users). Proves the WebSocket path works.
- **Tailscale connectivity identified as next friction**: Saturn is on Tailscale as `dittodatto` service (`100.121.237.101`, `saturn.tailb251cd.ts.net`). Current service exposes tcp:8001-8005 (web apps). SurrealDB port (8000) NOT exposed. Options: (1) add port 8000 to the Tailscale service, (2) create a separate Tailscale service for Saturn's DB layer, (3) phone joins Tailscale network.
- **User wants to stay on Tailscale network for dev/staging** — no cloud hosting for BP/PM until future decision. Tailscale is the connectivity layer.

### Session 2026-06-25 14:00 — Consumer Auth schema + integration tests
- **`consumer_auth` RECORD ACCESS defined** in `schemas/users.surql`. SIGNUP creates `user` with `role='customer'`, argon2 hashed password, all SCHEMAFULL fields. SIGNIN role-gated (`AND role = 'customer'`). Durations: 24h token / 24h session (`WITH REFRESH` deferred — Dart SDK compat).
- **13 integration tests** in `packages/ditto_auth/test/integration/consumer_auth_test.dart`: signup (3), signin (5), session restore (2), signout (1), role isolation (2). All green alongside 11 business tests = **24 total**.
- **Discovered `username` UNIQUE index gotcha**: SIGNUP clause doesn't set `username` (it's `option<string>`). Multiple null usernames collide on the UNIQUE index if leftover records exist. Tests pass on clean DB — not a real-world issue since each user gets a unique email, but the `idx_user_username` UNIQUE constraint on an optional field should be reviewed in the future security sweep.
- **Token duration decision**: 24h/24h chosen over 15m/24h to avoid surprise logouts on mobile while `WITH REFRESH` is deferred.

### Session 2026-06-25 13:26 — Marketplace Foundation build + on-device verification
- **Marketplace scaffolded:** `apps/marketplace/` — Flutter project targeting Android/iOS/web. Added to pub workspace. Dependencies: `ditto_auth`, `ditto_design`, `mercury_client`, `flutter_riverpod`, `go_router`, `google_fonts`, `intl`.
- **Navigation shell:** `StatefulShellRoute.indexedStack` with 3 branches. Norwegian labels (Utforsk/Bestillinger/Profil). `NavigationBar` (Material 3). Anonymous browsing (ADR-0020) — only Profile tab is auth-gated.
- **Auth screens built:** Login (email + password, validation, error snackbar) and Signup (name + email + password + confirm, 8-char min, match check). Norwegian throughout.
- **Profile screen:** "Hei, {firstName} 👋" + "I dag er {datetime}" (nb_NO locale via `intl`). Initials avatar, email display, sign out button, dark mode toggle.
- **Consumer auth implemented in `ditto_auth`:** `consumerSignin()` (RECORD ACCESS with `consumer_auth` access method), `consumerSignup()` (SurrealDB `.signup()` call), `tryRestoreConsumer()` (token-based session restore). `TokenStore` extended with `saveConsumerSession`/`loadConsumerSession` + `StoredConsumerSession` class. Session type key (`business`/`consumer`) for disambiguation.
- **`SurrealAuthBackend` API changes:** `_extractFirstRow` → `extractFirstRow` (public static), `_deriveWsUrl` → `deriveWsUrl` (public static). Both needed by `DittoAuth.consumerSignup()`.
- **Android environment verified:** Samsung Galaxy S21 Ultra (SM-G998B, Android 15, API 35, arm64) connected via ADB. KVM acceleration working (AMD Ryzen AI 7 350). 3 AVDs configured. Pixel 7 AVD fixed: GPU enabled, RAM bumped 1536→2048MB. `flutter doctor -v` clean.
- **On-device deployment:** Release build to S21 successful. Impeller/Vulkan rendering. `google_fonts` errors (no internet on USB-only) — harmless fallback to system fonts.
- **App renamed:** Android label, iOS CFBundleName, web title all changed from "marketplace" to "DittoDatto".
- **UX fix:** Bottom nav bar was disappearing on login/signup screens. Root cause: auth routes were top-level (outside `StatefulShellRoute`). Fix: moved login/signup as sub-routes under the Profile branch (`/login` → `/profile/login`, `/signup` → `/profile/signup`). Now the `NavigationBar` persists across all screens.

### Session 2026-06-24 19:27 — ditto_auth build + BP migration
- `ditto_auth` package created: 12 source files, swappable `AuthBackend` interface
- Schema hardened: `bp_auth` role gate + durations
- BP migrated to `ditto_auth`. Test results: 11 + 21 🟢
- Marketplace grill: ADR-0020 (Anonymous Browsing), glossary terms added

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔴 **Tailscale connectivity for phone → Saturn SDB.** Either add port 8000 to `dittodatto` service, create new DB service, or install Tailscale on phone. Then point marketplace app at `ws://dittodatto:8000/rpc`.
2. 🔴 **Apply updated `consumer_auth` schema to Saturn.** SSH into Saturn, run `DEFINE ACCESS consumer_auth` with role-gate-removed SIGNIN.
3. 🟡 **BP responsive layout verification** — Phase 5 remaining task. Test on mobile/tablet/desktop viewports.
4. 🟡 **Real E2E on phone.** Once connectivity + schema are sorted: login with `arnarvalur@avj.info`, test signup, test session restore.
5. 🟡 **Saturn deploy** for Marketplace at `:8004`.
6. 🟢 **Logo:** User is working on a logo — swap when ready.
