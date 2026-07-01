# Pulse — Current Project State

**Last Updated:** 2026-07-01 19:20
**Session Focus:** ME ↔ Booking UI Wiring — Delegated Trust auth bridge, BookingRepository, callback injection into booking_ui, opening hours display

## 🚀 Active Tracks

- **ME ↔ Booking UI Wiring** (`me_booking_wiring_20260701`) — **Phases 1–3 partial complete. Deployed to phone.** Auth bridge (ADR-0032), BookingRepository (13 tests), callback injection into booking_ui. E2E wiring confirmed: phone → ME API → clean 400 (ME config alignment needed).
- **BP Establishment Config** (`bp_establishment_config_20260701`) — **Phases 1–4 COMPLETE.** Schema migrated, 4 models built, 5 new BP edit sections, opening hours + open/closed badge in Marketplace. Deployed.
- **Discovery Layer** (`discovery_layer_20260630`) — **Phase 5 E2E COMPLETE.** Graduated.
- **Booking Flow UI** (`booking_flow_ui_20260630`) — **Phases 1–4 complete. Deployed to phone.** All 5 steps built. 18 unit tests. Now wired to ME API via callback injection.
- **Favorites Toggle** (`favorites_toggle_20260630`) — **Phases 1–3 functional.** Toggle works on phone. Remaining: widget tests, `pendingFavorite` login-return flow, merge to develop.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn.
- **Ticketing & Events** (`ticketing_events_20260628`) — **New.** Track created. 5 phases.

## ✅ Recently Completed

- **2026-07-01 19:20** — **ME ↔ Booking UI Wiring Phases 1–3 + Opening Hours.** Auth bridge (ADR-0032, 66/66 ME tests), BookingRepository (5 models, 13/13 tests), callback injection into booking_ui (async slot fetch + loading/error/cache), DittoAuth.getConsumerToken(), opening hours section + open/closed badge. Schema migration fix (establishment_type on 2 company DBs). Deployed to phone. E2E wiring confirmed: phone → ME API → 400 (ME config alignment needed next).
- **2026-07-01 16:50** — **BP Establishment Config Phases 1–3 complete + deployed.** 3 commits: schema migration (28 files), opening hours + social links + type selector (3 files), booking policy + reservation config (3 files). Saturn schema wiped + reapplied. BP deployed :8003, Marketplace redeployed to phone.
- **2026-07-01 13:40** — **Discovery Phase 5 E2E complete.** Detail page works on phone (timeout fix deployed). Services + service groups created on Dream On AS, appear in booking UI.
- **2026-07-01 12:53** — **Marketplace WS timeout hardening.** Added 10s timeouts to all WS operations. Created `AppEventLog` ring buffer.
- **2026-07-01 12:15** — **BP bugfixes deployed to Saturn.** Media picker state refresh, Kartverket autocomplete in creation dialog.
- **2026-07-01 11:56** — **Auth reconciliation complete.** Switched marketplace discovery from `bp_portal` to `marketplace_reader` NS VIEWER.

> 📦 Full history: `conductor/pulse-archive/2026-07-01.md`

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None

## 🧠 Session Memory

### Session 2026-07-01 19:20 — ME ↔ Booking UI Wiring

- **Track: `me_booking_wiring_20260701`** — Executed Phases 1–3 (partial) + bonus opening hours feature.

- **Phase 1: Auth Bridge (commits `5ba95de`, `47ba847`):**
  - ADR-0032: Delegated Trust Auth Bridge — ME accepts SurrealDB JWTs without signing key.
  - `verify_via_surrealdb()` in `auth.py`: ephemeral SDB connection → authenticate → info → role map.
  - `ACCESS_METHOD_ROLES`: consumer_auth→user, bp_auth→operator.
  - 66/66 ME tests green, ruff clean.
  - Housekeeping: ADR renumber collision (0027/0028 → 0030/0031), Discovery Layer graduated, relay archive trimmed.

- **Phase 2: BookingRepository (commit `94ca9f6`):**
  - 5 Dart models: TimeSlot, HoldResponse, BookingConfirmation, BookingListItem, CancelResponse.
  - BookingRepository: 6 methods (getAvailability, holdSlot, confirmBooking, getBookings, getBookingById, cancelBooking).
  - Bearer token passthrough for Delegated Trust. 13/13 tests green.

- **Phase 3: Callback injection (commit `abca9fb`):**
  - BookingFlowPage: optional `onFetchSlots`, `staffList`, `onConfirmBooking` — defaults to mocks.
  - DateTimeSelectionStep: async slot fetching with loading/error/cache.
  - StaffSelectionStep: accepts optional real staff list.
  - DittoAuth.getConsumerToken(): exposed SurrealDB JWT for ME API.
  - BookingScreen: wired to BookingRepository with consumer JWT.
  - Router: companySlug threaded to booking route.

- **Opening hours feature (commit `f7fdb67`):**
  - `OpeningSchedule` model moved to shared establishment_ui package.
  - `EstablishmentHoursSection`: Åpningstider card below map.
  - Open/Closed badge: computed from opening_schedule + timezone.
  - BP re-exports from shared package.

- **Bonus fix:** Applied missing `establishment_type` field to 2 company DBs on Saturn (schema migration gap).

- **E2E verification:** Phone → BookingScreen → BookingRepository → ME :8005 → clean 400 error (table 'establishment' does not exist). Confirms full pipeline wiring works. ME config alignment is the next step.

- **Decisions (Pulse):**
  - Callback injection pattern over Riverpod in booking_ui — keeps UI package framework-agnostic.
  - `MERCURY_URL` dart-define added for phone builds (default `http://dittodatto:8005`).

### Session 2026-07-01 16:50 — BP Establishment Config Full Track

- Track: `bp_establishment_config_20260701` — Executed Phases 1–3 in a single session. Details in pulse-archive.

### Session 2026-07-01 12:53 — Detail Page Debug + WS Timeout Hardening

- Detail page hang resolved (Tailscale mesh). WS timeout + event logging added. Schema hotfix on 3 company DBs. Discovery Phase 5 E2E complete. BP audit → /grill → /new-track for establishment config.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-07-01.md`

## 📋 Next Session Suggestions

1. 🔴 **ME config alignment** — Teach ME to read `booking_policy`, `opening_schedule`, `reservation_config` from company DBs. The `/availability` endpoint fails with "table 'establishment' does not exist" — ME needs company DB access.
2. 🔴 **Hold/Confirm wiring (Steps 4–5)** — Wire `holdSlot()` on review step entry, confirm on payment, handle hold expiry (410 → redirect).
3. 🟡 **Real staff list** — Staff CRUD in BP, then pass real staff to booking flow.
4. 🟡 **401 refresh + timeout handling** — Token expired → ditto_auth refresh → retry. ME unreachable → snackbar.
5. 🟡 **Marketplace integration tests** — Flagged gap: no integration test suite for marketplace app.
