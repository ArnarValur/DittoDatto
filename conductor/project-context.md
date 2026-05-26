<!-- Template: TheOracle v2.1 -->
# Project Context — DittoDatto

> Single identity + operational document for this project.
>
> **Created by `/conductor-init`; user-edited thereafter — no command writes here.**
> Persona and communication style are handled separately by `/hermes`.
>
> Section order is deliberate: **identity-first (1–3), operational-second (4–8).**

---

## 1. Product Definition

- **Name:** DittoDatto (`dittodatto.no`)
- **Tagline:** The Agentic Commerce Platform for Norway
- **Description:** A multi-agentic service booking platform. Layer 1 is a fully-functional non-AI marketplace + business portal + booking engine + admin panel; Layer 2 layers **Ditto** (consumer agent) and **Datto** (business agent) on top, mediated by the future **Universal Commerce Protocol (UCP)**. **MercuryEngine V2** (FastAPI / Pydantic) on **SurrealDB 3.0** is the single source of truth for booking, discovery, and CRUD across all surfaces. Drammen-first, fylke-by-fylke expansion, Scandinavia horizon.
- **Target Audience:**
  - **Service businesses** — salons, restaurants, garages, clinics, venues — starting in Drammen, scaling nationally.
  - **Norwegian general public** — locals seeking modern, efficient booking.
  - **Marginal groups & tourists** — users who benefit from accessible, multi-language, agent-mediated interfaces.
- **Key Differentiators:**
  - **Agentic by design, value without AI** — platform works fully without agents (Layer 1); Datto-tier upgrade adds AI for businesses that want it.
  - **Norway-native** — BankID/Vipps mandatory, bokmål + English from day one, fylke-by-fylke growth model, dogfooded by Merkurial Studio.
  - **DittoBar + Shadow Demand** — unified search interface that doubles as a B2B sales lead engine (every zero-result query is a `Zero-Result Signal` for outbound).
  - **Multi-vertical booking modes** — `standard` (appointments), `tableReservation` (restaurants), `ticketSystem` (venues/events) on one engine — booking mode lives on the Service, not the Establishment (ADR-0004).
  - **AaaS over SaaS** (ADR-0005) — nothing locked, everything has a limit; feature access scales with usage. `enabledFeatures` is transitional scaffolding.
  - **Universal Commerce Protocol** ambition — long-horizon agent-to-agent commerce standard; MercuryEngine API designed to be callable by any AI agent (Gemini Extensions, GPT Actions, Apple App Intents), not just Ditto.

---

## 2. Product Guidelines

- **Brand Voice:**
  - **Witty & Clever** — Norwegian "ditt og datt" charm; slightly silly to humanize the tech.
  - **Confident** — "the Vipps of Service Booking"; aiming to be a national utility.
  - **Pragmatic** — rock-solid reliability under the wit.
  - **Slogan:** *"Alt mellom ditten og datten finner du på DittoDatto. Prøv gratis, spør hva du trenger."*
  - **Agent personas:** Ditto = Friendly / Conversational / Witty. Datto = Efficient / Precise / Confident.
- **UX Principles:**
  - **Opt-in agentic** — platform must deliver full value without AI. Agents are an additive layer, never a gate.
  - **Mobile-first via Flutter** — Material 3 + Moody Blue `#6F71CC` brand tokens (full 50→950 palette).
  - **Three-tab Flutter nav** — Home (Map + DittoBar + curated listings) / Bookings / Profile.
  - **Norwegian-first, English-included** — bokmål primary, English from day one.
  - **Agentic presence** — subtle visual cues (glow, chat-bubble) when Ditto/Datto is thinking or active.
  - **Dogfooding** — Merkurial Studio runs its own business on DittoDatto; if it doesn't work for us, it doesn't ship.
  - **Drammen first, then fylke-by-fylke** — prove value locally before scaling.
  - **Best porcelain per layer** — right tool per concern (SurrealDB for the data foundation, BankID/Vipps for auth, Google Maps for maps, Flutter for mobile, Google ADK for agents).
