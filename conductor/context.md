# Domain Context

> Domain glossary and ubiquitous language for **DittoDatto**.
> Updated by `/grill` and `/new-track` sessions.
>
> **Last refined:** 2026-05-27 (`/grill flutter-design-system`) — Shared Flutter design system (`ditto_design`) defined: tokens + theme + layout utilities + `DittoDashboardShell`. SolarTheme acknowledged as future layer. `DittoWindowClass` breakpoint enum added. ADR-0014.
>
> **Authoritative legacy starting point:** `conductor/docs/legacy/CONTEXT.md` — superseded by this file as of the foundation grill.

---

## Entities

> Confirmed via brownfield scan + foundation grill refinement. Per-surface grills may add domain-specific entries.

| Term | Definition | Also known as |
|------|------------|---------------|
| **Establishment** | A business location registered on the platform — salons, restaurants, garages, clinics, venues. The user-facing term for the `establishment` table. | `store` (legacy Zod / `StoreSchema`), `storeId` (legacy FK) |
| **EstablishmentPage** | The detail screen for a single Establishment in the Public Marketplace (Flutter). | store page, shop page, detail page |
| **Company** | The owning business entity on the platform; one Company owns many Establishments. Registered in `companies/registry`. | tenant, merchant, business owner |
| **Service** | An offered booking unit at an Establishment (e.g., "Haircut 30 min"). Booking mode lives here (`standard` / `tableReservation` / `ticketSystem`) — ADR-0010. | offering, treatment |
| **ServiceGroup** | A grouping of Services on an Establishment (e.g., "Hair", "Beard"). | category (internal), service category |
| **StaffMember** | A person who performs Services at an Establishment. Migrated from `Person`. | `Person` (deprecated), `personId` (deprecated → `staffId`) |
| **Customer** | A person who books at an Establishment. Can be Establishment-scoped (walk-in, no BankID) or a platform User (BankID-verified consumer). | guest, walk-in |
| **User** | A consumer with a BankID-verified platform account, stored in `users/profiles`. | consumer, platform user |
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
| **Favorite** | A User's saved Establishment (or Staff, deferred). Stored in `users/profiles`. | save, bookmark |
| **Category** | A top-level service classification used by DittoBar (e.g., "Beauty", "Restaurant", "Fitness"). Stored in `companies/discovery`. | service type |
| **Area** | A geographic region used for filtering / browsing (e.g., a fylke, a city). Stored in `companies/discovery`. | region, zone |
| **EstablishmentListing** | A discovery-side projection of an Establishment for DittoBar search (denormalized for read-perf). | search listing, discovery card |
| **SearchEvent** | A logged DittoBar query — query string, result count, session, selected result, timestamp, geo location, active filters. Stored in `companies/discovery.search_event`. | search log, analytics event |
| **Zero-Result Signal** | A SearchEvent with `resultCount === 0`. Represents unmet market demand for outbound B2B sales. | failed search, demand gap |
| **SystemAlert** | Operational notices broadcast by Admin to consumers / businesses (e.g., scheduled maintenance). Stored in `companies/registry`. | banner, broadcast notice |
| **IconCollection** | Curated icon sets used across surfaces (categories, badges, agent icons). Stored in `companies/registry`. | icon library |
| **AuditLog** | Database-level audit trail (CREATE/UPDATE on critical entities) via SurrealDB `DEFINE EVENT`. Stored in `companies/registry`. | activity log |
| **MessageThread** | Conversation between a Customer (or Ditto) and an Establishment (or Datto). Stored in `companies/{slug}`. v1.4 scope. | conversation |
| **Message** | Single message within a MessageThread. | comm |
| **Entity** (agent memory) | Graph-node representing an actor/object the agent has knowledge of. | knowledge node |
| **Fact** (agent memory) | Graph-edge or attribute the agent has learned. | knowledge edge |

### Conceptual entities (platform concepts, not DB tables)

