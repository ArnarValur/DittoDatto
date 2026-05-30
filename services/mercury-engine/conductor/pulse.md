# Pulse — MercuryEngine Scoped State

**Last Updated:** 2026-05-29 12:15
**Session Focus:** Greenfield Booking Engine 1.0 Completed & Validated!

## 🚀 Active Tracks

- **mercury_migration_20260528** — Greenfield build of MercuryEngine 1.0 booking engine with TDD. [Link](./tracks/mercury_migration_20260528/) — **100% Completed & Verified (checkpoint: aabeb1e)**.

## ✅ Recently Completed

- **2026-05-29** — **Phases 2-5 Completed.** Delivered base Pydantic v2 domain schemas, pure Time Tetris shift/slot/hold calculators, SurrealDB 3.0 data repositories, and FastAPI endpoints (/availability, /availability/probe, /holds, /bookings/confirm, /bookings/{id}/cancel, /bookings/{id}/reschedule) with Norwegian Forbrukstilsynet compliance.
- **2026-05-29** — **Verification Suite Green.** 50/50 tests passing with 91% code coverage (95% on slot/shift/hold calculators), 100% Ruff-clean formatting, and clean wheel/tar compilation via `uv build`.
- **2026-05-28** — **Phase 1: Environment & FastAPI Foundation completed.** Created `pyproject.toml`, `main.py`, and `api/auth.py` validation dependencies under TDD (11/11 tests passing, 100% test coverage).
- **2026-05-28** — **Grill: Booking engine foundation.** MercuryEngine identity sharpened. PRD written. 2 child ADRs recorded (0002: booking-only scope, 0003: clean-slate TDD). 3 parent ADR candidates + 4 glossary updates queued in relay.
- **2026-05-28** — **Child conductor workflows deployed.** `.agents/workflows/` with `conductor-child.md`, `checkpoint.md`, `new-track.md`.
- **2026-05-28** — **Agent-rules installed.** Clean Architecture, Refactoring, Release It!, DDD Distilled.
- **2026-05-28** — **Linked Child Conductor established.** `services/mercury-engine/conductor/` with parent-linked index.

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- **Project Scope:** MercuryEngine 1.0 — booking engine only (Standard, Reservation, Ticket verticals). No entity CRUD, no discovery, no auth issuance, no admin.
- **Versioning:** 1.x.x (no "V2" — clean versioning base).
- **Parent Links:** Glossaries, global ADRs, and PRD read from parent `conductor/`. Domain terms discovered in ME work are relayed to parent via `relay.md`.
- **Workflow:** Strict TDD (Red → Green → Refactor) using `uv` and `pytest`. Clean-slate tests — no legacy porting.
- **Target environment:** local Docker dev DB → Saturn staging DB → Cloud Run production.
- *2026-05-29* — Self-healing event loop connection checker guarantees connection robustness under multi-threaded tests. _(operational)_
- *2026-05-29* — Norwegian compliance requires Cancellation (reason: Rescheduled) + Rebooking, creating an audit trail of old-to-new and new-from-old links. _(critical constraint)_
- *2026-05-28* — Agent-rules for child: Release It!, Clean Architecture, Refactoring, DDD Distilled. _(operational)_
- *2026-05-28* — Auth boundary settled: ME validates JWTs only. SurrealDB native auth for internal tools. Vipps OIDC is public/portal concern only. _(architectural — queued as parent ADR candidate)_
- *2026-05-28* — Company Management extracted as separate bounded context. Datto's domain. SurrealDB is the integration point. _(architectural — queued as parent ADR candidate)_
- *2026-05-28* — Shared kernel for entity models (Establishment, Service, Staff, etc.) — extract to read-only projections when Datto evolves the schema. _(operational)_
- *2026-05-28* — Single package, layered modules: `mercury_engine/domain/`, `mercury_engine/api/`, `mercury_engine/infra/`. _(architectural)_
- *2026-05-28* — Payment: MockPaymentGateway for 1.0, VippsPaymentGateway for 1.3. _(operational)_
- *2026-05-28* — Fiscal immutability: append-only booking records. Reschedule = cancel + rebook. Norwegian Forbrukstilsynet compliance. _(critical constraint)_

## 📋 Next Session Suggestions

1. 🔗 **Sync Parent Conductor** — Re-engage with the parent DittoDatto conductor to process the relay queue (3 platform ADR candidates + 4 glossary updates).
2. 🛠️ **Resume Admin Panel Build** — Return to DittoDatto Admin Panel implementation now that the core Booking Engine API is fully locked and available.
