# Pulse — Current Project State

**Last Updated:** 2026-06-28 13:11
**Session Focus:** BP preview viewport toggle (desktop/tablet/mobile) + theme toggle

## 🚀 Active Tracks

- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn. Future: Marketplace discovery map, Sweden support.

## ✅ Recently Completed

- **2026-06-28 13:11** — **BP preview viewport + theme toggle.** Added 3-mode viewport toggle (desktop/tablet/mobile) and dark/light theme toggle to preview top bar. MediaQuery override constrains EstablishmentPage to target width. 72 widget + 63 integration + 42 package tests green. Deployed to Saturn :8003.
- **2026-06-28 12:00** — **Map & Geocoding integration.** New `geo-integration` domain. Kartverket address autocomplete + Nominatim geocoding + flutter_map in shared `establishment_ui` package. Admin Panel company dialog + BP establishment edit form. GeoJSON `geometry<point>` round-trip to SurrealDB. 50 admin + 63 BP tests green. Both deployed to Saturn. Track created.
- **2026-06-28 03:13** — **EstablishmentPage desktop polish.** Max-width 1100→1200px, 24px inner padding on wide, gallery-to-content spacing, Book+Lagre buttons visible in preview. 42 + 72 tests green. Deployed to Saturn :8003.
- **2026-06-28 02:51** — **EstablishmentPage responsive layout + full-screen preview.** Tablet/desktop layout (bento gallery, horizontal info bar, two-column contact). Full-screen preview route outside shell. 42 + 63 tests green. Deployed to Saturn :8003.
- **2026-06-28 01:50** — **EstablishmentPage mobile foundation.** Rebuilt `establishment_ui` package: gallery section, centered info bar, action buttons, section shortcuts, conditional placeholder sections.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None active.

## 🧠 Session Memory

### Session 2026-06-28 13:11 — BP Preview Viewport + Theme Toggle

- **Viewport toggle:** 3 buttons in preview top bar — Desktop (full width), Tablet (1024px), Mobile (412px). `MediaQuery` override so `EstablishmentPage` sees the constrained width.
- **Theme toggle:** Dark/light mode icon button using existing `isDarkModeProvider`. Norwegian tooltips.
- **Confirmed:** `EstablishmentPage` is purely width-based — no `kIsWeb` or platform checks. Native and browser-mobile render identically at same width. 3 viewports sufficient (no separate "native" mode needed).
- **Converted** `EstablishmentPreviewScreen` from `StatelessWidget` → `ConsumerStatefulWidget` for Riverpod access.
- **Tests:** 72 BP widget + 63 integration + 42 establishment_ui — all green. Deployed twice to Saturn :8003.

### Session 2026-06-28 12:00 — Map & Geocoding Integration

- **New domain:** `geo-integration` — cross-cutting concern across Admin, BP, Marketplace.
- **New track:** `map_and_geocoding_20260628` — 8 phases, 6 complete.
- **Shared services** in `packages/establishment_ui/lib/src/services/`:
  - `KartverketService` — Norwegian address autocomplete via `ws.geonorge.no` (free, no auth, 300ms debounce).
  - `NominatimService` — OSM forward geocoding (fallback when Kartverket lacks coords).
  - `NorwegianAddress` model — street, city, postal code + optional lat/lng.
- **Map widget:** `EstablishmentMapSection` — read-only flutter_map sliver for `EstablishmentPage`. "Kart" shortcut chip appears when location exists.
- **BP integration:** Replaced "Kartvisning kommer snart" placeholder in `_LokasjonSection` with live autocomplete + map. Added `latitude`/`longitude` to BP `Establishment` model with GeoJSON parse/serialize.
- **Admin integration:** Created `_KartverketAddressField` widget in `companies_screen.dart`. Company dialog now has Kartverket autocomplete on the Address field.
- **Deploy script fix:** `apps/admin-panel` → `apps/admin` in `deploy-to-saturn.sh`.
- **Tests:** 50 admin + 63 BP — all green. Both deployed to Saturn, hash verified, smoke passed.
- **User confirmed:** Kartverket autocomplete + save round-trip works flawlessly on Saturn.
- **Future:** Marketplace multi-pin discovery map (Phase 7), Sweden/Lantmäteriet support (Phase 8).

### Session 2026-06-28 03:13 — EstablishmentPage Desktop Polish

- Desktop width/spacing fixes, buttons visible in preview. Deployed to Saturn :8003.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-06-28-pre-polish.md`

## 📋 Next Session Suggestions

1. 🔴 **EstablishmentPage layout adjustments** — user has "big layout requests" queued. Desktop margins, then mobile viewport focus.
2. 🟡 **Services section design** — name, type-dependent rendering (restaurant vs venue vs store). Needs grill.
3. 🟡 **Marketplace discovery map** — Phase 7 of geo-integration track. Multi-pin `MarkerLayer` on landing page.
4. 🟡 **Discovery service track** — `companies/discovery` needs sync from company DBs. `/new-track` candidate.
5. 🟡 **Review Auth Service Phase 4** — consumer auth live in marketplace.
6. 🟡 **SolarTheme Phase 2** — wire solar engine into real Marketplace shell.
7. 🟢 **E2E checklist** — user working through 45 scenarios gradually.
