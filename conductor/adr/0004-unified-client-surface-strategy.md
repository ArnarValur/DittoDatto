# Unified Client Surface Strategy

> **Recorded:** 2026-05-29 17:32
> **Status:** accepted

## Context

Managing multiple frontend applications built in different languages or frameworks (e.g. Nuxt for web, native Swift/Kotlin for mobile) causes visual drift, duplicate API integration logic, and high maintenance overhead for a solo developer or very small team.

## Decision

**All platform client surfaces are built using Flutter and Dart.** 

- **Admin Panel** (`apps/admin/`) — Flutter (Web/Android/Linux).
- **Business Portal** (`apps/business-portal/` — planned) — Flutter.
- **Public Marketplace** (`apps/marketplace/`) — Flutter (Android/iOS).
- Shared workspace packages are used to eliminate code duplication:
  - `packages/mercury_client` — API client, auth bindings, and models.
  - `packages/ditto_design` — shared Material 3 styles and layouts.

The apex domain `dittodatto.no` is retained as a static Nuxt 4 web landing/marketing page to optimize for SEO and SSR, but it is not a co-equal product surface.

## Consequences

- The shared `mercury_client` and `ditto_design` packages act as siblings in a monorepo workspace.
- High developer leverage: visual edits and model updates propagate instantly to all apps.
- A single frontend stack (Flutter/Dart) to learn, test, and maintain.
