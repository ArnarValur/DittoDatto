"""Integration test fixtures for live SurrealDB testing.

Provides session-scoped connection management and function-scoped
data cleanup. Uses a dedicated `company_test` database to isolate
test data from production databases like `company_sawasdee`.

Requires SurrealDB running at ws://localhost:8000/rpc.
All tests in this package are marked with @pytest.mark.integration.
"""

from __future__ import annotations

import contextlib
from pathlib import Path

import pytest
import pytest_asyncio
from surrealdb import AsyncSurreal

from mercury_engine.db.adapters import (
    SurrealBookingRepo,
    SurrealCustomerRepo,
    SurrealDateOverrideRepo,
    SurrealEstablishmentRepo,
    SurrealHoldRepo,
    SurrealResourceGroupRepo,
    SurrealResourceRepo,
    SurrealServiceGroupRepo,
    SurrealServiceRepo,
    SurrealStaffRepo,
)
from mercury_engine.dependencies import CompanyRepos

# All tests in this directory require a live SurrealDB instance
pytestmark = pytest.mark.integration

# Test database — never touch production data
TEST_DB = "company_test"
SURREALDB_URL = "ws://localhost:8000/rpc"
SURREALDB_USER = "root"
SURREALDB_PASSWORD = "12345678"

# Path to company-blueprint.surql (relative to project root)
SCHEMA_PATH = (
    Path(__file__).parent.parent.parent.parent.parent
    / "schemas"
    / "company-blueprint.surql"
)

# Tables defined in company-blueprint.surql (for cleanup)
DOMAIN_TABLES = [
    "establishment", "service", "service_group", "staff", "customer",
    "booking", "hold", "date_override", "resource", "resource_group",
    "message_thread", "message", "entity", "fact",
]
EDGE_TABLES = ["offers", "works_at", "assigned_to", "relates_to"]
ALL_TABLES = DOMAIN_TABLES + EDGE_TABLES


@pytest_asyncio.fixture(scope="session", loop_scope="session")
async def surreal_conn():
    """Session-scoped SurrealDB connection.

    Creates the `company_test` database and applies the company blueprint
    schema at the start of the test session. Drops the database at teardown.
    """
    conn = AsyncSurreal(SURREALDB_URL)
    await conn.connect()
    await conn.signin({"user": SURREALDB_USER, "password": SURREALDB_PASSWORD})

    # Scope to titan namespace first (root needs explicit NS)
    await conn.use("titan", TEST_DB)

    # Ensure the database exists
    await conn.query(f"DEFINE DATABASE IF NOT EXISTS {TEST_DB}")
    await conn.use("titan", TEST_DB)

    # Apply company blueprint schema
    if SCHEMA_PATH.exists():
        schema_sql = SCHEMA_PATH.read_text()
        await conn.query(schema_sql)

    yield conn

    # Teardown: drop test database
    try:
        await conn.use("titan", "platform")
        await conn.query(f"REMOVE DATABASE IF EXISTS {TEST_DB}")
    except Exception:
        pass  # Best-effort cleanup
    await conn.close()


@pytest_asyncio.fixture(autouse=True, loop_scope="session")
async def clean_tables(surreal_conn: AsyncSurreal):
    """Clean all table data between tests (function-scoped).

    SCHEMAFULL tables retain their schema after DELETE —
    only data is removed. This gives us a clean slate per test.
    """
    yield  # Run the test first

    # Cleanup after test
    for table in ALL_TABLES:
        with contextlib.suppress(Exception):
            await surreal_conn.query(f"DELETE {table}")


@pytest_asyncio.fixture(loop_scope="session")
async def db(surreal_conn: AsyncSurreal) -> AsyncSurreal:
    """Provide the raw SurrealDB connection for adapter tests."""
    return surreal_conn


@pytest_asyncio.fixture(loop_scope="session")
async def repos(surreal_conn: AsyncSurreal) -> CompanyRepos:
    """Provide a CompanyRepos bundle scoped to the test database."""
    return CompanyRepos(
        establishments=SurrealEstablishmentRepo(surreal_conn),
        services=SurrealServiceRepo(surreal_conn),
        service_groups=SurrealServiceGroupRepo(surreal_conn),
        staff=SurrealStaffRepo(surreal_conn),
        date_overrides=SurrealDateOverrideRepo(surreal_conn),
        bookings=SurrealBookingRepo(surreal_conn),
        holds=SurrealHoldRepo(surreal_conn),
        resources=SurrealResourceRepo(surreal_conn),
        resource_groups=SurrealResourceGroupRepo(surreal_conn),
        customers=SurrealCustomerRepo(surreal_conn),
    )
