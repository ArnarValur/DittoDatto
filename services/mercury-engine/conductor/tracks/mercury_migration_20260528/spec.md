# Specification — MercuryEngine V2 Migration (`mercury_migration_20260528`)

## Overview
This track governs the complete migration of the DittoDatto core booking, discovery, and CRUD API (MercuryEngine V2) from the legacy `/DittoDatto-old/services/mercury-engine-old` directory into the greenfield `/services/mercury-engine` directory. 

The legacy codebase is highly functional with **377 passing tests** covering authorization, availability, calculators, models, integration, and repositories. Our goal is a disciplined, clean-room port that:
1. Decouples core logic from the web transport layer.
2. Formally implements the new SurrealDB 3.0 dual-namespace topology (`companies` + `users`).
3. Adopts Pydantic v2 (`pydantic>=2.13.4`) conventions and strict timezone-aware UTC datetime validators.
4. Preserves 100% test contract coverage (all 377 test assertions ported and green).

---

## Functional Requirements

### 1. Database-Agnostic Core Models & Mixins (`mercury_core/models/*`)
- Port mixins (`TimestampMixin`, `SoftDeleteMixin`) using Pydantic v2 validators.
- Port all domain schemas:
  - `Establishment`, `Company`, `Service`, `ServiceGroup`, `Staff`, `Customer`, `User`, `Booking`, `Hold`, `Resource`, `Category`.
  - Nested objects: `StorePolicy`, `SocialLinks`, `ReservationConfig`, `TimeBlock`.
- Ensure Pydantic v2 `ConfigDict` configuration (e.g. `str_strip_whitespace=True`, `use_enum_values=True`, `validate_default=True`).

### 2. Time Tetris Slot Calculators (`mercury_core/calculators/*`)
- Port pure availability calculators (`slots.py`, `time.py`).
- Implement shift andOpening schedule mappings (Minutes-from-Midnight arithmetic).
- Ensure calculators perform 0 database operations, utilizing repository payloads passed as inputs.

### 3. SurrealDB 3.0 Repository Layer (`mercury_core/repositories/*`)
- Implement strict dual-pool repository adaptors.
- Scoping operations must direct private PII to the `users/profiles` namespace and discovery/booking/CRUD events to the corresponding `companies/{slug}` and `companies/registry` databases.

### 4. API Gateway Endpoints (`mercury_engine/routes/*`)
- Implement routes matching legacy signatures:
  - `/appointments/*`, `/reservations/*`, `/tickets/*` (Booking vertical)
  - `/discovery/*` (DittoBar listings and BM25 search)
  - `/establishments/*`, `/services/*`, `/staff/*` (CRUD operations)
  - `/admin/*` (breaker box platform configurations)
- Security checks matching parent authorization tiers: `public`, `require_auth`, `require_operator`, `require_admin`, `require_super_admin`.

---

## Non-Functional Requirements
- **Performance:** Slot-Tetris calculator algorithms must execute in under 200ms for high-concurrency requests.
- **Security:** Strict JWT validation using `pyjwt>=2.13.0` and cryptographically secure passwords using `bcrypt>=5.0.0`.
- **Type Safety:** 100% type annotations with zero `Any` references allowed in core models.
- **Code Quality:** Ruff-clean (`uv run ruff check .` and `uv run ruff format .` returning zero violations).

---

## Acceptance Criteria
- **Parity:** All 13 core domain modules compile and load without syntax errors.
- **Automated Tests:** All 377 test cases are successfully ported and return **100% green** in the new workspace environment.
- **Code Coverage:** Overall coverage exceeds 80% on backend modules, and 90% on availability calculators.
- **Clean builds:** `uv build` completes without warnings.

---

## Out of Scope
- Porting the legacy Nuxt Business Portal or Admin Panel (frozen Chapter 1 webapps).
- Setting up the frontend Flutter Admin Panel application (handled by the sibling track `admin_panel_20260527`).
- Implementing the physical Saturn Tailscale advertised gateway services (already deployed on Saturn staging).
