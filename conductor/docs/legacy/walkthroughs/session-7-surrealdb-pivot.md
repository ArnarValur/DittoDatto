---
title: "Session 7: SurrealDB Platform Pivot"
type: "grill"
status: "complete"
date: "2026-05-03"
session: 7
participants:
  - "Captain Arnar"
  - "Cmdr Opus (Antigravity)"
domain: "Infrastructure"
tags:
  - "surrealdb"
  - "firestore"
  - "pivot"
  - "grill"
---

# Session 7: SurrealDB Platform Pivot — Full Grill Documentation

---

## Executive Summary

DittoDatto is pivoting from a Firebase/Firestore-dependent stack to a **unified SurrealDB 3.0 architecture**. This is not a complement or materialized view — SurrealDB replaces Firestore as the platform database. Firebase Auth is on probation pending PoC evaluation. TheOracle ceases to be a separate microservice; its capabilities are native SurrealDB features exposed through MercuryEngine. Both Public Marketplace and Business Portal will be Flutter applications backed by SurrealDB.

**Key quote from Captain:** *"I feel like Im doing the same mistakes that I overlooked months ago... I will not repeat that mistake going firestore/firebase on saturn."*

---

## Decision Register

### GQ1: Scope of Replacement

> **Question:** What does "Firestore is out" mean in practice? All six Firebase layers, or selective?

**Answer:** SurrealDB replaces **Firestore** (database), **Cloud Functions** (compute → Hono on Saturn/Cloud Run), and the **Sync Pipe** concept (dead — no two-database sync needed). Firebase Auth stays **for now** — on probation pending PoC evaluation of SurrealDB's built-in auth with Vipps JWKS.

| Firebase Service | Decision | Replacement |
|---|---|---|
| Firestore | **REPLACED** | SurrealDB 3.0 |
| Cloud Functions | **REPLACED** | Hono services (MercuryEngine) |
| Sync Pipe (Module 10) | **DEAD** | No sync needed — one database |
| Firebase Auth | **PROBATION** | Evaluate SurrealDB built-in auth during PoC |
| Firebase Hosting | **IRRELEVANT** | Nuxt webapps staying as-is (stale) |

---

### GQ2: MercuryEngine Migration Strategy

> **Question:** What happens to the 156-test, battle-proven booking engine?

**Answer:** Option B — **swap the data layer, keep the Hono service**. The engine's pure core (60% of complexity) doesn't touch Firestore. Only the shell (data fetcher, transaction orchestrators) needs rewriting.

**Critical finding: Firestore is NOT abstracted.** There is no repository interface, no adapter pattern. `db` (Firestore instance) is imported directly into 10 source files. The migration forces creation of a proper abstraction layer — architecturally beneficial regardless.

**Incremental phases:**
1. Phase 0: SurrealDB schema design
2. Phase 1: Read adapter (`GET /slots` against SurrealDB)
3. Phase 2: Write adapter (hold/booking transactions)
4. Phase 3: CRM, cleanup, reservations
5. Each phase validated before the next

**Test audit:**
- 139/156 tests are genuinely pure (zero Firestore) — these survive migration untouched
- 17 contract tests use a hand-rolled Firestore mock — need rewriting
- 0 integration tests for transaction orchestration — migration is no riskier than current state

---

### GQ3: Flutter Client Architecture

> **Question:** How does Flutter talk to SurrealDB? Direct SDK or through API middleware?

**Answer:** Option C — **Flutter calls REST APIs (MercuryEngine), SurrealDB stays internal.** No official Dart/Flutter SDK exists (community only, experimental). SurrealDB is an implementation detail the client never sees. Real-time features (LIVE SELECT) can be exposed through Hono's WebSocket layer if needed.

---

### GQ4: Shared Types Strategy

> **Question:** What happens to the 23 Zod schemas designed for Firestore documents?

**Answer:** Option C — **defense in depth.** Zod stays for API-level validation at the Hono service boundary. SurrealDB's `DEFINE TABLE ... SCHEMAFULL` enforces types and constraints at the database level. The Zod schemas get liberated from Firestore assumptions:
- `DateTimeSchema` drops Firestore `Timestamp` handling → SurrealDB native `datetime`
- Collection path hierarchy → SurrealDB record link syntax
- Schemas evolve from "Firestore document shape" to "domain model shape"
- Adapter layer handles translation between SurrealDB records and Zod-validated objects

