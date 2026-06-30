# Pulse — Current Project State

**Last Updated:** 2026-06-30 22:06
**Session Focus:** Discovery Layer Phase 1 — package scaffold, models, sync, BP wiring, deploy + verify

## 🚀 Active Tracks

- **Discovery Layer** (`discovery_layer_20260630`) — **Phase 1 complete. Deployed to Saturn.** BP publish sync writes to `companies/discovery` on save. 24 package + 5 integration tests. Remaining phases: (2) Home Screen + DittoBar, (3) Areas + Geo, (4) Two-Phase Detail Load, (5) Verify + Deploy.
- **Booking Flow UI** (`booking_flow_ui_20260630`) — **Phases 1–4 complete. Deployed to phone.** All 5 steps built: service selection (real data), staff (mock), date/time (mock calendar + slots), review (summary + MVA), payment placeholder. 18 unit tests. Remaining: visual polish, ME availability wiring.
- **Favorites Toggle** (`favorites_toggle_20260630`) — **Phases 1–3 functional.** Toggle works on phone. Remaining: widget tests, `pendingFavorite` login-return flow, merge to develop.
- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn.
- **Services Section** (`services_section_20260628`) — **Completed.** All 4 phases done.
- **Ticketing & Events** (`ticketing_events_20260628`) — **New.** Track created. 5 phases.

## ✅ Recently Completed

- **2026-06-30 22:06** — **Discovery Layer Phase 1 complete + deployed.** Created `packages/discovery_service/` (models, DiscoveryRepository, ListingSyncService). Wired BP publish sync into establishment edit view. Fixed 3 bugs during deploy verification: fire-and-forget auth (→ connect-use-close), `type::thing` → `type::record`, `source_id` record ref coercion (`<string>` cast). 24 package unit tests + 5 integration tests (real SurrealDB). Deployed 3× to Saturn, final verification: listing record visible in Surrealist.
- **2026-06-30 20:33** — **Discovery Layer grilled + track created.** Full architecture interview: BP direct-write sync (ADR-0024), two-phase load (ADR-0025), `discovery_service` shared package (ADR-0026). 5 glossary terms added. 5-phase track spec + plan written. New `discovery` domain (🔴) registered.
- **2026-06-30 19:32** — **Booking Flow UI deployed to phone.** Built complete `booking_ui` shared package (5 steps, BookingState model, BookingStepIndicator, BookingFlowPage shell). Wired `onBookTapped` callback through EstablishmentPage → EstablishmentInfoBar. Added `/booking` route to Marketplace router. 18 unit tests for BookingState + MockTimeSlot. User confirmed: "Looks very good... clean, clear and easy to navigate!"
- **2026-06-30 13:48** — **Favorites Toggle Saturn DB fix.** Root-caused `PERMISSIONS NONE`. Fixed via REMOVE + DEFINE + ALTER TABLE. Verified HTTP API + deployed to phone.
- **2026-06-30 00:28** — **EstablishmentPage v2 native redesign.** SliverAppBar, glass-morphism bottom nav, featured services, theme toggle. Ingested 5 Stitch booking screens.
- **2026-06-29 19:38** — **BP bugfix session (4 fixes).** Sidebar company name, image deletion loop, category dropdown, map marker color.
- **2026-06-29 18:53** — **Stitch Design System Integration ("Moody Flutter").** Plus Jakarta Sans, #3F51B5 seed, spacing tokens.

> 📦 Full history: `conductor/pulse-archive/2026-06-30.md`

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

None.

## 🧠 Session Memory

### Session 2026-06-30 22:06 — Discovery Layer Phase 1 Implementation

- **Package created:** `packages/discovery_service/` — barrel export, 3 models (EstablishmentListing, DiscoveryCategory, DiscoveryArea), DiscoveryRepository (read), ListingSyncService (write).
- **BP wiring:** `discovery_sync_provider.dart` with connect-use-close pattern (not persistent connection). Hooked into `_save()` — sync on publish, deactivate on unpublish, re-sync on any update while published.
- **DB changes:** bp_portal upgraded VIEWER → EDITOR on discovery DB (both test-db-seed.sh and Saturn production).
- **Bugs caught during deploy:**
  1. Fire-and-forget auth → anonymous access error. Fix: connect-use-close pattern (await signin before query).
  2. `UPSERT ... WHERE` → silently creates nothing (no matching record). Fix: deterministic record ID via `type::record("table", $id)`.
  3. `type::thing()` deprecated → SurrealDB suggests `type::record()`. Fixed.
  4. `source_id` record ref coercion → schema expects string but `establishment:xxx` parses as record. Fix: `<string>` cast.
- **Lesson learned:** Must run integration tests against real SurrealDB before deploying query changes. Added 5 integration tests to `packages/discovery_service/test/integration/`.
- **Tests:** 24 unit + 5 integration (discovery_service), 72 widget + 75 integration (BP). All green.
- **Deploy:** 3 deploys to Saturn, final hash `d147cdc7`. Verified listing record in Surrealist.

