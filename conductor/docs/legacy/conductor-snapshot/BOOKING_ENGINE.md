# 🔴 MercuryEngine — Booking Engine Safety Manual

> **Caution Level: 🔴 CRITICAL**
> This engine handles real money, real time slots, and real customer trust.
> A bug here = failed bookings, lost revenue, angry customers.

> For the V1 TypeScript/Firestore safety manual, see [archive/chapter1/BOOKING_ENGINE.md](./archive/chapter1/BOOKING_ENGINE.md).

---

## Architecture Overview

```
Flutter App / Business Portal / Ditto Agent
  → FastAPI Routes (mercury_engine.routes)
    → Pure Calculators (mercury_core.calculators)
    → Repository Adapters (mercury_core.repositories)
      → SurrealDB (titan/company_{slug})
```

### Package Structure

| Package | Path | Purpose | Risk Level |
|---------|------|---------|------------|
| `mercury_core` | `services/mercury-engine/src/mercury_core/` | Pydantic models + pure domain logic | 🔴 Critical |
| `mercury_engine` | `services/mercury-engine/src/mercury_engine/` | FastAPI routes + DI + config | 🟡 High |

### Key Modules

| Module | Purpose | Risk Level |
|--------|---------|------------|
| `calculators/booking.py` | Hold → Booking conversion | 🔴 Critical |
| `calculators/hold.py` | Slot locking with TTL | 🔴 Critical |
| `calculators/slots.py` | Time Tetris — available slot calculation | 🔴 Critical |
| `calculators/reservations.py` | Table/resource reservation logic | 🔴 Critical |
| `availability/staff.py` | Staff schedule filtering | 🟡 High |
| `availability/resources.py` | Resource allocation | 🟡 High |
| `repositories/` | SurrealDB adapter layer (10 repos) | 🟡 High |
| `routes/` | FastAPI endpoints + DI wiring | 🟡 High |

### Documentation Hub

Full engine documentation lives at [`.docs/engine/`](../.docs/engine/README.md):

| Doc | Content |
|-----|---------|
| [architecture.md](../.docs/engine/architecture.md) | Full system architecture |
| [time-tetris.md](../.docs/engine/time-tetris.md) | Slot calculation algorithm |
| [booking-flow.md](../.docs/engine/booking-flow.md) | Hold → Booking lifecycle |
| [api-contract.md](../.docs/engine/api-contract.md) | REST API specification |
| [known-issues.md](../.docs/engine/known-issues.md) | Known issues + gotchas |

---

## Invariants (NEVER Break These)

### 1. Pydantic models are the source of truth

All domain objects are Pydantic `BaseModel` subclasses with strict validation. Never bypass Pydantic for raw dicts.

### 2. Holds must expire

Every hold has a TTL via `expires_at`. Both the slot calculator and hold creator must respect this:
- Slot calculator filters expired holds from occupied slots
- Hold creation overwrites expired holds on conflict

### 3. Booking creation is atomic

Hold → Booking conversion runs as a SurrealDB transaction:
- Read hold → Validate → Create booking → Delete hold
- If anything fails, nothing is written (transaction rollback)

### 4. Calculators are pure functions

`mercury_core.calculators.*` modules contain **zero** database calls. They accept data, return results. All I/O goes through repository interfaces.

### 5. Record links require explicit conversion

SurrealDB `record<T>` fields need `to_record_id()` conversion when used as query bindings. Raw strings don't match record types. See Session 15 bug log.

### 6. Datetime serialization uses Python mode

`model_to_record()` must use `mode="python"` (not `mode="json"`) to preserve native datetime objects for SurrealDB.

---

## Before You Change Anything

### Mandatory Checklist

- [ ] Read this document
- [ ] Understand which invariant your change touches
- [ ] Write or update tests BEFORE changing logic
- [ ] Run `uv run pytest` — all 224 tests must pass
- [ ] Run `uv run ruff check .` — lint must be clean

### Testing Commands

```bash
cd services/mercury-engine

# Run all tests
uv run pytest

# Run unit tests only
uv run pytest tests/unit/

# Run integration tests (requires SurrealDB running)
uv run pytest tests/integration/

# Lint
uv run ruff check .
```

---

## Known Gotchas (V2-Specific)

| Gotcha | Details |
|--------|---------|
| **`mode="json"` kills datetimes** | `model_to_record()` with `mode="json"` serializes datetimes to strings — SurrealDB rejects them. Use `mode="python"`. |
| **RecordID bindings** | String values don't match `record<T>` fields in SurrealQL. Must wrap with `to_record_id()`. |
| **Nested list recursion** | `_stringify_record_ids()` must recurse into list items that are dicts. Fixed in Session 15. |
| **Plural vs singular fields** | `hold.services` (plural, array) not `hold.service`. Check model definitions. |
| **Embedded record links** | Booking items contain embedded `service` record links that need conversion. See `EMBEDDED_RECORD_LINK_FIELDS`. |

---

## Post-Incident Log (V2)

| Date | Bug | Root Cause | Fix |
|------|-----|-----------|-----|
| 2026-05-05 | Datetime fields rejected by SurrealDB | `model_to_record(mode="json")` stringified datetimes | Switched to `mode="python"` |
| 2026-05-05 | Record link queries return empty | String bindings don't match `record<T>` | Added `to_record_id()` helper |
| 2026-05-05 | Nested dicts in lists not converted | `_stringify_record_ids()` skipped list items | Added `_stringify_list_item()` |
| 2026-05-05 | Hold creation fails on `services` | Model has `services` (plural), mapping said `service` | Fixed link registry |
| 2026-05-05 | Booking items missing service link | Embedded record links not converted | Added `EMBEDDED_RECORD_LINK_FIELDS` |

---

_Rewritten for MercuryEngine (Python/FastAPI/SurrealDB) — 2026-05-05_