---

### GQ5: Deployment Model

> **Question:** Where does SurrealDB run?

**Answer:**
- **Dev/Staging:** Saturn (GX10) — Docker container, self-hosted
- **Lite-Production:** SurrealDB Docker on Cloud Run (`europe-west1`)
- **MercuryEngine:** Stays on Cloud Run for production
- **Future:** Potential SurrealDB enterprise partnership

**Note:** Cloud Run is stateless/scale-to-zero. SurrealDB needs persistent storage. Cloud Run Gen2 volume mounts solve this — configuration detail for later, not a blocker.

**Foundation work starts on Mercury (Pluto host) now**, moves to Saturn when hardware arrives.

---

### GQ6: Authentication Architecture

> **Question:** Does Firebase Auth stay, or does SurrealDB replace it too?

**Answer:** **Evaluate during PoC.** SurrealDB has:
- Built-in JWT generation and verification
- JWKS support for third-party OIDC (Vipps)
- `DEFINE ACCESS` for record-level user auth
- Row-level permissions via `$auth` context
- `DEFINE USER` with role-based access

If SurrealDB can reliably validate Vipps tokens via JWKS during the Saturn PoC → Firebase Auth is removed. If not → keep it as the one remaining bridge.

**Goal:** Zero Firebase dependencies. Firebase Auth is the last one standing.

---

### GQ7: Nuxt Webapp Strategy

> **Question:** Business Portal and Admin Panel use nuxt-vuefire for direct Firestore access. What happens to them?

**Answer:** **Leave untouched.** They're stale legacy. The May plan builds both Public Marketplace AND Business Portal in Flutter, backed by SurrealDB. No energy spent migrating Nuxt apps that are being replaced.

---

### GQ8: TheOracle — Service or Concept?

> **Question:** If SurrealDB natively does graph traversal, BM25 search, geo queries, GraphRAG, and has `DEFINE API` — does TheOracle still need to be a separate Hono microservice?

**Answer:** **No.** TheOracle is not a separate microservice. It becomes a route module inside MercuryEngine (`routes/discovery.ts`). Discovery capabilities are native SurrealDB:

| Capability | SurrealDB Native Feature |
|---|---|
| Full-text search | BM25 analyzers |
| Geo search | `geo::distance()`, GeoJSON |
| Graph traversal | Arrow syntax (`->offers->`, `->located_in->`) |
| Vector/semantic search | HNSW indexes |
| Live updates | `LIVE SELECT` |
| Custom endpoints | `DEFINE API` |
| Knowledge graph | Native nodes + edges |
| GraphRAG | Graph + vector in one query |
| Demand signals | `CREATE search_event` with graph connections |

**Impact:** ADR-0007 and ADR-0008 need rewriting. Module 9 (TheOracle Microservice) in the PRD merges into MercuryEngine. Module 10 (Sync Pipe) is deleted.

**Captain's key insight:** *"I dont have to open a new codebase and start conceptualizing some 'in house solution' on how we create a conductor-like-KB-graph-system... ITS ALREADY IN SURREALDB."*

---

### GQ9: Sequencing (In Progress)

> **Question:** What gets built first?

**Identified dependency chain:**
```
SurrealDB Schema Design
    ↓
MercuryEngine adapter (read path — GET /slots)
    ↓
MercuryEngine adapter (write path — holds, bookings)
    ↓
Establishment CRUD API (NEW — doesn't exist today)
    ↓
Business Portal Flutter (creates data IN SurrealDB)
    ↓
Discovery routes (search what Business Portal created)
    ↓
Public Marketplace Flutter (browse → book)
    ↓
Simulation (Merkurial Studio + DittoDatto, real flows)
```

**Critical gap identified:** MercuryEngine currently has NO establishment CRUD endpoints. All store/service/staff management happens via direct Firestore writes from the Nuxt Business Portal. New API surface needed for Flutter Business Portal.

**Status:** Parked for post-break session. Captain wants clear roadmap, not execution yet.

---

## Firestore Residue Audit

