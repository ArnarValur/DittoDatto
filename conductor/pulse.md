# Pulse — Current Project State

**Last Updated:** 2026-06-30 13:14
**Session Focus:** Favorites Toggle (favorites_toggle_20260630) — data layer + UI wiring

## 🚀 Active Tracks

- **Favorites Toggle** (`favorites_toggle_20260630`) — **BLOCKED.** Phases 1–2 code complete. All tests pass locally (9 model, 9 repo integration, 91 UI, 75 BP regression). **Blocker:** SurrealDB version mismatch — Saturn runs 3.1.2, local test DB is 3.0.5. Consumer RECORD ACCESS users cannot CREATE records on Saturn (returns empty result). `consumer_auth` ACCESS not visible in `INFO FOR DB` on Saturn despite working signup/signin. Needs debugging in fresh session.
- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn. Future: Marketplace discovery map, Sweden support.
- **Services Section** (`services_section_20260628`) — **Completed.** All 4 phases done.
- **Ticketing & Events** (`ticketing_events_20260628`) — **New.** Track created. 5 phases.

## ✅ Recently Completed

- **2026-06-30 00:28** — **EstablishmentPage v2 native redesign.** Full page overhaul: SliverAppBar with transparent-to-solid collapsing toolbar + AnnotatedRegion for system status bar. Header refactored to inline Row (logo left, info right). Featured services section (hero card + seamless service list, secondaryContainer tint, no header label). Bottom nav evolved to glass-morphism (48px, icons only 23px, BackdropFilter blur). Theme toggle button in top bar. Removed full "Tjenester" section + Kontakt section. Dynamic bottom padding clears glass nav. 91/91 establishment_ui tests. Multiple deploys to phone. Ingested 5 Stitch booking flow screens and wrote analysis for next session.
- **2026-06-29 19:38** — **BP bugfix session (4 fixes).** Sidebar company name, image deletion loop, category dropdown, map marker color. 75/75 integration tests. Deployed twice to Saturn :8003.
- **2026-06-29 18:53** — **Stitch Design System Integration ("Moody Flutter").** Stitch MCP wired. Design tokens updated (Plus Jakarta Sans, #3F51B5 seed, spacing tokens). Deployed to Saturn + phone.
- **2026-06-29 17:29** — **Services Section track completed (Phases 3+4).** ServiceCard (3 variants), ServiceGroupSection, EstablishmentServicesSection. 95 package tests. Deployed to Saturn + phone.
- **2026-06-29 11:57** — **Services Section Phases 1-2 complete.** Data layer + BP CRUD. 75 total BP tests. Deployed to Saturn :8003.

> 📦 Full history: `conductor/pulse-archive/2026-06-30.md`

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- **SurrealDB version mismatch (Saturn 3.1.2 vs local 3.0.5).** Consumer RECORD ACCESS users cannot CREATE on any SCHEMAFULL table on Saturn — results silently empty. Even `PERMISSIONS FULL` doesn't help. The `consumer_auth` ACCESS definition doesn't appear in `INFO FOR DB` despite working signup/signin. This blocks ALL consumer-write features (favorites, booking refs, etc.). Must resolve before favorites can deploy.

## 🧠 Session Memory

### Session 2026-06-30 13:14 — Favorites Toggle Implementation

- **Data layer (Phase 1 ✅):** Created `Favorite` model (with structured SurrealDB ID support), `FavoriteRepository` (CRUD against `users/users`), Riverpod providers (`isFavoritedProvider`, `toggleFavoriteProvider`, `favoritesCountProvider`).
- **Schema changes:** Added `PERMISSIONS` to `favorite` table (select/delete own, create when authed, no update). Added `VALUE $auth.id` on `user` field for auto-set. Applied to Saturn via docker exec.
- **UI wiring (Phase 2 ✅):** Threaded `onFavoriteTapped` + `isFavorited` through `EstablishmentPage` → `EstablishmentInfoBar` → `EstablishmentActionButtons` (3 Lagre buttons total). Auth gate in `EstablishmentTestScreen` — unauthenticated taps redirect to login. Profile "Mine favoritter" sticker card with live count.
- **Bug fixes during session:** `AsyncValue.value` → pattern matching (throws during loading in Riverpod 3.x). SurrealDB SDK coerces colon-containing strings to record links → changed `target_id` from `establishment:slug` to plain `slug`. `bindings` → positional `vars` parameter in SurrealDB Dart SDK.
- **Tests:** 9/9 model unit tests, 9/9 repo integration tests (local), 91/91 establishment_ui widget tests, 75/75 BP regression tests.
- **Blocker discovered:** E2E test passes against local test DB (SurrealDB 3.0.5) but fails against Saturn (3.1.2). Even with `PERMISSIONS FULL` and `option<record<user>>`, CREATE returns empty. Schemaless CREATE also fails. Root cause: consumer RECORD ACCESS behavior changed between 3.0.x and 3.1.x. Needs fresh debugging session.
- **User decision:** Favorite counts belong in Discovery layer (not company DBs). Discovery will aggregate cross-namespace metrics when that layer is built.
- **User decision:** `consumerDb` getter on DittoAuth is acceptable for dev/debug phase. Proper DB auth access will be re-grilled during Discovery grill.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-06-30.md`

## 📋 Next Session Suggestions

1. 🔴 **Debug SurrealDB 3.1.2 RECORD ACCESS CREATE** — Root-cause why consumer users can't CREATE on Saturn. Check `consumer_auth` ACCESS visibility, test with `surreal sql` directly inside container. Consider upgrading local test DB to 3.1.2 to reproduce.
2. 🔴 **Favorites Toggle — complete deploy** — Once DB issue resolved, run E2E against Saturn, deploy to phone, verify full flow.
3. 🔴 **Booking Flow UI (Steps 1–5)** — Build 5-step booking UI with mock data.
4. 🟡 **MercuryEngine availability engine** — Unblocks real booking step 3.
5. 🟡 **Light theme polish** — User said light theme is "sterile".
6. 🟡 **Profile page grill** — Deferred from this session. Favorites sticker is placed, full profile design TBD.
