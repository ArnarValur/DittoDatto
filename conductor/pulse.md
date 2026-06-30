# Pulse — Current Project State

**Last Updated:** 2026-06-30 13:48
**Session Focus:** Favorites Toggle — Saturn DB fix + deploy

## 🚀 Active Tracks

- **Favorites Toggle** (`favorites_toggle_20260630`) — **Phases 1–3 functional.** Toggle works on phone. Remaining: widget tests for filled/outline states, `pendingFavorite` login-return flow, auth gate integration test, merge to develop.
- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn. Future: Marketplace discovery map, Sweden support.
- **Services Section** (`services_section_20260628`) — **Completed.** All 4 phases done.
- **Ticketing & Events** (`ticketing_events_20260628`) — **New.** Track created. 5 phases.

## ✅ Recently Completed

- **2026-06-30 13:48** — **Favorites Toggle Saturn DB fix.** Root-caused `PERMISSIONS NONE` on Saturn's `favorite` table (left from prior debugging). Fixed via REMOVE TABLE + DEFINE TABLE + ALTER TABLE. Verified via HTTP API test + deployed to phone. User confirmed toggle works and verified data in SDB.
- **2026-06-30 00:28** — **EstablishmentPage v2 native redesign.** Full page overhaul: SliverAppBar with transparent-to-solid collapsing toolbar + AnnotatedRegion for system status bar. Header refactored to inline Row (logo left, info right). Featured services section (hero card + seamless service list, secondaryContainer tint, no header label). Bottom nav evolved to glass-morphism (48px, icons only 23px, BackdropFilter blur). Theme toggle button in top bar. Removed full "Tjenester" section + Kontakt section. Dynamic bottom padding clears glass nav. 91/91 establishment_ui tests. Multiple deploys to phone. Ingested 5 Stitch booking flow screens and wrote analysis for next session.
- **2026-06-29 19:38** — **BP bugfix session (4 fixes).** Sidebar company name, image deletion loop, category dropdown, map marker color. 75/75 integration tests. Deployed twice to Saturn :8003.
- **2026-06-29 18:53** — **Stitch Design System Integration ("Moody Flutter").** Stitch MCP wired. Design tokens updated (Plus Jakarta Sans, #3F51B5 seed, spacing tokens). Deployed to Saturn + phone.
- **2026-06-29 17:29** — **Services Section track completed (Phases 3+4).** ServiceCard (3 variants), ServiceGroupSection, EstablishmentServicesSection. 95 package tests. Deployed to Saturn + phone.

> 📦 Full history: `conductor/pulse-archive/2026-06-30.md`

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

None.

## 🧠 Session Memory

### Session 2026-06-30 13:48 — Favorites Toggle Saturn DB Fix

- **Root cause:** `favorite` table on Saturn had `PERMISSIONS NONE` — left over from previous session's debugging that ran `DEFINE TABLE` without proper permissions clause.
- **Fix:** `REMOVE TABLE favorite` → `DEFINE TABLE favorite SCHEMAFULL PERMISSIONS FULL` → re-defined all fields + indexes → `ALTER TABLE` for row-level permissions (`select/delete WHERE user = $auth.id`, `create WHERE $auth.id != NONE`, `update NONE`).
- **Verification:** HTTP API test (signup → CREATE → SELECT → DELETE) confirmed full CRUD cycle works with RECORD ACCESS consumer users.
- **Cleanup:** Removed debug/test user records from Saturn. Removed temp scripts.
- **Deploy:** Marketplace app deployed to phone (`flutter run --release -d R5CR61FGVPN`). User confirmed Lagre button works and verified favorite data appears in SurrealDB.

### Session 2026-06-30 13:14 — Favorites Toggle Implementation

- **Data layer (Phase 1 ✅):** Created `Favorite` model (with structured SurrealDB ID support), `FavoriteRepository` (CRUD against `users/users`), Riverpod providers (`isFavoritedProvider`, `toggleFavoriteProvider`, `favoritesCountProvider`).
- **Schema changes:** Added `PERMISSIONS` to `favorite` table (select/delete own, create when authed, no update). Added `VALUE $auth.id` on `user` field for auto-set. Applied to Saturn via docker exec.
- **UI wiring (Phase 2 ✅):** Threaded `onFavoriteTapped` + `isFavorited` through `EstablishmentPage` → `EstablishmentInfoBar` → `EstablishmentActionButtons` (3 Lagre buttons total). Auth gate in `EstablishmentTestScreen` — unauthenticated taps redirect to login. Profile "Mine favoritter" sticker card with live count.
- **Bug fixes during session:** `AsyncValue.value` → pattern matching (throws during loading in Riverpod 3.x). SurrealDB SDK coerces colon-containing strings to record links → changed `target_id` from `establishment:slug` to plain `slug`. `bindings` → positional `vars` parameter in SurrealDB Dart SDK.
- **Tests:** 9/9 model unit tests, 9/9 repo integration tests (local), 91/91 establishment_ui widget tests, 75/75 BP regression tests.
- **User decision:** Favorite counts belong in Discovery layer (not company DBs). Discovery will aggregate cross-namespace metrics when that layer is built.
- **User decision:** `consumerDb` getter on DittoAuth is acceptable for dev/debug phase. Proper DB auth access will be re-grilled during Discovery grill.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-06-30.md`

## 📋 Next Session Suggestions

1. 🔴 **Booking Flow UI (Steps 1–5)** — Build 5-step booking UI with mock data.
2. 🟡 **Favorites Toggle — remaining polish** — Widget tests for filled/outline states, `pendingFavorite` login-return flow, auth gate integration test, merge to develop.
3. 🟡 **MercuryEngine availability engine** — Unblocks real booking step 3.
4. 🟡 **Light theme polish** — User said light theme is "sterile".
5. 🟡 **Profile page grill** — Deferred. Favorites sticker is placed, full profile design TBD.
