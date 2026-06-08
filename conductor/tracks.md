# Tracks Registry

All tracks organized by domain. Each track links to its dedicated folder.

---

## 🗂️ Domain Structure

> The three domains the user plans to grill individually (per `grill_strategy.md`) are listed below as **planned domains**. They will be formalized — with paths, caution levels, and active tracks — once the foundation grill consolidates the surface inventory.

| Domain | Path (planned) | Caution Level | Notes |
|---|---|---|---|
| **MercuryEngine** | `services/mercury-engine/` | 🔴 Critical | Core platform. Legacy code in `DittoDatto-old/services/mercury-engine/` (377 tests). To be migrated track-by-track. |
| **Admin Panel** | `apps/admin/` | 🟡 Active | Flutter, in-progress (S19–S20). Foundation grill + Admin Panel grill will scope next work. |
| **Business Portal** | `apps/business-portal/` | 🔴 Tread Carefully | Full Flutter replacement of legacy Nuxt webapp. [PRD exists](./business-portal-prd.md). |
| **Public Marketplace (native)** | `apps/marketplace/` | 🔴 To regrill | Flutter tracer-bullet (scaffold only in legacy). |
| **Public Marketplace (web)** | `apps/web/public-marketplace/` | 🟡 Active | Nuxt 4 / Vue 3 — kept as a dual surface. |
| **Shared Dart packages** | `packages/mercury_client/` | 🔴 Critical | Consumed by all Flutter apps. |
| **Infrastructure** | Saturn (GX10) on-prem + SurrealDB | 🟢 Active | Staging environment fully deployed and live (ADR-0003). |

---

## Active Tracks

- [ ] **Admin Panel — Flutter platform administration interface**
  - *Type:* feature | *Domain:* admin-panel | *Status:* in-progress (needs grill/alignment)
  - *Link:* [tracks/admin-panel/admin_panel_20260527/](./tracks/admin-panel/admin_panel_20260527/)
  - *Phases:* 5 — (1) Monorepo + ditto_design + Shell, (2) Auth + Login, (3) Dashboard, (4) Users + Companies + Categories, (5) Inbox + Polish [checkpoint: pending user approval]

- [ ] **Business Portal — Scaffold project and router shell**
  - *Type:* feature | *Domain:* business-portal | *Status:* new
  - *Link:* [tracks/business-portal/business_portal_scaffold_20260608/](./tracks/business-portal/business_portal_scaffold_20260608/)

---

## Completed Tracks

_None._

> Chapter 1 + Chapter 2 historical track records live in `conductor/docs/legacy/conductor-snapshot/tracks.md` for reference (377 tests, S18 admin routes, S19 mercury_client + Flutter scaffold, S20 Admin Panel screens, etc.).

---

## 💡 Strategy Reference

See `grill_strategy.md` at the workspace root for Hermes's recommended `/conductor-init` → `/grill foundation` → `/grill <domain>` sequencing.
