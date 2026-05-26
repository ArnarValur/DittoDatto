---
title: "PostIT: MercuryEngine Python Migration Decision"
type: "postit"
status: "grilled-and-locked"
date: "2026-05-05"
session: 11
domain: "MercuryEngine"
tags:
  - "python"
  - "migration"
  - "decision"
---

# PostIt: MercuryEngine Python Migration Decision

---

## Context

During a strategic tooling exploration session, the following convergence was identified:

- **ADK (Google Agent Development Kit)** is the planned framework for Ditto/Datto agents → Python-only, Pydantic as core dependency
- **SurrealDB Python SDK** has native Pydantic support (`pip install surrealdb[pydantic]`)
- **Pydantic AI** (v1.89.1, May 2026) — type-safe agent framework with MCP + A2A support, built on Pydantic
- **Captain's stated tech preferences** — Python for backend services, FastAPI for lightweight HTTP services
- **MercuryEngine** is already undergoing a full data layer rewrite (Firestore → SurrealDB)

The question: If we're rewriting the data layer anyway, and the entire agent ecosystem (ADK, SurrealDB, Pydantic AI) converges on Python/Pydantic — is staying TypeScript accumulating technical debt?

---

## The Triple-Representation Problem

If MercuryEngine stays TypeScript and agents are Python:

| # | Format | Where | Purpose |
|---|---|---|---|
| 1 | `.surql` schemas | SurrealDB | Source of truth (written ✅) |
| 2 | Zod schemas (TypeScript) | MercuryEngine | API validation + types |
| 3 | Pydantic models (Python) | Ditto/Datto agents (ADK) | Agent tool validation + types |

**24+ schemas × 3 representations = maintenance burden.** Every field change, every new table, updated in three places.

With unified Python: `.surql` + Pydantic = **2 representations** (no codegen exists for either direction — confirmed by SDB agent).

---

## SDB Agent Consultation (A2A)

Five questions were relayed to the SurrealDB agent. Key findings:

1. **SDK Maturity:** TS SDK is more mature, gets features first. Python SDK is stable and feature-complete for most operations.
2. **Pydantic Integration:** Goes beyond RecordID serialization. Recursive Pydantic models are ergonomic for graph traversal results. No automatic graph-to-model mapping in either SDK.
3. **Graph Ergonomics:** Both SDKs return raw nested JSON/dict. Model mapping is manual regardless of language. Pydantic recursive models and TS types (with Surqlize) are roughly equivalent.
4. **Schema Sync:** **No codegen exists** in either direction (`.surql` → Zod or `.surql` → Pydantic). Manual sync is the standard.
5. **Agentic Layer:** *"If your AI agents are heavily integrated with your business logic and benefit from model sharing, a unified Python runtime is a strong choice."* Shared runtime = unified models, shared connection pool, no serialization overhead. Dual-stack = duplication + inter-service communication overhead + desync risk.

### SDB Agent's key quote:
> "Inter-service communication: Adds overhead (HTTP/gRPC/etc.) and potential for desync."

Ditto/Datto are heavily integrated with business logic (intelligent staff scoring, availability reasoning, conversational feature activation via AaaS model). They are extensions of MercuryEngine, not consumers of it.

---

## MercuryEngine Scope Analysis

| Layer | Files | Lines |
|---|---|---|
| **Engine src** | 24 files | **3,058 lines** |
| **Shared Types (Zod)** | — | **2,474 lines** |
| **Tests (vitest)** | — | **2,484 lines** |

### Largest files (the "brain"):
| File | Lines | Purpose |
|---|---|---|
| `booking.ts` | 390 | Receipt builder + cancellation |
| `hold.ts` | 314 | Hold allocation + creation |
| `availability-context.ts` | 246 | Pure context builder |
| `reservations/calculator.ts` | 209 | Table reservation slot calc |
| `reservations/availability.ts` | 205 | Restaurant availability |
| `reservations/booking.ts` | 184 | Reservation booking logic |

**Core domain logic:** ~1,000 lines of pure functions (Time Tetris, hold allocation, receipt building). The rest is routes (thin wrappers), data fetching (being replaced anyway), and config.

