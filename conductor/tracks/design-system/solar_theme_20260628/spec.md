# Specification — SolarTheme

> **Track:** `solar_theme_20260628`
> **Domain:** Design System (`packages/ditto_design/`)
> **Type:** feature
> **Origin:** Saturday night side-quest (2026-06-28). Ported from Nuxt SolarTheme PoC.

---

## Scope

Time-of-day atmospheric theming for the DittoDatto platform. The sun's real position over Drammen drives a continuous atmospheric gradient, star field rendering, and dark/light theme mode switching. Consumer-facing surfaces feel alive — the app breathes with the Norwegian sky.

## What's Already Built (Phase 1 ✅)

### Solar Engine — `ditto_design/lib/src/solar/`

- **`SunCalc`** — pure Dart port of the suncalc npm package (`getPosition` only). Zero dependencies.
- **`SolarEngine`** — maps sun altitude → HSL values (lightness, hue, saturation), solar phase, star opacity. Moody Blue (hue 237) as base. Golden hour override (hue 40, saturation 70). Nordic Studio saturation damping.
- **`SolarState`** + **`SolarPhase`** — immutable state model. Phase enum: night / astronomical twilight / nautical twilight / civil twilight / golden hour / day.
- **`StarMap`** + **`StarCatalog`** — 30 real stars (Orion, Big Dipper, Cassiopeia, Polaris, etc.) + 2 planets. Sidereal time calculation → screen-space projection.

### Typography Normalization

- **Both themes** now use Outfit (headlines) + Inter (body). Previously: dark = Inter-only, light = Outfit + Manrope. The Manrope third font is eliminated.

### Marketplace Demo

- Riverpod providers: `solarStateProvider`, `projectedStarsProvider`, `solarTimeOverrideProvider`
- `SolarDemoScreen` at `/solar` route — full-screen atmospheric gradient + star field + glassmorphic debug card + time slider
- `StarFieldPainter` — `CustomPainter` with glow blur

## Key Decisions

| Decision | Choice | Status |
|----------|--------|--------|
| Typography voice | Outfit headlines + Inter body, both themes | ✅ Grilled & applied |
| SolarTheme hue identity | Parked — using existing dark/light themes as polar opposites for now. Moody Blue orbit vs presets TBD. | 🟡 Marinating |
| Which surfaces get solar | Marketplace + BP establishment preview. Admin stays dark-only. | ✅ Grilled |
| Atmospheric rendering | Gradient sky + star field. No aurora (Phase 2 polish). | ✅ Grilled |
| Theme switching strategy | Option A — binary ThemeData flip at 40% lightness + continuous atmospheric gradient. | ✅ From exploration doc |

## Acceptance Criteria

### Phase 2 — Theme Integration

- `solarStateProvider.isDark` replaces `isDarkModeProvider` in the Marketplace app
- Atmospheric gradient (sky + stars) renders behind the real Marketplace shell (home/bookings/profile)
- Theme mode follows the sun — automatic dark/light switching
- Manual override persists (user can still toggle dark mode, overriding solar)

### Phase 3 — Twilight Transitions & Polish

- Improved gradient transitions between twilight phases (captain is brainstorming this)
- Better visual distinction between civil/nautical/astronomical twilight
- Gradient color ramps that feel natural for Norwegian summer nights
- Star field twinkling / subtle animation

### Phase 4 — Shared EstablishmentPage

- EstablishmentPage widget in shared `establishment_ui` package
- Renders with solar atmosphere in Marketplace
- Renders as static preview in Business Portal
- WYSIWYG: what the business previews is what the consumer sees

### Phase 5 — Hue Palette (Deferred)

- Decide on Moody Blue orbit vs preset system
- If presets: define DD-branded presets (not the Nuxt slate/sand/minimal/forest)
- If Moody Blue orbit: design how the single hue responds to solar position

## Out of Scope

- Aurora overlay (future polish)
- GPS-based location (uses Drammen hardcoded for now)
- Admin Panel theming changes
- Vipps/BankID theme requirements
