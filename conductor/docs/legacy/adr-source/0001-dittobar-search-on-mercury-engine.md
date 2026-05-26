---
title: "ADR-0001: DittoBar Search on MercuryEngine"
type: "adr"
status: "superseded"
superseded_by: "ADR-0007"
date: "2026-05-02"
session: 1
domain: "Discovery"
tags:
  - "dittobar"
  - "search"
  - "mercury-engine"
---

# ~~DittoBar search lives on MercuryEngine, not client-side~~

The Nuxt prototype used client-side fuzzy matching (loading all stores into memory and filtering with `.includes()`). For the Flutter rebuild, DittoBar search will be a MercuryEngine REST endpoint instead.

**Why not client-side fuzzy?** It would work for 20-50 stores in Drammen, but DittoBar is a future agentic component — Ditto agents will use the same search interface. Building client-side now means rebuilding server-side later (tvíverknað). With Saturn (GX10) arriving for dev infrastructure, there's no reason to build in clay when porcelain is available.

**Why use MercuryEngine?** The engine already has access to all company, store, and service data. The search endpoint can evolve from keyword matching → vector/semantic search without changing the Flutter client contract. The analytics pipeline (Search Events, Zero-Result Signals) logs at the engine level, giving richer data (e.g., availability-aware search results).

## Considered Options

- **Client-side fuzzy** — fast to ship, works offline, but doesn't scale and requires rewrite for agentic use
- **Standalone Cloud Function** — possible, but fragments the API surface away from MercuryEngine
- **MercuryEngine endpoint** ✅ — single API surface, engine has the data, scales with Saturn compute

## Consequences

- Flutter v1 DittoBar requires MercuryEngine to be reachable (no offline search)
- MercuryEngine needs a new search endpoint — to be designed during the engine PRD grilling session
- SearchAnalytics dashboard can query the engine directly instead of reading raw Firestore events