### Where Firestore Still Lives in the Codebase

#### MercuryEngine (`packages/mercury-engine/`)

| File | Firestore Usage | Migration Impact |
|---|---|---|
| `config/firebase.ts` | `initializeApp()`, `getFirestore()` — creates `db` singleton | Replace with `config/surrealdb.ts` |
| `core/shared/data.ts` | 7 parallel Firestore reads via `db.doc()`, `db.collection()`, `.where()` | Rewrite as SurrealQL queries |
| `core/bookings/hold.ts` | `db.runTransaction()`, `transaction.get()`, `transaction.set()` | Rewrite with SurrealDB ACID transactions |
| `core/bookings/booking.ts` | `db.runTransaction()`, `getAuth()` for user lookup, `transaction.set()`, `transaction.delete()` | Rewrite transaction + decouple auth lookup |
| `core/shared/customer.ts` | `db.collection()`, `FieldValue.increment()`, `FieldValue.arrayUnion()` | Rewrite as SurrealDB upsert |
| `core/reservations/availability.ts` | `db.collection()` reads | Rewrite as SurrealQL |
| `core/reservations/booking.ts` | `db.runTransaction()` | Rewrite transaction |
| `routes/cleanup.ts` | `db.collection()` for expired hold cleanup | Rewrite as SurrealQL |
| `routes/ticketing.ts` | `db.collection()` (scaffold only) | Rewrite when activated |
| `middleware/auth.ts` | `getAuth().verifyIdToken()` — Firebase Auth token verification | Keep if Firebase Auth stays; replace if SurrealDB auth wins PoC |

**Total: 10 files with Firebase imports. 14 import statements.**

#### Shared Types (`packages/shared-types/`)

| Concern | Firestore Dependency |
|---|---|
| `DateTimeSchema` | Handles Firestore `Timestamp` objects alongside JS Dates and ISO strings |
| Collection paths | Schemas assume `companies/{id}/stores/{id}/services/{id}` hierarchy |
| Field naming | `storeId`, `companyId` as flat string refs (vs. SurrealDB record links) |

#### Nuxt Web Apps (STAYING AS-IS)

| App | Dependency |
|---|---|
| `apps/web/business-portal/` | `nuxt-vuefire` — direct Firestore reads/writes for all CRUD |
| `apps/web/admin-panel/` | `nuxt-vuefire` — direct Firestore reads for dashboards |
| `apps/web/public-marketplace/` | `nuxt-vuefire` — direct Firestore reads for public display |

**Decision:** These are not being migrated. They will be replaced by Flutter apps.

---

## Architecture: Before vs After

### Before (Firebase Era)

```
Flutter App ──→ MercuryEngine (Hono) ──→ Firestore
                                          ↑
Business Portal (Nuxt) ──→ nuxt-vuefire ──┘
                                          ↑
Admin Panel (Nuxt) ──→ nuxt-vuefire ──────┘

TheOracle (Hono) ──→ SurrealDB (discovery only)

Sync Pipe: Firestore Triggers ──→ Cloud Functions ──→ SurrealDB
Firebase Auth: JWT verification for all services
```

### After (SurrealDB Era)

```
Flutter Public App ──→ MercuryEngine (Hono) ──→ SurrealDB
Flutter Business App ──→ MercuryEngine (Hono) ──→ SurrealDB

MercuryEngine routes:
  /appointments/*     ← Booking domain (existing, migrated)
  /reservations/*     ← Reservation domain (existing, migrated)
  /tickets/*          ← Ticketing domain (existing scaffold)
  /discovery/*        ← Discovery domain (NEW — was TheOracle)
  /establishments/*   ← CRUD domain (NEW — was direct Firestore)
  /services/*         ← CRUD domain (NEW)
  /staff/*            ← CRUD domain (NEW)

Auth: SurrealDB built-in (if PoC validates) OR Firebase Auth (fallback)
No Sync Pipe. No Cloud Functions. No separate TheOracle service.
```

---

## Documents Requiring Updates

