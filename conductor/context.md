# Domain Context

> Domain glossary and ubiquitous language for **DittoDatto**.
> Updated by `/grill` and `/new-track` sessions.
>
> **Pre-populated from targeted domain scan during `/conductor-init` (2026-05-26)** — sourced from `DittoDatto-old/services/mercury-engine/src/mercury_core/models/`, `DittoDatto-old/schemas/*.surql`, `DittoDatto-old/.docs/types/`, and `DittoDatto-old/.docs/CONTEXT.md`. Refine with `/grill`.
>
> **Authoritative legacy starting point:** `conductor/docs/legacy/CONTEXT.md` — the foundation grill will sharpen this into the canonical v2.1 glossary.

---

## Entities

> Confirmed via brownfield scan. Foundation grill will refine definitions, resolve open ambiguities, and add relationships.

| Term | Definition (seed — refine in grill) | Also known as |
|------|-------------------------------------|---------------|
| **Establishment** | A business location registered on the platform — salons, restaurants, garages, clinics, venues. The user-facing term for the `establishment` table. | `store` (legacy Zod / `StoreSchema`), `storeId` (legacy FK) |
| **EstablishmentPage** | The detail screen for a single Establishment in the Public Marketplace (Flutter). | store page, shop page, detail page |
| **Company** | The owning business entity on the platform; one Company owns many Establishments. Registered in `titan/platform`. | tenant, merchant, business owner |
| **Service** | An offered booking unit at an Establishment (e.g., "Haircut 30 min"). Booking mode lives here (`standard` / `tableReservation` / `ticketSystem`). | offering, treatment |
| **ServiceGroup** | A grouping of Services on an Establishment (e.g., "Hair", "Beard"). | category (internal), service category |
| **StaffMember** | A person who performs Services at an Establishment. Migrated from `Person`. | `Person` (deprecated), `personId` (deprecated → `staffId`) |
| **Customer** | A person who books at an Establishment. Can be Establishment-scoped (walk-in, no BankID) or a platform User (BankID-verified consumer). | guest, walk-in |
| **User** | A consumer with a BankID-verified platform account, stored in `enceladus/users`. | consumer, platform user |
| **Booking** | A confirmed reservation of a Service at a specific time with optional Staff assignment. Fiscally immutable once created. | appointment (when `standard` mode) |
| **Hold** | A short-lived slot lock (TTL via `expires_at`) that prevents double-booking during checkout. | slot lock, reservation lock |
| **Reservation** | A table/resource booking via `tableReservation` mode (restaurants). | table booking, group booking |
| **Ticket** | A booking via `ticketSystem` mode (venues, events, recurring ticketed activities). | event ticket, admission |
| **Event** | A one-off occurrence at an Establishment (e.g., a salon workshop). Can be ticketed if gated by `Company.enabledFeatures.ticketSystem`. | workshop, special event |
| **BookingPolicy** | Embedded rules on an Establishment (cancellation deadline, deposit, reschedule notice, etc.). | cancellation policy |
| **Schedule** | The recurring opening pattern of an Establishment or shift pattern of Staff. | opening hours, recurring availability |
| **Shift** | A staff working slot within a Schedule. | rota slot |
| **Holiday** | A scheduled non-working day at platform / establishment / staff level. | non-working day |
| **DateOverride** | A one-off override to a Schedule for a specific date. | exception, schedule override |
| **Resource** | A bookable non-staff asset (e.g., a chair, a table, a room). | asset, table (when restaurant) |
| **ResourceGroup** | Grouping of Resources for cohort booking (e.g., "Window tables"). | resource pool |
| **Favorite** | A User's saved Establishment (or Staff, deferred). Stored in `enceladus/users`. | save, bookmark |
| **Category** | A top-level service classification used by DittoBar (e.g., "Beauty", "Restaurant", "Fitness"). Stored in `titan/discovery`. | service type |
| **Area** | A geographic region used for filtering / browsing (e.g., a fylke, a city). Stored in `titan/discovery`. | region, zone |
| **EstablishmentListing** | A discovery-side projection of an Establishment for DittoBar search (denormalized for read-perf). | search listing, discovery card |
| **SearchEvent** | A logged DittoBar query — query string, result count, session, selected result, timestamp, geo location, active filters. Stored in `titan/discovery.search_event`. | search log, analytics event |
| **Zero-Result Signal** | A SearchEvent with `resultCount === 0`. Represents unmet market demand for outbound B2B sales. | failed search, demand gap |
| **SystemAlert** | Operational notices broadcast by Admin to consumers / businesses (e.g., scheduled maintenance). Stored in `titan/platform`. | banner, broadcast notice |
| **IconCollection** | Curated icon sets used across surfaces (categories, badges, agent icons). Stored in `titan/platform`. | icon library |
| **AuditLog** | Database-level audit trail (CREATE/UPDATE on critical entities) via SurrealDB `DEFINE EVENT`. Stored in `titan/platform`. | activity log |
| **MessageThread** | Conversation between a Customer (or Ditto) and an Establishment (or Datto). Stored in `titan/company_{slug}`. v1.4 scope. | conversation |
| **Message** | Single message within a MessageThread. | comm |
| **Entity** (agent memory) | Graph-node representing an actor/object the agent has knowledge of. | knowledge node |
| **Fact** (agent memory) | Graph-edge or attribute the agent has learned. | knowledge edge |

