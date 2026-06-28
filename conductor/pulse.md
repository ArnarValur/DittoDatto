# Pulse — Current Project State

**Last Updated:** 2026-06-28 02:51
**Session Focus:** EstablishmentPage responsive layout + full-screen preview route + "Ship Before You Speak" workflow rule

## 🚀 Active Tracks

- **Auth Service** (`auth_service_20260624`) — **Ready for Phase 4.** Phases 1-3 ✅. Marketplace consumer auth now live → Phase 4 unblocked.
- **SolarTheme** (`solar_theme_20260628`) — **Phase 1 complete.** Solar engine ported, star field + demo running on device. Phases 2-5 open.
- **EstablishmentPage rebuild** (no formal track yet) — **Responsive layout + full-screen preview complete.** Mobile + tablet/desktop layouts implemented. Full-screen preview route with top bar. Deployed to Saturn :8003.

## ✅ Recently Completed

- **2026-06-28 02:51** — **EstablishmentPage responsive layout + full-screen preview.** Tablet/desktop layout (bento gallery, horizontal info bar, two-column contact). Full-screen preview route outside shell with Nuxt-style top bar (back button + search placeholder). 42 package + 63 BP integration tests green. Deployed to Saturn :8003. "Ship Before You Speak" rule added to AGENTS.md.
- **2026-06-28 01:50** — **EstablishmentPage mobile foundation.** Rebuilt `establishment_ui` package: gallery section, centered info bar, action buttons, section shortcuts, conditional placeholder sections. Wired to marketplace test route. Running on device.
- **2026-06-28 00:30** — **SolarTheme Phase 1 complete.** Solar engine ported to pure Dart, star field CustomPainter, demo screen on device, typography unified (Outfit+Inter).
- **2026-06-27 19:52** — **Marketplace Foundation graduated.** Phase 4 complete: 32 tests green. Track closed.
- **2026-06-27 16:39** — **Business Portal Chapter 1 graduated.** 2 tracks merged. Confirmed on Saturn.

> 📦 Full history: `conductor/pulse-archive/2026-06-09-pre-portal.md`

## ⚠️ Blockers

- None active.

## 🧠 Session Memory

### Session 2026-06-28 02:41 — EstablishmentPage Responsive Layout + Workflow Fix

- **Responsive layout implemented** in `packages/establishment_ui/`:
  - `EstablishmentPage` — `LayoutBuilder` → `DittoWindowClass` → `isWide` boolean. Content constrained to max 1100px on desktop.
  - `EstablishmentGallerySection` — bento grid (hero flex 2 + 2 stacked thumbs flex 1, 4px gap, 380px height) on wide. Mobile unchanged.
  - `EstablishmentInfoBar` — horizontal row (logo + name/address/status left, Book + Favorite buttons right) on wide. Accepts `isPreview` to hide buttons.
  - `EstablishmentActionButtons` — converted to non-sliver, hidden on wide (buttons in info bar).
  - `EstablishmentSectionShortcuts` — converted to non-sliver.
  - `EstablishmentContactSection` — two-column (contact card left + map placeholder right) on wide.
  - Draft banner — `Flexible` fix for narrow viewport overflow.
- **Tests:** 42 package tests passing (mobile + wide viewport coverage), 63 BP integration tests passing. `dart analyze` clean.
- **Deployment workflow fix:** User frustrated by recurring pattern: agent says "you can see it" but code only exists locally. Added **"Ship Before You Speak"** rule to AGENTS.md: Code → Test → Ask to deploy → Deploy → THEN report. Never claim visibility without deployment. This has been a recurring issue across 5+ sessions.
- **Deployed** BP to Saturn :8003 — hash verified, smoke test passed. User can now see the responsive layout.
- **Full-screen preview route** added post-checkpoint:
  - User observed preview was constrained by sidebar — suggested full-screen rendering as an independent screen.
  - Created `EstablishmentPreviewScreen` — renders `EstablishmentPage` edge-to-edge outside the dashboard shell.
  - Top bar with "← Tilbake" back button + "Spør Datto om hva som helst..." search placeholder (future feature slot).
  - Route: `/establishments/preview` (outside `ShellRoute`, same level as login). Data passed via `GoRouter.extra`.
  - Preview toggle 👁️ in edit view now navigates to this route instead of swapping the body inline.
  - Redeployed to Saturn :8003 — hash `020a8b96a143d39b7b02622a215bffee`, smoke passed.

### Session 2026-06-28 01:56 — EstablishmentPage Mobile-First Rebuild

- **Design analysis:** User shared 4 screenshots of legacy Nuxt EstablishmentPage at different breakpoints. Extracted responsive gallery modes, info bar layout shifts, tab structure.
- **Key design decisions:** No tabs/swipes (single-scroll), conditional sections, back-to-top FAB, services naming marinating.
- **Shared widget rebuilt** (`packages/establishment_ui/`): 11 files modified/created. Wired to marketplace test route.
- **Data wiring pivot:** Marketplace can't use `bp_portal`. Discovery DB has no data. Polish via BP preview instead.

> 📦 Full history for earlier sessions: `conductor/pulse-archive/2026-06-27-pre-graduations.md`

## 📋 Next Session Suggestions

1. 🔴 **Visual verification** — User should refresh BP on Saturn :8003 and verify the responsive layout looks right.
2. 🟡 **Services section design** — name, type-dependent rendering (restaurant vs venue vs store). Needs grill.
3. 🟡 **Discovery service track** — `companies/discovery` needs sync from company DBs. Required before marketplace can show real data. `/new-track` candidate.
4. 🟡 **Review Auth Service Phase 4** — consumer auth live in marketplace.
5. 🟡 **SolarTheme Phase 2** — wire solar engine into real Marketplace shell.
6. 🟢 **E2E checklist** — user working through 45 scenarios gradually.
