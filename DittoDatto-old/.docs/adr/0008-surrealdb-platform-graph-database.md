---
title: "ADR-0008: SurrealDB as Unified Platform Database"
type: "adr"
status: "revised"
date: "2026-05-02"
revised: "2026-05-03"
session:
  - 4
  - 7
  - 8
  - 9
  - 10
domain: "Infrastructure"
tags:
  - "surrealdb"
  - "database"
  - "graph"
  - "firestore-replacement"
---

# SurrealDB as Unified Platform Database

## Context

The original ADR-0008 positioned SurrealDB as a **complementary** database alongside Firestore — a "materialized graph view" synced via Firestore Triggers. Sessions 7–9 resolved that this creates tvíverknað: two databases, a sync pipe, and Firebase Auth as a third dependency.

The platform pivot (Session 7) eliminated the split: **SurrealDB 3.0 is the sole platform database.** Firestore and Firebase Auth are deprecated.

## Decision

**SurrealDB 3.0** is the single source of truth for all DittoDatto platform data. There is no Firestore. There is no sync pipe. MercuryEngine reads and writes SurrealDB directly via a repository adapter.

## What Changed From Original ADR-0008

| Aspect | Original (Session 4) | Revised (Sessions 7–10) |
|--------|----------------------|------------------------|
| Role | Complementary graph layer | **Sole platform database** |
| Firestore | Source of truth | **Deprecated** |
| Sync mechanism | Firestore Triggers → SurrealDB | **None needed — single DB** |
| Auth | Firebase Auth | **SurrealDB native auth + BankID/Vipps OIDC** |
| TheOracle | Separate Hono microservice | **Discovery routes within MercuryEngine** |
| Deployment | Saturn only | **Pluto (now) → Saturn (production)** |

## Architecture

```
Clients (Flutter, Business Portal, Ditto/Datto agents)
    ↓ (REST API)
MercuryEngine (Hono)
    ↓ (SurrealDB JS SDK)
SurrealDB 3.0
    ├── titan/company_{slug}    ← Per-company data (booking, staff, services)
    ├── titan/discovery         ← Public aggregator (DittoBar, search events)
    ├── titan/platform          ← Company registry, system alerts
    └── enceladus/users         ← GDPR-isolated consumer PII
```

### Namespace Architecture (Session 8–9)

| Namespace | Database | Purpose |
|-----------|----------|---------|
| `titan` | `company_{slug}` | Multi-tenant company data (19-table blueprint) |
| `titan` | `discovery` | Public search, categories, demand signals |
| `titan` | `platform` | Company registry, system alerts, audit log |
| `enceladus` | `users` | GDPR-isolated consumer profiles |

See [ADR-0009](./0009-surrealdb-namespace-architecture.md) for full namespace design.

### Schema Blueprints

Phase 0 schema files are in `schemas/`:
- `init.surql` — Namespace + database bootstrap
- `company-blueprint.surql` — 19-table per-company template (282 statements)
- `discovery.surql` — DittoBar search + demand signals (72 statements)
- `users.surql` — GDPR-isolated user profiles (43 statements)
- `platform.surql` — Company registry + audit log (75 statements)

All tested on Pluto SurrealDB 3.0 (2026-05-03, Session 10).

## Why SurrealDB (Unchanged)

| Capability | SurrealDB 3.0 | What It Replaces |
|-----------|---------------|------------------|
| **Native graph** (`RELATE`) | First-class nodes & edges | Separate graph DB |
| **Full-text search** (BM25) | Built-in analyzers, tokenizers | Meilisearch / Typesense |
| **Vector search** (HNSW) | Hybrid keyword + semantic | Qdrant |
| **Geospatial** (GeoJSON) | `geo::distance()`, `geo::intersects()` | PostGIS / manual geohash |
| **ACID transactions** | Atomic multi-model operations | Firestore transactions |
| **Multi-tenant isolation** | Namespace + Database per company | Firestore subcollections |
| **Single binary** | Runs on Saturn, Docker, anywhere | 3-4 separate services |

## Migration Path

| Phase | Scope | Saturn Required? |
|-------|-------|-----------------|
| **0** ✅ | Schema blueprints (`.surql` files) | No |
| **1.1** | Repository interface (abstract Firestore out) | No |
| **1.2** | SurrealDB adapter (implement interface) | No (Pluto) |
| **2** | CRUD API (establishments, services, staff) | No |
| **3** | Write adapter (holds, bookings) | No |
| **4** | Discovery routes (DittoBar, search events) | No |
| **5** | Flutter apps consume new API | No |
| **6** | Production deployment on Saturn | Yes |

## Deployment

**Current (Pluto):** Docker container on `merkurial-networks`, port 8000, RocksDB storage.  
**Production (Saturn):** Same container config, bigger hardware. Day-1 checklist applies schemas.

## Consequences

- Firestore is fully deprecated — no sync pipe, no triggers, no dual-write complexity
- Firebase Auth is deprecated — replaced by SurrealDB native auth + BankID/Vipps OIDC
- TheOracle as a separate service is deprecated — discovery routes live in MercuryEngine
- Qdrant Dome can be decommissioned
- One database, one query language, one deployment — no tvíverknað
- MercuryEngine migrates via repository adapter pattern (no big bang)
- GDPR compliance via namespace isolation (`enceladus` for PII)
- All schema definitions are versioned in `schemas/` directory

---

*"If we are going to be an AI Agency, we need an agentic database."* — Captain Arnar, Session 4 Grill

*Origin: Session 4 Grill → Revised Sessions 7–10 (full platform pivot, namespace architecture, schema blueprints)*
