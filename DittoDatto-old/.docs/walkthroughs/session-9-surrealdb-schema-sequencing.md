---
title: "Session 9: SurrealDB Schema Sequencing"
type: "grill"
status: "complete"
date: "2026-05-03"
session: 9
participants:
  - "Captain Arnar"
  - "Cmdr Opus (Antigravity)"
domain: "Infrastructure"
tags:
  - "surrealdb"
  - "schema"
  - "sequencing"
  - "grill"
---

# Session 9: SurrealDB Schema Sequencing — Locking the Blueprint

---

## Executive Summary

Session 9 resolved all 7 open questions from Session 8 in rapid succession. No paradigm shifts this time — the architecture from Session 8 held firm. The session locked the graph edge classification, confirmed namespace naming, chose the sync mechanism, mapped all 23 Zod schemas to their database homes, parked Surrealism, sequenced the migration phases, and defined the multi-connection pattern for MercuryEngine.

**Key outcome:** The architecture is now fully specified. Next session begins Phase 0 — writing the actual `.surql` schema blueprint files.

---

## Decisions Locked

### Q1 (GQ3 Resumed): Graph Edges vs Record Links — ✅ LOCKED

**Decision heuristic:**
> Metadata? Bidirectional traversal? Multiple instances between same entities? → Graph edge. Otherwise → record link.

**Record links (ownership, single-hop):**

| Field | On Table | Type |
|-------|----------|------|
| `establishment` | `service` | `record<establishment>` |
| `establishment` | `staff` | `record<establishment>` |
| `establishment` | `booking` | `record<establishment>` |
| `service` | `booking_item` | `record<service>` |
| `staff` | `booking_item` | `record<staff>` |
| `customer` | `booking` | `record<customer>` |

**Graph edges (traversable, carry metadata):**

| Edge Table | Pattern | Metadata |
|------------|---------|----------|
| `offers` | `establishment→offers→service` | `sortOrder`, `featured` |
| `works_at` | `staff→works_at→establishment` | `role`, `since`, `schedule` |
| `assigned_to` | `booking→assigned_to→staff` | `confirmed`, `notified_at` |

**Discovery edges:** `categorized_as`, `located_in`, `searched_for`
**User edges:** `booked`, `favorited`