- **Accessibility:** WCAG 2.1 AA. High-contrast text, clear/large touch targets, screen-reader-friendly structure. Accessibility is core to the "Marginal Groups" mission, not an afterthought.

---

## 3. Tech Stack

### Core Infrastructure

- **Platform Database:** SurrealDB 3.0 — unified document + graph + vector (HNSW) + BM25 full-text + geo + time-series. Storage engine: RocksDB.
  - Namespaces: `titan/company_{slug}` (per-company), `titan/discovery` (public aggregator), `titan/platform` (system ops), `enceladus/users` (GDPR-isolated PII).
- **API Gateway:** MercuryEngine V2 — FastAPI · Python 3.11+ · Pydantic v2 · uv package manager.
  - Domains: booking (`/appointments/*`, `/reservations/*`, `/tickets/*`), discovery (`/discovery/*` — absorbed TheOracle), CRUD (`/establishments/*`, `/services/*`, `/staff/*`), admin (`/admin/*`).
- **Auth:** SurrealDB native + BankID/Vipps OIDC. MercuryEngine issues JWTs. Five middleware tiers: `public` / `require_auth` / `require_operator` / `require_admin` / `require_super_admin` (per ADR-0010 + ADR-0011 amendments).

### Languages

- **Python 3.11+** — MercuryEngine V2 backend, ADK agents (future Ditto/Datto), tooling.
- **Dart** — Flutter mobile + admin + portal + marketplace native apps.
- **SurrealQL** — schema definition, queries, functions, events.
- **TypeScript / Vue 3** — Nuxt 4 webapps (Public Marketplace web, plus legacy admin/portal Nuxt apps being phased out).

### Frameworks

- **Backend:** FastAPI + Pydantic v2 + uv (MercuryEngine V2).
- **Flutter:** Riverpod (state) · GoRouter (routing) · Material 3 (design system) · `mercury_client` shared Dart package (HTTP client, auth, models).
- **Web (Nuxt 4):** Nuxt UI · Tailwind CSS. Used for the Public Marketplace web surface.
- **Agent Orchestration:** Google ADK (Agent Development Kit) — Python, Pydantic-native (future Ditto/Datto).

### Product Surfaces (canonical truth as of v2.1 init)

| Surface | Stack | Path | Status |
|---|---|---|---|
| **Admin Panel** | Flutter (Dart) | `apps/admin/` | 🟡 In-progress migration from Nuxt — Dashboard / Users / Companies / Categories done (S19–S20); continuing post-foundation grill |
| **Business Portal** | Flutter (Dart) — planned | `apps/business-portal/` (TBD) | 🔴 To regrill — full Flutter replacement of legacy Nuxt webapp |
| **Public Marketplace (native)** | Flutter (Dart) | `apps/marketplace/` (Flutter, scaffold) | 🔴 To regrill — tracer-bullet app; consumer-facing |
| **Public Marketplace (web)** | Nuxt 4 / Vue 3 | `apps/web/public-marketplace/` | 🟢 Active — kept as a dual web surface alongside the Flutter app |
| **Legacy Nuxt webapps (admin-panel, business-portal)** | Nuxt 4 / Vue 3 | `apps/web/admin-panel/`, `apps/web/business-portal/` | ❄️ Frozen — retired once Flutter replacements ship |

> The old "Web Shell" concept is **superseded**: the Public Marketplace web (Nuxt) is a real product surface, not transitional scaffolding. To be confirmed/refined by the foundation grill.

### Data Storage / Search

- **Database:** SurrealDB 3.0 (sole platform DB — no Firestore, no separate vector DB, no BigQuery).
- **Full-text search:** SurrealDB BM25 analyzers (Norwegian snowball stemmer on discovery listings).
- **Vector search:** SurrealDB HNSW indexes (semantic search for Ditto fuzzy matching).
- **Geo:** `geo::distance()` + native GeoJSON.
- **Time-series / analytics:** SurrealDB graph aggregation, pre-computed materialized views.

### Deployment Targets

