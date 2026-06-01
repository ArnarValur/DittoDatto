# Domain Context

> Domain glossary and ubiquitous language for **DittoDatto**.
> Updated by `/grill` and `/new-track` sessions.
>
> **Last refined:** 2026-05-27

---

## Entities

| Term                      | Definition                                                                                                                                                             | Also known as                         |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| **Establishment**         | A business location registered on the platform — salons, restaurants, garages, clinics, venues.                                                                        | (none)                                |
| **EstablishmentPage**     | The detail screen for a single Establishment in the Public Marketplace (Flutter).                                                                                      | store page, shop page, detail page    |
| **Company**               | The owning business entity on the platform; one Company owns many Establishments. Registered in `companies/registry`.                                                  | tenant, merchant, business owner      |
| **Service**               | An offered booking unit at an Establishment (e.g., "Haircut 30 min"). Booking mode lives here (`standard` / `tableReservation` / `ticketSystem`) — ADR-0010.           | offering, treatment                   |
| **ServiceGroup**          | A grouping of Services on an Establishment (e.g., "Hair", "Beard").                                                                                                    | category (internal), service category |
| **StaffMember**           | A person who performs Services at an Establishment.                                                                                                                    | staff, company staff                  |
| **Customer**              | A person who books at an Establishment. Can be Establishment-scoped                                                                                                    | guest, walk-in                        |
| **User**                  | A consumer platform account, stored in `users/profiles`.                                                                                                               | consumer, platform user               |
| **Booking**               | A confirmed reservation of a Service at a specific time with optional Staff assignment. Fiscally immutable once created.                                               | appointment (when `standard` mode)    |
| **Hold**                  | A short-lived slot lock (TTL via `expires_at`) that prevents double-booking during checkout.                                                                           | slot lock, reservation lock           |
| **Reservation**           | A table/resource booking via `tableReservation` mode (restaurants).                                                                                                    | table booking, group booking          |
| **Ticket**                | A booking via `ticketSystem` mode (venues, events, recurring ticketed activities).                                                                                     | event ticket, admission               |
| **Event**                 | A one-off occurrence at an Establishment (e.g., a salon workshop). Can be ticketed if gated by `Company.enabledFeatures.ticketSystem`.                                 | workshop, special event               |
| **BookingPolicy**         | Embedded rules on an Establishment (cancellation deadline, deposit, reschedule notice, etc.).                                                                          | cancellation policy                   |
| **Schedule**              | The recurring opening pattern of an Establishment or shift pattern of Staff.                                                                                           | opening hours, recurring availability |
| **Shift**                 | A staff working slot within a Schedule.                                                                                                                                | rota slot                             |
| **Holiday**               | A scheduled non-working day at platform / establishment / staff level.                                                                                                 | non-working day                       |
| **DateOverride**          | A one-off override to a Schedule for a specific date.                                                                                                                  | exception, schedule override          |
| **Resource**              | A bookable non-staff asset (e.g., a chair, a table, a room).                                                                                                           | asset, table (when restaurant)        |
| **ResourceGroup**         | Grouping of Resources for cohort booking (e.g., "Window tables").                                                                                                      | resource pool                         |
| **Favorite**              | A User's saved Establishment (or Staff, deferred). Stored in `users/profiles`.                                                                                         | save, bookmark                        |
| **Category**              | A top-level service classification used by DittoBar (e.g., "Beauty", "Restaurant", "Fitness"). Stored in `companies/discovery`.                                        | service type                          |
| **Area**                  | A geographic region used for filtering / browsing (e.g., a fylke, a city). Stored in `companies/discovery`.                                                            | region, zone                          |
| **EstablishmentListing**  | A discovery-side projection of an Establishment for DittoBar search (denormalized for read-perf).                                                                      | search listing, discovery card        |
| **SearchEvent**           | A logged DittoBar query — query string, result count, session, selected result, timestamp, geo location, active filters. Stored in `companies/discovery.search_event`. | search log, analytics event           |
| **Zero-Result Signal**    | A SearchEvent with `resultCount === 0`. Represents unmet demand on the platform.                                                                                       | failed search, demand gap             |
| **SystemAlert**           | Operational notices broadcast by Admin to consumers / businesses (e.g., scheduled maintenance). Stored in `companies/registry`.                                        | banner, broadcast notice              |
| **IconCollection**        | Curated icon sets used across surfaces (categories, badges, agent icons). Stored in `companies/registry`.                                                              | icon library                          |
| **AuditLog**              | Database-level audit trail (CREATE/UPDATE on critical entities) via SurrealDB `DEFINE EVENT`. Stored in `companies/registry`.                                          | activity log                          |
| **MessageThread**         | Conversation between a Customer (or Ditto) and an Establishment (or Datto). Stored in `companies/{slug}`. v1.4 scope.                                                  | conversation                          |
| **Message**               | Single message within a MessageThread.                                                                                                                                 | comm                                  |
| **Entity** (agent memory) | Graph-node representing an actor/object the agent has knowledge of.                                                                                                    | knowledge node                        |
| **Fact** (agent memory)   | Graph-edge or attribute the agent has learned.                                                                                                                         | knowledge edge                        |

### Conceptual entities (platform concepts, not DB tables)

