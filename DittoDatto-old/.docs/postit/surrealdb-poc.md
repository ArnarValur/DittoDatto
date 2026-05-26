---
title: "PostIT: SurrealDB PoC on Pluto"
type: "postit"
status: "complete"
date: "2026-05-02"
completed: "2026-05-03"
session:
  - 4
  - 8
  - 9
  - 10
domain: "Infrastructure"
tags:
  - "surrealdb"
  - "poc"
  - "pluto"
---

# PostIt: SurrealDB PoC on Pluto

## Context

During the TheOracle grill session (Session 4), SurrealDB 3.0 was identified as the unified graph+search+geo+vector database for TheOracle. This PoC proves the concept before Saturn deployment.

## Scope

### Phase 1: Install & Boot (30 min)
- Docker container on `merkurial-networks`, port 8001
- Data persisted to `/media/addinator/Mercury/Domes/SurrealDB/data`
- Verify with Surrealist web UI

### Phase 2: Model the Graph (90 min)
- 5 node tables: `establishment`, `category`, `area`, `service_type`, `search_event`
- 4 edge tables: `belongs_to`, `located_in`, `offers`, `near`
- Seed with 5 establishments across Drammen + Mjøndalen
- Test queries: text search, geo search, combined text+geo, graph traversal, demand signals

### Phase 3: TheOracle API Skeleton (90 min)
- Hono server (`packages/the-oracle/`)
- 4 endpoints: `GET /search`, `GET /establishments/:id`, `GET /categories`, `POST /search-events`
- SurrealDB JavaScript SDK
- Full DittoBar flow simulation

## What It Proves

| Question | Success Criteria |
|----------|-----------------|
| Can SurrealDB model our domain graph? | Nodes + edges + traversals work |
| Can it handle DittoBar queries? | Text + geo combined, <100ms |
| Does the JS SDK work with Hono? | TheOracle serves results |
| Does SurrealQL feel natural? | DX assessment |

## What It Does NOT Do

- Migrate MercuryEngine (stays on Firestore)
- Firebase Auth integration (JWT validation comes later)
- Flutter client code (API-first)
- Vector/semantic search (needs Saturn GPU)
- Firestore sync triggers (after PoC validates SurrealDB)

## Full Plan

See implementation plan from Session 4 grill (filed in Antigravity brain).

## References

- [ADR-0007: TheOracle Discovery Service](../adr/0007-dittobar-search-on-theoracle.md)
- [SurrealDB GitHub](https://github.com/surrealdb/surrealdb)
- [SurrealDB 3.0 Intro](https://youtu.be/USg8ZQC5mQc)