- **Dev / Staging:** Docker on **Saturn** (GX10 on-prem) and **Mercury** (Pluto host). Two real-tenant dogfood: `merkurial-studio` and `dittodatto` companies on Saturn staging.
- **Lite-Production:** Docker on Google **Cloud Run** (`europe-west1` only — region-locked).
- **Production target:** Saturn primary once stable; Cloud Run as overflow / DR.

### Hosting

- **Cloud:** Google Cloud Platform — Cloud Run only. **No Firestore, no Cloud Functions, no BigQuery.**
- **On-prem:** Saturn (GX10) hardware — primary as it lands.
- **Domains:** `dittodatto.no` (apex, web + app store links), `mercury.dittodatto.no` (legacy V1 staging, frozen).

### What's Dead (do not resurrect)

| Former Component | Replacement |
|---|---|
| Cloud Firestore | SurrealDB 3.0 |
| Cloud Functions | FastAPI services on Cloud Run |
| Firebase Emulators | SurrealDB local Docker (Pluto / Saturn) |
| Sync Pipe (Firestore → SurrealDB) | Eliminated — one database |
| TheOracle (separate microservice) | Discovery routes inside MercuryEngine |
| Qdrant (vector DB) | SurrealDB HNSW vectors |
| BigQuery analytics | SurrealDB graph aggregation |
| MercuryEngine V1 (Hono / TypeScript) | MercuryEngine V2 (FastAPI / Python / Pydantic) |
| Zod schemas (TypeScript) | Pydantic v2 models (Python) — `services/mercury-engine/src/mercury_core/models/` |

---

## 4. Caution Levels

| Domain | Level | Notes |
|---|---|---|
| **MercuryEngine V2** (`services/mercury-engine/`) | 🔴 **Critical** | Real money, real time slots, real customer trust. See `conductor/docs/legacy/conductor-snapshot/BOOKING_ENGINE.md` for the V2 safety manual until it's promoted into `conductor/docs/`. |
| **SurrealDB schemas** (`schemas/*.surql`) | 🔴 **Critical** | Data integrity — `REFERENCE` constraints, timestamps, audit triggers. |
| **Auth / JWT pipeline** (ADR-0010 lineage) | 🔴 **Critical** | Tier mismatches = security holes. `require_operator` + company-access guard must agree. |
| **Cloud config (region lock)** | 🔴 **Critical** | All Cloud Run must deploy to `europe-west1`. Never `us-central1`. |
| **Shared packages** (`packages/mercury_client/`) | 🔴 **Critical** | Cross-app blast radius (Flutter Admin + Portal + Marketplace all consume it). |
| **Flutter app UI** | 🟡 Careful | Visual impact; verify rendering on Android + iOS + Desktop preview. |
| **Nuxt webapps (frozen)** | 🟡 Careful | Frozen Chapter 1 — only touch for critical bug fixes. |
| **conductor/ files** | 🟡 Careful | Source of truth — don't corrupt. |
| **Content / assets / docs** | 🟢 Normal | Low risk. |

---

## 5. Domain Expertise

| Area | Confidence | Notes |
|---|---|---|
| Flutter + Riverpod + GoRouter | High | Admin panel built end-to-end (S19–S20); Marketplace scaffold ready. Material 3 conventions applied. |
| Python + FastAPI + Pydantic v2 + uv | High | MercuryEngine V2 — 377 tests, ruff-clean, repository pattern, DI through FastAPI. |
| SurrealDB 3.0 (data + graph + vector + geo + BM25) | High | Schema blueprints applied per company; dual-namespace isolation (`titan`/`enceladus`). |
| Dart shared packages | Medium-High | `packages/mercury_client/` — HTTP client + auth + 7 models + 11 admin endpoints. |
| BankID / Vipps OIDC | Medium | Architecture decided (ADR-0010), implementation pending Vipps merchant registration. |
| Google ADK (agent orchestration) | Low | Future Ditto/Datto — not yet implemented. |
| Nuxt 4 / Vue 3 | Medium | Chapter 1 stack; Public Marketplace web is the only active Nuxt surface going forward. |
| Saturn on-prem ops | Low | Hardware incoming; Day-1 blueprint in `conductor/docs/legacy/postit/saturn-local-stack.md`. |

