---
title: "DittoDatto — Domain Context"
type: "context"
status: "living"
date: "2026-05-02"
updated: "2026-05-03"
domain: "Platform"
tags:
  - "glossary"
  - "domain"
  - "terminology"
  - "source-of-truth"
---

# DittoDatto — Domain Context

The agentic commerce platform for Norway. Consumers find and book local services through AI-mediated interfaces. Businesses manage operations through intelligent dashboards.

## Language

**Public Marketplace**:
The consumer-facing native application (Flutter, iOS + Android). The primary product surface where users discover, book, and manage services.
_Avoid_: webapp, website, frontend, client app

**Establishment**:
A business location registered on the platform — salons, restaurants, garages, clinics, etc. The user-facing term for what the database stores as an `establishment` record (previously `store` in Firestore).
_Avoid_: store (user-facing), shop, venue, location

**EstablishmentPage**:
The detail screen for a single **Establishment** in the **Public Marketplace**. Shows services, staff, info, and the booking entry point.
_Avoid_: store page, shop page, detail page

**Web Shell**:
A minimal static web presence at `dittodatto.no` — landing page, app store links, and basic SEO/establishment pages. Not a product surface; transitional scaffolding.
_Avoid_: public-marketplace (when referring to the web)

**BankID**:
Norwegian digital identity verification. Mandatory for self-service online transactions (booking through the app, online payments). NOT required for staff-created accounts — a business can add a walk-in customer to the system without BankID. That person can later download the app and verify to unlock self-service capabilities.
_Avoid_: ID verification, identity check

**Business Portal**:
The merchant dashboard for managing stores, services, staff, and bookings. Currently Nuxt web; planned Flutter migration after Public Marketplace ships.
_Avoid_: admin dashboard, merchant app

**Admin Panel**:
Internal platform operations and analytics. Nuxt web, no migration planned.
_Avoid_: back-office, control panel

**MercuryEngine**:
The standalone booking/reservation/availability microservice. Source of truth for all time-slot calculations, holds, and bookings. Consumed by all client applications via REST API.
_Avoid_: booking API, functions, backend

**TheOracle** (conceptual):
The discovery concern within **MercuryEngine** — DittoBar queries, geo search, category browsing, and demand signal harvesting. Originally planned as a separate microservice (ADR-0007 v1), merged back into MercuryEngine after the SurrealDB platform pivot unified the data layer. The discovery routes and the `titan/discovery` database remain logically separate from booking concerns, but share the same API server. See [ADR-0007](adr/0007-dittobar-search-on-theoracle.md) (revised), [ADR-0008](adr/0008-surrealdb-platform-graph-database.md).
_Avoid_: search API, search service, separate microservice

**Ditto**:
The consumer's personal AI agent. Finds services, handles bookings, watches marketplaces. Future Layer 2 feature.
_Avoid_: chatbot, assistant

**Datto**:
The business's AI receptionist agent. Handles inquiries, manages availability, communicates with Ditto agents. Future Layer 2 feature (tiered upgrade for businesses).
_Avoid_: bot, auto-responder

**UCP (Universal Commerce Protocol)**:
The agent-to-agent interoperability protocol. Replaces traditional discovery (SEO/browsing) with structured agent-mediated commerce. Future standard.
_Avoid_: API, webhook

**DittoBar**:
_Avoid_: search bar, search component

**Search Event**:
A logged record of a DittoBar query. Contains: query string, result count, session ID, selected result (if any), timestamp, **user geo location** (for demand mapping), **active filters** (category, radius, city), **nearest result distance** (for gap analysis). Stored in SurrealDB `titan/discovery` as the `search_event` table. Consumed by the SearchAnalytics dashboard.
_Avoid_: search log, analytics event

**Tracer Bullet**:
A single, thin end-to-end path through every layer of the system that proves the architecture works. Term from _The Pragmatic Programmer_.
_Avoid_: steel thread, proof of concept

**Vertical Slice**:
A development unit that cuts through all layers (UI → API → DB) for one feature, independently shippable.
_Avoid_: horizontal slice, task-based breakdown

## Version Roadmap

**v1.0 (Core Tracer Bullet)**:
Auth (**BankID** mandatory) → Home (Map + **DittoBar** + curated listings) → Category Browse → **EstablishmentPage** → Appointment Booking → Profile (bookings + cancel). The first complete vertical through the platform.