| Term | Definition | Also known as |
|------|------------|---------------|
| **MercuryEngine** | The high-performance booking-only engine (FastAPI / Pydantic v2 / uv) that owns the Hold -> Booking lifecycle and the Time Tetris availability calculator. It does not own admin operations, entity CRUD, or auth issuance. | booking API, engine, backend |
| **DittoBar** | The unified search interface in the Public Marketplace. An A2UI visor — Ditto's eyes into the knowledge graph. Dual purpose: user search + demand intelligence harvester. | search bar (avoid), search component (avoid) |
| **Ditto** | The consumer's personal AI agent (future Layer 2). Finds services, handles bookings, watches marketplaces. | chatbot (avoid), assistant (avoid) |
| **Datto** | The business's AI receptionist agent (future Layer 2, tiered upgrade). Handles inquiries, manages availability, communicates with Ditto via UCP. | bot (avoid), auto-responder (avoid) |
| **UCP (Universal Commerce Protocol)** | Future agent-to-agent interoperability protocol — agent-mediated commerce instead of SEO/browsing. | API (avoid), webhook (avoid) |
| **Public Marketplace (Flutter)** | The consumer-facing native app (iOS + Android). **THE canonical consumer surface** for DittoDatto. | webapp (avoid), frontend (avoid) |
| **`dittodatto.no` landing page** | The Nuxt 4 / Vue 3 web surface at `dittodatto.no` (Cloud Run-hosted). **Public marketing/landing page only** — NOT a co-equal product surface. Polished AFTER the Flutter app reaches feature completeness. | Public Marketplace (web) — *deprecated framing*, Web Shell — *deprecated framing* |
| **Business Portal** | Merchant dashboard for managing establishments, services, staff, bookings. **Flutter (planned, full replacement of legacy Nuxt webapp).** Merkurial Studio dogfoods the Business Portal as a company on the platform — "we use our own system to administrate others with the same system." The Business Portal is where Merkurial Studio manages its business relationships; the Admin Panel is the infrastructure breaker box. | admin dashboard (avoid), merchant app (avoid) |
| **Admin Panel** | The platform's **"breaker box"** — a 2-user private tool (Arnar + Höddi) for platform infrastructure operations. NOT a customer-facing product. **Flutter** (`apps/admin/`), targets: Android + Linux desktop + Web (same codebase, no iOS). 5 screens: Dashboard / Users / Companies / Categories / Inbox. Login: email + password only, maximum opacity (no branding, no error feedback). Explicitly excludes establishment/booking/service management (→ Business Portal). Replaces `panel.dittodatto.no` (Nuxt) when Flutter web build is ready. See ADR-0006, PRD v1.0. | back-office (avoid), control panel (avoid), breaker box (informal) |
| **MasterDatto** | A future AI agent operated by Merkurial Studio — Merkurial's own Datto instance that other companies' Datto agents communicate with for critical support escalation and platform-level coordination. The human precursor is the Inbox screen in the Admin Panel. Not v1 scope. | (none yet) |
| **Inbox** (Admin Panel) | Within-platform messaging screen where platform administrators (Arnar + Höddi) receive feedback, support messages, and notifications from businesses and users on the platform. Future home for System Alerts. The human precursor to MasterDatto's AI-mediated inbox. Distinct from any future Business Portal messaging. | admin inbox, support inbox |
| **SearchAnalytics** | Separate project (`predict.dittodatto.no`, `~/Projects/SearchAnalytics`) for Shadow Demand analytics and Zero-Result Signal visualization. Currently a bare Nuxt webapp under conceptualization. Whether to merge into Admin Panel is an open question for a future session. | demand dashboard, analytics panel |
| **BankID** | Norwegian digital identity verification via Vipps Login (OIDC). Mandatory for self-service consumer transactions. NOT required for staff-created walk-in customer accounts. | ID verification (avoid), identity check (avoid) |
| **Tracer Bullet** | A single, thin end-to-end path through every layer of the system that proves the architecture works. Term from *The Pragmatic Programmer*. v1.0 IS the tracer bullet. | steel thread (avoid), proof of concept (avoid) |
| **Vertical Slice** | A development unit that cuts through all layers (UI → API → DB) for one feature, independently shippable. | horizontal slice (avoid) |
| **Time Tetris** | The slot-availability algorithm — maps "Minutes from Midnight" to answer "Can I book?" in <200ms. Pure-function `mercury_core.calculators.slots`. | slot algorithm |
| **Shadow Demand** | The data signal from unauthenticated DittoBar searches — anonymized query+location, used to identify high-demand services for outbound business recruitment. | demand intelligence |
| **AaaS** (Anything-as-a-Service) | The platform's monetization model (ADR-0011) — nothing locked, everything has a limit; feature access scales with usage. Datto (v1.5) mediates activation conversationally. | SaaS (rejected framing) |
| **Saturn** | The on-prem NVIDIA GX10 server hosting the DittoDatto Hub (SurrealDB) and other backend STAGING services. Always-on, Tailscale-gated, accessible to Arnar + Höddi + AI agents + occasional showcase guests. Never public. **Staging only — never the production target.** Tailscale machine name: `saturn`; tailnet: `tailb251cd.ts.net`; tailnet IPv4: `100.87.99.59`. Pre-existing OpenWebUI on `saturn:8080` is outside DittoDatto scope. | (none) |
| **DittoDatto Hub** | The SurrealDB 3.0 instance running on Saturn (Docker container, port `8001`) — the staging-environment source of truth. Hosts both `companies` and `users` namespaces. **Distinct from local dev SurrealDB** — dev runs its own independent instance with the same namespace topology but isolated data. | the Hub, staging DB |
| **`companies` namespace** | The SurrealDB namespace holding all non-PII platform data: per-company databases (`companies/{slug}`), the cross-company DittoBar aggregator (`companies/discovery`), and the platform registry (`companies/registry` — company list, system alerts, audit log, icon collections). Replaces the legacy `titan` codename. | (formerly `titan`) |
| **`users` namespace** | The SurrealDB namespace holding consumer PII (`users/profiles` — `vipps_sub`, name, email, phone). GDPR-isolated from `companies` via SurrealDB namespace-level user credentials. Replaces the legacy `enceladus` codename. | (formerly `enceladus`) |
| **Tailscale** | Mesh VPN used by the Merkurial Studio team + AI agents to reach Saturn-hosted staging services. Paid subscription tier; MagicDNS enabled (services reach via `http://saturn:<port>`). No public exposure. | (none) |
| **`ditto_design`** | Shared Flutter design system package (`packages/ditto_design/`). Provides design tokens (Moody Blue palette, spacing grid, border radii, animation durations), theme (`DittoTheme.dark` + `DittoTheme.light` from Moody Blue `#6F71CC` seed), layout utilities (breakpoints, `DittoWindowClass`), and `DittoDashboardShell`. Sibling to `mercury_client`. Domain-specific widgets graduate into the package organically when cross-app need is proven. See ADR-0014. | design system, shared theme (avoid) |
| **SolarTheme** | A time-of-day-aware theme system that switches between dark and light modes based on solar position at the user's Norwegian location (Drammen, 59.74°N, 10.20°E). Uses SunCalc for sun altitude → lightness mapping, golden hour hue override, saturation damping. Includes a star field renderer with real celestial projection (30-star catalog, sidereal time calculation). Originally built for Nuxt (`DittoDatto-old/packages/ui/themes/SolarTheme/`). Future `ditto_design` layer for the Public Marketplace — pre-launch polish, not v1 scope. | night mode, solar mode |
| **`DittoDashboardShell`** | Shared responsive dashboard shell widget in `ditto_design`. Flutter equivalent of the Nuxt UI `DashboardSidebar` + `DashboardPanel` + `DashboardNavbar` layout — permanent collapsible sidebar, nav groups with expandable children, header/footer slots, main content panel. On narrow screens (`DittoWindowClass.compact`), sidebar collapses to a drawer. Consumed by Admin Panel and Business Portal. Public Marketplace uses its own consumer shell (3-tab bottom nav). | dashboard layout, sidebar scaffold |
| **`DittoWindowClass`** | Enum in `ditto_design` classifying window width into Material 3 canonical breakpoints: `compact` (<600px), `medium` (600–839px), `expanded` (840–1199px), `large` (≥1200px). Apps use `LayoutBuilder` + `windowClassOf(width)` to make responsive layout decisions. Shared by all 3 Flutter surfaces. | breakpoint class, window size class |

