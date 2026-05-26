# Flutter-Only Client Strategy

> **Recorded:** 2026-05-26 (new — /grill foundation)
> **Status:** accepted

## Context

By Chapter 1 close, three planned client-facing surfaces existed (Admin, Business Portal, Public Marketplace consumer), with legacy Nuxt 4 / Vue 3 implementations of varying maturity. The Admin Panel pivot to Flutter (ADR-0006, originally legacy 0011, S15–S20) established `mercury_client` + Riverpod + Material 3 + Moody Blue as a reusable foundation. With the Admin Panel proving the pattern works (S19 shared package, S20 four screens shipped on a real-engine backend), the question became: tactical Admin-only choice, or platform-wide direction?

## Decision

**All DittoDatto client-facing surfaces are Flutter** (Dart · Riverpod · GoRouter · Material 3 · `mercury_client` shared package). The only Nuxt 4 surface retained is **`dittodatto.no`** — a public marketing/landing page polished AFTER the Flutter app reaches feature completeness. It is NOT a co-equal product surface.

| Surface | Stack | Location | Status |
|---|---|---|---|
| Admin Panel | Flutter | `apps/admin/` | In-progress; foundation laid S19–S20 (4 screens shipped) |
| Business Portal | Flutter (planned) | `apps/business-portal/` (TBD) | Pre-grill — replaces legacy Nuxt webapp |
| Public Marketplace (consumer) | Flutter (Android + iOS) | `apps/marketplace/` | Scaffold; tracer-bullet in /grill public-marketplace |
| `dittodatto.no` landing page | Nuxt 4 (Cloud Run) | `apps/web/public-marketplace/` | Marketing/landing only; polished post-Flutter |
| Legacy Nuxt admin-panel + business-portal | Frozen → retired | `apps/web/{admin-panel,business-portal}/` | Bug-fix-only until Flutter replacement ships |

## Why Flutter for all clients

- `mercury_client` shared package = single HTTP client, JWT auth, model definitions for all three Flutter apps (ADR-0006 §9).
- Riverpod compile-safe state management — same paradigm in all client codebases.
- Material 3 + Moody Blue (`#6f71cc`) — consistent visual identity.
- Cross-platform native — Vipps + BankID native SDKs land on Android + iOS equally; Linux desktop and Web come for free.
- Mobile-first product direction (project-context.md §2: *"Mobile-first via Flutter"*).
- Norway-native dogfooding flows through the Flutter app on devices.

## Why Nuxt stays for `dittodatto.no`

- SSR + SEO + first-impression marketing surface; Flutter Web doesn't serve this as well.
- One-time polish investment, not a continuous product surface.
- Already deployed on Cloud Run; no migration cost.

## Considered Options

| Option | Rejected because |
|---|---|
| Hybrid (Flutter app + Vue Portal/Admin) | Two render/state models → twice the maintenance + UX inconsistency. |
| Nuxt everywhere | Mobile-first product direction; Vipps/BankID native SDKs first-class on mobile. |
| Flutter for marketing too (incl. `dittodatto.no`) | SEO + SSR + first-impression matters too much; revisit post-v1.0. |

## Consequences

- Three Flutter apps share `packages/mercury_client/` — change once, all apps inherit (with proper versioning).
- Business Portal Flutter timeline locked in `/grill business-portal`.
- `dittodatto.no` Nuxt continues to consume MercuryEngine but receives no NEW product features — only marketing/SEO polish.
- Legacy Nuxt admin-panel + business-portal webapps retire upon Flutter feature-parity (bug-fix-only in the interim).
- Engineering: Flutter+Dart proficiency required for all client work; Vue proficiency optional (landing page only).

## Relationship to Other ADRs

- **Extends ADR-0006** (Flutter Admin Panel — establishes foundational patterns).
- **References ADR-0004 + ADR-0005** (Auth — JWT pipeline + admin tiers consumed by Flutter clients).
- **References ADR-0002** (`companies` namespace — all client surfaces speak this DB through MercuryEngine).
- **Does NOT supersede ADR-0006** — that ADR remains the canonical Admin Panel decision record.

---

*Origin: /grill foundation 2026-05-26 — synthesized from surface-inventory lockdown + ADR-0011's existing Flutter foundation patterns.*