| Term                                  | Definition                                                                                                                                    | Also known as            |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| **MercuryEngine**                     | Booking-only engine (FastAPI / Pydantic v2). Owns Hold→Booking lifecycle and Time Tetris availability. No admin ops, no auth issuance.        | booking API, engine      |
| **DittoBar**                          | Unified search interface in the Public Marketplace. Dual purpose: user search + demand intelligence (Zero-Result Signals).                    | search bar (avoid)       |
| **Ditto**                             | Consumer AI agent (future Layer 2). Finds services, handles bookings.                                                                         | chatbot (avoid)          |
| **Datto**                             | Business AI receptionist agent (future Layer 2, tiered upgrade). Handles inquiries via UCP.                                                   | bot (avoid)              |
| **UCP (Universal Commerce Protocol)** | Future agent-to-agent commerce protocol.                                                                                                      | API (avoid)              |
| **Public Marketplace (Flutter)**      | Consumer-facing native app (iOS + Android). Canonical consumer surface.                                                                       | webapp (avoid)           |
| **`dittodatto.no` landing page**      | Nuxt 4 / Vue 3 marketing page on Cloud Run. Not a product surface — polished after Flutter app ships.                                         | (none)                   |
| **Business Portal**                   | Merchant dashboard for establishments, services, staff, bookings. Flutter (planned).                                                          | (none)                   |
| **Admin Panel**                       | Platform administration interface (Arnar + Höddi). Flutter (`apps/admin/`). Android + Linux desktop + Web. 5 screens. See ADR-0006, PRD v1.0. | back-office (avoid)      |
| **MasterDatto**                       | Future AI agent for cross-company support escalation. Not v1 scope.                                                                           | (none)                   |
| **Inbox** (Admin Panel)               | Within-platform messaging for administrators. Human precursor to MasterDatto.                                                                 | admin inbox              |
| **SearchAnalytics**                   | Separate project (`predict.dittodatto.no`) for Shadow Demand analytics. Merge into Admin Panel TBD.                                           | demand dashboard         |
| **BankID**                            | Norwegian digital identity via Vipps Login (OIDC).                                                                                            | ID verification (avoid)  |
| **Tracer Bullet**                     | Single thin end-to-end path proving the architecture works. v1.0 IS the tracer bullet.                                                        | steel thread (avoid)     |
| **Vertical Slice**                    | Development unit cutting UI→API→DB for one feature.                                                                                           | horizontal slice (avoid) |
| **Time Tetris**                       | Slot-availability algorithm in `mercury_core.calculators.slots`. Pure function, <200ms.                                                       | slot algorithm           |
| **Shadow Demand**                     | Data signal from unauthenticated DittoBar searches. Identifies unmet demand on the platform.                                                  | demand intelligence      |
| **AaaS** (Anything-as-a-Service)      | Monetization model — nothing locked, everything has a limit. Feature access scales with usage.                                                | SaaS (rejected)          |
| **Saturn**                            | On-prem NVIDIA GX10 staging server. Tailscale-gated, never production. Hosts DittoDatto Hub.                                                  | (none)                   |
| **DittoDatto Hub**                    | SurrealDB 3.0 on Saturn (port 8001). Staging source of truth. Both `companies` and `users` namespaces.                                        | the Hub                  |
| **`companies` namespace**             | SurrealDB namespace for non-PII data: per-company DBs, discovery aggregator, platform registry.                                               | (none)                   |
| **`users` namespace**                 | SurrealDB namespace for consumer PII (`users/profiles`). GDPR-isolated.                                                                       | (none)                   |
| **Tailscale**                         | Mesh VPN for team + AI agents to reach Saturn staging. No public exposure.                                                                    | (none)                   |
| **`ditto_design`**                    | Shared Flutter design system package (`packages/ditto_design/`). Tokens, theme, layout, shell widget. See ADR-0014.                           | design system (avoid)    |
| **SolarTheme**                        | Time-of-day theme switching based on solar position. Future `ditto_design` layer, not v1.                                                     | day-cycle mode           |
| **`DittoDashboardShell`**             | Shared responsive dashboard shell in `ditto_design`. Sidebar + content panel, drawer on compact. Used by Admin Panel and Business Portal.     | dashboard layout         |
| **`DittoWindowClass`**                | Enum in `ditto_design` for Material 3 breakpoints: compact (<600), medium (600–839), expanded (840–1199), large (≥1200).                      | breakpoint class         |

---

## Relationships

- A **Company** owns one or more **Establishment**s.
- An **Establishment** offers many **Service**s. A **Service** has one **booking mode** (`standard` / `tableReservation` / `ticketSystem`).
- An **Establishment** employs many **StaffMember**s. A **Service** has an `assignedStaff` list.
- A **Booking** references one **Service**, optionally one **StaffMember**, optionally one **Resource**, and one **Customer** or **User**.
- A **Hold** precedes a **Booking** with a TTL (`expires_at`).
- A **SearchEvent** logs a **DittoBar** query. Zero-result subsets are **Zero-Result Signals**.
- **Ditto** ↔ **Datto** communicate via **UCP** (future).
- The **Admin Panel** connects directly to SurrealDB via WebSocket (ADR-0006).

---

## Terminology Boundaries

| Use                             | Instead of                                          |
| ------------------------------- | --------------------------------------------------- |
| Establishment                   | store, shop, venue                                  |
| StaffMember / staffId           | Person / personId                                   |
| Public Marketplace              | webapp, frontend, frontpage                         |
| Admin Panel                     | back-office, control panel                          |
| Business Portal                 | admin dashboard, merchant app                       |
| MercuryEngine                   | (no version suffix)                                 |
| Tracer Bullet / Vertical Slice  | steel thread                                        |
| BankID                          | ID verification                                     |
| `companies` / `users` namespace | Making up namespaces                                |
| DittoDatto Hub                  | (only the Saturn SurrealDB instance, not local dev) |

---

## Open Questions — Deferred to Grills

### `/grill business-portal`
- Full PRD
- Operator-side UX patterns

### `/grill public-marketplace`
- Flutter consumer app PRD
- DittoBar interaction model