**Architecture advantage:** The engine follows "Pure Core, Thin Shell" — all business logic is in `core/` as pure functions with zero IO. This is the ideal architecture for porting: the pure functions translate almost 1:1 to Python.

**156 tests** serve as the migration specification — they define exactly what the Python version must do.

---

## The Convergence Argument

```
SurrealDB  ──→ native Pydantic support (pip install surrealdb[pydantic])
ADK        ──→ Pydantic as core dependency (google-adk)
FastAPI    ──→ built on Pydantic (Captain's stated preference)
Pydantic AI──→ MCP + A2A support for agent interop
Captain    ──→ "Python for backend services, FastAPI for lightweight HTTP"
Engine     ──→ 3K lines, pure-core architecture (portable)
Tests      ──→ 156 tests = migration specification
No tvíverknað ──→ one language, one validation framework
```

### Counter-arguments considered:
| Argument | Assessment |
|---|---|
| "It's working code" | Working code that talks to Firestore — data layer is being rewritten anyway |
| "Rewriting introduces bugs" | 156 tests define the spec; Antigravity Business Ultra quota is untouched |
| "TS runs servers too" | True, but adds a second language to the platform with no strategic benefit |
| "Hono is lean" | So is FastAPI — and FastAPI auto-generates OpenAPI docs from Pydantic models |

---

## Recommendation

**Migrate MercuryEngine to Python/FastAPI/Pydantic** during the SurrealDB migration (Sessions 12–13).

### Rationale:
1. The data layer rewrite is already scoped — the incremental cost of changing language is bounded
2. The entire agent ecosystem (ADK, SurrealDB, Pydantic AI) converges on Python/Pydantic
3. Unified runtime eliminates inter-service overhead for Ditto/Datto integration
4. Reduces schema representations from 3 to 2 (no codegen exists, so fewer = less debt)
5. Aligns with Captain's stated technology preferences
6. Engine is small (3K LOC) with pure-core architecture — ideal for porting

### What changes in the WAYMAP:
- **Session 11** (Auth Grill) — unchanged, auth decisions are language-agnostic
- **Session 12** (Repository Interface) — becomes "MercuryEngine Python Migration" 
- **Session 13** (Issues) — adjusted to reflect Python stack
- **Saturn deployment** — one Python service instead of TS + Python

### Prerequisite:
A formal grill session to lock this decision before any code changes.

---

## Framework Landscape Reference

### Pydantic (v2.13.3, April 2026)
- Python data validation library (equivalent of Zod for TypeScript)
- pydantic-core merged into main repo, Python 3.14 support
- Polymorphic serialization, computed field `exclude_if`, `ascii_only` strings

### Pydantic AI (v1.89.1, May 2026)
- Agent framework — "FastAPI for agents"
- Type-safe structured outputs, function tools, dependency injection
- Native MCP support (MCPServerStdio + MCPServerHTTP)
- A2A protocol support (`to_a2a()`)
- Model-agnostic (OpenAI, Anthropic, Gemini, Ollama, etc.)
- Logfire integration (OpenTelemetry tracing)
- Relevant for Ditto/Datto at v1.5, but ADK is the primary agent framework

### Google ADK (Agent Development Kit)
- Google's open-source Python agent framework
- Pydantic as core dependency for schemas, tool signatures, structured outputs
- Workflow agents (sequential, parallel, loop) + AgentTeam API
- Model-agnostic (optimized for Gemini/Vertex AI, supports LiteLLM)
- CLI (`adk`) + visual dev UI for testing/debugging
- Deploys to Cloud Run, Vertex AI Agent Engine
- **This is the planned framework for Ditto and Datto**

### Comparison (for reference):

| | LangGraph | CrewAI | Pydantic AI | ADK |
|---|---|---|---|---|
| **Philosophy** | Explicit graph orchestration | Role-based agent teams | Type-safe "FastAPI-style" | Code-first, production-grade |
| **Best for** | Complex stateful workflows | Rapid prototyping | Strict correctness + DX | Google ecosystem, multi-agent |
| **Trade-off** | High complexity | Less deterministic | Multi-agent is newer | Google-optimized |

---

*Created: 2026-05-05 — Morning strategic exploration session*  
*Decision status: Pending formal grill*
