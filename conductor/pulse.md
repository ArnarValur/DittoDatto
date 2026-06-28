# Pulse — Current Project State

**Last Updated:** 2026-06-28 17:41
**Session Focus:** Ticketing & Events domain grill + track creation

## 🚀 Active Tracks

- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **Map & Geocoding** (`map_and_geocoding_20260628`) — **Phases 1-6 complete.** Kartverket autocomplete + flutter_map live in Admin + BP on Saturn. Future: Marketplace discovery map, Sweden support.
- **Services Section** (`services_section_20260628`) — **New.** Track created. 4 phases: Data Layer → BP CRUD → Marketplace Display → Verify+Deploy. No code yet.
- **Ticketing & Events** (`ticketing_events_20260628`) — **New.** Track created. 5 phases: Schema+Data → BP Event CRUD → Marketplace Display → Recurring Events MVP → Verify+Deploy. Depends on services track Phase 1–2. ADR-0022 + ADR-0023 landed.

## ✅ Recently Completed

- **2026-06-28 17:03** — **Marketplace bottom nav fix.** Moved establishment route from top-level (outside shell = no bottom nav) into `StatefulShellRoute` home branch as child route. Fixed route path (`/` not `/home`). Gallery viewer + layouts confirmed working on phone with bottom nav visible.
- **2026-06-28 16:55** — **Gallery layout modes + viewer.** Implemented 3 `CoverLayoutMode` variants (Bento Grid, Showcase, Spotlight) in shared `EstablishmentGallerySection`. Showcase auto-scrolls thumbnails vertically in a continuous loop (pauses on hover). Wired "Se bilder" pill to a full-screen `_GalleryViewerDialog` with swipeable `PageView`, arrow/keyboard nav, pinch-to-zoom, and image counter. 50 package + 72 BP widget tests green. Deployed 3× to Saturn :8003 + 1× to phone.
- **2026-06-28 16:08** — **Marketplace debug data pipe.** Created `EstablishmentDebugService` + `FutureProvider.autoDispose` to fetch real establishment data from Hub (`company_dittodatto-as`). Replaced mock data in `EstablishmentTestScreen`. Updated AGENTS.md deployment rules (native vs web distinction). Deployed to phone via `flutter run -d R5CR61FGVPN`. House of the North page loads with live SurrealDB data.
- **2026-06-28 13:28** — **EstablishmentPage desktop layout polish.** Gallery redesign: hero 50% + 2×2 thumbnails, 12px rounded corners, 8px gaps, max-width constrained (not full-bleed). Removed section shortcut chips (users scroll naturally). Viewport toggle (desktop/tablet/mobile) + theme toggle in preview top bar. Info bar spacing improvements. 72 widget + 41 package tests green. Deployed to Saturn :8003.
- **2026-06-28 12:00** — **Map & Geocoding integration.** Kartverket autocomplete + Nominatim geocoding + flutter_map in shared `establishment_ui`. Admin + BP. 50 admin + 63 BP tests green. Both deployed.
- **2026-06-28 03:13** — **EstablishmentPage desktop polish.** Max-width, padding, buttons visible. 42 + 72 tests green.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None active.

## 🧠 Session Memory

### Session 2026-06-28 17:38 — Recon Audit + Services Grill + Track Creation

