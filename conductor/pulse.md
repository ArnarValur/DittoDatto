# Pulse — Current Project State

**Last Updated:** 2026-06-24 19:27
**Session Focus:** `ditto_auth` package — Phase 1 design, Phase 2 implementation, Phase 3 BP migration

## 🚀 Active Tracks

- **Auth Service** (`auth_service_20260624`) — **Paused.** Phase 1 (research + design) ✅, Phase 2 (business auth + schema) ✅, Phase 3 (BP migration) ✅. Paused until Marketplace foundation lands for Phase 4 (consumer auth). Remaining: deploy BP to Saturn, consumer auth, `bp_portal` provisioning hardening.
- **BP Login + Establishments** (`bp_login_establishments_20260614`) — In-progress. Awaiting clean E2E (blocked on BP deploy with new `ditto_auth`).
- **Admin Panel** (`admin_panel_20260527`) — In-progress. 50/50 integration tests green. Deployed on Saturn.

## ✅ Recently Completed

- **2026-06-24 19:27** — Auth Service track: Phases 1-3 complete. `ditto_auth` package built (12 files), `bp_auth` schema hardened (role gate + 15m/8h durations), BP migrated to `ditto_auth`. 11 ditto_auth + 21 BP integration tests green. `WITH REFRESH` deferred (Dart SDK compat). Design doc: `design.md`. Track paused for Marketplace.
- **2026-06-24 16:17** — Auth Service track: created `auth_service_20260624` with spec interview (5 questions), plan (4 phases), and 4/5 Phase 1 research tasks. ADR-0019 (SurrealDB-native auth architecture).
- **2026-06-24 15:12** — Grill session: ADR-0017, ADR-0018. Saturn DB wiped clean, schemas re-applied.
- **2026-06-24 09:31** — Fixed two deployment-only bugs: blueprint asset path + password mismatch.
- **2026-06-23 20:21** — Deploy gate passed (50 admin + 21 BP tests green). Deployed both apps.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- 🔴 **Clean E2E blocked.** BP now uses `ditto_auth` but hasn't been deployed to Saturn yet. Need: build + deploy + manual E2E verification.
- ~~🟡 **`bp_auth` has no role gate.**~~ ✅ FIXED. Role gate added: `AND role IN ['business', 'admin', 'super_admin']`. Verified by integration tests.
- 🟡 **No post-deploy verification.** Deploy gate tests logic against local DB, not the deployed product.

## 🧠 Session Memory

### Session 2026-06-24 19:27 — ditto_auth build + BP migration
- **`ditto_auth` package created:** `packages/ditto_auth/` — 12 source files, swappable `AuthBackend` interface, `TokenStore`, `TenantConnection`, sealed exception hierarchy
- **Schema hardened:** `bp_auth` role gate + durations (15m token / 8h session). `WITH REFRESH` removed — Dart surrealdb SDK throws when response format changes. Deferred to SDK investigation.
- **BP migrated:** `auth_provider.dart` → `DittoAuth`, `establishment_providers.dart` → `TenantConnection`, `portal_shell.dart` → `tenantConnectionProvider`. Old `surreal_auth_service.dart` and `surreal_connection.dart` no longer imported by app code (still exist for legacy test coverage).
- **Design decisions resolved:** AuthState stays in `mercury_client`. Token durations adjustable later. `bp_portal` credential proxy is future infrastructure.
- **Test results:** `ditto_auth` 11/11 🟢, BP 21/21 🟢 (1 test updated: customer role gate now DB-level)
- **Marketplace context:** Grill happening in parallel — silver thread is signup/login + profile page for Android/iOS foundation. Consumer auth in `ditto_auth` ready for Phase 4 when Marketplace lands.

### Session 2026-06-24 16:17 — Auth Service track creation + research
- Auth Service track created. Phase 1 research 4/5 tasks complete.
- Key findings: `WITH REFRESH` works, PASSHASH works, `bp_auth` needs role gate.
- ADR-0019 recorded.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## 📋 Next Session Suggestions

1. 🔴 **Deploy BP to Saturn** with `ditto_auth`. Build + deploy + manual E2E: login → establishments.
2. 🔴 **Public Marketplace foundation.** Android/iOS setup, signup/login screens, profile page. Then wire `ditto_auth.consumerSignin()`/`consumerSignup()`.
3. 🟡 **Clean E2E:** Admin Panel → create user → create company → verify BP login as that company.
4. 🟡 **Glossary update:** Add `ditto_auth`, `consumer_auth`, `TenantConnection` to `conductor/context.md`.
