# Pulse — Current Project State

**Last Updated:** 2026-06-28 16:55
**Session Focus:** Gallery layout modes (Bento/Showcase/Spotlight) + auto-scroll strip + full-screen gallery viewer

## 🚀 Active Tracks

- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn. Future: Marketplace discovery map, Sweden support.

## ✅ Recently Completed

- **2026-06-28 16:55** — **Gallery layout modes + viewer.** Implemented 3 `CoverLayoutMode` variants (Bento Grid, Showcase, Spotlight) in shared `EstablishmentGallerySection`. Showcase auto-scrolls thumbnails vertically in a continuous loop (pauses on hover). Wired "Se bilder" pill to a full-screen `_GalleryViewerDialog` with swipeable `PageView`, arrow/keyboard nav, pinch-to-zoom, and image counter. 50 package + 72 BP widget tests green. Deployed 3× to Saturn :8003 + 1× to phone.
- **2026-06-28 16:08** — **Marketplace debug data pipe.** Created `EstablishmentDebugService` + `FutureProvider.autoDispose` to fetch real establishment data from Hub (`company_dittodatto-as`). Replaced mock data in `EstablishmentTestScreen`. Updated AGENTS.md deployment rules (native vs web distinction). Deployed to phone via `flutter run -d R5CR61FGVPN`. House of the North page loads with live SurrealDB data.
- **2026-06-28 13:28** — **EstablishmentPage desktop layout polish.** Gallery redesign: hero 50% + 2×2 thumbnails, 12px rounded corners, 8px gaps, max-width constrained (not full-bleed). Removed section shortcut chips (users scroll naturally). Viewport toggle (desktop/tablet/mobile) + theme toggle in preview top bar. Info bar spacing improvements. 72 widget + 41 package tests green. Deployed to Saturn :8003.
- **2026-06-28 12:00** — **Map & Geocoding integration.** Kartverket autocomplete + Nominatim geocoding + flutter_map in shared `establishment_ui`. Admin + BP. 50 admin + 63 BP tests green. Both deployed.
- **2026-06-28 03:13** — **EstablishmentPage desktop polish.** Max-width, padding, buttons visible. 42 + 72 tests green.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None active.

## 🧠 Session Memory

### Session 2026-06-28 16:55 — Gallery Layout Modes + Viewer

- **3 cover layout modes** wired to `CoverLayoutMode` enum dispatch in `EstablishmentGallerySection.build()`. Wide viewports switch layout; mobile stays identical across all modes.
  - **Bento Grid:** 1/2 hero + 2×2 thumbnail grid (was already built, now properly dispatched).
  - **Showcase:** 3/4 hero cover + 1/4 auto-scrolling vertical strip. Thumbnails duplicated for seamless loop. `AnimationController` drives 30px/sec scroll. Pauses on hover/tap.
  - **Spotlight:** Full-width single cover with rounded corners. "Se bilder" pill if extras exist.
- **Gallery viewer dialog** (`_GalleryViewerDialog`): Full-screen `Dialog.fullscreen` with `PageView.builder`, `InteractiveViewer` (pinch-to-zoom), arrow navigation, keyboard support (←/→/Esc), image counter ("1 / 6"), close button. Wired to all "Se bilder" pills across all layouts + mobile.
- **Removed dead `onViewPhotos` callback** — gallery section is now self-contained, opens the dialog itself.
- **Tests:** 9 new layout mode tests + updated Showcase test for auto-scroll behavior. 50/50 package, 72/72 BP widget tests.
- **Deploys:** 3× Saturn :8003 (iterating on auto-scroll + viewer), 1× phone `flutter run --release -d R5CR61FGVPN`.
- **User confirmed** gallery works on device ✅.

### Session 2026-06-28 16:08 — Marketplace Debug Data Pipe

- Created `EstablishmentDebugService` + `FutureProvider.autoDispose`. Replaced mock data. Deployed to phone.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-06-28-pre-polish.md`

## 📋 Next Session Suggestions

1. 🟡 **Services section design** — name, type-dependent rendering (restaurant vs venue vs store). Needs grill.
2. 🟡 **Marketplace discovery map** — Phase 7 of geo-integration track.
3. 🟡 **Discovery service track** — `companies/discovery` sync. `/new-track` candidate.
4. 🟡 **Auth Service Phase 4** — consumer auth in marketplace.
5. 🟡 **SolarTheme Phase 2** — wire into real Marketplace shell.
6. 🟢 **E2E checklist** — user working through 45 scenarios gradually.