---

## Relationships

> Seed relationships refined during the foundation grill. Per-surface grills may extend.

- A **Company** owns one or more **Establishment**s.
- An **Establishment** offers many **Service**s. A **Service** has exactly one **booking mode** (`standard` / `tableReservation` / `ticketSystem`) — ADR-0010.
- An **Establishment** employs many **StaffMember**s. A **Service** has an `assignedStaff` list (empty = not bookable — ADR-0012).
- A **Booking** holds: one **Service**, optionally one **StaffMember**, optionally one **Resource**, exactly one **Customer** (Establishment-scoped) or one **User** (platform-wide).
- A **Hold** precedes a **Booking** with a TTL (`expires_at`). Slot calculator filters expired holds.
- A **SearchEvent** logs a **DittoBar** query; a zero-result subset becomes a **Zero-Result Signal** for B2B sales (Shadow Demand).
- **Ditto** ↔ **Datto** communicate via **UCP** (future).
- The **Public Marketplace (Flutter)** consumes **MercuryEngine** for all booking + discovery — the canonical consumer surface.
- The **`dittodatto.no` landing page** consumes **MercuryEngine** for marketing-page content (categories, featured listings, SEO) — supplementary marketing layer, not a co-equal product.
- The **Business Portal** (Flutter, planned) configures what **MercuryEngine** serves.
- The **Admin Panel** (Flutter, in-progress) monitors all platform operations via `/admin/*` routes.
- **Saturn** hosts the **DittoDatto Hub** (SurrealDB) + MercuryEngine staging build; Flutter clients on devices talk to it over **Tailscale**.

