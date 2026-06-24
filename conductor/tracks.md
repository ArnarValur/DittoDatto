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
| **Auth Service** | `services/auth-service/` | 🔴 Critical | SurrealDB-native auth + shared `ditto_auth` Dart package. New domain. |

---

## Active Tracks

- [ ] **Admin Panel — Flutter platform administration interface**
  - *Type:* feature | *Domain:* admin-panel | *Status:* in-progress (needs grill/alignment)
  - *Link:* [tracks/admin-panel/admin_panel_20260527/](./tracks/admin-panel/admin_panel_20260527/)
  - *Phases:* 5 — (1) Monorepo + ditto_design + Shell, (2) Auth + Login, (3) Dashboard, (4) Users + Companies + Categories, (5) Inbox + Polish [checkpoint: pending user approval]

- [ ] **Business Portal — Login redesign + Establishments CRUD**
  - *Type:* feature | *Domain:* business-portal | *Status:* in-progress
  - *Link:* [tracks/business-portal/bp_login_establishments_20260614/](./tracks/business-portal/bp_login_establishments_20260614/)
  - *Phases:* 5 — (1) Design System Light Theme, (2) Login Redesign, (3) Establishments List, (4) Establishment Create + Edit, (5) Integration & Polish
- [ ] **Auth Service — SurrealDB-native auth consolidation + shared ditto_auth package**
  - *Type:* feature | *Domain:* auth-service | *Status:* in-progress
  - *Link:* [tracks/auth-service/auth_service_20260624/](./tracks/auth-service/auth_service_20260624/)
  - *Phases:* 4 — (1) Research & Design, (2) ditto_auth Package + Schema Definitions, (3) BP Migration, (4) Marketplace Consumer Auth



---

## Completed Tracks

- [x] **Business Portal — Scaffold project and router shell** [checkpoint: `eadc310`]
  - *Type:* feature | *Domain:* business-portal | *Status:* completed
  - *Link:* [tracks/business-portal/business_portal_scaffold_20260608/](./tracks/business-portal/business_portal_scaffold_20260608/)
  - *Phases:* 3 — (1) Project Scaffolding, (2) Router & Shell Setup, (3) Verification & Compilation

> Chapter 1 + Chapter 2 historical track records live in `conductor/docs/legacy/conductor-snapshot/tracks.md` for reference (377 tests, S18 admin routes, S19 mercury_client + Flutter scaffold, S20 Admin Panel screens, etc.).

---

## 💡 Strategy Reference

See `grill_strategy.md` at the workspace root for Hermes's recommended `/conductor-init` → `/grill foundation` → `/grill <domain>` sequencing.
