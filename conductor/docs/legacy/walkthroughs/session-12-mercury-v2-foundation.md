---
title: "Session 12: MercuryEngine V2 Foundation"
session: 12
date: 2026-05-05
type: execution
domain: MercuryEngine
participants:
  - Captain Arnar
  - Cmdr Opus (Antigravity)
model: Claude Opus 4.6 (Thinking)
tags:
  - python
  - fastapi
  - pydantic
  - scaffolding
  - chapter-2
status: complete
---

# Session 12 Walkthrough: MercuryEngine V2 Foundation

---

## What Was Done

### Phase 1: Root Cleanup

Moved 15 Node.js/Firebase files to `_chapter1/`, deleted `node_modules/` and log files, updated `.gitignore` with Python patterns.

**Root before:** 22 files + 16 dirs (cluttered with TS/Firebase configs)
**Root after:** 2 files + 15 dirs (clean, organized by purpose)

### Phase 2: Python Project Scaffold

Created `services/mercury-engine/` via `uv init --package`. Configured `pyproject.toml` with:
- **Runtime:** `fastapi[standard]`, `pydantic>=2`, `pydantic-settings`
- **Dev:** `pytest`, `pytest-asyncio`, `httpx`, `ruff`
- **Tools:** Ruff (py311 target, isort + UP + B + SIM rules), pytest (auto async mode)

49 packages installed in 489ms.

### Phase 3: Pydantic Models (from `.surql` schemas)

All 7 core tables from `schemas/company-blueprint.surql` ported:

| Model | Fields | Key Features |
|-------|--------|-------------|
| `Establishment` | ~30 | Embedded BookingPolicy, OpeningSchedule, ReservationConfig |
| `Service` | ~20 | BookingMode enum (ADR-0004), AI/embedding fields |
| `Staff` | ~18 | Embedded WeeklyShifts, multi-store assignment |
| `Booking` | ~22 | Fiscal snapshot (Norwegian law), user snapshot, multi-service items |
| `Hold` | ~10 | TTL-managed, Vipps payment fields |
| `Resource` / `ResourceGroup` | ~12 | Best-fit allocation support |
| `Customer` | ~14 | Cross-DB projection, CRM metrics |

Plus: 18 `StrEnum` types, 9 embedded sub-models, `MercuryModel` base class.

### Phase 4: FastAPI Skeleton

- App factory pattern (`create_app()`) for testability
- CORS middleware (same origins as V1)
- `MercuryError` → JSON response error handler
- `GET /health` → `{"status": "ok", "version": "2.0.0-alpha"}`
- Pydantic Settings with `MERCURY_` env prefix

### Phase 5: Domain Errors

7-class error hierarchy: `MercuryError` base → `NotFoundError`, `ConflictError`, `ValidationError`, `UnauthorizedError`, `ForbiddenError`, `SlotUnavailableError`, `PolicyViolationError`

---

## Verification Results

```
18 passed in 0.09s
```

- **14 model tests:** Construction, default values, enum serialization, embedded objects, JSON round-trip
- **4 API tests:** Health check shape, root endpoint, error handler, error details propagation
- **Lint:** `ruff check` — all checks passed
- **Dev server:** `uvicorn` starts, `GET /health` returns 200

---

## Decisions Made During Session

| Decision | Rationale |
|----------|-----------|
| `services/` top-level directory | Python services separated from Node.js `packages/`. Agnostic — no build tool dictates structure. |
| Two-package architecture | `mercury_core` (shared library) + `mercury_engine` (FastAPI shell). Agents import core, not the API. |
| `_chapter1/` archive | Root cleanup without losing reference. Node.js cruft accessible if needed. |
| `uv` as package manager | Already on Pluto, standard `pyproject.toml`, 10-100x faster than pip, no lock-in. |
| One git repo, no submodules | Simplicity for a solo-with-AI team. One log, one branch, one PR. |
| No premature dependencies | `surrealdb` and `python-dateutil` deferred to Sessions 14 and 13 respectively. |

---

## Files Changed

### New Files (22)

```
services/mercury-engine/
├── pyproject.toml, uv.lock, .python-version, README.md, Dockerfile
├── src/mercury_core/__init__.py, errors.py
├── src/mercury_core/models/__init__.py, common.py, establishment.py,
│   service.py, staff.py, booking.py, hold.py, resource.py, customer.py
├── src/mercury_engine/__init__.py, main.py, config.py
├── src/mercury_engine/routes/__init__.py, health.py
└── tests/__init__.py, conftest.py, test_health.py,
    models/__init__.py, models/test_models.py
```

### Modified Files (1)

- `.gitignore` — Added Python section, updated header for Chapter 2

### Moved to `_chapter1/` (15 files)

- Node.js: `package.json`, `package-lock.json`, `turbo.json`
- Firebase: `firebase.json`, `.firebaserc`, `firestore.rules`, `firestore.indexes.json`, `storage.rules`
- Docker: `Dockerfile.emulator`, `Dockerfile.mercury-engine`, `Dockerfile.mercury-engine.dev`, `Dockerfile.web`
- Other: `.nuxtrc`, `deploy.sh`, `docker-compose.yml`, `.dockerignore`

### Deleted

- `node_modules/`, `firebase-debug.log`, `firestore-debug.log`

---

*Next: Session 13 — Core Logic Port (156 tests, pure functions, TDD in reverse)*
