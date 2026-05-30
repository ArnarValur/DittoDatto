# 🚀 MercuryEngine

> Booking engine for the DittoDatto platform.  
> **Stack:** Python · FastAPI · Pydantic · SurrealDB

**Version:** 2.0.0-alpha  
**Runtime:** Python ≥3.11, FastAPI + Uvicorn  
**Port:** 5002  

## Quick Start

```bash
# Install dependencies
uv sync

# Run dev server (auto-reload)
uv run uvicorn mercury_engine.main:app --reload --port 5002

# Run tests
uv run pytest -v

# Lint & format
uv run ruff check src/ tests/
uv run ruff format src/ tests/
```

## Architecture

```
src/
├── mercury_core/        ← Shared domain library (models + errors + pure logic)
│   ├── models/          ← Pydantic v2 models (source of truth)
│   └── errors.py        ← Domain error hierarchy
│
└── mercury_engine/      ← FastAPI application shell
    ├── main.py          ← App factory + middleware
    ├── config.py        ← Pydantic Settings (fail-fast env)
    └── routes/          ← HTTP endpoints
```

**Two packages, one project:**
- `mercury_core` is imported by FastAPI, Ditto agent, and Datto agent
- `mercury_engine` is the REST API shell — thin, no business logic

## V1 → V2 Migration

| V1 (TypeScript) | V2 (Python) |
|-----------------|-------------|
| Hono | FastAPI |
| Zod | Pydantic |
| Vitest | pytest |
| date-fns | python-dateutil |
| firebase-admin | surrealdb |
| env.ts (Zod) | config.py (Pydantic Settings) |

## Related Docs

- [Engine Bookshelf](../../.docs/engine/README.md) — V1 architecture & API reference
- [SurrealDB Schemas](../../schemas/) — Database schema definitions
- [Session 11 Grill](../../.docs/grill/session-11-python-migration-grill.md) — Migration decisions

---

*MercuryEngine — Session 12 (2026-05-05)*
