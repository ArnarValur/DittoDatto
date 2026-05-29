# Product Guide: DittoDatto.no

> **Chapter 2** — Flutter-first, Python-powered, SurrealDB-backed.
> For Chapter 1 sprint history, see [archive/chapter1/product.md](./archive/chapter1/product.md).

## Concept

DittoDatto.no is a multi-agentic service booking platform designed to revolutionize how people find and book local services in Norway. The startup is based in Drammen, Norway. The platform aims to scale nationally, becoming the go-to solution for locals, tourists, and businesses alike.

## Vision

To be the premier service discovery and booking platform in Norway, leveraging advanced AI agents ("Ditto" for users, "Datto" for businesses) to simplify complex interactions. The platform seeks to empower marginal groups and tourists through accessible interfaces while providing powerful management tools for local businesses.

## Version Roadmap

| Version | Focus | Status |
|---------|-------|--------|
| **v1.0** | Core tracer bullet (Auth+BankID, Home+Map+DittoBar, Browse, Book, My Bookings) | `[ ]` PRD drafted |
| **v1.1** | Stickiness (Favorites, profile polish) | `[ ]` Not started |
| **v1.2** | Restaurant vertical (Table reservations) | `[ ]` Not started |
| **v1.3** | Payment (Vipps) | `[ ]` Not started |
| **v1.4** | Comms layer (Messages, notifications — Ditto↔Datto neural foundation) | `[ ]` Not started |
| **v1.5** | Agentic path (Ditto agent interface, voice/text, Saturn-powered) | `[ ]` Not started |

## Architecture

```
Clients (Flutter iOS/Android, Business Portal, Ditto/Datto agents)
    ↓ (REST API)
MercuryEngine (FastAPI / Python / Pydantic)
    ↓ (SurrealDB Python SDK)
SurrealDB 3.0
    ├── titan/company_{slug}    ← Per-company data (booking, staff, services)
    ├── titan/discovery         ← Public aggregator (DittoBar, search events)
    ├── titan/platform          ← Company registry, system alerts
    └── enceladus/users         ← GDPR-isolated consumer PII
```

### Key Technical Components

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **MercuryEngine** | FastAPI + Pydantic + uv | Unified API: booking + discovery + CRUD |
| **SurrealDB 3.0** | Docker (Pluto → Saturn) | Sole platform database — graph, search, geo, vector |
| **Flutter App** | Dart + Riverpod + GoRouter | Consumer marketplace (iOS + Android) |
| **Auth** | SurrealDB native auth + BankID/Vipps OIDC | Three-tier: public, auth, operator (ADR-0010) |

## Deep Dive Features

### 1. The "Time Tetris" Algorithm

- **Logic:** A robust availability calculation engine that handles recurrence, staff priorities, and resource allocation.
- **Key:** Maps "Minutes from Midnight" to solve the "Can I book?" question in <200ms.
- **Implementation:** `mercury_core.calculators.slots` — pure Python, 197 unit tests.

### 2. Unified Discovery (ex-TheOracle)

- **Search:** SurrealDB BM25 full-text analyzers for "fix messy beard" → "Beard Trim".
- **Geo:** `geo::distance()` for "near me" queries with GeoJSON.
- **Vector:** HNSW indexes for semantic search when Ditto agents need fuzzy matching.
- **Demand Signals:** `search_event` table captures shadow demand for business recruitment.

### 3. Multi-Tenant Security

- **Model:** Namespace isolation — `titan/company_{slug}` per business, `enceladus/users` for GDPR-isolated PII.
- **Auth Tiers:** `public` (no JWT) → `require_auth` (consumer) → `require_operator` (business owner/staff).
- **Company Guard:** Path parameter + JWT claim validation, SurrealDB `db.use()` per request.

## Target Audience

1. **Service Businesses:** From salons to clinics, starting in Drammen.
2. **Marginal Groups & Tourists:** Users benefiting from accessible, multi-language agentic interfaces.
3. **Norwegian General Public:** Locals seeking a modern, efficient booking experience.

---

*Rewritten for Chapter 2 — 2026-05-05*