| Document | Change Needed | Priority |
|---|---|---|
| **PRD** (`.docs/prd-public-marketplace-v1.md`) | Module 9 (TheOracle) → merged into MercuryEngine. Module 10 (Sync Pipe) → deleted. Tech stack rewrite. Auth module update. | High |
| **ADR-0007** (`.docs/adr/0007-dittobar-search-on-theoracle.md`) | Reframe: TheOracle is not a separate service, discovery is SurrealDB-native via MercuryEngine routes | High |
| **ADR-0008** (`.docs/adr/0008-surrealdb-platform-graph-database.md`) | Reframe from "complementary" to "sole platform database." Remove Sync Pipe architecture. Remove "What Lives Where" split. | High |
| **NEW ADR-0009** | "SurrealDB as Unified Platform Database (Replacing Firestore)" — the full replacement decision | High |
| **CONTEXT.md** | Update tech defaults, remove Firestore references, update TheOracle description | Medium |
| **tech-stack.md** (conductor) | Complete rewrite — Firestore out, Cloud Functions out, SurrealDB in | Medium |
| **tracks.md** (conductor) | TheOracle domain description update | Medium |
| **PoC PostIT** (`.docs/postit/surrealdb-poc.md`) | Scope expanded — not just discovery, full platform PoC | Medium |
| **Auth PostIT** (`.docs/postit/bankid-vipps-auth.md`) | Add SurrealDB JWKS evaluation path, remove Cloud Function dependency | Medium |
| **WAYMAP.md** | Update pipeline — new grill sessions needed | Low |

---

## What SurrealDB Brings (Verified via Research)

| Capability | SurrealDB 3.0 | What It Replaces |
|---|---|---|
| ACID transactions | Full multi-table, MVCC snapshot isolation | Firestore optimistic concurrency |
| Real-time | `LIVE SELECT` via WebSocket | Firestore onSnapshot listeners |
| Auth | Built-in JWT/JWKS, `DEFINE ACCESS`, row-level permissions | Firebase Auth |
| Full-text search | BM25 analyzers, tokenizers | Firestore composite indexes (poor) |
| Vector search | HNSW indexes | Qdrant (decommissioned) |
| Geo queries | `geo::distance()`, GeoJSON | Manual geohash / PostGIS |
| Graph | Native `RELATE`, arrow traversal | Separate graph DB |
| Custom API endpoints | `DEFINE API` — HTTP endpoints in-database | Separate Hono services |
| Server-side functions | `DEFINE FUNCTION`, Surrealism (Rust WASM) | Cloud Functions |
| ML model management | `surreal ml import/export` | External ML pipeline |
| Knowledge graph | Native nodes + edges + GraphRAG | Would have been custom-built |
| Schema enforcement | `DEFINE TABLE ... SCHEMAFULL`, field-level constraints | Zod validation only |
| Offline/embedded | In-process mode, WASM for browser | Firestore offline SDK |
| Storage engine | RocksDB (abstracted KV layer) | Firestore proprietary |

---

## Risk Register

| Risk | Severity | Mitigation |
|---|---|---|
| No official Dart/Flutter SDK | Medium | Flutter never talks to SurrealDB directly (GQ3: Option C) |
| SurrealDB 3.0 is young (Feb 2026) | Medium | Saturn PoC validates before any production commitment |
| MercuryEngine transaction rewrite complexity | High | Incremental phases, pure core stays untouched, each phase validated |
| New CRUD API surface needed | Medium | Doesn't exist for Firestore either — greenfield regardless |
| Cloud Run + SurrealDB persistent storage | Low | Cloud Run Gen2 volume mounts; solve when needed |
| Vipps JWKS integration unproven | Medium | PoC validation; Firebase Auth fallback exists |
| Captain's SurrealDB enthusiasm vs battle-testing | Low | That's what the PoC and simulation are for |

---

## Next Session Agenda

1. **Resume GQ9:** Lock the sequencing / priority order
2. **Phase 0 execution:** Begin SurrealDB schema design on Mercury
3. **ADR-0009:** Write the formal replacement decision
4. **PRD surgery:** Update modules, tech stack, architecture diagrams
5. **Roadmap:** Clear month-of-May timeline

---

*"Less is More. The fewer bits and parts we need to weld and screw together the better." — Captain Arnar, Session 7*

*Session 7 Grill — 9 questions, 9 decisions. The Yaris is parked. 🏺🖖*
