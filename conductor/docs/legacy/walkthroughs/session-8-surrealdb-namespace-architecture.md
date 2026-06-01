---
title: "Session 8: SurrealDB Namespace Architecture"
type: "grill"
status: "complete"
date: "2026-05-03"
session: 8
participants:
  - "Captain Arnar"
  - "Cmdr Opus (Antigravity)"
domain: "Infrastructure"
tags:
  - "surrealdb"
  - "namespace"
  - "titan"
  - "enceladus"
  - "grill"
---

# Session 8: SurrealDB Namespace Architecture — The Surreal Twist

---

## Executive Summary

Session 8 started as a schema translation exercise (Zod → SurrealQL) but evolved into a **fundamental architectural rethinking**. Instead of a single multi-tenant database with WHERE-clause isolation (the Firestore pattern), DittoDatto will use SurrealDB's namespace/database hierarchy to give each company its own isolated database — making each Datto agent the embodiment of its company's entire data context.

**Key quote from Captain:** *"If company can be fully presented in the agent-space as Datto → Datto is the embodiment of that company database... So when we have 20 companies we have 20 databases that represent 20 Dattos."*

---

## Decisions Locked

### GQ1: Firestore Hierarchy → Flat Tables with Record Links

**Decision:** Option A — Flat tables with `record<table>` links.

No subcollections. No compound IDs. SurrealDB's native pattern.

```surql
DEFINE FIELD company ON establishment TYPE record<company>;
SELECT company.name FROM establishment:sawasdee;
```

### GQ2: SurrealDB Table Name = `establishment`

**Decision:** Name the table `establishment` in SurrealDB, not `store`.

- Zod schemas stay `StoreSchema` / `storeId` (transitional)
- Flutter uses `Establishment` / `establishmentId`
- Adapter layer maps `store` ↔ `establishment`
- Clean slate, use the right name from day one

### GQ3: Graph Edges — Partially Explored

Graph edges explained from first principles:

- **Record link** = address written on paper inside a building (ownership, foreign key)
- **Graph edge** = a road between buildings (traversable, carries metadata, has its own table)

Proposed split discussed but **not locked** — paused for namespace architecture discovery:

**Record links (ownership):** company→establishment, service→establishment, booking→company, staff→company, customer→company

**Graph edges (traversal):** establishment→offers→service, category→contains→establishment, establishment→located_in→area, user→booked→booking, user→favorited→establishment, staff→works_at→establishment, search_event→searched_for→category, booking→assigned_to→staff

**Status:** Resume in next session after namespace architecture is settled.

---

## Major Architecture Discovery: Datto = Database

### The Insight

The Captain proposed that instead of one big shared database with logical tenant isolation, **each company gets its own SurrealDB database**. Each database IS that company's Datto agent — operational data, knowledge graph, and agent memory all unified in a single transaction boundary.

### Agent Scope Clarification

Two agent scopes identified (previously conflated):

| Agent | Scope | Database Access |
|---|---|---|
| **Datto** (per-company) | Single company's data, customers, bookings, services. Online marketing agent for that business. | Its own company database only |
| **Ditto** (consumer agent) | User's personal context + public discovery across all companies. | `discovery` + user's own data |

**Key correction from Captain:** Datto cannot do cross-company demand intelligence. That's MasterDatto's role. Datto only sees its own company's data.

### SurrealDB Validation

Confirmed via SurrealDB documentation/support:

1. **No native cross-database queries** — isolation is strict and by design
2. **Per-company databases** are the intended multi-tenancy pattern
3. **Agent memory can be embedded** in each company's database (no separate DB needed)
4. **Discovery aggregator database** is the recommended bridge for cross-company search/discovery
5. **Separate namespaces** provide hard isolation for different security domains

### Namespace Architecture (Current State — Not Final)

```
titan (namespace)              ← Datto world (companies)
├── company_sawasdee           ← Datto:Sawasdee — ops data + KG + agent memory
├── company_merkurial          ← Datto:Merkurial — ops data + KG + agent memory  
├── company_xxx                ← ...
└── discovery                  ← Public aggregator (Ditto's eyes into the graph)

enceladus (namespace)          ← User world (consumers)
└── users                      ← Profiles, BankID/NIN, booking refs, preferences
```

**Rationale for two namespaces:**

- BankID/NIN data requires GDPR-level protection → hard isolation from company data
- No cross-namespace transaction needed — MercuryEngine mediates sequentially
- Booking source of truth lives in company database; user booking reference is an index that can be rebuilt