---

## Terminology Boundaries

> Resolved ambiguities. Per-surface grills may extend.

- We say **Establishment** (domain term + SurrealDB table name), not "store" / "shop" / "venue".
  - *Exception:* `StoreSchema`, `storeId` remain in legacy `packages/shared-types/` Zod for Chapter 1 backward compatibility. Flutter / Python use `Establishment` / `establishmentId`.
- We say **StaffMember** (`StaffMemberSchema`, `staffId`), not "Person". `personId` was migrated to `staffId` across all schemas in Session 3 (2026-05-02).
- We say **Public Marketplace** for the Flutter consumer app (`apps/marketplace/`, iOS + Android) — the canonical consumer surface. We say **`dittodatto.no` landing page** for the Nuxt 4 web surface (`apps/web/public-marketplace/`) — a public marketing/landing page, NOT a co-equal product. The "Web Shell" framing and the "equal dual surface" framing are both **dead**.
- We say **Admin Panel = Flutter** (`apps/admin/`), cross-platform. The legacy CONTEXT.md and vision.md said "Nuxt web, no migration planned" — that is **stale** and superseded by ADR-0006.
- We say **Business Portal = Flutter (planned)** — full replacement of the legacy Nuxt webapp. ADR-0007 locks all client-facing surfaces as Flutter.
- We say **MercuryEngine** (single API server) — discovery routes live in the same FastAPI app as booking/CRUD/admin (`/discovery/*`). There is no separate discovery service.
- We say **MercuryEngine**, never "MercuryEngine". The Hono/TypeScript predecessor (V1) is dead — no version suffix needed for disambiguation. The name of the service is MercuryEngine.
- We say **Tracer Bullet** or **Vertical Slice**, never "steel thread" (no Microsoft terminology).
- We say **BankID** (or "BankID via Vipps Login"), not "ID verification".
- We say **`companies` namespace** and **`users` namespace** — the legacy `titan` / `enceladus` codenames are dead. Any code, schema, or doc still using `titan` or `enceladus` is pre-rename and needs migration.
- **Saturn is staging, never production.** When you read "production target" or "live deployment," the answer is **Cloud Run `europe-west1`**. Saturn exists to validate behaviour e2e before Cloud Run deploys — not to host live traffic. Saturn's NVIDIA hardware is a future agent-inference option, not a production hosting option.
- **DittoDatto Hub** refers ONLY to the Saturn-deployed SurrealDB instance (the staging source of truth). Local dev SurrealDB is "the dev DB" or "the local SurrealDB instance" — never "the Hub."
- The **`dittodatto.no` landing page** is on **Cloud Run** for now. Cloud Run scope going forward is **only the marketing/landing layer** + the frozen legacy Nuxt apps until retired. New backend services target Saturn (staging) → Cloud Run (production).

