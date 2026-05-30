<!-- Template: TheOracle -->
# Project Context — MercuryEngine

> Scoped operational document for the MercuryEngine microservice.
> Parent Conductor Link: [DittoDatto Conductor](../../../conductor/project-context.md)

---

## 1. Product Definition & Guidelines

- **Name:** MercuryEngine
- **Description:** The central core database, CRUD, discovery, and slot-availability booking microservice for DittoDatto.
- **Parent Links:**
  - [Product Definition](../../../conductor/project-context.md#1-product-definition)
  - [Product Guidelines](../../../conductor/project-context.md#2-product-guidelines)
  - [Canonical Glossary](../../../conductor/context.md)

---

## 2. Tech Stack (Backend Scoped)

- **Languages:** Python 3.11+
- **Frameworks:** FastAPI (0.136.3) · Pydantic v2 (2.13.4) · Pydantic Settings
- **Database:** SurrealDB 3.0 (RocksDB engine, dual-namespace pooled client)
- **Dependency Management:** `uv` package manager
- **Testing:** Pytest (8.0+) · Pytest-Asyncio · HTTPX (integration tests)
- **Formatting / Linting:** Ruff (0.11+)

---

## 3. Caution Levels

| Domain | Level | Notes |
|---|---|---|
| **Calculators / Time Tetris** | 🔴 **Critical** | Core availability slot algorithms (`calculators/slots.py`) must remain pure functions, fast (<200ms), and 100% test-covered. |
| **SurrealDB Schemas** | 🔴 **Critical** | SurrealQL definitions must match Pydantic model serialization exactly. |
| **Auth / JWT Pipeline** | 🔴 **Critical** | Access level checks (`public` / `require_auth` / `require_operator` / `require_admin` / `require_super_admin`) must enforce GDPR limits and company scoping without leaks. |
| **GDPR / Fiscal Immutability** | 🔴 **Critical** | Bookings must freeze snapshot prices, service titles, and staff assignments. Never allow updates to completed bookings. |

---

## 4. Preferred Workflows

1. **Strict TDD Mode:** Every feature, bug fix, or schema change must follow the Red -> Green -> Refactor sequence. Never write code without a failing test first.
2. **Local Test Environment:** Dev uses independent SurrealDB local Docker instances. Never touch or read Saturn staging databases during daily unit testing.
3. **Repository Pattern:** Core models (`mercury_core/models/`) and calculators are pure Python; database CRUD actions live strictly behind repository interfaces to allow swapping and testing against mocks.
4. **Time Zone Rules:** All datetimes stored in SurrealDB and validated by Pydantic must use UTC with timezone-awareness. No naive datetimes in the pipeline.

---

## 5. Environment Notes

- **Local Development:**
  - Launch local SurrealDB: `docker run --rm -p 8000:8000 surrealdb/surrealdb:v3.0.0 start` (or equivalent workspace compose)
  - Python Environment: Managed by `uv`. Run tests with `uv run pytest`.
  - Ruff formatting: `uv run ruff format .` and linting: `uv run ruff check .`.
- **Saturn Staging:**
  - Accessible via Tailscale at `http://saturn:8001` (DittoDatto Hub SurrealDB) and `http://dittodatto.tailb251cd.ts.net`.
  - Staging deployment: Docker container within the `dittodatto-net` network on the Saturn ASUS GX10 server.