### Conceptual entities (platform concepts, not DB tables)

| Term | Definition (seed) | Also known as |
|------|-------------------|---------------|
| **MercuryEngine** (V2) | The unified FastAPI/Pydantic API server: booking + discovery + CRUD + admin domains, on SurrealDB 3.0. **Single API server** — no separate microservices. | booking API, engine, backend |
| **DittoBar** | The unified search interface in the Public Marketplace. An A2UI visor — Ditto's eyes into the knowledge graph. Dual purpose: user search + demand intelligence harvester. | search bar (avoid), search component (avoid) |
| **Ditto** | The consumer's personal AI agent (future Layer 2). Finds services, handles bookings, watches marketplaces. | chatbot (avoid), assistant (avoid) |
| **Datto** | The business's AI receptionist agent (future Layer 2, tiered upgrade). Handles inquiries, manages availability, communicates with Ditto via UCP. | bot (avoid), auto-responder (avoid) |
| **UCP (Universal Commerce Protocol)** | Future agent-to-agent interoperability protocol — agent-mediated commerce instead of SEO/browsing. | API (avoid), webhook (avoid) |
| **TheOracle** *(deprecated)* | The discovery concern originally planned as a separate microservice (ADR-0007 v1). **Absorbed** into MercuryEngine after the SurrealDB unification — discovery routes + `titan/discovery` DB remain logically separate but share the API server. | search service (avoid), search API (avoid) |
| **Public Marketplace (Flutter)** | The consumer-facing native app (iOS + Android). Primary product surface for consumers. | webapp (avoid), frontend (avoid) |
| **Public Marketplace (web)** | The Nuxt 4 / Vue 3 web surface of the consumer marketplace at `dittodatto.no`. **Real product surface, not a transitional shell.** | web shell (deprecated framing) |
| **Business Portal** | Merchant dashboard for managing establishments, services, staff, bookings. **To be re-grilled** — full Flutter replacement of legacy Nuxt webapp planned. | admin dashboard (avoid), merchant app (avoid) |
| **Admin Panel** | Internal platform operations and analytics — Captain/Merkurial Studio super-admin tool. **Flutter** (`apps/admin/`), Android-first (LineageOS tablet). Migration from legacy Nuxt in progress (S19–S20 shipped Dashboard/Users/Companies/Categories). | back-office (avoid), control panel (avoid) |
| **MasterDatto** | A future cross-Establishment Datto for platform-wide super-business agents. Inbox slot is reserved in the Flutter Admin Panel. | (none yet) |
| **BankID** | Norwegian digital identity verification via Vipps Login (OIDC). Mandatory for self-service consumer transactions. NOT required for staff-created walk-in customer accounts. | ID verification (avoid), identity check (avoid) |
| **Tracer Bullet** | A single, thin end-to-end path through every layer of the system that proves the architecture works. Term from *The Pragmatic Programmer*. v1.0 IS the tracer bullet. | steel thread (avoid), proof of concept (avoid) |
| **Vertical Slice** | A development unit that cuts through all layers (UI → API → DB) for one feature, independently shippable. | horizontal slice (avoid) |
| **Time Tetris** | The slot-availability algorithm — maps "Minutes from Midnight" to answer "Can I book?" in <200ms. Pure-function `mercury_core.calculators.slots`. | slot algorithm |
| **Shadow Demand** | The data signal from unauthenticated DittoBar searches — anonymized query+location, used to identify high-demand services for outbound business recruitment. | demand intelligence |
| **AaaS** (Anything-as-a-Service) | The platform's monetization model (ADR-0005) — nothing locked, everything has a limit; feature access scales with usage. Datto (v1.5) mediates activation conversationally. | SaaS (rejected framing) |

---

## Relationships

> **Open for foundation grill.** Seed relationships from the legacy CONTEXT.md and schemas:

