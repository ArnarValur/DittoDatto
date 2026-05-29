# Technology Stack: DittoDatto.no

> ⚠️ **Updated 2026-05-05 (Session 11)** — Full language migration from TypeScript to Python.
> MercuryEngine = Python/FastAPI/Pydantic/SurrealDB. TypeScript is out of the platform stack.
> See [Session 11 Grill](../.docs/grill/session-11-python-migration-grill.md) for decision register.

## Core Infrastructure

* **Platform Database:** SurrealDB 3.0 (unified: document, graph, vector, relational, geo, time-series)
  * **Dev/Staging:** Docker container on Saturn (GX10) / Mercury (Pluto host)
  * **Lite-Production:** Docker container on Cloud Run (`europe-west1`)
  * **Storage Engine:** RocksDB (abstracted KV layer)
* **API Gateway:** MercuryEngine (FastAPI · Python · Pydantic)
  * Booking domain (`/appointments/*`, `/reservations/*`, `/tickets/*`)
  * Discovery domain (`/discovery/*`) — was TheOracle, now unified
  * Establishment CRUD domain (`/establishments/*`, `/services/*`, `/staff/*`) — NEW
  * Dev: Docker on Pluto/Saturn. Production: Cloud Run (or TBD)
  * V1 (Hono/TypeScript) frozen on `mercury.dittodatto.no` (Firebase staging)
* **Authentication:** Under evaluation
  * **Current:** Firebase Auth with Custom Claims (on probation)
  * **Target:** SurrealDB built-in auth (JWKS/OIDC with Vipps) — pending PoC validation
* **Cloud Provider:** Google Cloud Platform (Cloud Run only). No Firestore, no Cloud Functions.

## Mobile Stack (Primary)

* **Framework:** Flutter (Dart)
* **State Management:** Riverpod
* **Routing:** GoRouter
* **API Communication:** REST (http/dio) → MercuryEngine. No direct SurrealDB access.
* **Applications:**
  * **Public Marketplace:** Consumer-facing booking + discovery app
  * **Business Portal:** Merchant dashboard for establishment management

## Web Frontend (Legacy — Not Actively Developed)

* **Framework:** Nuxt 4 (Vue 3)
* **UI Library:** Nuxt UI
* **State Management:** Nuxt-Vuefire (direct Firestore — **NOT migrating**)
* **Applications (stale):**
  * `apps/web/admin-panel`: Internal management dashboard
  * `apps/web/business-portal`: Merchant dashboard (being replaced by Flutter)
  * `apps/web/public-marketplace`: Public booking site (being replaced by Flutter)

## Shared Packages

* `packages/mercury-core` (Python): Pydantic models + pure domain logic (shared by API and agents)
* `packages/mercury-api` (Python): FastAPI thin shell (MercuryEngine)
* `packages/shared-types` (TypeScript): Zod schemas — **FROZEN** (Chapter 1 reference for Nuxt apps)
* `packages/mercury-engine` (TypeScript): Booking engine V1 — **FROZEN** (reference + 156 test spec)

## AI & Data Strategy

* **Knowledge Graph:** SurrealDB native (nodes, edges, GraphRAG)
* **Vector Search:** SurrealDB HNSW indexes
* **Full-Text Search:** SurrealDB BM25 analyzers
* **Geo Search:** SurrealDB `geo::distance()`, GeoJSON
* **Demand Intelligence:** Event logging + graph aggregation in SurrealDB
* **ML Integration:** SurrealDB ML model import/export (`surreal ml`)
* **LLM Orchestration:** Google ADK (Agent Development Kit) — Python, Pydantic-native
* **Agent Framework:** ADK for Ditto (consumer agent) and Datto (business agent)
* **Agent Models:** Pydantic (shared with MercuryEngine via mercury-core)

## What's Dead

| Former Component | Replacement |
|---|---|
| Cloud Firestore | SurrealDB 3.0 |
| Cloud Functions | FastAPI services on Cloud Run |
| Firebase Emulators | SurrealDB local Docker (Pluto/Saturn) |
| Sync Pipe (Firestore → SurrealDB) | Eliminated — one database |
| TheOracle (separate microservice) | Discovery routes inside MercuryEngine |
| Qdrant (vector DB) | SurrealDB HNSW vectors |
| Vector Search with Firestore extension | SurrealDB native vector search |
| BigQuery analytics | SurrealDB graph aggregation |
| MercuryEngine V1 (Hono/TypeScript) | MercuryEngine (FastAPI/Python/Pydantic) |
| Zod schemas (TypeScript) | Pydantic models (Python) |
| TypeScript backend | Python unified backend |
