# Pulse — MercuryEngine Scoped State

**Last Updated:** 2026-05-28 14:52 (Project Initialization)
**Session Focus:** Scaffolding the Linked Child Conductor and establishing the V2 Migration Track.

## 🚀 Active Tracks

- **mercury_migration_20260528** — Core migration of legacy `mercury-engine-old` (377 tests) to the greenfield Pydantic v2/SurrealDB 3.0 workspace structure. [Link](./tracks/mercury_migration_20260528/) (planned)

## ✅ Recently Completed

- **2026-05-28** — **Linked Child Conductor established.** Built `/services/mercury-engine/conductor/` with parent-linked `index.md`, scoped Python TDD `workflow.md`, and direct links back to the main DittoDatto glossary (`context.md`) and global ADR ledger (`adr/`). Prevents glossary drift while isolating operational rules.

## ⚠️ Blockers

_None._

## 🧠 Session Memory

- **Project Scope:** `MercuryEngine V2` microservice.
- **Parent Links:** Glossaries, global ADRs, and high-level product requirements are read directly from the parent monorepo `conductor/` directory.
- **Workflow:** Strict TDD (Red -> Green -> Refactor) using `uv` and `pytest`.
- **Target environment:** local Docker dev DB -> Saturn staging DB -> Cloud Run production.

## 📋 Next Session Suggestions

1. 🟢 **Scaffold first migration track** — Create `tracks/mercury_migration_20260528/` with comprehensive phased plan to migrate core models and Time Tetris calculators.
2. **Phase 1: Setup & Health Checks** — Port pytest configurations, dependencies, and stand up simple route tests.
