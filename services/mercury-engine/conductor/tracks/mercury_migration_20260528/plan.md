# Plan — MercuryEngine V2 Migration (`mercury_migration_20260528`)

> **Workflow:** Strict Python TDD
> **Phases:** 5 (each is a checkpoint)
> **Parity Target:** 377 legacy tests green

---

## Phase 1: Environment & Health Endpoint

Stand up the development environment using `uv`, establish the testing architecture, and port the initial health routes and baseline test configurations.

- [ ] **Task 1.1: Setup UV Workspace & Pyproject**
    - [ ] Create `pyproject.toml` containing all core dependencies (`fastapi`, `pydantic>=2.13.4`, `pydantic-settings`, `bcrypt>=5.0.0`, `pyjwt>=2.13.0`, `surrealdb>=2.0.0`).
    - [ ] Setup `tool.pytest.ini_options` and dev dependencies (`pytest-asyncio`, `httpx`, `ruff`).
    - [ ] Run `uv sync` and verify all lock dependencies resolve cleanly.
- [ ] **Task 1.2: Port Health Check Routes & Baseline Tests**
    - [ ] Port `tests/test_health.py` and `tests/test_errors.py` (Red Phase).
    - [ ] Port `src/mercury_engine/main.py` and health endpoint to satisfy tests (Green Phase).
    - [ ] Verify: `uv run pytest tests/test_health.py` is 100% green.

---

## Phase 2: Core Models & Serializations

Clean-room port of the database-agnostic Pydantic v2 schemas and models, verifying timezone-aware UTC datetime validators.

- [ ] **Task 2.1: Port Mixins & Enums**
    - [ ] Port `tests/models/` serialization tests (Red Phase).
    - [ ] Port `mercury_core/models/common.py` (base `MercuryModel`, `TimestampMixin`, `SoftDeleteMixin`, and StrEnums).
    - [ ] Verify: Pydantic v2 validation works, stripping trailing whitespace and utilizing enum values correctly.
- [ ] **Task 2.2: Port Core Domain Models**
    - [ ] Port model files: `company.py`, `establishment.py`, `service.py`, `staff.py`, `customer.py`, `user.py`, `booking.py`, `hold.py`, `resource.py`, `category.py`.
    - [ ] Run Pydantic round-trip serialization tests to confirm complete compliance.

---

## Phase 3: Time Tetris & Availability Engine

Port the core availability slot logic, openings schedule arithmetic, and shift calculators.

- [ ] **Task 3.1: Port Availability Arithmetic & Time Math**
    - [ ] Port availability calculators tests: `tests/calculators/` and `tests/test_time.py` (Red Phase).
    - [ ] Port availability calculations (`mercury_core/time.py`, `mercury_core/calculators/slots.py`).
    - [ ] Ensure all slot math executes as pure functions without side effects.
- [ ] **Task 3.2: Verify availability calculator tests**
    - [ ] Run slot calculators tests.
    - [ ] Confirm: Performance remains under 200ms for high-cardinality shift matrices.

---

## Phase 4: SurrealDB 3.0 Repositories

Port the data access layers and implement the dual-pool connection architecture mapping correctly to `companies` and `users` namespaces.

- [ ] **Task 4.1: Port Database Connections & Configuration**
    - [ ] Port database client tests: `tests/repositories/` (Red Phase).
    - [ ] Implement dual-namespace client pool adaptors separating company data from isolated user PII profiles.
- [ ] **Task 4.2: Port Repository Interfaces & Mocks**
    - [ ] Port abstract repository interfaces and their corresponding mock implementations (`mercury_core/repositories/*`).
    - [ ] Verify mock repository unit tests run and pass without live database dependencies.

---

## Phase 5: Route Implementations & Integration Check

Port the FastAPI route handlers, authorization middlewares, and execute the full integration test suite.

- [ ] **Task 5.1: Port Router Endpoints**
    - [ ] Port endpoint routes (`mercury_engine/routes/*`): booking vertical, CRUD entities, discovery engine, and admin breaker box.
    - [ ] Port access levels and JWT validation middleware.
- [ ] **Task 5.2: Final Integration Sync**
    - [ ] Run full 377 test suite: `uv run pytest`.
    - [ ] Perform Ruff lint check and format checks: zero warnings.
    - [ ] Achieve Phase 5 checkpoint verification!
