# Pulse — Current Project State

**Last Updated:** 2026-06-28 00:39
**Session Focus:** SolarTheme exploration — engine port, theme architecture grill, typography normalization

## 🚀 Active Tracks

- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.

## ✅ Recently Completed

- **2026-06-28 00:30** — **SolarTheme Phase 1 complete.** Solar engine ported to pure Dart, star field CustomPainter, demo screen on device, typography unified (Outfit+Inter).
- **2026-06-27 23:34** — **All 4 research docs delivered.** Noona CRM, CRM architecture, Communication architecture, SDB message bus deep dive + experiment script.
- **2026-06-27 19:52** — **Marketplace Foundation graduated.** Phase 4 complete: 32 tests green. Track closed.
- **2026-06-27 16:39** — **Business Portal Chapter 1 graduated.** 2 tracks merged. Confirmed on Saturn.
- **2026-06-27 16:33** — **Admin Panel Chapter 1 graduated.** 50 integration tests green. Confirmed on Saturn.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- ✅ ~~**No post-deploy verification.**~~ Resolved.
- ✅ ~~**Deploy path confusion.**~~ Resolved — `deploy-to-saturn.sh` with hash verification.
- ✅ ~~**Deploy missing dart-defines.**~~ Resolved — `DART_DEFINES` map in deploy script + AGENTS.md rules.
- ✅ ~~**No marketplace-level tests.**~~ Resolved — 32 tests (7 integration + 25 widget).

## 🧠 Session Memory

### Session 2026-06-28 00:39 — SolarTheme Exploration (Saturday Night Side-Quest)

- **Mini grill on DD theme foundation:**
  - Typography: **Outfit headlines + Inter body** — unified across both dark and light themes. Manrope eliminated.
  - SolarTheme surfaces: **Marketplace + BP establishment preview**. Admin stays dark-only.
  - Atmospheric rendering: **Gradient sky + stars**. Aurora deferred.
  - Hue palette: **Marinating** — user brainstorming Moody Blue orbit vs presets. Using existing dark/light as poles for now.
- **Solar engine ported to pure Dart** — `SunCalc.getPosition()`, `SolarEngine.compute()`, `SolarState` model, `SolarPhase` enum. Zero external dependencies. Lives in `ditto_design/lib/src/solar/`.
- **Star system ported** — 30 real stars + 2 planets, sidereal time projection, `StarMap.project()`. `StarFieldPainter` CustomPainter with glow blur.
- **Demo screen** — `/solar` route in marketplace. Full-screen atmospheric gradient + star field + glassmorphic debug card + time slider. Running on Galaxy S21 Ultra.
- **Norwegian summer validation** — at midnight June 28 in Drammen (59.74°N), engine correctly shows civil twilight / golden hour. Bright blue sky, barely any stars. Math checks out.
- **Track created** — `solar_theme_20260628` under new `design-system` domain.
- **User brainstorming** twilight transition gradients and how to make phase shifts feel more natural. Letting it marinate.

### Session 2026-06-27 23:34 — Research Review + Firebase Decision
- **User read all 4 research docs:** Noona CRM, CRM Architecture, Communication Architecture, SDB Message Bus Deep Dive
- **Decision: Firebase for SMS/email** — user already has Firebase project registered. Replaces Sveve + MailerSend recommendation from comms research.
- **Shared EstablishmentPage requirement** — BP preview and Marketplace public page must be identical (same source widget in `establishment_ui`). WYSIWYG for businesses.
- **DD theme regrill needed** — cohesive design system across Admin Panel, BP, and Marketplace. Currently ad-hoc per app.

> 📦 Full history: `conductor/pulse-archive/2026-06-27-pre-graduations.md`

## 📋 Next Session Suggestions

1. 🔴 **Review Auth Service Phase 4** — consumer auth live in marketplace. Review and potentially graduate.
2. 🔴 **CRM `/grill` or `/new-track`** — 4 research docs digested. User ready to define the next domain track.
3. 🟡 **SolarTheme Phase 2** — wire solar engine into real Marketplace shell (atmospheric gradient behind tabs, solar-driven theme mode).
4. 🟡 **Shared EstablishmentPage** — BP preview + Marketplace must use same widget source (`establishment_ui`). Phase 4 of SolarTheme track.
5. 🟡 **SDB message bus experiment** — run `sdb-message-bus-experiment.surql` against local SDB to validate patterns.
6. 🟡 **Marketplace Discovery + Home** — next feature track (ADR-0020 anonymous browsing).
7. 🟢 **E2E checklist** — user working through 45 scenarios gradually.
8. 🟢 **Logo:** User is working on a logo — swap when ready.