Validated against [SurrealDB graph relations docs](https://surrealdb.com/docs/surrealdb/reference-guide/graph-relations).

---

### Q2: Namespace Naming — ✅ LOCKED

**Two namespaces. Final.**

```
titan (namespace)
├── company_sawasdee        ← Datto:Sawasdee
├── company_merkurial       ← Datto:Merkurial
├── discovery               ← Public aggregator (Ditto's eyes)
└── platform                ← System config, audit, billing, company registry

enceladus (namespace)
└── users                   ← Profiles, BankID/NIN, booking refs
```

- `discovery` stays in `titan` — derived from company data, written by company-side events.
- `platform` database in `titan` for system-level ops data.
- No third namespace. Less is more.

---

### Q3: Discovery Sync Mechanism — ✅ LOCKED

**Decision:** MercuryEngine dual-write (Option B).

- `DEFINE EVENT` triggers cannot write cross-database. Confirmed via [SurrealDB docs](https://surrealdb.com/docs/surrealql/statements/define/event).
- MercuryEngine performs both source-of-truth write and discovery projection.
- Centralized via `syncToDiscovery()` helper function.
- Discovery is eventually consistent — acceptable for search results.

---

### Q4: Schema Translation — ✅ LOCKED

**Per-company database blueprint (19 tables):**

| Category | Tables |
|----------|--------|
| Core | `establishment`, `service`, `service_group`, `staff`, `customer` |
| Booking | `booking`, `booking_item`, `booking_policy` |
| Schedule | `operating_hours`, `date_override` |
| Resources | `resource` |
| Comms (v1.4) | `message_thread`, `message` |
| Edge tables | `offers`, `works_at`, `assigned_to` |
| Agent memory | `entity`, `fact`, `relates_to` |

**Non-company schemas:**

| Schema | Database | Reason |
|--------|----------|--------|
| `UserSchema` | `enceladus/users` | GDPR-isolated PII |
| `CategorySchema` | `titan/discovery` | Platform-wide taxonomy |
| `AreaSchema` | `titan/discovery` | Geo regions |
| `SearchEventSchema` | `titan/discovery` | Demand signals |
| `SystemAlertSchema` | `titan/platform` | Platform ops |
| `IconCollectionSchema` | `titan/platform` | Shared assets |
| `CompanySchema` | `titan/platform` | Company registry |

**Provisioning:** Versioned `.surql` migration files in the repo. MercuryEngine applies blueprint to new databases on company onboard.

---

### Q5: Surrealism (WASM) — ✅ PARKED

SurrealDB's native geo, vector, and graph queries are sufficient for v1.0–v1.5 scale. Surrealism stays in the toolbox as a future optimization lever if query profiling reveals bottlenecks.

---

### Q6: Sequencing — ✅ LOCKED

```
Phase 0: Foundation (now → Saturn arrival)
├── [0.1] Write .surql schema blueprint (company DB template)
├── [0.2] Write discovery DB schema
├── [0.3] Write enceladus/users schema
├── [0.4] Write platform DB schema
└── [0.5] Update docs (11_SATURN_STRATEGY.md, ADR-0009)

Phase 1: MercuryEngine Adapter Layer (Saturn Day 1+)
├── [1.1] Define repository interface (abstract Firestore)
├── [1.2] Implement SurrealDB adapter
├── [1.3] Multi-connection manager
└── [1.4] Test migration (139 pure stay green, 17 rewritten)

Phase 2: Company Provisioning
├── [2.1] Provisioning endpoint
├── [2.2] syncToDiscovery() dual-write helper
├── [2.3] Seed Sawasdee + Merkurial
└── [2.4] CRUD endpoints for establishment management

Phase 3: Auth (parallel, can start during Phase 1)
├── [3.1] Evaluate SurrealDB JWKS + Vipps Login
├── [3.2] Record access in enceladus/users
└── [3.3] Token exchange flow

Phase 4: Discovery + DittoBar
├── [4.1] Category/area taxonomy seed
├── [4.2] Discovery query routes
├── [4.3] DittoBar API endpoint
└── [4.4] SearchEvent capture
```

**Critical path:** 0.1 → 1.1 → 1.2 → 2.1 → 2.3 → 2.4
**Can start NOW:** Phase 0 entirely + Phase 1.1 (pure TypeScript)

---

### Q7: MercuryEngine Multi-Connection Pattern — ✅ LOCKED

- 3 static connections at startup: `discovery`, `platform`, `users`
- Dynamic company connections via factory + LRU cache
- 2 service account credentials (namespace-level for `titan` and `enceladus`)
- Hono middleware resolves company slug → injects DB connection to request context

---

## Additional Findings

### Customer Table — Cross-DB Projection Contract

Each company DB has a `customer` table that projects user data from `enceladus/users`:
- **Synced fields:** Name, contact info, booking history refs. NOT BankID/NIN.
- **Direction:** `enceladus` → `company_X` only. Never reverse.
- **GDPR deletion:** MercuryEngine iterates all company DBs to purge `customer` records. Defense-in-depth: periodic job checks for missed purges.

### SurrealDB Agent Feedback (Incorporated)

1. Define explicit sync contracts (owned-by-enceladus vs local-only fields)
2. Soft delete pattern for GDPR audit trail
3. Connection pool health monitoring (metrics, eviction, error rates)
4. Consistent `company_slug` naming — lowercase, no special characters
5. Test isolation via ephemeral `titan/test_company_X` databases with `mem://` backend
6. Track SurrealDB releases for future cross-database event support

---

## What Changed from Session 8

| Aspect | Session 8 | Session 9 |
|--------|-----------|-----------|
| Graph edges | Partially explored, paused | Fully classified and locked |
| Namespace naming | Proposed `titan`/`enceladus` | Confirmed final |
| Discovery sync | Two options identified | Dual-write locked, events ruled out |
| Schema mapping | "Each company gets same tables?" | Full 19-table blueprint + 7 non-company schemas mapped |
| Surrealism | Captain's wild concept | Parked — native queries sufficient |
| Sequencing | Parked since Session 7 | 4-phase plan with critical path |
| Multi-connection | Open question | Factory + LRU + middleware pattern locked |

---

## Next Session: Phase 0 Execution

Session 10 begins the actual schema writing:
1. Write `schemas/company-blueprint.surql` — the 19-table company database template
2. Write `schemas/discovery.surql` — discovery database schema
3. Write `schemas/users.surql` — enceladus user schema
4. Write `schemas/platform.surql` — platform ops schema
5. Test all schemas on the Pluto SurrealDB instance

---

*"Less is more." — Captain Arnar, Session 9*

*Session 9 — Seven questions in, seven answers out. The blueprint is locked. Time to build. 🖖*
