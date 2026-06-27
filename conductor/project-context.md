# Project Context

<!-- Template: TheOracle -->

> Single identity + operational document for this project.
>
> **Created by `/conductor-init`; user-edited thereafter — command writes only when user explicitly invites them (S3).**
> Persona and communication style are handled separately by `/hermes`.
>
> Section order is deliberate: **identity-first (1–3), operational-second (4–8).**
> **Last sync:** 2026-05-26 (`/grill foundation` updates folded in at user request).

---

## 1. Product Definition

- **Name:** DittoDatto (`dittodatto.no`)
- **Tagline:** The Agentic Commerce Platform for Norway
- **Description:** A multi-agentic service booking platform. Layer 1 is a fully-functional non-AI marketplace + business portal + booking engine + admin panel; Layer 2 layers **Ditto** (consumer agent) and **Datto** (business agent) on top, mediated by the future **Universal Commerce Protocol (UCP)**. **MercuryEngine** (FastAPI / Pydantic) on **SurrealDB 3.1** is the single source of truth for booking, discovery, and CRUD across all surfaces.
- **Target Audience:**
  - **Service businesses** — salons, restaurants, garages, clinics, venues — starting in Drammen, scaling nationally.
  - **Norwegian general public** — locals seeking modern, efficient booking.
  - **Marginal groups & tourists** — users who benefit from accessible, multi-language, agent-mediated interfaces.
- **Key Differentiators:**
  - **Agentic by design, value without AI** — platform works fully without agents (Layer 1); Datto-tier upgrade adds AI for businesses that want it.
  - **Norway-native** — BankID/Vipps mandatory, bokmål + English from day one, fylke-by-fylke growth model, dogfooded by Merkurial Studio.
  - **Multi-vertical booking modes** — `standard` (appointments), `tableReservation` (restaurants), `ticketSystem` (venues/events) on one engine — booking mode lives on the Service, not the Establishment.
  - **AaaS over SaaS** — nothing locked, everything has a limit; feature access scales with usage. `enabledFeatures` is transitional scaffolding.
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

- **Platform Database:** SurrealDB 3.1 — unified document + graph + vector (HNSW) + BM25 full-text + geo + time-series. Storage engine: RocksDB.
  - Namespaces: `companies/{slug}` (per-company), `companies/discovery` (public aggregator), `companies/registry` (system ops), `users/users` (GDPR-isolated PII). See ADR-0002.
- **Booking Engine:** MercuryEngine — FastAPI · Python 3.11+ · Pydantic v2 · uv package manager.
  - Scope: Booking hold/booking lifecycle and Time Tetris availability calculator. Does not own admin routes or entity CRUD.
- **Auth:** Direct-to-SurrealDB via native OIDC (Vipps integration). Admin Panel uses native credentials over WebSockets. MercuryEngine is a booking-only backend using Delegated Trust Service Account authentication (no token issuance). (ADR-0006)

### Languages

- **Python 3.11+** — MercuryEngine backend, ADK agents (future Ditto/Datto), tooling.
- **Dart** — Flutter mobile + admin + portal + marketplace native apps.
- **SurrealQL** — schema definition, queries, functions, events.
- **TypeScript / Vue 3** — Nuxt 4 webapps (`dittodatto.no` landing page, plus legacy admin/portal Nuxt apps being phased out).

### Frameworks

- **Backend:** FastAPI + Pydantic v2 + uv (MercuryEngine).
- **Flutter:** Riverpod (state) · GoRouter (routing) · Material 3 (design system) · `mercury_client` shared Dart package (HTTP client, auth, models).
- **Web (Nuxt 4):** Nuxt UI · Tailwind CSS. Used for the `dittodatto.no` landing page.
- **Agent Orchestration:** Google ADK (Agent Development Kit) — Python, Pydantic-native (future Ditto/Datto).

### Product Surfaces (canonical truth as of `/grill foundation` 2026-05-26)

