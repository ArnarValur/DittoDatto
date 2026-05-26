---
title: "Session 11: MercuryEngine Python Migration Grill"
type: "grill"
status: "complete"
date: "2026-05-05"
session: 11
participants:
  - "Captain Arnar"
  - "Cmdr Opus (Antigravity)"
  - "SDB Agent"
domain: "MercuryEngine"
tags:
  - "python"
  - "fastapi"
  - "migration"
  - "grill"
---

# Session 11: MercuryEngine Python Migration Grill

---

## Decision Register

| # | Question | Decision |
|---|---|---|
| GQ1 | Go/No-Go — migrate now? | ✅ Yes. TypeScript is out of the platform stack entirely. No point abstracting in a language we're leaving. |
| GQ2 | Framework — FastAPI or alternative? | ✅ FastAPI. Pydantic-native, auto-generates OpenAPI, async-first, Python ecosystem standard. ADK for agents (separate layer). |
| GQ3 | Migration strategy — big bang or incremental? | ✅ Big bang rewrite. 3K LOC + 156 tests as spec. Port tests first (pytest), then code until green. |
| GQ4 | Client contracts — Nuxt/Flutter impact? | ✅ Nuxt apps stay on Firebase staging untouched. Flutter built against new FastAPI engine on Saturn. OpenAPI spec serves Flutter clients. |
| GQ5 | Shared types — what happens to Zod? | ✅ `shared-types/` stays frozen as Chapter 1 reference. Pydantic models become the living source of truth. |
| GQ6 | Agent integration — in-process or inter-service? | ✅ Shared library for code, separate connections for data. `mercury-core` is a Python package; FastAPI/Datto/Ditto each import it, each creates own SurrealDB session with appropriate credentials. |
| GQ7 | Test migration — 156 vitest → what? | ✅ pytest + pytest-asyncio + httpx. Tests ported first as migration specification. |
| GQ8 | Auth — Firebase Auth stays or goes? | ✅ Firebase Auth stays as interim. SurrealDB auth evaluation parked for future PoC (Saturn). |
| GQ9 | Deployment — where does V2 run? | ✅ Pluto now (Docker alongside SurrealDB dome), Saturn when it arrives. Cloud Run for production TBD. Saturn = dev/staging ONLY. |
| GQ10 | Sequencing — roadmap impact? | ✅ 4-session arc: 12 (scaffold) → 13 (core port) → 14 (SurrealDB data layer) → 15 (routes + integration). |

---

## Key Architectural Decisions

### TypeScript is a Chapter 1 Artifact

Captain's definitive statement: *"TypeScript is out of the picture completely. I don't like it anymore if it only brings overhead and extra layers."*

This is not just about MercuryEngine — it's a platform-level language decision. Python is the unified backend language for:
- MercuryEngine V2 (FastAPI)
- Ditto agent (ADK)
- Datto agent (ADK)
- SurrealDB integration (native Pydantic support)

### The Convergence Stack

```
SurrealDB  ──→ native Pydantic support (pip install surrealdb[pydantic])
ADK        ──→ Pydantic as core dependency (google-adk)
FastAPI    ──→ built on Pydantic
Pydantic AI──→ MCP + A2A support for agent interop
```

One language. One validation framework. No tvíverknað.

### Triple → Double Representation

| Before (TS + Python agents) | After (unified Python) |
|---|---|
| `.surql` + Zod + Pydantic = 3 | `.surql` + Pydantic = 2 |
| 24 schemas × 3 = maintenance hell | 24 schemas × 2 = manageable |

### Shared Library Architecture (GQ6)

```
mercury-core/          ← Pure domain logic + Pydantic models
├── Used by: FastAPI   ← REST API shell (own SurrealDB session)
├── Used by: Datto     ← ADK agent (own SurrealDB session, company-scoped)
└── Used by: Ditto     ← ADK agent (own SurrealDB session, discovery-scoped)
```

SDB agent confirmed: different credentials = separate SurrealDB connections. Shared code, separate pipes.

### No Migration Risk

- Nothing is in production. Firebase staging stays untouched.
- MercuryEngine V2 is born on new infrastructure (Pluto → Saturn).
- No cutover. No downtime. No traffic to protect.
- 156 tests = migration specification.

---

## SDB Agent Consultations

### Consultation 1: SDK Maturity & Pydantic Integration (Morning Session)

Five questions relayed. Key findings:
1. TS SDK more mature, Python SDK stable and feature-complete
2. Pydantic integration goes beyond RecordID — recursive models ergonomic for graph traversal
3. No codegen exists in either direction (`.surql` → Zod or `.surql` → Pydantic)
4. Shared runtime = unified models, shared pool, no serialization overhead

### Consultation 2: Connection Management (Grill Session)

Question: Should agents and API share SurrealDB connection pools?

Answer: 
- Same credentials → can share connection pool
- Different credentials/roles/scopes → **must use separate connections**
- Auth is tied to SurrealDB session, not individual queries
- Idiom: one client per authentication context

This aligns with the titan/enceladus namespace design (Session 8):
- API mediates both namespaces (service credentials)
- Datto scoped to company DB in titan (agent credentials)  
- Ditto reads discovery + users (consumer credentials)

### Consultation 3: SurrealDB Auth Capabilities (Informational)

SDB agent provided full auth capability summary:
- Record-based auth with custom SIGNUP/SIGNIN procedures
- Native JWT support (issuing + verifying)
- Field-level and row-level permissions
- No built-in social login — custom implementation needed
- **Parked for future auth PoC session**

---

## Updated Session Roadmap

| Session | Focus | Status |
|---|---|---|
| 1–10 | Domain Model → PRD → SurrealDB Schema | ✅ All complete |
| **11** | **Python Migration Grill** | ✅ **Complete (this session)** |
| **12** | **MercuryEngine V2 Foundation** — Python scaffolding, FastAPI skeleton, Pydantic models, pytest | `[ ]` Next |
| **13** | **Core Logic Port** — Pure functions + tests (calculators, availability, holds) | `[ ]` Blocked by 12 |
| **14** | **SurrealDB Data Layer** — Repository against SurrealDB (replaces Firestore) | `[ ]` Blocked by 13 |
| **15** | **Routes + Integration** — FastAPI endpoints, auth middleware, E2E | `[ ]` Blocked by 14 |
| TBD | Auth Architecture Grill (BankID/Vipps + SurrealDB auth) | `[ ]` Can run in parallel |

---

*Created: 2026-05-05 — Grill session with Captain Arnar*  
*Decision status: All 10 questions locked*
