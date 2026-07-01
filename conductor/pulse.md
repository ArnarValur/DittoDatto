# Pulse — Current Project State

**Last Updated:** 2026-07-01 11:56
**Session Focus:** Auth reconciliation + Discovery Phase 5 E2E walkthrough (user-driven)

## 🚀 Active Tracks

- **Discovery Layer** (`discovery_layer_20260630`) — **Phases 1-2+4 complete. Phase 5 E2E in progress (user testing).** Home screen with DittoBar BM25 search, category chips, EstablishmentListingCard deployed to phone. Two-phase detail load via NS VIEWER + `fn::get_establishment_detail()` live. User recreating House of the North under correct company (Dream On AS). Remaining: Phase 5 E2E verification.
- **Booking Flow UI** (`booking_flow_ui_20260630`) — **Phases 1–4 complete. Deployed to phone.** All 5 steps built: service selection (real data), staff (mock), date/time (mock calendar + slots), review (summary + MVA), payment placeholder. 18 unit tests. Remaining: visual polish, ME availability wiring.
- **Favorites Toggle** (`favorites_toggle_20260630`) — **Phases 1–3 functional.** Toggle works on phone. Remaining: widget tests, `pendingFavorite` login-return flow, merge to develop.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn.
- **Ticketing & Events** (`ticketing_events_20260628`) — **New.** Track created. 5 phases.

## ✅ Recently Completed

- **2026-07-01 11:56** — **Auth reconciliation complete.** Switched marketplace discovery from `bp_portal` to `marketplace_reader` NS VIEWER. Deleted 2 dead BP auth files (–413 lines). Updated deploy script dart-defines. Graduated auth service track (Phase 4 was already done). 40/40 marketplace + 72/72 BP widget tests green.
- **2026-07-01 11:24** — **Auth Service track graduated.** Research agent confirmed all Phase 4 deliverables complete: `consumerSignin/Signup` in `ditto_auth`, RECORD ACCESS schemas deployed, marketplace wired, 32 tests. `bp_portal` PASSHASH hardening deferred (blocked on backend intermediary).
- **2026-06-30 23:40** — **Discovery Layer Phases 2 + 4 complete.** Built Marketplace Home (DittoBar BM25, category chips, EstablishmentListingCard). Discovered SurrealDB NS-level VIEWER pattern — eliminated per-DB user provisioning. Built `fn::get_establishment_detail()` server-side function. Replaced 371-line debug pipe with ~50-line service. Deployed to Galaxy S21.
- **2026-06-30 22:06** — **Discovery Layer Phase 1 complete + deployed.** Created `packages/discovery_service/`. Wired BP publish sync. Fixed 3 deploy-time bugs. 24 unit + 5 integration tests. Deployed 3× to Saturn.
- **2026-06-30 20:33** — **Discovery Layer grilled + track created.** ADR-0024, ADR-0025, ADR-0026. 5 glossary terms added. 5-phase track.

> 📦 Full history: `conductor/pulse-archive/2026-07-01.md`

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

None.

## 🧠 Session Memory

### Session 2026-07-01 11:56 — Auth Reconciliation + Discovery Phase 5 E2E

- **Auth reconciliation completed:**
  - Dispatched research agent → full credential audit across all apps.
  - Found: marketplace discovery Home tab was using `bp_portal` (DB EDITOR) instead of `marketplace_reader` (NS VIEWER). Fixed.
  - Found: deploy script had dead `DEBUG_DB_PASS` (from deleted debug pipe). Replaced with `MARKETPLACE_READER_PASS`.
  - Found: 2 dead auth files in BP (`surreal_auth_service.dart`, `surreal_connection.dart`). Deleted (–413 lines).
  - Confirmed: Auth Service Phase 4 (consumer auth) was fully implemented during Marketplace Foundation sessions. Graduated track.
  - Credential model now clean: marketplace uses `marketplace_reader` + `consumer_auth` only. No BP credential leakage.
- **Discovery Phase 5 E2E (user-driven):**
  - User manually testing: delete House of the North → recreate under correct company (Dream On AS) → create establishments for all 3 companies.
  - User deleted House of the North directly from DB (no delete UI in BP — gap identified).
- **BP gaps found during E2E:**
  - 🐛 **No "delete establishment" in BP** — user had to go to DB directly. Needs adding to BP Chapter 2.
  - 🐛 **Kartverket address autocomplete missing from "Ny virksomhet" dialog** — only wired into edit view, not the creation dialog. Map & Geocoding track Phase 7 or BP bugfix.
- **Tests:** 40/40 marketplace widget, 72/72 BP widget — all green.
- **Commit:** `adee391` — `refactor(auth): reconcile marketplace auth — NS VIEWER unification`

### Session 2026-06-30 23:40 — Discovery Layer Phase 2 + 4 (Home + Detail Load)

- **Phase 2 built:** Marketplace Home screen with DittoBar (BM25 full-text, 400ms debounce), category chip row ("Alle" + dynamic from discovery DB), EstablishmentListingCard (cover/logo, rating stars, city). Empty/error states. Shimmer loading. All wired via Riverpod providers + `DiscoveryRepository`.
- **Phase 3 deferred:** Lean skip — city filter exists, full area hierarchy postponed until listing density justifies it.
- **Phase 4 — SurrealDB native feature discovery:**
  - Consulted Sidekick with 5 questions about SDB capabilities.
  - **Key finding:** `DEFINE USER marketplace_reader ON NAMESPACE ROLES VIEWER` — one user covers ALL company DBs. No per-DB provisioning.
  - Added `fn::get_establishment_detail()` to company-blueprint.surql — every company DB gets it.
  - Built `EstablishmentDetailService`: WS connect → signin(NS) → use(company DB) → fn::get_establishment_detail() → close.
- **Post-checkpoint fix:** Renamed all `storefront` → `establishment_detail` (domain naming).

### Session 2026-06-30 22:06 — Discovery Layer Phase 1 Implementation

- **Package created:** `packages/discovery_service/` — barrel export, 3 models, DiscoveryRepository (read), ListingSyncService (write).
- **BP wiring:** `discovery_sync_provider.dart` with connect-use-close pattern. Hooked into `_save()` — sync on publish, deactivate on unpublish, re-sync on any update while published.
- **Bugs caught during deploy:** fire-and-forget auth, UPSERT WHERE, type::thing deprecation, source_id coercion.
- **Lesson learned:** Must run integration tests against real SurrealDB before deploying query changes.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-07-01.md`

## 📋 Next Session Suggestions

1. 🔴 **Discovery Phase 5 completion** — finish E2E: all 3 companies with establishments published, verify on Marketplace, multi-tenant detail load + booking.
2. 🟡 **BP "Ny virksomhet" Kartverket autocomplete** — wire Kartverket address lookup into creation dialog (currently only in edit view).
3. 🟡 **BP delete establishment** — add delete action to establishment list/edit.
4. 🟡 **Deploy BP + Marketplace** — after E2E walkthrough completes, deploy both to Saturn + phone with updated auth.
5. 🟡 **MercuryEngine Availability Wiring** — Replace mock time slots in booking flow.
6. 🟡 **Favorites Toggle polish** — Widget tests, `pendingFavorite` flow, merge.
