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
  - *Type:* feature | *Domain:* auth-service | *Status:* **paused** (Phase 1-3 complete, waiting on Marketplace for Phase 4)
  - *Link:* [tracks/auth-service/auth_service_20260624/](./tracks/auth-service/auth_service_20260624/)
  - *Phases:* 4 — (1) Research & Design ✅, (2) ditto_auth Package + Schema ✅, (3) BP Migration ✅, (4) Marketplace Consumer Auth

- [ ] **Marketplace Foundation — Flutter scaffold + consumer auth (signup/login/profile)**
  - *Type:* feature | *Domain:* marketplace | *Status:* in-progress
  - *Link:* [tracks/marketplace/marketplace_foundation_20260624/](./tracks/marketplace/marketplace_foundation_20260624/)
  - *Phases:* 4 — (1) Project Scaffold + Nav Shell, (2) Consumer Auth, (3) Profile Page, (4) Integration Testing + Saturn Deploy
  - *Depends on:* Auth Service Phase 2 (consumer_auth schema + ditto_auth consumer methods)

- [ ] **BP Establishment Page Preview — shared EstablishmentPage widget + preview toggle in edit screen**
  - *Type:* feature | *Domain:* business-portal | *Status:* in-progress
  - *Link:* [tracks/business-portal/bp_establishment_preview_20260625/](./tracks/business-portal/bp_establishment_preview_20260625/)
  - *Phases:* 4 — (1) Shared Package Scaffold, (2) EstablishmentPage Widget, (3) BP Integration, (4) Verification

- [x] **Media Manager Package — Extract media management into `packages/media_manager/` shared package** [checkpoint: `6c465c9`]
  - *Type:* feature | *Domain:* shared-packages | *Status:* complete
  - *Link:* [tracks/shared-packages/media_manager_package_20260626/](./tracks/shared-packages/media_manager_package_20260626/)
  - *Phases:* 4 — (1) Package Scaffold + Data Layer ✅, (2) Gallery Page Widget ✅, (3) Inline Picker + Modal ✅, (4) BP Integration + Verification ✅
  - *Depends on:* ADR-0021 (Media Manager as Shared Package)

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
