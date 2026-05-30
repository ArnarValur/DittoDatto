# Tracks Registry — MercuryEngine

All tracks organized by domain. Each track links to its dedicated folder.

---

## 🗂️ Domain Structure

| Domain | Path | Caution Level | Notes |
|---|---|---|---|
| **Core Models** | `src/mercury_core/models/` | 🔴 Critical | Base domain models, Pydantic v2. |
| **Availability / Slots** | `src/mercury_core/calculators/` | 🔴 Critical | Time Tetris availability calculators. |
| **Data Repositories** | `src/mercury_core/repositories/` | 🔴 Critical | SurrealDB 3.0 dual-namespace data adaptors. |
| **API Endpoints & Auth** | `src/mercury_engine/` | 🔴 Critical | FastAPI endpoints and JWT security checks. |

---

## Active Tracks

- [~] **MercuryEngine 1.0 Booking Engine Greenfield — Greenfield TDD implementation**
  - *Type:* feature | *Domain:* core-booking-engine | *Status:* in-progress
  - *Link:* [tracks/mercury_migration_20260528/](./tracks/mercury_migration_20260528/)
  - *Phases:* 5 — (1) Environment & FastAPI foundation, (2) Base models & shared kernel projections, (3) Time Tetris & availability engine, (4) SurrealDB 3.0 & repository integration, (5) Route implementation & lifecycle verification.

---

## Completed Tracks

_None yet._
