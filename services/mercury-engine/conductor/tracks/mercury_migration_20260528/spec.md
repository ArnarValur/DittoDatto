# Specification — MercuryEngine 1.0 Greenfield Booking Engine (`mercury_migration_20260528`)

## Overview

This track governs the greenfield, TDD-first construction of **MercuryEngine 1.0** — the dedicated booking engine microservice for DittoDatto. It focuses exclusively on the core **Hold → Pay → Confirm** lifecycle for the Standard Booking (appointments) vertical and the pure-function **Time Tetris** availability calculations.

All features are designed under DDD first principles, clean-slate TDD (ADR 0003), and strict bounded context separation (ADR 0002).

---

## Bounded Context Boundaries

### In Scope — MercuryEngine 1.0
1. **JWT Validation Middleware:** 5-tier access guard (`public`, `require_auth`, `require_operator`, `require_admin`, `require_super_admin`). Validates tokens, does not issue them.
2. **Shared Kernel Projections:** Read-only entity models (Establishment, Service, StaffMember, Resource, Schedule) representing company data stored in SurrealDB `companies/{slug}` namespace.
3. **Writeable Booking Models:** Models for booking state (Hold, Booking, Customer, User).
4. **Time Tetris Availability Engine:** Pure-function calculation of free time slots and staff assignment without database side-effects.
5. **AvailabilityProbe:** Read-only exploratory queries supporting agentic scheduling without creating slot-locking holds.
6. **Payment Interface:** Swappable payment gateway mapping (MockPaymentGateway for 1.0, swapped to VippsPaymentGateway in 1.3).

### Out of Scope (Managed by other contexts)
* **Entity CRUD / Management** (Company Management context — Datto's domain)
* **Auth Issuance / Vipps OIDC / Dev Login** (SurrealDB native / future gateway concern)
* **DittoBar / Search / Discovery** (Discovery service context)
* **Platform Administration / Breaker Box** (Admin Panel direct-to-database context)

---

## Functional Requirements

### 1. Database-Agnostic Core Models & Shared Kernel
* Implement base schemas using Pydantic v2 (`pydantic>=2.13.4`).
* Ensure strict Pydantic v2 `ConfigDict` configuration (`str_strip_whitespace=True`, `use_enum_values=True`, `validate_default=True`).
* Implement read-only entity schemas that match SurrealDB data structure for Company Management integration.
* Implement timezone-aware UTC datetime validators.

### 2. Time Tetris Availability Engine (`mercury_engine/domain/calculators/`)
* Implement pure availability calculations.
* Build `AvailabilityContext` to aggregate schedules, bookings, active holds, and staff shifts.
* Use minutes-from-midnight shift arithmetic to calculate free slots.
* Support requested staff selection and first-available automatic staff assignment.
* Ensure all calculations execute completely in-memory with zero I/O side-effects.

### 3. Hold-to-Booking Lifecycle Router (`mercury_engine/api/`)
* **Hold Endpoint:** Create a short-lived slot lock with TTL (`expires_at`), hard-deleted upon expiration.
* **Confirm Endpoint:** Validate payment state, build a fiscally immutable booking snapshot (prices, service titles, staff assignments), and persist the booking.
* **Cancel Endpoint:** Policy-enforced cancellation updating status but keeping the snapshot permanently frozen.
* **Reschedule:** Enforce Norwegian Forbrukstilsynet compliance — old record marked `cancelled` and links to new booking via `rescheduled_to`/`rescheduled_from`.

### 4. SurrealDB 3.0 Dual-Namespace Repositories
* Connect using strict dual-pool repository adapters.
* Discovery/booking/CRUD reads target `companies/{slug}` and `companies/registry` databases.
* Consumer profiles/PII write strictly to the isolated `users/profiles` database (GDPR opacity).

---

## Non-Functional Requirements

* **Performance:** Availability calculations must execute in `<200ms` for high-cardinality shift matrices.
* **Security:** Timezone-aware JWT validation using `pyjwt>=2.13.0`.
* **Testing:** 100% test coverage on Time Tetris availability calculators, and >80% on other domain modules.
* **TDD Workflow:** Red → Green → Refactor sequence on every task. No skipping test failure phase.
* **Formatting / Linting:** 100% Ruff-clean (`ruff format` and `ruff check` with zero warnings).