**v1.1 (Stickiness)**:
Favorites system, profile polish. Makes browsing sticky and personal.

**v1.2 (Restaurant Vertical)**:
Table Reservations. Core feature to serve and accommodate restaurants — a key **Establishment** category.

**v1.3 (Payment)**:
Vipps integration. Enables deposits, no-show fees, pre-payment.

**v1.4 (Comms Layer)**:
Messages/threads and push notifications. The neural network between customers and companies — the foundation for **Ditto** ↔ **Datto** communication.

**v1.5 (Agentic Path)**:
**Ditto** agent interface. Text/voice requests, agent-mediated discovery and booking via **Datto**. Requires Saturn infrastructure.

## Relationships

- The **Public Marketplace** consumes **MercuryEngine** for all booking and discovery operations
- The **Business Portal** configures what **MercuryEngine** serves (services, staff, hours, resources)
- **MercuryEngine** is the single API server — both booking routes and discovery routes (formerly TheOracle)
- **Ditto** and **Datto** communicate via **UCP** (future)
- The **Web Shell** links to the **Public Marketplace** (app stores) and provides SEO fallback
- The **Admin Panel** monitors all platform operations
- v1.0 through v1.5 are additive layers on the same booking spine — each version widens the tracer bullet
- Merkurial Studio dogfoods the platform: runs its own business on DittoDatto alongside customers
- **DittoBar** is the universal entry point: services today, second-hand marketplace tomorrow, agentic queries via **Ditto** in v1.5

## Navigation (Public Marketplace — Flutter)

Three-tab bottom navigation:

| Tab | Screen | Notes |
|-----|--------|-------|
| 🏠 **Home** | Map + **DittoBar** + curated listings | Discovery IS home — no separate browse tab |
| 📅 **Bookings** | Upcoming & past bookings, cancel | Promoted from profile sub-section |
| 👤 **Profile** | Account, settings, favorites (v1.1) | Minimal in v1.0 |

## Establishment Verticals

Three business verticals, each with a primary booking mode:

| `storeType` | Booking Mode | Description |
|---|---|---|
| `service` | `standard` | 1:1 time-based appointments — salons, clinics, garages, massage |
| `restaurant` | `tableReservation` | Capacity-based group bookings — restaurants, cafés |
| `venue` | `ticketSystem` | Ticketing-based — nightclubs, concert halls, event spaces |

- **Any** establishment can create one-off **Events** (a salon hosting a workshop). Events with ticketing are gated by `Company.enabledFeatures.ticketSystem` (feature flag / tier).
- **Venues** have ticketing as their _primary_ booking mode — they need frequent, recurring ticketing (the Scandinavian Ticketmaster play).
- `storeType` determines the default booking UX and **MercuryEngine** behavior for that establishment.

## Principles

- **Opt-in agentic**: Agentic features are never forced on users or businesses. The platform must deliver full value without AI.
- **Per-service booking modes** (ADR-0004): Booking mode (`standard`, `tableReservation`, `ticketSystem`) lives on the **Service**, not the Store. One establishment can have multiple booking modes across its services. A venue can have ticketed events AND bookable party halls. A salon can have appointments AND ticketed workshops.
- **AaaS over SaaS** (ADR-0005): Nothing is locked, everything has a limit. Feature access is not gated by boolean toggles — capabilities scale with usage. Datto (v1.5) mediates activation conversationally. `enabledFeatures` is transitional scaffolding.
- **Staff assignment is explicit** (ADR-0006): Empty `assignedStaff` on a Service = not bookable. Staff assignment mode (`customer_choice`, `any_available`, `manual`) is per-service. Datto enhances `any_available` with intelligent scoring in v1.5.
- **Fiscal immutability**: Booking snapshots (price, service title, user info) are captured at creation time and never updated. Legal requirement for Norwegian commerce.
- **Dogfooding**: Merkurial Studio operates on the same platform it sells. If it doesn't work for us, it doesn't ship.
- **No tvíverknað**: Don't build in clay when porcelain is available. Build it right once.
- **Drammen first**: Start local (Drammen), prove value, expand by fylke. Eventually Scandinavia (Höddi in Sweden).
- **Best porcelain per layer**: Use the right tool for each concern. SurrealDB 3.0 as the unified data platform (see [ADR-0008](adr/0008-surrealdb-platform-graph-database.md), [ADR-0009](adr/0009-surrealdb-namespace-architecture.md)), BankID/Vipps OIDC for authentication, Google Maps for maps, Flutter for mobile. Google ecosystem for services and AI; SurrealDB for the agentic data foundation. Evolved from "Google-first" to "best fit per layer" (Session 4), then unified on SurrealDB (Session 7 pivot).

