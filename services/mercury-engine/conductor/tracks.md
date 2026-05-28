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

- [ ] **MercuryEngine V2 Migration — Complete TDD port of legacy engine**
  - *Type:* feature | *Domain:* core-migration | *Status:* new
  - *Link:* [tracks/mercury_migration_20260528/](./tracks/mercury_migration_20260528/)
  - *Phases:* 5 — (1) Environment & health endpoint, (2) Base models & serializations, (3) Time Tetris & availability, (4) SurrealDB 3.0 repositories, (5) Route implementations & integration check.

---

## Completed Tracks

_None yet._