---

## 6. Preferred Workflows

1. **Session Start Protocol:**
   - Read `conductor/relay.md` first (pending messages, blockers)
   - Then read `conductor/pulse.md` (current state, recent progress)
   - Review `conductor/tracks.md` for next task
   - For domain language, read `conductor/context.md` (and `conductor/docs/legacy/CONTEXT.md` until the foundation grill consolidates)
2. **Checkpoint Frequency:**
   - Checkpoint after every completed phase
   - Consider mid-phase checkpoints for long phases (>5 tasks)
3. **Decision Logging:**
   - Architectural decisions live in `conductor/adr/` (batched by `/grill`, `/new-track`, or `/checkpoint`)
   - Operational notes live in `conductor/pulse.md` Session Memory
   - Verify actual state on disk before proposing changes
4. **Debugging Protocol:**
   - Check legacy interference before blaming new code
   - If a fix fails twice, stop and escalate
   - Audit actual state vs documented state — especially across the surface inventory
5. **MercuryEngine V2 (🔴 Critical):**
   - Always read `conductor/docs/legacy/conductor-snapshot/BOOKING_ENGINE.md` before changing anything in `services/mercury-engine/`
   - Tests-first: 377 tests must remain green (197 unit + 73 admin + 50 auth + 32 integration + 25 token)
   - Calculators are pure (zero DB calls); all I/O via repository interfaces

---

## 7. Project-Specific Constraints

- **Region lock:** All Cloud Run deployments must use `europe-west1`. Never `us-central1`.
- **GDPR / Norwegian commerce law:**
  - Consumer PII isolated to `enceladus/users` namespace.
  - Fiscal immutability: booking snapshots (price, service title, user info) captured at creation and **never updated**. Legal requirement for Norwegian commerce.
  - Search Events from unauthenticated users must be anonymized — strict no-PII rule for `titan/discovery`.
- **BankID:** Mandatory for self-service online transactions (booking through the app, online payments). NOT required for staff-created walk-in customer accounts.
- **Pydantic models as source of truth:** Domain schema authority lives in `services/mercury-engine/src/mercury_core/models/`. TypeScript Zod schemas in `packages/shared-types/` are **frozen** Chapter 1 reference only.
- **Norwegian-first:** Bokmål is the primary locale; English is co-equal from day one. No locale should ship in production without both.
- **Dogfooding non-negotiable:** Merkurial Studio runs its own business on the platform. If a feature doesn't work for us, it doesn't ship.
- **Booking modes on the Service, not the Establishment:** Per ADR-0004 — one establishment can host multiple booking modes (appointments + ticketed workshops + table reservations).

---

## 8. Environment Notes

- **MercuryEngine V2 (services/mercury-engine/):**
  - `uv` for dependency management — `uv run pytest`, `uv run ruff check .`
  - Local dev: Docker on Pluto host; staging: Docker on Saturn (incoming).
  - SurrealDB connection: dual-connection pool (titan + enceladus).
- **Flutter apps (apps/*):**
  - Dart SDK `^3.11.3`; Flutter via local install.
  - Admin app primary platform: **Android** (LineageOS tablet). Desktop + web are freebies.
  - Marketplace primary platforms: iOS + Android.
- **Public Marketplace web (apps/web/public-marketplace/):**
  - Nuxt 4 + Vue 3 + Nuxt UI + Tailwind CSS.
- **Saturn (incoming GX10):**
  - Day-1 blueprint in `conductor/docs/legacy/postit/saturn-local-stack.md`.
  - Production target: SurrealDB Docker + MercuryEngine FastAPI.
- **Legacy reference:** Old Chapter 1 codebase + 11 ADRs + 32 type specs + engine docs live in `DittoDatto-old/`. The foundation grill will triage what's promoted into the new conductor.
