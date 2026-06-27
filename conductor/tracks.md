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
| **Design System** | `packages/ditto_design/` | 🟡 Active | Shared theme, tokens, layout, solar engine. Consumed by all Flutter apps. |
| **Auth Service** | `services/auth-service/` | 🔴 Critical | SurrealDB-native auth + shared `ditto_auth` Dart package. New domain. |

---

## Active Tracks

- [ ] **SolarTheme — Time-of-day atmospheric theming (solar engine, star field, gradient sky)**
  - *Type:* feature | *Domain:* design-system | *Status:* **Phase 1 complete** (engine ported, demo running on device)
  - *Link:* [tracks/design-system/solar_theme_20260628/](./tracks/design-system/solar_theme_20260628/)
  - *Phases:* 5 — (1) Solar Engine + Foundation ✅, (2) Theme Integration, (3) Twilight Transitions & Polish, (4) Shared EstablishmentPage, (5) Hue Palette (deferred — marinating)
  - *Grilled decisions:* Outfit+Inter typography ✅, Marketplace+BP preview surfaces ✅, gradient+stars atmosphere ✅, hue palette marinating

- [ ] **Auth Service — SurrealDB-native auth consolidation + shared ditto_auth package**
  - *Type:* feature | *Domain:* auth-service | *Status:* **ready for Phase 4** (Marketplace consumer auth now live)
  - *Link:* [tracks/auth-service/auth_service_20260624/](./tracks/auth-service/auth_service_20260624/)
  - *Phases:* 4 — (1) Research & Design ✅, (2) ditto_auth Package + Schema ✅, (3) BP Migration ✅, (4) Marketplace Consumer Auth (unblocked)

- [x] **Media Manager Package — Extract media management into `packages/media_manager/` shared package** [checkpoint: `6c465c9`]
  - *Type:* feature | *Domain:* shared-packages | *Status:* complete
  - *Link:* [tracks/shared-packages/media_manager_package_20260626/](./tracks/shared-packages/media_manager_package_20260626/)
  - *Phases:* 4 — (1) Package Scaffold + Data Layer ✅, (2) Gallery Page Widget ✅, (3) Inline Picker + Modal ✅, (4) BP Integration + Verification ✅
  - *Depends on:* ADR-0021 (Media Manager as Shared Package)

---

## Completed Tracks

- [x] **Marketplace Foundation — Flutter scaffold + consumer auth (signup/login/profile)** [checkpoint: phase-4-tests]
  - *Type:* feature | *Domain:* marketplace | *Status:* completed
  - *Link:* [tracks/marketplace/marketplace_foundation_20260624/](./tracks/marketplace/marketplace_foundation_20260624/)
  - *Phases:* 4 — (1) Project Scaffold + Nav Shell ✅, (2) Consumer Auth ✅, (3) Profile Page ✅, (4) Integration Testing + Saturn Deploy ✅
  - *What works:* Signup/login/logout ✅, Profile page ✅, Route guards ✅, 7 integration tests + 25 widget tests. Deployed to Saturn `:8004`.
  - *Deferred to next tracks:* Discovery/home, bookings, search.

- [x] **Business Portal Chapter 1 — Login + Establishments + Preview + Media** [checkpoint: graduation]
  - *Type:* feature | *Domain:* business-portal | *Status:* completed
  - *Tracks merged:* `bp_login_establishments_20260614` + `bp_establishment_preview_20260625`
  - *Links:* [login+establishments](./tracks/business-portal/bp_login_establishments_20260614/) · [preview](./tracks/business-portal/bp_establishment_preview_20260625/)
  - *What works:* Login/logout ✅, Establishments CRUD ✅, Preview toggle ✅, Media upload/select/remove ✅, EstablishmentPage with cover+gallery+logo ✅. Deployed to Saturn `:8003`.
  - *Deferred to Chapter 2:* EstablishmentPage UI polish (bento/showcase/spotlight layouts), responsive layout, coverage gate, preview integration test.
  - *Notes:* User-confirmed 2026-06-27. E2E checklist at `conductor/docs/media-manager-e2e-checklist.md` — user working through gradually.

- [x] **Admin Panel Chapter 1 — Flutter platform administration interface** [checkpoint: graduation]
  - *Type:* feature | *Domain:* admin-panel | *Status:* completed
  - *Link:* [tracks/admin-panel/admin_panel_20260527/](./tracks/admin-panel/admin_panel_20260527/)
  - *Phases:* 5 — (1) Monorepo + ditto_design + Shell ✅, (2) Auth + Login ✅, (3) Dashboard ✅, (4) Users + Companies + Categories ✅, (5) Inbox + Polish (deferred to Chapter 2)
  - *Notes:* User-confirmed 2026-06-27. Login, Users, Companies, Categories all working. 50 integration tests. Inbox + advanced features → future re-grill.

- [x] **Business Portal — Scaffold project and router shell** [checkpoint: `eadc310`]
  - *Type:* feature | *Domain:* business-portal | *Status:* completed
  - *Link:* [tracks/business-portal/business_portal_scaffold_20260608/](./tracks/business-portal/business_portal_scaffold_20260608/)
  - *Phases:* 3 — (1) Project Scaffolding, (2) Router & Shell Setup, (3) Verification & Compilation

> Chapter 1 + Chapter 2 historical track records live in `conductor/docs/legacy/conductor-snapshot/tracks.md` for reference (377 tests, S18 admin routes, S19 mercury_client + Flutter scaffold, S20 Admin Panel screens, etc.).

---

## 💡 Strategy Reference

See `grill_strategy.md` at the workspace root for Hermes's recommended `/conductor-init` → `/grill foundation` → `/grill <domain>` sequencing.
