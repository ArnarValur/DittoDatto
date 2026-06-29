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
| **Geo Integration** | `packages/establishment_ui/` (services) | 🟢 Active | Kartverket + Nominatim + flutter_map. Cross-cutting: Admin, BP, Marketplace. |
| **Services** | `packages/establishment_ui/` + `apps/*/features/services/` | 🟡 Careful | Service display + CRUD. Cross-cutting: Marketplace, BP, future booking flow. |
| **Ticketing** | `packages/establishment_ui/` + `apps/*/features/events/` + `schemas/` | 🟡 Careful | Events + ticketSystem booking mode. ServiceGroup = Event (ADR-0022), independent flags (ADR-0023). Depends on Services domain. |

---

## Active Tracks

- [ ] **SolarTheme — Time-of-day atmospheric theming (solar engine, star field, gradient sky)**
  - *Type:* feature | *Domain:* design-system | *Status:* **Phase 1 complete** (engine ported, demo running on device)
  - *Link:* [tracks/design-system/solar_theme_20260628/](./tracks/design-system/solar_theme_20260628/)
  - *Phases:* 5 — (1) Solar Engine + Foundation ✅, (2) Theme Integration, (3) Twilight Transitions & Polish, (4) Shared EstablishmentPage, (5) Hue Palette (deferred — marinating)
  - *Grilled decisions:* Outfit+Inter typography ✅, Marketplace+BP preview surfaces ✅, gradient+stars atmosphere ✅, hue palette marinating

- [x] **Services Section — EstablishmentPage display + BP CRUD for service management** [checkpoint: Phase 3+4 complete]
  - *Type:* feature | *Domain:* services | *Status:* **completed**
  - *Link:* [tracks/services/services_section_20260628/](./tracks/services/services_section_20260628/)
  - *Phases:* 4 — (1) Data Layer ✅, (2) BP Services CRUD ✅, (3) Marketplace Display ✅, (4) Verification + Deploy ✅
  - *What works:* ServiceCard (3 booking-mode variants), ServiceGroupSection (collapsible), EstablishmentServicesSection (groups, sorts, filters inactive + soft-deleted). 95 package tests, 75 BP integration tests. Deployed to Saturn :8003 + phone. User E2E verified.
  - *Deferred:* MultiSelectGroup checkboxes (booking UX grill), isActive badge in BP list view (minor polish)

- [ ] **Ticketing & Events — Event system + ticketSystem booking mode + recurring events**
  - *Type:* feature | *Domain:* ticketing | *Status:* **new**
  - *Link:* [tracks/ticketing/ticketing_events_20260628/](./tracks/ticketing/ticketing_events_20260628/)
  - *Phases:* 5 — (1) Schema + Data Layer, (2) BP Event CRUD, (3) Marketplace Event Display, (4) Recurring Events MVP, (5) Verification + Deploy
  - *Depends on:* ADR-0022 (ServiceGroup = Event), ADR-0023 (Independent Feature Flags), `services_section_20260628` Phase 1–2
  - *Grilled decisions:* ServiceGroup = Event container ✅, Services = Ticket tiers ✅, independent event_system/ticket_system flags ✅, RFC 5545 rrule for recurrence ✅, auto-create + notify for recurring ✅

- [ ] **Favorites Toggle — Wire the Lagre button on EstablishmentPage (toggle, persistence, auth gate)**
  - *Type:* feature | *Domain:* marketplace | *Status:* **new**
  - *Link:* [tracks/marketplace/favorites_toggle_20260630/](./tracks/marketplace/favorites_toggle_20260630/)
  - *Phases:* 3 — (1) Data Layer, (2) UI Wiring + Auth Gate, (3) Verification + Deploy
  - *Depends on:* Auth Service Phase 1–3 (✅ built), `favorite` schema in `users.surql` (✅ exists)
  - *Deferred:* `favorites_count` counter sync, favorites list screen (profile polish), staff favorites

- [ ] **Auth Service — SurrealDB-native auth consolidation + shared ditto_auth package**
  - *Type:* feature | *Domain:* auth-service | *Status:* **ready for Phase 4** (Marketplace consumer auth now live)
  - *Link:* [tracks/auth-service/auth_service_20260624/](./tracks/auth-service/auth_service_20260624/)
  - *Phases:* 4 — (1) Research & Design ✅, (2) ditto_auth Package + Schema ✅, (3) BP Migration ✅, (4) Marketplace Consumer Auth (unblocked)

- [x] **Media Manager Package — Extract media management into `packages/media_manager/` shared package** [checkpoint: `6c465c9`]
  - *Type:* feature | *Domain:* shared-packages | *Status:* complete
  - *Link:* [tracks/shared-packages/media_manager_package_20260626/](./tracks/shared-packages/media_manager_package_20260626/)
  - *Phases:* 4 — (1) Package Scaffold + Data Layer ✅, (2) Gallery Page Widget ✅, (3) Inline Picker + Modal ✅, (4) BP Integration + Verification ✅
  - *Depends on:* ADR-0021 (Media Manager as Shared Package)

- [ ] **Map & Geocoding — Shared map widget + Kartverket address autocomplete + Nominatim geocoding**
  - *Type:* feature | *Domain:* geo-integration | *Status:* **Phases 1–6 complete** (Admin + BP deployed, live on Saturn)
  - *Link:* [tracks/geo-integration/map_and_geocoding_20260628/](./tracks/geo-integration/map_and_geocoding_20260628/)
  - *Phases:* 8 — (1) Data Layer ✅, (2) Geocoding Services ✅, (3) Map Widget ✅, (4) BP Integration ✅, (5) Admin Integration ✅, (6) Verification ✅, (7) Marketplace Discovery Map, (8) Sweden Support
  - *What works:* Kartverket autocomplete (Admin + BP) ✅, flutter_map with OSM tiles ✅, GeoJSON round-trip to SurrealDB ✅. Future: multi-pin marketplace map, Swedish addresses.

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
