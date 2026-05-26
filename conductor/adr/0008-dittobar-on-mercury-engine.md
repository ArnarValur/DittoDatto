# DittoBar Search on MercuryEngine

> **Recorded:** 2026-05-26 (promoted from legacy ADR-0001 Session 1; `superseded_by` reference stripped — legacy 0007 was a misunderstood concept never decided)
> **Status:** accepted

## Context

The Nuxt prototype used client-side fuzzy matching (loading all stores into memory and filtering with `.includes()`). For the Flutter rebuild, DittoBar search needs to scale beyond 20-50 stores and support agentic use cases (Ditto agents querying the same interface).

## Decision

**DittoBar search is a MercuryEngine REST endpoint.** Discovery routes live in `services/mercury-engine/` under `/discovery/*`. Search analytics (Search Events, Zero-Result Signals) are logged at the engine level for richer data (availability-aware search, demand intelligence).

## Why MercuryEngine

- The engine already has access to all company, store, and service data — no duplicate data layer required.
- A single API surface — Flutter clients + future Ditto agents call the same endpoint.
- The search endpoint can evolve from BM25 keyword matching → SurrealDB HNSW vector search → semantic search without changing the Flutter client contract.
- Search analytics flow into `companies/discovery.search_event`, feeding the Zero-Result Signal pipeline for B2B sales (Shadow Demand).

## Considered Options

| Option | Rejected because |
|---|---|
| Client-side fuzzy matching | Fast to ship; doesn't scale; rewrite required for agentic use. |
| Standalone microservice | Fragments the API surface; conflicts with the sole-MercuryEngine direction (ADR-0001 architecture). |
| MercuryEngine endpoint | Single API surface, engine has the data, scales with Saturn staging + Cloud Run prod. |

## Consequences

- Flutter v1 DittoBar requires MercuryEngine to be reachable (no offline search).
- MercuryEngine has a discovery endpoint surface — to be detailed in a future MercuryEngine track.
- SearchAnalytics dashboards query the engine directly (no raw event-store scraping).
- The legacy `0007-dittobar-search-on-theoracle.md` file in `conductor/docs/legacy/adr-source/` references a "TheOracle" concept that was never a real project decision — see /grill foundation 2026-05-26 transcript.

---

*Origin: Session 1 Grill — initial DittoBar architecture decision. Promoted into canonical conductor/adr/ with `superseded_by` reference stripped (legacy 0007 was a misunderstanding) during /grill foundation 2026-05-26.*
