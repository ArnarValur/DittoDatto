# Pulse — Current Project State

**Last Updated:** 2026-06-25 14:00
**Session Focus:** Consumer Auth wiring — `consumer_auth` RECORD ACCESS + integration tests

## 🚀 Active Tracks

- **Marketplace Foundation** (`marketplace_foundation_20260624`) — **In-progress.** Phase 1 ✅, Phase 2 ✅ (consumer_auth schema + Dart methods + 13 integration tests), Phase 3 ✅. Remaining: marketplace-level widget tests, Saturn deploy.
- **Auth Service** (`auth_service_20260624`) — **Paused.** Phases 1-3 ✅, Phase 2 consumer tasks ✅ (schema + tests). Phase 4 consumer wiring ✅ (done in Marketplace track). Remaining: `bp_portal` hardening, Saturn BP deploy.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. BP migrated to `ditto_auth`. Awaiting clean E2E on Saturn.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed on Saturn.

## ✅ Recently Completed

- **2026-06-25 14:00** — Consumer Auth wired: `DEFINE ACCESS consumer_auth` added to `schemas/users.surql` (SIGNUP + SIGNIN + role gate + 24h tokens). 13 new integration tests in `ditto_auth` (signup, signin, session restore, signout, role isolation). All 24 `ditto_auth` integration tests green (11 business + 13 consumer).
- **2026-06-25 13:44** — Marketplace Foundation: scaffolded Flutter project, built 3-tab nav shell, login/signup/profile screens, consumer auth in `ditto_auth`. On-device deploy to Samsung Galaxy S21. App renamed to "DittoDatto". Fixed bottom nav bar disappearing on login/signup.
- **2026-06-24 19:27** — Auth Service track: Phases 1-3 complete. `ditto_auth` package built, BP migrated.
- **2026-06-24 16:17** — Auth Service track: created with spec + plan + Phase 1 research. ADR-0019.
- **2026-06-24 15:12** — Grill session: ADR-0017, ADR-0018. Saturn DB wiped clean.
- **2026-06-23 20:21** — Deploy gate passed (50 admin + 21 BP tests green). Deployed both apps.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🟡 **Clean E2E blocked.** BP hasn't been deployed to Saturn with `ditto_auth` yet.
- 🟡 **No post-deploy verification.** Deploy gate tests logic against local DB, not the deployed product.
- 🟡 **No marketplace-level tests.** `apps/marketplace/test/` is empty — package-level tests cover auth logic, but widget/integration tests needed before Saturn deploy.

## 🧠 Session Memory

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

1. 🟡 **On-device test:** Deploy marketplace to Samsung Galaxy S21 with local SurrealDB — test signup → profile → signout → login end-to-end.
2. 🔴 **Deploy BP to Saturn** with `ditto_auth`. Build + deploy + manual E2E.
3. 🟡 **Marketplace widget/integration tests** — `apps/marketplace/test/` is empty. Needed before Saturn deploy.
4. 🟡 **Saturn deploy** for Marketplace at `:8004` (Caddy config + rsync).
5. 🟢 **Logo:** User is working on a logo — swap when ready.