| Surface | Stack | Path | Status |
|---|---|---|---|
| **Admin Panel** | Flutter (Dart) | `apps/admin/` | 🟡 In-progress. Dashboard, Users, Companies, Categories, Inbox. Direct WebSocket DB queries, no intermediate API gateway. See ADR-0004 & ADR-0006. |
| **Business Portal** | Flutter (Dart) — planned | `apps/business-portal/` (TBD) | 🔴 Pre-grill — full Flutter replacement of legacy Nuxt webapp. Strategy locked by ADR-0004; PRD pending `/grill business-portal`. |
| **Public Marketplace** | Flutter (Dart) | `apps/marketplace/` (Flutter, scaffold) | 🔴 Scaffold — tracer-bullet app; THE canonical consumer surface (ADR-0004). |
| **`dittodatto.no` landing page** | Nuxt 4 / Vue 3 | `apps/web/public-marketplace/` | 🟡 Active — public marketing/landing page only; polished after Flutter app reaches feature completeness. Hosted on Cloud Run. Not a co-equal product surface. |
| **Legacy Nuxt webapps (admin-panel, business-portal)** | Nuxt 4 / Vue 3 | `apps/web/admin-panel/`, `apps/web/business-portal/` | ❄️ Frozen — retired once Flutter replacements ship; bug-fix-only in the interim. |

> The "equal dual surface" framing is **superseded** (ADR-0004): the canonical consumer surface is the Flutter app. `dittodatto.no` (Nuxt) is a public marketing layer, not a co-equal product.

### Data Storage / Search

- **Database:** SurrealDB 3.1 (sole platform DB — no Firestore, no separate vector DB, no BigQuery).
- **Full-text search:** SurrealDB BM25 analyzers (Norwegian snowball stemmer on discovery listings).
- **Vector search:** SurrealDB HNSW indexes (semantic search for Ditto fuzzy matching).
- **Geo:** `geo::distance()` + native GeoJSON.
- **Time-series / analytics:** SurrealDB graph aggregation, pre-computed materialized views.

### Deployment Targets

- **Dev:** This workstation (local Docker for SurrealDB + native `uv run` for MercuryEngine + `flutter run` / `npm run dev` for client surfaces). Independent SurrealDB instance — never connects to the staging Hub during dev.
- **Staging:** Saturn (GX10 on-prem, always-on, Tailscale-gated). Reachable at `saturn` (machine name) and `dittodatto` (Tailscale Service — routes to Saturn). Hosts the **DittoDatto Hub** (SurrealDB on port `8001`) + MercuryEngine staging + future Ditto/Datto agent containers, all on the `dittodatto-net` Docker network. Purpose: fast e2e iteration "as if in the wild" without paying Cloud Run deploy latency. Access: Arnar + Höddi + AI agents **Never public.** Pre-existing OpenWebUI on `saturn:8080` is outside DittoDatto scope. See ADR-0003.
- **Production:** Cloud Run (`europe-west1` only — region-locked). The sole production target. Scales to thousands of consumers + hundreds of companies. The `dittodatto.no` Nuxt marketing webapp is the current Cloud Run service.

### Hosting

- **Cloud:** Google Cloud Platform — Cloud Run only. **No Firestore, no Cloud Functions, no BigQuery.**
- **On-prem:** Saturn (GX10) hardware — staging only.
- **Domains:** `dittodatto.no` (apex, web + app store links), `mercury.dittodatto.no` (legacy V1 staging, frozen).

### What's Dead (do not resurrect)

| Former Component | Replacement |
|---|---|
| Cloud Firestore | SurrealDB 3.1 |
| Cloud Functions | FastAPI services on Cloud Run |
| Firebase Emulators | SurrealDB local Docker (workstation / Saturn) |
| Sync Pipe (Firestore → SurrealDB) | Eliminated — one database |
| Qdrant (vector DB) | SurrealDB HNSW vectors |
| BigQuery analytics | SurrealDB graph aggregation |
| MercuryEngine V1 (Hono / TypeScript) | MercuryEngine (FastAPI / Python / Pydantic) |
| Zod schemas (TypeScript) | Pydantic v2 models (Python) — `services/mercury-engine/src/mercury_core/models/` |
| Mercury V1 staging (Pluto host) | Saturn staging (DittoDatto Hub) |

---

## 4. Caution Levels