---

## Notes / Open Questions

> Items resolved this session vs. items deferred to per-surface grills.

### Resolved during `/grill foundation` (2026-05-26)

- [x] **Surface inventory contradictions** — Admin Panel = Flutter (ADR-0006); Business Portal = Flutter planned (ADR-0007); Public Marketplace = Flutter primary + `dittodatto.no` landing-only (ADR-0007).
- [x] **SurrealDB namespace rename** — `titan`/`enceladus` → `companies`/`users`; `titan/platform` → `companies/registry`; `enceladus/users` → `users/profiles`; `titan/company_{slug}` → `companies/{slug}` (drop redundant prefix) (ADR-0002).
- [x] **ADR triage** — 11 legacy ADRs reviewed: 0008/0009 → canonical 0001/0002 (SurrealDB), 0010 → canonical 0004 (auth identity), 0011 → canonical 0006 (Flutter Admin); new ADRs written: 0003 (Saturn staging), 0005 (admin tier expansion, stub), 0007 (Flutter-only strategy); legacy 0001/0002/0004/0005/0006 promoted as canonical 0008–0012; legacy 0003 (Unified DateTimeSchema) left in legacy as Chapter 1 reference (Pydantic/SurrealDB solve datetime natively); legacy 0007 (DittoBar on TheOracle) dropped as a non-concept.
- [x] **Saturn topology** — staging environment locked; Tailscale-gated; runbook at `saturn-setup-runbook.md` (workspace root) ready for SSH-capable agent (ADR-0003).
- [x] **TheOracle** — scrubbed from the glossary as a non-concept (legacy ADR-0007 was a misunderstanding).
- [x] **Glossary boundaries** — Establishment vs. Company vs. Business locked; Booking vs. Reservation vs. Ticket = mode-on-Service per ADR-0010; Ditto (consumer) vs. Datto (business) personas distinct.

### Deferred to per-surface grills

1. ~~**`/grill admin-panel`:**~~ ✅ **Resolved 2026-05-26** — All 4 ADR-0005 open questions answered "no" (2-user private tool). Inbox = within-platform messaging (human precursor to MasterDatto). Scope locked to 5 screens. See ADR-0013, PRD v1.0.

2. **`/grill business-portal`:**
   - Full PRD from scratch (legacy never had one).
   - Migration strategy from legacy Nuxt webapp (timing, parity threshold).
   - Operator-side UX patterns (calendar, staff management, booking inbox).

3. **`/grill public-marketplace`:**
   - Refresh the stale `prd-public-marketplace-v1-STALE.md`.
   - Lock the Flutter consumer app PRD (v1.0 tracer-bullet scope).
   - Confirm Hybrid Collapsible Map Home as the default Home pattern (ADR-0009).
   - DittoBar interaction model + Search Event schema extensions for v1.5 agentic queries.

4. **`/grill mercury-engine`** (when scheduled):
   - Pydantic v2 datetime conventions (always-UTC? timezone-aware?) — successor to the dead Zod DateTimeSchema problem.
   - Migration plan for `DittoDatto-old/schemas/*.surql` into `services/mercury-engine/`.
   - 377-test review and reconciliation post-disruption.

5. **Open domain refinements (any grill):**
   - `Favorite.type: "store" | "person"` — surface staff favoriting in v1.0 or defer to v1.1?
   - MasterDatto (cross-establishment business agent) — when, what scope, what entity model?
   - SearchEvent schema future — v1.5 agentic queries may need new fields.
