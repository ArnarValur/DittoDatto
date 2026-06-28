# Pulse — Current Project State

**Last Updated:** 2026-06-28 13:28
**Session Focus:** EstablishmentPage desktop layout polish — gallery redesign, shortcuts removal, viewport/theme toggles

## 🚀 Active Tracks

- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn. Future: Marketplace discovery map, Sweden support.

## ✅ Recently Completed

- **2026-06-28 13:28** — **EstablishmentPage desktop layout polish.** Gallery redesign: hero 50% + 2×2 thumbnails, 12px rounded corners, 8px gaps, max-width constrained (not full-bleed). Removed section shortcut chips (users scroll naturally). Viewport toggle (desktop/tablet/mobile) + theme toggle in preview top bar. Info bar spacing improvements. 72 widget + 41 package tests green. Deployed to Saturn :8003.
- **2026-06-28 12:00** — **Map & Geocoding integration.** Kartverket autocomplete + Nominatim geocoding + flutter_map in shared `establishment_ui`. Admin + BP. 50 admin + 63 BP tests green. Both deployed.
- **2026-06-28 03:13** — **EstablishmentPage desktop polish.** Max-width, padding, buttons visible. 42 + 72 tests green.
- **2026-06-28 02:51** — **EstablishmentPage responsive layout + full-screen preview.** Bento gallery, horizontal info bar, two-column contact. 42 + 63 tests green.
- **2026-06-28 01:50** — **EstablishmentPage mobile foundation.** Gallery section, centered info bar, action buttons, section shortcuts, placeholder sections.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None active.

## 🧠 Session Memory

### Session 2026-06-28 13:28 — Desktop Layout Polish

- **Gallery redesign:** Hero 50% + 2×2 thumbnail grid (was hero 66% + 2 stacked). 12px rounded corners on outer edges. 8px gaps (was 4px). Gallery now max-width constrained with side margins (was full-bleed). Height 400px (was 380px).
- **Section shortcuts removed:** "Tilbud / Om oss / Kontakt / Kart" anchor chips deleted — users scroll naturally. Removed all anchor scroll infrastructure (GlobalKeys, scroll methods, `_SectionAnchor` class). Deleted `establishment_section_shortcuts.dart` entirely.
- **Viewport toggle:** 3 buttons in preview top bar — Desktop (full width), Tablet (1024px), Mobile (412px). `MediaQuery` override.
- **Theme toggle:** Dark/light mode icon button using existing `isDarkModeProvider`.
- **Spacing:** Gallery-to-content gap 32px (was 24px), info bar vertical padding 20px (was 12px), logo radius 32 (was 28).
- **Confirmed:** `EstablishmentPage` is purely width-based — no platform checks. 3 viewports sufficient.
- **Tests:** 72 BP widget + 41 establishment_ui — all green. Deployed 4× to Saturn :8003.

### Session 2026-06-28 12:00 — Map & Geocoding Integration

- Kartverket autocomplete + Nominatim geocoding + flutter_map. Admin + BP integration. GeoJSON round-trip. New `geo-integration` domain + track.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-06-28-pre-polish.md`

1. 🔴 **Marketplace front app work** — user's next session focus. Then return to BP layout.
2. 🟡 **EstablishmentPage continued polish** — more layout adjustments, mobile viewport focus.
3. 🟡 **Services section design** — name, type-dependent rendering. Needs grill.
4. 🟡 **Marketplace discovery map** — Phase 7 of geo-integration track.
5. 🟡 **Discovery service track** — `companies/discovery` sync. `/new-track` candidate.
6. 🟡 **Auth Service Phase 4** — consumer auth in marketplace.
7. 🟡 **SolarTheme Phase 2** — wire into real Marketplace shell.
8. 🟢 **E2E checklist** — user working through 45 scenarios gradually.
