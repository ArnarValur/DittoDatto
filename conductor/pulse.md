# Pulse — Current Project State

**Last Updated:** 2026-06-25 13:26
**Session Focus:** Marketplace Foundation — Flutter scaffold, consumer auth implementation, on-device deployment

## 🚀 Active Tracks

- **Marketplace Foundation** (`marketplace_foundation_20260624`) — **In-progress.** Phase 1 (scaffold + nav shell) ✅, Phase 2 (consumer auth) partial — `ditto_auth` consumer methods implemented, screens built, `consumer_auth` schema not yet defined. Phase 3 (profile page) ✅. Verified on Samsung Galaxy S21 (Android 15). Remaining: `consumer_auth` schema, integration tests, Saturn :8004 deploy.
- **Auth Service** (`auth_service_20260624`) — **Paused.** Phases 1-3 ✅. Consumer auth methods now implemented in `ditto_auth` as part of Marketplace Foundation work. Remaining: `consumer_auth` schema on `users/users`, Saturn BP deploy, `bp_portal` hardening.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. BP migrated to `ditto_auth`. Awaiting clean E2E on Saturn.
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed on Saturn.

## ✅ Recently Completed

- **2026-06-25 13:26** — Marketplace Foundation: scaffolded Flutter project, built 3-tab nav shell (Utforsk/Bestillinger/Profil), login/signup screens (Norwegian), profile screen ("Hei, {name}" + date), consumer auth in `ditto_auth` (consumerSignin/consumerSignup/tryRestoreConsumer + TokenStore consumer session). Deployed to Samsung Galaxy S21 via USB debugging. App name changed from "marketplace" to "DittoDatto" across platforms. Android Studio + emulator readiness verified (GPU enabled, RAM bumped on AVD).
- **2026-06-24 19:27** — Auth Service track: Phases 1-3 complete. `ditto_auth` package built, BP migrated.
- **2026-06-24 16:17** — Auth Service track: created with spec + plan + Phase 1 research. ADR-0019.
- **2026-06-24 15:12** — Grill session: ADR-0017, ADR-0018. Saturn DB wiped clean.
- **2026-06-23 20:21** — Deploy gate passed (50 admin + 21 BP tests green). Deployed both apps.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🔴 **`consumer_auth` RECORD ACCESS not defined.** The schema on `users/users` needs a `DEFINE ACCESS consumer_auth` definition before signup/login can work end-to-end. Parallel session may be handling this.
- 🔴 **Clean E2E blocked.** BP hasn't been deployed to Saturn with `ditto_auth` yet.
- 🟡 **No post-deploy verification.** Deploy gate tests logic against local DB, not the deployed product.

## 🧠 Session Memory

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

### Session 2026-06-24 19:27 — ditto_auth build + BP migration
- `ditto_auth` package created: 12 source files, swappable `AuthBackend` interface
- Schema hardened: `bp_auth` role gate + durations
- BP migrated to `ditto_auth`. Test results: 11 + 21 🟢
- Marketplace grill: ADR-0020 (Anonymous Browsing), glossary terms added

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔴 **Define `consumer_auth` RECORD ACCESS** on `users/users` schema. Then test signup/login on-device.
2. 🔴 **Deploy BP to Saturn** with `ditto_auth`. Build + deploy + manual E2E.
3. 🟡 **Integration tests** for Marketplace consumer auth flow (signup → profile → signout → signin).
4. 🟡 **Saturn deploy** for Marketplace at `:8004` (Caddy config + rsync).
5. 🟢 **Logo:** User is working on a logo — swap when ready.