| Domain | Level | Notes |
|---|---|---|
| **MercuryEngine** (`services/mercury-engine/`) | 🔴 **Critical** | Real money, real time slots, real customer trust. See `conductor/docs/legacy/conductor-snapshot/BOOKING_ENGINE.md` for the safety manual until it's promoted into a MercuryEngine track. |
| **SurrealDB schemas** (`schemas/*.surql`) | 🔴 **Critical** | Data integrity — `REFERENCE` constraints, timestamps, audit triggers. |
| **Auth & Security topology** (ADR-0006) | 🔴 **Critical** | Database namespace credentials and direct WebSocket / OIDC boundaries. |
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
| Python + FastAPI + Pydantic v2 + uv | High | MercuryEngine — 377 tests, ruff-clean, repository pattern, DI through FastAPI. |
| SurrealDB 3.1 (data + graph + vector + geo + BM25) | High | Schema blueprints applied per company; dual-namespace isolation (`companies` / `users`). |
| Dart shared packages | Medium-High | `packages/mercury_client/` — HTTP client + auth + 7 models + 11 admin endpoints. |
| BankID / Vipps OIDC | Medium | Direct-to-SurrealDB native OIDC (ADR-0006), implementation pending Vipps merchant registration. |
| Google ADK (agent orchestration) | Low | Future Ditto/Datto — not yet implemented. |
| Nuxt 4 / Vue 3 | Medium | Chapter 1 stack; `dittodatto.no` landing page is the only active Nuxt surface going forward. |
| Saturn on-prem ops | Low | Hardware here; setup runbook at workspace root `saturn-setup-runbook.md` (foundation grill 2026-05-26). |

---

## 6. Preferred Workflows

1. **Session Start Protocol:**
   - Read `conductor/relay.md` first (pending messages, blockers)
   - Then read `conductor/pulse.md` (current state, recent progress)
   - Review `conductor/tracks.md` for next task
   - For domain language, read `conductor/context.md`
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
5. **MercuryEngine (🔴 Critical):**
   - Always read `conductor/docs/legacy/conductor-snapshot/BOOKING_ENGINE.md` before changing anything in `services/mercury-engine/`
   - Tests-first: 377 tests must remain green (197 unit + 73 admin + 50 auth + 32 integration + 25 token)
   - Calculators are pure (zero DB calls); all I/O via repository interfaces

---

## 7. Project-Specific Constraints

- **Region lock:** All Cloud Run deployments must use `europe-west1`. Never `us-central1`.
- **GDPR / Norwegian commerce law:**
  - Consumer PII isolated to `users/users` namespace.
  - Fiscal immutability: booking snapshots (price, service title, user info) captured at creation and **never updated**. Legal requirement for Norwegian commerce.
  - Search Events from unauthenticated users must be anonymized — strict no-PII rule for `companies/discovery`.
- **BankID:** Mandatory for self-service online transactions (booking through the app, online payments). NOT required for staff-created walk-in customer accounts.
- **Pydantic models as source of truth:** Domain schema authority lives in `services/mercury-engine/src/mercury_core/models/`. TypeScript Zod schemas in `packages/shared-types/` are **frozen** Chapter 1 reference only.
- **Norwegian-first:** Bokmål is the primary locale; English is co-equal from day one. No locale should ship in production without both.
- **Dogfooding non-negotiable:** Merkurial Studio runs its own business on the platform. If a feature doesn't work for us, it doesn't ship.
- **Booking modes on the Service, not the Establishment:** One establishment can host multiple booking modes (appointments + ticketed workshops + table reservations).

---

## 8. Environment Notes

- **MercuryEngine (services/mercury-engine/):**
  - `uv` for dependency management — `uv run pytest`, `uv run ruff check .`
  - Dev: Docker on this workstation. Staging: Docker on Saturn (DittoDatto Hub).
  - SurrealDB connection: dual-connection pool (`companies` + `users`).
- **Flutter apps (apps/*):**
  - Dart SDK `^3.11.3`; Flutter via local install.
  - Cross-platform: Android + iOS + Linux desktop + Web all first-class. Tablet is a test surface, not a design constraint.
- **`dittodatto.no` landing page (apps/web/public-marketplace/):**
  - Nuxt 4 + Vue 3 + Nuxt UI + Tailwind CSS. Public marketing layer, hosted on Cloud Run.
- **Saturn (DittoDatto Hub — staging):**
  - Docker network: `dittodatto-net` (umbrella for all DD containers).
  - Tailscale: machine `saturn` + Service `dittodatto` (routes to Saturn) — accessible at `saturn` (machine) and `dittodatto` (Service).
  - Staging only. Production runs on Cloud Run. See ADR-0003.
