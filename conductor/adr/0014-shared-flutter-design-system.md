# Shared Flutter Design System (`ditto_design`)

> **Recorded:** 2026-05-27 00:22
> **Status:** accepted

Three Flutter apps (Admin Panel, Business Portal, Public Marketplace) share brand identity (Moody Blue `#6F71CC`, Inter typography, Material 3 dark surfaces) but had no shared design package. Without one, visual drift — different spacing, radii, animation timings, surface colors — is inevitable across surfaces.

Created `packages/ditto_design/` as the single source of truth for visual cohesion across all Flutter surfaces.

## Decisions

1. **Package boundary:** Tokens (colors, spacing grid 4/8/12/16/24/32px, border radii 8/12/16/24, animation durations 150/300/500ms) + Theme (`DittoTheme.dark`, `DittoTheme.light` from Moody Blue seed) + Layout utilities (breakpoints, `DittoWindowClass` enum, scroll behavior). Domain-specific widgets graduate into the package organically when cross-app need is proven — no speculative widget library.

2. **Theme modes:** Both `DittoTheme.dark` and `DittoTheme.light` exported, built from the same `ColorScheme.fromSeed(seedColor: #6F71CC)` with hand-tuned dark surface grades (`#0f1117` → `#1c1f2b`) extracted from the existing admin theme (zero visual regression). Admin hardcodes `.dark`. Marketplace and Portal choose their own mode (system-default, user toggle, or future SolarTheme).

3. **SolarTheme:** Acknowledged as a future `ditto_design` layer — a time-of-day-aware theme switcher based on solar position at the user's Norwegian location. Pre-launch polish, not v1 scope. Original Nuxt implementation preserved in `DittoDatto-old/packages/ui/themes/SolarTheme/` as reference.

4. **Responsive scaffold:** `DittoDashboardShell` widget shared by Admin Panel and Business Portal — Flutter equivalent of the Nuxt UI `DashboardSidebar` + `DashboardPanel` + `DashboardNavbar` layout (permanent collapsible sidebar, nav groups, header/footer slots, main content panel, drawer on narrow screens). Public Marketplace uses its own app-local consumer shell (3-tab bottom nav). Breakpoints + `DittoWindowClass` enum shared by all 3 apps.

5. **Monorepo tooling:** Dart Workspaces (native `pub` resolution). No Melos — unnecessary coordination overhead for a 2-person team. Additive later if needed.

6. **No widget gallery app.** Admin Panel serves as the living reference for all shared tokens and widgets.

7. **Admin retrofit:** Extract existing admin theme (`DittoDatto-old/apps/admin/lib/theme/`) as the `ditto_design` seed — zero visual regression, code-location move only. New admin (`apps/admin/`) imports `ditto_design` from day one, never has a local theme file.

## Considered Options

### Package boundary
- **Tokens + Theme only** — minimal coordination, maximum app freedom, but risks widget-level drift (cards, buttons)
- **Tokens + Theme + Layout + Brand widgets** (chosen with organic graduation) — medium coordination, strong visual cohesion, no speculative waste
- **Full component library** — heavy coordination, tightest control, overkill for 2-person team

### Responsive scaffold
- **Custom `DittoScaffold` for all apps** — forced abstraction, Admin and Marketplace have fundamentally different nav patterns
- **Direct Material 3 widgets per app** — maximum flexibility, risk of breakpoint drift
- **Shared breakpoints + `DittoDashboardShell` for Admin/Portal** (chosen) — captures the genuine shared pattern without forcing Marketplace into the wrong shape

### Monorepo tooling
- **Melos 7.7.0** — full orchestrator, conventional commits, cross-package commands — unnecessary overhead for 2-person team
- **Dart Workspaces** (chosen) — native, zero-config, KISS

## Consequences

- All Flutter apps must declare `ditto_design` as a path dependency
- Theme changes propagate to all surfaces from a single edit
- `DittoDashboardShell` becomes a load-bearing widget — Admin and Portal depend on it
- `mercury_client` and `ditto_design` are sibling packages, not nested — neither depends on the other
- SolarTheme port to Flutter is deferred but architecturally planned (future `DittoTheme` layer)