## Tech Defaults (Flutter Public Marketplace)

| Area | Choice | Rationale |
|------|--------|-----------|
| State management | **Riverpod** | Compile-safe, testable, Flutter-native |
| Map provider | **Google Maps** (`google_maps_flutter`) | Google ecosystem, native rendering, future Ditto canvas (see [ADR-0002](adr/0002-hybrid-collapsible-map-home-screen.md)) |
| Routing | **GoRouter** | Declarative, deep-link support |
| i18n | **Norwegian (bokmål) + English** from day 1 | Norway-first but tourist/immigrant accessible |
| Design system | **Material 3** + DittoDatto brand tokens | moody-blue palette, pickled-bluewood, mountain-meadow (from Nuxt brand system) |
| Auth | **BankID** (mandatory) via Vipps Login (OIDC) | SurrealDB native auth + BankID/Vipps OIDC. See `.docs/postit/bankid-vipps-auth.md` |
| Backend | **MercuryEngine** (REST) + **SurrealDB 3.0** | Single API server for booking + discovery. SurrealDB as sole platform DB. See [ADR-0008](adr/0008-surrealdb-platform-graph-database.md), [ADR-0009](adr/0009-surrealdb-namespace-architecture.md) |

## Strategic Scope (Future)

- **Second-hand marketplace (~6 months post-launch)**: Users can list items for sale via their Ditto agent — like Finn.no but agentic. Each user becomes their own "bruktsbutikk." Same **DittoBar** entry point, same **UCP** protocol.
- **Scandinavia expansion**: Norway first (Drammen → national), then Sweden (Höddi partnership).
- **External AI integration**: **MercuryEngine** API designed to be callable by any AI agent — not just **Ditto**. Gemini Extensions, GPT Actions, Apple App Intents (via Gemini/Siri). DittoDatto becomes discoverable through whatever AI interface the user prefers. This is **UCP** in practice.
- **Home screen widgets**: OS-level widgets (Android/iOS) so users can interact with **Ditto** without opening the app. Deferred to post-v1.5.

## Example dialogue

> **Dev:** "Where does the **DittoBar** search get its results from?"
> **Domain expert:** "From **MercuryEngine's discovery routes** — they query the SurrealDB `titan/discovery` database for establishments, services, and categories. TheOracle was merged into MercuryEngine after the SurrealDB unification."

> **Dev:** "Can a user create an account without **BankID**?"
> **Domain expert:** "No. **BankID** is mandatory. No exceptions."

> **Dev:** "Is the 'store detail page' the same as the **EstablishmentPage**?"
> **Domain expert:** "Yes — we say **EstablishmentPage** in Flutter. 'Store' is only a legacy Zod schema name (`StoreSchema`). The SurrealDB table is `establishment`."

## Flagged ambiguities

- "public-marketplace" historically referred to both the Nuxt web app and the consumer product concept — resolved: **Public Marketplace** = Flutter native app; the Nuxt remnant is **Web Shell**.
- "steel thread" was used in early vision docs — resolved: use **Tracer Bullet** or **Vertical Slice** instead. No Microsoft terminology.
- "store" vs "establishment" — **resolved (Session 2, updated Session 10):** **Establishment** is the domain term and the SurrealDB table name. `store` remains as the Zod schema name (`StoreSchema`, `storeId`) for backward compatibility. Flutter domain models use `Establishment` / `establishmentId`. The repository layer maps between Zod schemas and SurrealDB records.
- "person" vs "staff member" — resolved: **Person** is deprecated. **Staff Member** (`StaffMemberSchema`) is canonical. ✅ `personId` fields migrated to `staffId` across all schemas and MercuryEngine (Session 3, 2026-05-02).
- "favorite a person?" — `UserFavoriteSchema` supports `type: "store" | "person"`. Primary use is favoriting **Establishments**. Whether to surface staff favoriting in the Flutter app is deferred to v1.1 scope.
