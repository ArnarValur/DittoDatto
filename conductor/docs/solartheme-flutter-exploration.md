# SolarTheme — Flutter Port Exploration

> **Written:** 2026-05-27 (conceptual exploration during `/grill flutter-design-system`)
> **Status:** Future — pre-launch polish, not v1 scope
> **Related:** ADR-0014 (acknowledges SolarTheme as future `ditto_design` layer)
> **Original:** `DittoDatto-old/packages/ui/themes/SolarTheme/`

---

## What the Nuxt version does

Three independent layers:

1. **Solar Engine** (`useSolarEngine.ts`) — pure math: `SunCalc.getPosition(date, lat, lng)` → altitude → lightness/hue/saturation/phase. Sets CSS custom properties. Ticks every 60 seconds. Hardcoded to Drammen (59.74°N, 10.20°E).
2. **Star Map** (`useStarMap.ts`) — pure math: sidereal time calculation → project 30 real stars (Orion's Belt, Ursa Major, Cassiopeia, Polaris, etc.) + 2 planets (Jupiter, Mars) to horizontal coordinates → render as positioned dots. Stars fade based on solar altitude (< -6° threshold).
3. **Atmosphere** (`app.vue`) — CSS gradient background driven by the engine's HSL output. Smooth transitions via `transition-all duration-500`. Golden hour override (hue 40, saturation 70%) at solar altitude -2° to 8°. Saturation damping above 50% lightness ("Nordic Studio" vibe).

**Key insight:** None of this is framework-specific. It's trigonometry with a rendering layer on top. The port is clean because the original was built on first principles.

---

## Flutter Translation, Layer by Layer

### Layer 1: Solar Engine → Pure Dart + Riverpod

The SunCalc algorithm is ~150 lines of trigonometry. No JS dependency — ports to pure Dart line-for-line (or use a Dart pub package if one exists).

The engine becomes a Riverpod provider that:

- Computes solar position for a given `DateTime` + lat/lng
- Outputs a `SolarState` record: altitude, lightness, hue, saturation, phase, starOpacity
- Auto-ticks every 60 seconds via a `Timer`
- Exposes a manual override (like the original slider) via a separate `StateProvider`

**Theme mode is derived, not set.** A second provider watches `SolarState.lightness` and returns `ThemeMode.dark` when < 40%, `ThemeMode.light` otherwise — same logic as the Nuxt version syncing `colorMode.preference`.

### Layer 2: Star Field → `CustomPainter`

Flutter's Canvas API is perfect for this. A `CustomPainter` that:

- Takes the same 30-star catalog (static data, compile-time constant)
- Runs the same sidereal time → horizontal coordinate math
- Paints each star as a circle with a `MaskFilter.blur` glow (equivalent to the CSS `boxShadow` effect)
- Planets get a larger radius
- The whole painter's opacity is driven by `SolarState.starOpacity`

Wrap in a `RepaintBoundary` so it only redraws when star positions change (every 60 seconds). Far cheaper than DOM elements — Canvas is the natural home for this kind of rendering.

### Layer 3: Atmosphere → Animated Container Gradient

A `Container` with an `AnimatedContainer` (or `TweenAnimationBuilder`) that smoothly interpolates a `LinearGradient` based on the engine's HSL output. The gradient goes from sky-color at top to deep-surface at bottom. Flutter's `HSLColor` class maps 1:1 to the existing `--solar-h/s/l` logic.

---

## Composition in `ditto_design`

```
DittoSolarTheme (widget — wraps MaterialApp)
├── SolarEngine (Riverpod provider — pure Dart math, 60s tick)
├── StarFieldOverlay (CustomPainter — positioned behind content)
├── AtmosphericGradient (animated background — HSL-driven LinearGradient)
└── ThemeMode switch (watches engine → toggles DittoTheme.dark / DittoTheme.light)
```

### How apps opt in

```dart
// Marketplace — full SolarTheme experience
DittoSolarTheme(
  latitude: 59.74,     // Drammen default
  longitude: 10.20,
  child: MaterialApp(
    theme: DittoTheme.light,
    darkTheme: DittoTheme.dark,
    // themeMode controlled internally by DittoSolarTheme
  ),
)

// Admin — no SolarTheme, hardcoded dark
MaterialApp(
  theme: DittoTheme.dark,
  themeMode: ThemeMode.dark,
)
```

---

## Difficulty Assessment

| Aspect | Difficulty | Notes |
|--------|-----------|-------|
| Solar position math | 🟢 Free | Pure trig, ports line-for-line from TS |
| Sidereal time + star projection | 🟢 Free | Same — pure math, no framework dependency |
| Star field rendering | 🟢 Easy | `CustomPainter` is arguably cleaner than positioned `<div>`s |
| Atmospheric gradient | 🟢 Easy | `AnimatedContainer` + `LinearGradient` + `HSLColor` |
| Theme mode switching | 🟢 Easy | Riverpod provider → `ThemeMode` |
| Golden hour hue override | 🟢 Free | Same conditional logic |
| Smooth transition between themes | 🟡 Medium | Flutter doesn't animate `ThemeData` changes by default — use `AnimatedTheme` or `ThemeData.lerp` for smooth crossfade |
| Debug panel (Solar Debug card) | 🟡 Medium | Nice-to-have dev tool — draggable overlay with slider + readouts |
| Location-aware (device GPS) | 🟡 Medium | Currently hardcoded to Drammen. GPS adds `geolocator` dependency + permission flow |

---

## The One Design Question

The Nuxt version modifies CSS custom properties **continuously** — the entire page color-shifts smoothly as the sun moves. In Flutter, `ThemeData` switches are binary (dark ↔ light). Two choices:

### Option A: Binary switch + continuous background (recommended)

`ThemeData` flips at the 40% lightness threshold. The `StarFieldOverlay` and `AtmosphericGradient` animate continuously. Material components stay crisp with proper contrast. This is what the Nuxt version effectively does — `colorMode` flips dark/light, the CSS vars do the smooth part.

### Option B: Continuous theme interpolation

`ThemeData.lerp(darkTheme, lightTheme, t)` where `t` is the lightness value. Technically possible but risks muddy text contrast in the twilight zone. **Not recommended.**

---

## Effort Estimate

~2 days total:

- Half day: Solar engine port (pure Dart math)
- Half day: Star field `CustomPainter` + star catalog
- Half day: Atmospheric gradient + theme mode wiring
- Half day: Debug panel + manual time override slider

---

## Reference Files (Nuxt original)

- Solar engine: `DittoDatto-old/packages/ui/themes/SolarTheme/app/composables/useSolarEngine.ts`
- Star map: `DittoDatto-old/packages/ui/themes/SolarTheme/app/composables/useStarMap.ts`
- App shell + rendering: `DittoDatto-old/packages/ui/themes/SolarTheme/app/app.vue`