### MercuryEngine's Role

MercuryEngine becomes the **application-layer mediator** between namespaces:

```
Flutter App
    → MercuryEngine (Hono API)
        → titan/discovery (read: search, browse, discover)
        → titan/company_X (write: book, manage, transact)
        → enceladus/users (read/write: user profile, auth, booking refs)
```

Discovery routes query `discovery` database. Booking routes target the specific company database. User routes target `enceladus/users`.

### Data Sync: Company → Discovery

When an establishment updates its public-facing data, the public profile is synced to the `discovery` database. Two approaches identified:

1. `DEFINE EVENT` triggers in company databases that push public data to discovery
2. MercuryEngine dual-writes on establishment updates

**Not decided yet** — needs PoC evaluation.

---

## Spectron Waitlist

Captain submitted the Spectron waitlist application on 2026-05-03. Spectron is SurrealDB's native agent memory system with:

- Knowledge graph with entity disambiguation
- Bi-temporal, append-only fact storage
- Hybrid retrieval (graph + vector + structured filters)
- Multi-agent shared memory
- MCP-native access

**Current strategy:** Build manual knowledge graph using SurrealDB native graph + vector indexes. Zero-cost migration to Spectron when available.

---

## What Changed from Session 7

| Aspect | Session 7 | Session 8 |
|---|---|---|
| Database architecture | Single `merkurial/dittodatto` for everything | Per-company databases in `titan` namespace |
| Agent memory | Separate `agent_memory` database | Embedded in each company database |
| Namespace count | 1 (`merkurial`) | 2 (`titan` + `enceladus`) |
| Namespace naming | `merkurial` | `titan` (companies), `enceladus` (users) |
| Discovery | SurrealDB queries on shared tables | Dedicated `discovery` aggregator database |
| Tenant isolation | Logical (WHERE clauses + permissions) | Physical (separate databases) |
| Agent scope | Conflated | Clarified: Datto, MasterDatto, Ditto |

---

## Open Questions for Session 9

1. **Graph edges (GQ3):** Which relationships are edges vs record links? Paused — resume after namespace architecture settles.
2. **Namespace layout finality:** Is `titan` / `enceladus` the final naming? Any other namespaces needed?
3. **Discovery sync mechanism:** `DEFINE EVENT` triggers vs MercuryEngine dual-write?
4. **Schema translation:** Now that we know it's per-company databases, how do the 23 Zod schemas map? Each company database gets the same table definitions (template/blueprint pattern)?
5. **Surrealism (WASM):** The Captain hinted at Rust+WASM for ultra-fast discovery routing. Explore further.
6. **Sequencing (GQ9 from Session 7):** Still parked. Dependency chain needs updating for the new architecture.
7. **MercuryEngine multi-connection pattern:** How does Hono manage connections to multiple databases/namespaces?

---

## Key References

- [Session 7 Grill](./session-7-surrealdb-pivot.md) — 9 decisions, Firestore replacement scope
- [SurrealDB Knowledge Base](/home/addinator/MerkurialDrive/TheVault/Documentations/SurrealDB/) — 13 curated docs
- [ADR-0007](../.docs/adr/0007-dittobar-search-on-theoracle.md) — DittoBar as A2UI visor, Ditto traverses graph to find Datto endpoints
- [Spectron](https://surrealdb.com/platform/spectron) — Waitlist submitted
- [Agentic Data Planes video](https://youtu.be/LMjxfPGidUI) — OpenAI's Postgres architecture critique

---

## Captain's Wild Concepts (Captured)

1. **Datto = Database embodiment.** Each company IS a database. 20 companies = 20 databases = 20 Dattos.
2. **Spectron per Datto.** Each company agent has its own knowledge graph and memory.
3. **Location + category routing.** Narrows scope to find the right Datto without cross-database queries.
4. **Rust + WASM for discovery.** Surrealism module for ultra-fast geo+category routing in the discovery database.
5. **Ditto as graph traverser.** From ADR-0007: "Each establishment node carries a Datto endpoint. Ditto traverses the graph, finds establishments, and calls their Datto agents."

---

*"Have I ever told you that I'm not always the sharpest one in the drawer but a deep spoon I am?" — Captain Arnar, Session 8*

*Session 8 Grill — Started with schema translation, ended with a new architecture. The deep spoon found bedrock. 🍦🖖*
