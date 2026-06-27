# Implementation Plan — SolarTheme

> **Track:** `solar_theme_20260628`
> **Workflow:** Light (exploration track — creative iteration)

---

## Phase 1: Solar Engine + Foundation ✅

- [x] Port `SunCalc.getPosition` to pure Dart (`sun_calc.dart`)
- [x] Create `SolarState` model + `SolarPhase` enum (`solar_state.dart`)
- [x] Create `SolarEngine` — altitude → HSL mapping (`solar_engine.dart`)
- [x] Port star catalog — 30 stars + 2 planets (`star_catalog.dart`)
- [x] Port star map projection — sidereal time + screen coords (`star_map.dart`)
- [x] Export solar module from `ditto_design` barrel
- [x] Normalize typography — Outfit headlines + Inter body in both themes
- [x] Create Riverpod providers (marketplace `solar_providers.dart`)
- [x] Create `StarFieldPainter` (`CustomPainter` with glow)
- [x] Create `SolarDemoScreen` — gradient + stars + debug card + slider
- [x] Wire `/solar` route in marketplace + home screen button
- [x] Static analysis clean
- [x] Running on device ✅ (Galaxy S21 Ultra)

## Phase 2: Theme Integration

- [ ] Replace `isDarkModeProvider` with solar-driven theme mode in Marketplace
- [ ] Move atmospheric gradient behind the `MarketplaceShell` (gradient + stars behind real UI)
- [ ] Add manual dark mode override (user preference overrides solar)
- [ ] Smooth `AnimatedTheme` crossfade on dark/light switch
- [ ] Remove `/solar` demo route (functionality absorbed into real shell)

## Phase 3: Twilight Transitions & Polish

- [ ] Design improved gradient ramps for Norwegian twilight phases
- [ ] Better color transitions between phases (captain brainstorming)
- [ ] Star field twinkling animation (subtle opacity pulse)
- [ ] Performance profiling — ensure gradient + stars don't impact scroll
- [ ] Widget tests for `SolarEngine.compute` edge cases (midnight sun, polar night)
- [ ] Unit tests for `SunCalc.getPosition` accuracy

## Phase 4: Shared EstablishmentPage

- [ ] Create `packages/establishment_ui/` shared widget package
- [ ] EstablishmentPage widget (cover, gallery, logo, services, info)
- [ ] Solar-aware rendering in Marketplace
- [ ] Static preview rendering in Business Portal
- [ ] Integration test: same widget, both contexts

## Phase 5: Hue Palette (Deferred — marinating)

- [ ] Decide Moody Blue orbit vs preset system
- [ ] Implement chosen palette strategy
- [ ] Theme preset UI (if applicable)
