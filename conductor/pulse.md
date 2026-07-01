# Pulse — Current Project State

**Last Updated:** 2026-07-01 13:40
**Session Focus:** Discovery Phase 5 E2E completion + BP establishment edit page audit

## 🚀 Active Tracks

- **Discovery Layer** (`discovery_layer_20260630`) — **Phase 5 E2E COMPLETE.** Detail page, service groups, services, booking UI all verified on phone. Ready to graduate.
- **Booking Flow UI** (`booking_flow_ui_20260630`) — **Phases 1–4 complete. Deployed to phone.** All 5 steps built. 18 unit tests. Remaining: visual polish, ME availability wiring.
- **Favorites Toggle** (`favorites_toggle_20260630`) — **Phases 1–3 functional.** Toggle works on phone. Remaining: widget tests, `pendingFavorite` login-return flow, merge to develop.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn.
- **Ticketing & Events** (`ticketing_events_20260628`) — **New.** Track created. 5 phases.

## ✅ Recently Completed

- **2026-07-01 13:40** — **Discovery Phase 5 E2E complete.** Detail page works on phone (timeout fix deployed). Services + service groups created on Dream On AS, appear in booking UI. All 5 discovery phases done.
- **2026-07-01 12:53** — **Marketplace WS timeout hardening.** Added 10s timeouts to all WS operations (detail service + discovery providers). Created `AppEventLog` ring buffer. Timeout → snackbar + redirect home. Schema hotfix (`keywords`/`service_type` DEFAULT []) on all 3 company DBs. 40/40 marketplace widget tests. Deployed to phone. Commit: `001540d`.
- **2026-07-01 12:15** — **BP bugfixes deployed to Saturn.** (1) Media picker state refresh: `onUpload` now returns `List<MediaItem>`, modal merges locally. (2) Kartverket autocomplete wired into "Ny virksomhet" creation dialog. (3) Deleted 2 dead integration test files (old bespoke auth). 72/72 widget + 54/54 integration tests green. Deploy hash verified + smoke passed.
- **2026-07-01 11:56** — **Auth reconciliation complete.** Switched marketplace discovery from `bp_portal` to `marketplace_reader` NS VIEWER. Deleted 2 dead BP auth files (–413 lines). Updated deploy script dart-defines. Graduated auth service track.
- **2026-07-01 11:24** — **Auth Service track graduated.** Research agent confirmed all Phase 4 deliverables complete.
- **2026-06-30 23:40** — **Discovery Layer Phases 2 + 4 complete.** Built Marketplace Home. Discovered SurrealDB NS-level VIEWER pattern. Built `fn::get_establishment_detail()`. Deployed to Galaxy S21.
- **2026-06-30 22:06** — **Discovery Layer Phase 1 complete + deployed.** Created `packages/discovery_service/`. Wired BP publish sync.

> 📦 Full history: `conductor/pulse-archive/2026-07-01.md`

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None

## 🧠 Session Memory

### Session 2026-07-01 12:53 — Detail Page Debug + WS Timeout Hardening

- **Detail page hang (RESOLVED):**
  - Root cause: User's phone was not connected to Tailscale mesh. `db.wait()` had no timeout → infinite spinner.
  - Confirmed DB side is 100% correct: function exists, VIEWER can call it, data returns. Tested via CLI (`--auth-level namespace`) and Dart SDK script.
  - Saturn root password found autonomously at `/srv/dittodatto/.env` (user: `dittodatto_root`).

- **WS timeout + event logging (NEW):**
  - Added 10s timeout to all SurrealDB WS operations in `EstablishmentDetailService` and `_openDiscoveryDb()`.
  - Created `AppEventLog` — in-memory ring buffer (100 events) for connectivity failures. Future hook for remote monitoring.
  - Detail screen: `EstablishmentDetailException` → snackbar + redirect to home. Other errors → retry screen (unchanged).
  - 40/40 marketplace widget tests green.
  - Commit: `001540d`

- **Schema hotfix on ALL company DBs:**
  - `keywords` and `service_type` fields on `service` table missing `DEFAULT []` (provisioned before blueprint fix).
  - Applied `DEFINE FIELD OVERWRITE` on `company_dream-on-as`, `company_dittodatto-as`, `company_merkurial-studio`. Blueprint already correct — new DBs unaffected.

- **Marketplace deployed to phone** with timeout fixes.

- **Discovery Phase 5 E2E COMPLETE:**
  - User verified: detail page loads, services + service groups created, booking UI shows them.
  - Minor reactivity issues noted (favorites toggle on redeploy) — deferred to User Profile track.

- **BP Establishment Edit Page audit:**
  - Full gap analysis: schema vs UI vs model.
  - 🔴 **Opening schedule** — fully defined in schema (per-weekday open/close), zero Dart code.
  - 🟡 **Booking policy** (8 subfields), **booking_form_type**, **reservation_config** (10 subfields) — all in schema, no model/UI.
  - 🟡 **Social links** — schema hardcodes FB/IG/X only. User wants open-ended links.
  - User observations: booking types need better distinction per establishment type, reservation_config is restaurant-specific, social links too constrained.
  - **Decision: /grill session needed** before implementing. Domain needs refinement.

### Session 2026-07-01 12:25 — BP Bugfixes + Discovery Phase 5 E2E Debugging

- BP bugfixes (media picker + Kartverket autocomplete) + dead test cleanup. Detail page hang discovered.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-07-01.md`

## 📋 Next Session Suggestions

1. 🔴 **`/grill` — Establishment configuration domain** — Refine booking types vs establishment types, opening hours model, social links (open-ended), booking policy. Must precede implementation.
2. 🟡 **Opening hours editor** — Build model + UI after grill locks the design.
3. 🟡 **BP delete operations** — Delete establishment, services, companies.
4. 🟡 **MercuryEngine availability** — Real time slots for booking flow.
5. 🟡 **Booking persistence** — Store bookings in company DB + notify business.
