# Pulse — Current Project State

**Last Updated:** 2026-06-28 16:08
**Session Focus:** Marketplace debug data pipe — wired House of the North establishment to live SurrealDB data on phone

## 🚀 Active Tracks

- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn. Future: Marketplace discovery map, Sweden support.

## ✅ Recently Completed

- **2026-06-28 16:08** — **Marketplace debug data pipe.** Created `EstablishmentDebugService` + `FutureProvider.autoDispose` to fetch real establishment data from Hub (`company_dittodatto-as`). Replaced mock data in `EstablishmentTestScreen`. Updated AGENTS.md deployment rules (native vs web distinction). Deployed to phone via `flutter run -d R5CR61FGVPN`. House of the North page loads with live SurrealDB data.
- **2026-06-28 13:28** — **EstablishmentPage desktop layout polish.** Gallery redesign: hero 50% + 2×2 thumbnails, 12px rounded corners, 8px gaps, max-width constrained (not full-bleed). Removed section shortcut chips (users scroll naturally). Viewport toggle (desktop/tablet/mobile) + theme toggle in preview top bar. Info bar spacing improvements. 72 widget + 41 package tests green. Deployed to Saturn :8003.
- **2026-06-28 12:00** — **Map & Geocoding integration.** Kartverket autocomplete + Nominatim geocoding + flutter_map in shared `establishment_ui`. Admin + BP. 50 admin + 63 BP tests green. Both deployed.
- **2026-06-28 03:13** — **EstablishmentPage desktop polish.** Max-width, padding, buttons visible. 42 + 72 tests green.
- **2026-06-28 02:51** — **EstablishmentPage responsive layout + full-screen preview.** Bento gallery, horizontal info bar, two-column contact. 42 + 63 tests green.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None active.

## 🧠 Session Memory

### Session 2026-06-28 16:08 — Marketplace Debug Data Pipe

- **Created 3 files** in `apps/marketplace/lib/features/establishment/`:
  - `establishment_debug_service.dart` — connects to `companies/company_dittodatto-as` via WebSocket, queries published establishments, maps SurrealDB JSON → `EstablishmentData`.
  - `establishment_providers.dart` — `FutureProvider.autoDispose` wrapping the service. Closes WS on screen exit, refetches on re-entry.
  - `establishment_test_screen.dart` — replaced 100% mock data with live provider. Loading/error states + debug refresh button.
- **Deploy script** updated: marketplace dart-defines `SURREAL_URL=ws://dittodatto:8001/rpc` + `DEBUG_DB_PASS=test-portal-pass`.
- **AGENTS.md deployment rules rewritten:** Distinguished web apps (Admin/BP → Saturn via deploy script) from native app (Marketplace → phone via `flutter run -d R5CR61FGVPN`). This was a recurring friction point — deployment strategy questions were being asked every session.
- **Bug fix:** Initial build used wrong company slug (`house-of-the-north` — doesn't exist as a DB). House of the North is an establishment within `company_dittodatto-as`. Fixed and redeployed.
- **Marketplace Caddy container** created on Saturn (:8004) for web builds — but native phone deployment is the primary workflow per updated rules.
- **Tests:** 25 widget tests + 7 integration tests green. Analysis clean.

### Session 2026-06-28 13:28 — Desktop Layout Polish

- Gallery redesign, shortcuts removal, viewport/theme toggles. See Recently Completed above.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-06-28-pre-polish.md`

## 📋 Next Session Suggestions

1. 🔴 **EstablishmentPage polish on phone** — verify layout looks right on the native app with real data. Debug refresh button available for quick iteration.
2. 🟡 **Services section design** — name, type-dependent rendering (restaurant vs venue vs store). Needs grill.
3. 🟡 **Marketplace discovery map** — Phase 7 of geo-integration track.
4. 🟡 **Discovery service track** — `companies/discovery` sync. `/new-track` candidate.
5. 🟡 **Auth Service Phase 4** — consumer auth in marketplace.
6. 🟡 **SolarTheme Phase 2** — wire into real Marketplace shell.
7. 🟢 **E2E checklist** — user working through 45 scenarios gradually.