- A **Company** owns one or more **Establishment**s.
- An **Establishment** offers many **Service**s. A **Service** has exactly one **booking mode** (`standard` / `tableReservation` / `ticketSystem`) — ADR-0004.
- An **Establishment** employs many **StaffMember**s. A **Service** has an `assignedStaff` list (empty = not bookable — ADR-0006).
- A **Booking** holds: one **Service**, optionally one **StaffMember**, optionally one **Resource**, exactly one **Customer** (Establishment-scoped) or one **User** (platform-wide).
- A **Hold** precedes a **Booking** with a TTL (`expires_at`). Slot calculator filters expired holds.
- A **SearchEvent** logs a **DittoBar** query; a zero-result subset becomes a **Zero-Result Signal** for B2B sales.
- **Ditto** ↔ **Datto** communicate via **UCP** (future).
- The **Public Marketplace (Flutter)** consumes **MercuryEngine** for all booking + discovery.
- The **Public Marketplace (web)** consumes **MercuryEngine** for the same — dual surface, same backend.
- The **Business Portal** configures what **MercuryEngine** serves.
- The **Admin Panel** monitors all platform operations via `/admin/*` routes.

---

## Terminology Boundaries

> Resolved ambiguities. Foundation grill should validate and extend.

- We say **Establishment** (domain term + SurrealDB table name), not "store" (user-facing) or "shop" or "venue".
  - *Exception:* `StoreSchema`, `storeId` remain in legacy `packages/shared-types/` Zod for Chapter 1 backward compatibility. Flutter / Python use `Establishment` / `establishmentId`.
- We say **StaffMember** (`StaffMemberSchema`, `staffId`), not "Person". `personId` was migrated to `staffId` across all schemas in Session 3 (2026-05-02).
- We say **Public Marketplace (Flutter)** for the native consumer app; **Public Marketplace (web)** for the Nuxt webapp. The two are equal product surfaces, **not** "app vs. shell". *(Foundation grill: confirm and codify this — the legacy CONTEXT.md frames the web as a "Web Shell" / transitional scaffolding.)*
- We say **Admin Panel = Flutter** (`apps/admin/`). The legacy CONTEXT.md and vision.md say "Nuxt web, no migration planned" — this is **stale**; the Flutter Admin Panel was shipped in S19–S20 (Dashboard / Users / Companies / Categories). *(Foundation grill: write this into the canonical glossary, retire the Nuxt framing.)*
- We say **MercuryEngine** (single API server), not "TheOracle" (deprecated — absorbed). The discovery routes and `titan/discovery` DB remain logically separate but live in the same FastAPI app.
- We say **Tracer Bullet** or **Vertical Slice**, never "steel thread" (no Microsoft terminology).
- We say **BankID** (or "BankID via Vipps Login"), not "ID verification".

---

## Notes / Open Questions for the Foundation Grill

The following items are **flagged as inputs** to the upcoming foundation grill session:

1. **Surface inventory contradictions:**
   - Legacy CONTEXT.md says Admin Panel = "Nuxt web, no migration planned." Reality: `apps/admin/` is a **fully built Flutter app** (S19–S20). **Fix in this conductor.**
   - Legacy vision.md says Business Portal = "Nuxt web (Chapter 1 frozen), Flutter if demand later." Reality: User intends Flutter replacement. **Decide and document.**
   - Legacy frames the consumer web as "Web Shell" (transitional). Reality: User intends a real Nuxt webapp alongside the Flutter app. **Decide and document.**

2. **PRD freshness:**
   - `conductor/docs/legacy/prd-public-marketplace-v1-STALE.md` references Hono/TypeScript backend and 156 tests. The backend is now Python/FastAPI/377 tests. **Refresh during Public Marketplace grill (Session 4).**

3. **ADR triage:**
   - 11 legacy ADRs live in `conductor/docs/legacy/adr-source/`. Foundation grill should triage:
     - ADR-0010 (auth architecture) — Firebase Auth was "on probation"; what's the current stance vs. SurrealDB native + Vipps OIDC?
     - ADR-0011 (Flutter Admin Panel) — was "planned"; now built. Update status, possibly supersede.
     - New ADR likely needed: Public Marketplace dual surface (Flutter + Nuxt web).
     - New ADR likely needed: Business Portal Flutter migration strategy.
     - New ADR likely needed: Saturn deployment model.

4. **Domain entity refinements not yet locked:**
   - `Favorite.type: "store" | "person"` — surface staff favoriting in v1.0 or defer to v1.1? (Legacy CONTEXT.md flagged this.)
   - MasterDatto (cross-establishment business agent) — when, what scope, what entity model?

5. **Glossary boundaries not yet formalized:**
   - Establishment vs. Company vs. Business — legacy docs use these inconsistently. Lock the boundary.
   - Booking vs. Reservation vs. Ticket — three modes on the engine; ensure the glossary cleanly separates the *mode* from the *entity*.
   - Ditto (consumer agent) vs. Datto (business agent) — clear boundary; the personas differ.

6. **`Search Event` schema future:**
   - Currently captures geo, filters, nearest result distance. Foundation grill may extend for v1.5 agentic queries.

---

*Refine in `/grill foundation`.*
