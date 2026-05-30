# Plan — MercuryEngine 1.0 Booking Engine (`mercury_migration_20260528`)

> **Workflow:** Strict Python TDD
> **Architecture:** Clean Architecture + Repository Pattern
> **Phases:** 5 (each ending in a Phase Checkpoint)
> **Goal:** Greenfield 1.0 Booking Engine

---

## Phase 1: Environment & FastAPI Foundation

Establish the greenfield environment, setup the Ruff linting and Pytest harnesses, and build the baseline FastAPI web framework with its JWT-validation access tiers.

* [x] **Task 1.1: Setup UV Workspace & Pyproject** (08bef71)
  * [x] Create `pyproject.toml` with strict dependencies (`fastapi`, `pydantic>=2.13.4`, `pydantic-settings`, `bcrypt>=5.0.0`, `pyjwt>=2.13.0`, `surrealdb>=2.0.0`).
  * [x] Configure Pytest settings (`tool.pytest.ini_options` for pytest-asyncio).
  * [x] Configure Ruff formatter and lint settings.
  * [x] Run `uv sync` and verify all dependencies compile and resolve.
* [x] **Task 1.2: FastAPI Web Application & Health Routes** (9abfe00)
  * [x] Write failing test for health and readiness endpoints (Red Phase).
  * [x] Implement FastAPI startup lifecycle and health route handlers in `src/mercury_engine/main.py` (Green Phase).
  * [x] Verify: tests run and pass.
* [x] **Task 1.3: TDD JWT Access Validation Middleware** (c6a5fa5)
  * [x] Write test suite validating JWT parsing, signature checks, expiration verification, and the 5 security tiers (`public`, `require_auth`, `require_operator`, `require_admin`, `require_super_admin`) (Red Phase).
  * [x] Implement JWT validation middleware in `src/mercury_engine/api/auth.py` (Green Phase).
  * [x] Refactor middleware and verify 100% test coverage.

---

## Phase 2: Base Models & Shared Kernel Projections [checkpoint: fce8314]

Construct the core database-agnostic Pydantic v2 domain schemas, ensuring timezone-aware UTC datetime validators and read-only projection mappings.

* [x] **Task 2.1: Domain Mixins & Timezone Validators** (e877f0f)
  * [x] Write tests validating that datetimes are strictly timezone-aware UTC and trailing whitespace is stripped (Red Phase).
  * [x] Implement `TimestampMixin`, `SoftDeleteMixin`, and custom Pydantic timezone validator helpers in `src/mercury_engine/domain/models/common.py` (Green Phase).
  * [x] Verify round-trip model serializations.
* [x] **Task 2.2: Shared Kernel Read-Only Projections** (50de4a4)
  * [x] Write serialization tests for `Establishment`, `Service`, `StaffMember`, `Resource`, and `Schedule` domain models (Red Phase).
  * [x] Create read-only models in `src/mercury_engine/domain/models/projections/` satisfying all domain validation parameters (Green Phase).
  * [x] Verify and refactor.
* [x] **Task 2.3: Writeable Booking Engine Models** (25cd21c)
  * [x] Write serialization and lifecycle state tests for `Hold`, `Booking`, `Customer`, and `User` (Red Phase).
  * [x] Create the core booking models in `src/mercury_engine/domain/models/booking.py` (Green Phase).
  * [x] Verify all state transition validators work cleanly.

---

## Phase 3: Time Tetris & Availability Engine [checkpoint: d594b6a]

Implement the pure availability slot calculator logic, openings schedules, and shifts arithmetic.

* [x] **Task 3.1: Time Tetris Shift Arithmetic** (d5da9c7)
  * [x] Write calculator tests covering high-cardinality shift matrices, minutes-from-midnight math, and staff opening schedules (Red Phase).
  * [x] Implement pure slot calculators in `src/mercury_engine/domain/calculators/slots.py` operating strictly on memory-context payloads (Green Phase).
  * [x] Confirm slot calculations return free blocks in `<200ms`.
* [x] **Task 3.2: Staff Hold & Resource Assignment** (a444416)
  * [x] Write allocation tests for requested staff vs. automatic first-available staff selection, and best-fit resource allocation (Red Phase).
  * [x] Implement the hold allocator within the domain calculator layer (Green Phase).
  * [x] Verify slot locking constraints and resource conflicts are correctly flagged.
* [x] **Task 3.3: AvailabilityProbe Queries** (d594b6a)
  * [x] Write tests for read-only `AvailabilityProbe` queries verifying zero state changes (Red Phase).
  * [x] Implement availability probing calculator logic supporting agentic search without hold creation (Green Phase).
  * [x] Verify and refactor.

---

## Phase 4: SurrealDB 3.0 & Repository Integration [checkpoint: 6e6cc1c]

Build the data access adapters and implement connection pooling mapping correctly to the dual-namespace SurrealDB topology.

* [x] **Task 4.1: Dual-Namespace Client Connection** (d01982d)
  * [x] Write connection tests for establishing parallel pool clients targeting `companies` namespace and `users` namespace (Red Phase).
  * [x] Implement the dual-pool connection adaptors in `src/mercury_engine/infra/db.py` (Green Phase).
  * [x] Verify connection and database health checking.
* [x] **Task 4.2: Domain Repository Interfaces & Mock Repository** (daf37f0)
  * [x] Write repository tests targeting abstract interfaces (Red Phase).
  * [x] Create abstract interfaces (`IHoldRepository`, `IBookingRepository`) and in-memory mock repository implementations (`MockHoldRepository`, `MockBookingRepository`) for isolated unit testing (Green Phase).
  * [x] Verify: all unit tests run green against mocks with no live database connection.
* [x] **Task 4.3: Live SurrealDB Integration Repository** (6e6cc1c)
  * [x] Write integration tests for writing and reading actual database records against a local SurrealDB docker container (Red Phase).
  * [x] Implement SurrealDB 3.0 SQL repository adapters in `src/mercury_engine/infra/repositories/` (Green Phase).
  * [x] Verify all database-level constraints match the domain models.

---

## Phase 5: Route Implementation & Lifecycle Verification [checkpoint: aabeb1e]

Hook up the FastAPI route handlers, integrate the swappable payment system, and verify the full hold-to-booking pipeline.

* [x] **Task 5.1: Booking Holds & Probe API Routes** (aabeb1e)
  * [x] Write integration tests for creating a Hold, getting available slots, and posting AvailabilityProbes (Red Phase).
  * [x] Implement `/holds` and `/availability/probe` endpoint routers (Green Phase).
  * [x] Verify TTL expiry on holds behaves correctly.
* [x] **Task 5.2: Booking Confirmation & Payments** (aabeb1e)
  * [x] Write TDD tests for confirm bookings with payment checks and cancellations (Red Phase).
  * [x] Implement `/bookings` confirmation and cancellation routers using the `MockPaymentGateway` (Green Phase).
  * [x] Verify Norwegians Forbrukstilsynet rescheduling compliance (cancel + rebook link).
* [x] **Task 5.3: Core 1.0 Final Integration Sync** (aabeb1e)
  * [x] Run all test cases in the test suite (`uv run pytest`) and check coverage (>80% overall, >90% calculators).
  * [x] Execute Ruff check and format.
  * [x] Build verification: `uv build` executes with zero warnings.
