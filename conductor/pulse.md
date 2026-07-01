# Pulse — Current Project State

**Last Updated:** 2026-07-01 16:50
**Session Focus:** BP Establishment Config — full track execution (Phases 1–3) + deployment

## 🚀 Active Tracks

- **BP Establishment Config** (`bp_establishment_config_20260701`) — **Phases 1–3 COMPLETE. Deployed to Saturn + phone.** Schema migrated, 4 models built, 5 new BP edit sections wired. Phase 4 Marketplace display deferred to co-joined ME session.
- **Discovery Layer** (`discovery_layer_20260630`) — **Phase 5 E2E COMPLETE.** Detail page, service groups, services, booking UI all verified on phone. Ready to graduate.
- **Booking Flow UI** (`booking_flow_ui_20260630`) — **Phases 1–4 complete. Deployed to phone.** All 5 steps built. 18 unit tests. Remaining: visual polish, ME availability wiring.
- **Favorites Toggle** (`favorites_toggle_20260630`) — **Phases 1–3 functional.** Toggle works on phone. Remaining: widget tests, `pendingFavorite` login-return flow, merge to develop.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn.
- **Ticketing & Events** (`ticketing_events_20260628`) — **New.** Track created. 5 phases.

## ✅ Recently Completed

- **2026-07-01 16:50** — **BP Establishment Config Phases 1–3 complete + deployed.** 3 commits: schema migration (28 files), opening hours + social links + type selector (3 files), booking policy + reservation config (3 files). Saturn schema wiped + reapplied. BP deployed :8003, Marketplace redeployed to phone. 72 BP tests, 54 integration tests, 91 establishment_ui tests all green.
- **2026-07-01 13:40** — **Discovery Phase 5 E2E complete.** Detail page works on phone (timeout fix deployed). Services + service groups created on Dream On AS, appear in booking UI. All 5 discovery phases done.
- **2026-07-01 12:53** — **Marketplace WS timeout hardening.** Added 10s timeouts to all WS operations. Created `AppEventLog` ring buffer. Commit: `001540d`.
- **2026-07-01 12:15** — **BP bugfixes deployed to Saturn.** Media picker state refresh, Kartverket autocomplete in creation dialog. 72/72 widget + 54/54 integration tests green.
- **2026-07-01 11:56** — **Auth reconciliation complete.** Switched marketplace discovery from `bp_portal` to `marketplace_reader` NS VIEWER.

> 📦 Full history: `conductor/pulse-archive/2026-07-01.md`

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None

## 🧠 Session Memory

### Session 2026-07-01 16:50 — BP Establishment Config Full Track

- **Track: `bp_establishment_config_20260701`** — Executed Phases 1–3 in a single session.

- **Phase 1 (commit `91ec570`, 28 files):**
  - Schema: `store_type` → `establishment_type`, removed `booking_form_type`, `social_links` → `array<object>`, `large_party_handling` updated.
  - 4 new Dart models: `OpeningDay`, `BookingPolicy`, `SocialLink`, `ReservationConfig`.
  - Unified `BusinessType` → `EstablishmentType` enum across 28 files (BP + establishment_ui).
  - 133 tests passed (establishment_ui 91 + BP unit 25 + BP widget 17).

- **Phase 2 (commit `e755ae9`, 3 files):**
  - `SegmentedButton<EstablishmentType>` type selector in Generelt section.
  - `OpeningHoursSection`: 7-day schedule with toggle, time pickers, copy-to-all.
  - `SocialLinksSection`: dynamic list with platform dropdown, URL field, add/remove.
  - 72 BP tests passed.

- **Phase 3 (commit `781fa68`, 3 files):**
  - `BookingPolicySection`: 9-field editor (steppers, toggles, segmented slot interval, confirmation message).
  - `ReservationConfigSection`: restaurant-only (ADR-0027), 10 fields (max guests, large party radios, duration/buffer/capacity, auto-confirm).
  - 72 BP tests passed.

- **Saturn deployment:**
  - Wiped `company_dream-on-as` data (establishment, media, services) + discovery listings.
  - Removed old schema fields (`store_type`, `booking_form_type`, `social_links.fb/ig/x`).
  - Reapplied clean schema. BP deployed to :8003 (hash verified + smoke OK).
  - Marketplace redeployed to phone (fixed `Null is not subtype of String` crash from stale compiled code).

- **Decisions (Pulse):**
  - Wiped Saturn data instead of migration script — only one establishment, clean slate faster.
  - Phase 4 Marketplace display (opening hours + social links) deferred to co-joined ME session.

### Session 2026-07-01 12:53 — Detail Page Debug + WS Timeout Hardening

- Detail page hang resolved (Tailscale mesh). WS timeout + event logging added. Schema hotfix on 3 company DBs. Discovery Phase 5 E2E complete. BP audit → /grill → /new-track for establishment config.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-07-01.md`

## 📋 Next Session Suggestions

1. 🔴 **Co-joined ME + BP session** — Wire ME booking engine to read `booking_policy`, `opening_schedule`, `reservation_config` from company DB. Settle auth token bridge. Test one vertical slice (restaurant with full config).
2. 🟡 **Marketplace opening hours + social links display** — `OpeningScheduleHelper.isOpenNow()`, status text, social link icons row. (Phase 4 remainder.)
3. 🟡 **BP delete operations** — Delete establishment, services, companies.
4. 🟡 **Discovery Layer graduation** — Phase 5 complete, move to Completed Tracks.
5. 🟡 **Booking persistence** — Store bookings in company DB + notify business.