- **Three recon agents dispatched** in parallel: MercuryEngine auditor, Legacy Nuxt services researcher, Noona API researcher.
- **MercuryEngine audit:** 50 tests, 91% coverage, 30 days idle. **Critical schema drift found:** `rescheduled_from`/`rescheduled_to` fields missing from `company-blueprint.surql` — silent data loss on SCHEMAFULL tables. 3 unsynced relay entries.
- **Nuxt legacy inventory:** Full service CRUD (596-line ServiceFormSlideover), ServiceGrid with composite multi-select group cards, complete booking flow (hold→confirm). 10 design patterns catalogued.
- **Noona API research:** Two-tier API, 4-level service hierarchy vs DittoDatto's cleaner 2-level. CRM as "loyalty engine" (win-back, vouchers, favorites). DittoDatto has stronger multi-tenancy.
- **Recon report artifact:** `recon_report.md` — full convergence analysis with dependency graphs and recommended sequencing.
- **Services grill (`/grill services`):** Marketplace-first, grouped by ServiceGroup (collapsible), 3 booking-mode card variants, multi-select checkboxes + summary bar, models in `establishment_ui`, `kr 450` / `30 min` formatting. 3 glossary terms added (ServiceCard, ServiceSection, MultiSelectGroup). No ADRs — all natural extensions.
- **Track created (`/new-track`):** `services_section_20260628` in new "services" domain (🟡 Careful). 4 phases. Includes basic BP services CRUD as Phase 2 (no seeding hack — real forms).
- **Note:** Concurrent ticketing grill in another session produced ADR-0022 + ADR-0023 — got swept into our git commit. User flagged to be more careful with concurrent sessions.

### Session 2026-06-28 17:30 — Ticketing & Events Domain Grill

- **Deep-dive research** into all ticketing-related code, schemas, docs, and competitive research (Ticketmaster + Noona).
- **Two systems clarified:** Events (`event_system` flag) = general event creation (public/private, visibility-only possible). Ticketing (`ticket_system` flag) = capacity-managed ticket sales via `bookingMode: ticketSystem`. `ticket_system` requires `event_system`.
- **Core model decided:** ServiceGroup = Event container, Services = Ticket tiers (VIP, General, Standing). Simple events: 1 ServiceGroup + 1 Service. Complex events: 1 ServiceGroup + N Services. Total capacity = Σ child Service capacities. See **ADR-0022**.
- **Feature flag independence:** ADR-0023 formalizes the two-flag model and dependency direction.
- **Recurring events:** RFC 5545 `rrule` on ServiceGroup. Platform auto-creates next instance, notifies company user. Future: Datto automates.
- **context.md updated:** ServiceGroup, Ticket, Event terms refined. Recurring Event added.
- **Research artifacts:** `ticketing_deep_dive.md` (full codebase/docs audit), `ticketing_grill_brief.md` (decision summary).
- **Finding:** `BOOKING_ENGINE.md` safety manual is a dead link in `project-context.md` — lives in `DittoDatto-old/`, not current repo.

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
- **Bottom nav fix:** Establishment route was a top-level `GoRoute` (outside `StatefulShellRoute`) → moved inside home branch as child route. Home path is `/`, so sub-route resolves to `/establishment-test`. Redeployed to phone.

### Session 2026-06-28 16:08 — Marketplace Debug Data Pipe

- Created `EstablishmentDebugService` + `FutureProvider.autoDispose`. Replaced mock data. Deployed to phone.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-06-28-pre-polish.md`

## 📋 Next Session Suggestions

1. 🔴 **Schema hotfix** — Add `rescheduled_from`/`rescheduled_to` to `company-blueprint.surql`. Five-minute fix, prevents compliance data loss.
2. 🟡 **Services section Phase 1** — Dart models (Service, ServiceGroup) + DB queries + format helpers. Track: `services_section_20260628`.
3. 🟡 **Ticketing Phase 1** — Schema extensions + data layer. Blocked on services track Phase 1–2. Track: `ticketing_events_20260628`.
4. 🟡 **Services section Phase 2** — BP CRUD ("Tjenester" sidebar page + create/edit dialog).
5. 🟡 **MercuryEngine relay sync** — 3 ADR candidates + 4 glossary updates sitting unprocessed in its conductor.
6. 🟡 **Discovery service track** — `companies/discovery` sync. `/new-track` candidate.
7. 🟡 **Auth Service Phase 4** — consumer auth in marketplace.
8. 🟡 **SolarTheme Phase 2** — wire into real Marketplace shell.
9. 🟢 **CRM grill** — When services + discovery are wired. Noona "loyalty engine" framing.
