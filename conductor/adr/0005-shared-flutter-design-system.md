# Shared Flutter Design System

> **Recorded:** 2026-05-29 17:32
> **Status:** accepted

## Context

With all platforms standardizing on Flutter (ADR-0004), sharing design tokens (typography, colors, spacings) and layout controls is necessary to guarantee visual cohesion and eliminate UI code duplication across the Admin Panel, Business Portal, and Public Marketplace.

## Decision

We use a shared Dart package **`packages/ditto_design`** as the single source of truth for visual tokens and layouts:

- **Tokens:** Spacing grid (4/8/12/16/24/32px), border radii (8/12/16/24px), animation durations (150/300/500ms).
- **Themes:** Exports `DittoTheme.dark` and `DittoTheme.light` based on the Moody Blue `#6F71CC` primary seed.
- **Layouts:** Shared window breakpoints (`DittoWindowClass` compaction model compact/medium/expanded/large) and `DittoDashboardShell` (collapsible sidebar layout) consumed by Admin Panel and Business Portal.
- **Tooling:** Managed natively via Dart Workspaces (native `pubspec.yaml` workspace resolution).

## Consequences

- Direct path dependency on `ditto_design` from all Flutter client applications.
- Spacing and theme values are completely standardized; visual drift is mechanically prevented.
- Keeps apps decoupled from custom layout logic—the shell adapts natively across compact (drawer nav) and wide (rail nav) screens.
