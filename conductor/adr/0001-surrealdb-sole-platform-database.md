# SurrealDB as Sole Platform Database

> **Recorded:** 2026-05-26 (promoted from legacy ADR-0008 Sessions 4 + 7–10; namespace rename applied; deployment scope corrected)
> **Status:** accepted

## Context

The original ADR-0008 positioned SurrealDB as a complementary database alongside Firestore — a materialized graph view synced via Firestore Triggers. Sessions 7–9 resolved that this creates two databases, a sync pipe, and Firebase Auth as a third dependency. The platform pivot eliminated the split.

## Decision

**SurrealDB 3.0** is the single source of truth for all DittoDatto platform data. There is no Firestore. There is no sync pipe. MercuryEngine V2 (FastAPI · Pydantic v2 · Python 3.11+) reads and writes SurrealDB directly via a repository adapter.

## Architecture

```
Clients (Flutter Admin, Business Portal, Public Marketplace, future Ditto/Datto agents)
    ↓ (REST API)
MercuryEngine V2 (FastAPI · Pydantic v2 · Python 3.11+)
    ↓ (SurrealDB Python SDK)
SurrealDB 3.0
    ├── companies/{slug}     ← Per-company data (booking, staff, services)
    ├── companies/discovery  ← Public aggregator (DittoBar, search events)
    ├── companies/registry   ← Company registry, system alerts, audit log
    └── users/profiles       ← GDPR-isolated consumer PII
```

See ADR-0002 for the namespace architecture rationale.

## Why SurrealDB

| Capability | SurrealDB 3.0 | What It Replaces |
|---|---|---|
| Native graph (`RELATE`) | First-class nodes & edges | Separate graph DB |
| Full-text search (BM25) | Built-in analyzers, tokenizers | Meilisearch / Typesense |
| Vector search (HNSW) | Hybrid keyword + semantic | Qdrant |
| Geospatial (GeoJSON) | `geo::distance()`, `geo::intersects()` | PostGIS / manual geohash |
| ACID transactions | Atomic multi-model operations | Firestore transactions |
| Multi-tenant isolation | Namespace + Database per company | Firestore subcollections |
| Single binary | Runs in Docker anywhere | 3-4 separate services |

## Deployment

- **Dev:** Independent SurrealDB instance on the developer workstation (Docker, ephemeral).
- **Staging:** DittoDatto Hub on Saturn (`saturn:8001` via Tailscale) — see ADR-0003.
- **Production:** Cloud Run `europe-west1` (sole production target).

Dev and staging instances are independent — no data shared, no schema-migration coupling.

## Consequences

- Firestore is fully deprecated — no sync pipe, no triggers, no dual-write complexity.
- Firebase Auth is deprecated — replaced by SurrealDB native auth + BankID/Vipps OIDC (ADR-0004).
- Qdrant is decommissioned (HNSW vectors live in SurrealDB).
- One database, one query language, one deployment per environment.
- MercuryEngine migrates via repository adapter pattern (no big-bang migration).
- GDPR compliance via namespace isolation (`users` for PII — ADR-0002).
- Schema definitions versioned in Pydantic models at `services/mercury-engine/src/mercury_core/models/` + future `.surql` migration files (currently in `DittoDatto-old/schemas/`).

---

*Origin: Session 4 Grill (initial proposal) → Sessions 7–10 (platform pivot, namespace architecture, schema blueprints). Promoted into canonical conductor/adr/ during /grill foundation 2026-05-26.*