### Session 2026-06-30 20:33 — Discovery Layer Grill + Track

- **Grill focus:** General exploration of the Discovery domain — data pipeline, consumer surface, auth model.
- **Architecture decided:**
  - **BP direct-write** (ADR-0024): BP writes `establishment_listing` to `companies/discovery` on publish. `bp_portal` upgraded to EDITOR.
  - **Two-phase load** (ADR-0025): Home tab reads lightweight listings from discovery. Tap → full detail from `company_{slug}` via `marketplace_reader` VIEWER user.
  - **`discovery_service` package** (ADR-0026): shared Dart package with `DiscoveryRepository` (reads) + `ListingSyncService` (writes).
- **Home screen design:** DittoBar search (BM25 full-text, Norwegian snowball) + category chips + EstablishmentListingCards.
- **Area hierarchy:** Kartverket auto-detection from geocoded coordinates. Viken → Drammen → bydeler (Bragernes, Konnerud, Fjell, etc.).
- **Credential model:** `marketplace_reader` password via `--dart-define=MARKETPLACE_READER_PASS=xxx`.
- **Deferred:** SearchEvent/Zero-Result logging → separate DittoBar Intelligence grill. User has a vision for `predict.dittodatto.no` keyword extraction dashboard.
- **Track created:** `discovery_layer_20260630` — 5 phases, spec + plan written.
- **Glossary:** 5 terms added (`discovery_service`, `marketplace_reader`, `PublishSync`, `Two-Phase Load`, `EstablishmentListingCard`).
- **Schema:** `discovery.surql` already fully designed (164 lines) — no schema work needed.

### Session 2026-06-30 19:32 — Booking Flow UI Implementation

- **Package created:** `packages/booking_ui/` — shared package with `booking_ui.dart` barrel, depends on `establishment_ui` + `ditto_design`.
- **Models:** `BookingState` (immutable, `copyWith` helpers, computed `subtotal`/`taxAmount`/`totalPrice` with 25% MVA), `MockStaff` (3 demo entries), `MockTimeSlot` (date-seeded pseudo-random generation).
- **Step widgets built (5/5):**
  1. `ServiceSelectionStep` — real data from debug pipe, group filtering by `showOnBookingPanel`, respects `ServiceGroup.multiSelect` (radio vs checkbox).
  2. `StaffSelectionStep` — "Ingen preferanse" default + 3 mock staff with ratings.
  3. `DateTimeSelectionStep` — custom calendar (Norwegian month names, past-date greying), time slot chips (Morgen / Ettermiddag).
  4. `ReviewStep` — summary cards (service/staff/time/location) with edit pencils, customer note field, MVA payment summary.
  5. `PaymentPlaceholderStep` — disabled card form, "Betaling kommer snart" badge.
- **Shell:** `BookingFlowPage` — manages `BookingState`, `AnimatedSwitcher` transitions, close confirmation dialog, back navigation preserves state.
- **Stepper:** `BookingStepIndicator` — numbered circles (Stitch Step 1 style), checkmarks for completed, tap-to-jump-back on completed steps.
- **Tests:** 18 unit tests. Deployed to Galaxy S21.
- **User feedback:** "Looks very good... comparing with the old nuxt, this looks actually amazing... It's clean, clear and easy to navigate!"

### Session 2026-06-30 13:48 — Favorites Toggle Saturn DB Fix

- **Root cause:** `favorite` table on Saturn had `PERMISSIONS NONE` — left over from previous session's debugging.
- **Fix:** `REMOVE TABLE favorite` → `DEFINE TABLE favorite SCHEMAFULL PERMISSIONS FULL` → re-defined fields + indexes → `ALTER TABLE` for row-level permissions.
- **Verification:** HTTP API test confirmed full CRUD. Deployed to phone. User confirmed toggle works.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-06-30.md`

## 📋 Next Session Suggestions

1. 🔴 **Discovery Layer Phase 2** — Marketplace Home Screen + DittoBar search. Wire `DiscoveryRepository` into Marketplace, build EstablishmentListingCard, category chips, BM25 search.
2. 🔴 **BP Bookings Backend** — Build BP tab to receive/view bookings after ME processes them. Critical path for E2E booking flow.
3. 🟡 **MercuryEngine Availability Wiring** — Replace mock time slots with real ME availability. Unblocks real booking creation.
4. 🟡 **Favorites Toggle polish** — Widget tests, `pendingFavorite` flow, merge to develop.
5. 🟡 **DittoBar Intelligence grill** — SearchEvent logging, keyword extraction, `predict.dittodatto.no` dashboard concept.
6. 🟡 **Light theme polish** — User said light theme is "sterile."
