"""Integration test: dev-login against live SurrealDB.

Seeds a real Merkurial Studio operator into enceladus/users,
then exercises the full auth flow:
  1. POST /auth/dev-login → JWT
  2. Decode JWT → verify claims
  3. Use JWT on a protected endpoint (via test app)

Requires SurrealDB running at ws://localhost:8000/rpc.
"""

from __future__ import annotations

import bcrypt
import pytest
import pytest_asyncio
from surrealdb import AsyncSurreal

from mercury_core.models.auth import ActorRole
from mercury_engine.auth.token_service import verify_token
from mercury_engine.db.adapters import SurrealUserRepo

# All tests in this file require a live SurrealDB instance
# Use session-scoped event loop to share the WebSocket connection across tests
pytestmark = [
    pytest.mark.integration,
    pytest.mark.asyncio(loop_scope="session"),
]

SURREALDB_URL = "ws://localhost:8000/rpc"
SURREALDB_USER = "root"
SURREALDB_PASSWORD = "12345678"
ENCELADUS_DB = "users"


@pytest_asyncio.fixture(scope="module", loop_scope="session")
async def enceladus_conn():
    """Module-scoped connection to enceladus/users.

    Applies the real users.surql schema (same one used in production).
    Cleans up the user table after all tests in this module.
    """
    conn = AsyncSurreal(SURREALDB_URL)
    await conn.connect()
    await conn.signin({"user": SURREALDB_USER, "password": SURREALDB_PASSWORD})

    # Ensure enceladus namespace and users database exist
    await conn.use("enceladus", ENCELADUS_DB)
    await conn.query(f"DEFINE DATABASE IF NOT EXISTS {ENCELADUS_DB}")
    await conn.use("enceladus", ENCELADUS_DB)

    # Clean any leftover test data from previous runs
    await conn.query("DELETE user")

    # Apply new ADR-0010 auth fields (the base schema is already deployed)
    await conn.query("""
        DEFINE FIELD IF NOT EXISTS vipps_sub     ON user TYPE option<string>;
        DEFINE FIELD IF NOT EXISTS password_hash ON user TYPE option<string>;
        DEFINE FIELD IF NOT EXISTS company_slug  ON user TYPE option<string>;
        DEFINE INDEX IF NOT EXISTS idx_user_vipps ON user FIELDS vipps_sub UNIQUE;
    """)

    yield conn

    # Cleanup: remove test users
    await conn.query("DELETE user")
    await conn.close()


@pytest_asyncio.fixture(scope="module", loop_scope="session")
async def user_repo(enceladus_conn: AsyncSurreal) -> SurrealUserRepo:
    """User repository connected to live enceladus/users."""
    return SurrealUserRepo(enceladus_conn)


@pytest_asyncio.fixture(scope="module", loop_scope="session")
async def seeded_user(user_repo: SurrealUserRepo):
    """Seed Arnar Valur as the Merkurial Studio operator.

    This is the real deal — an actual record in enceladus/users.
    """
    from mercury_core.models.user import User

    password_hash = bcrypt.hashpw(b"12345678", bcrypt.gensalt()).decode("utf-8")

    user = User(
        vipps_sub="dev_arnar",
        name="Arnar Valur",
        email="arnar@merkurial-studio.com",
        phone=None,
        role=ActorRole.OPERATOR,
        company_slug="merkurial-studio",
        password_hash=password_hash,
    )

    created = await user_repo.create(user)
    return created


class TestUserSeedAndLookup:
    """Verify the user was actually persisted in enceladus/users."""

    async def test_user_seeded(self, seeded_user) -> None:
        """Seeded user has an ID assigned by SurrealDB."""
        assert seeded_user.id is not None
        assert seeded_user.name == "Arnar Valur"
        assert seeded_user.email == "arnar@merkurial-studio.com"
        assert seeded_user.company_slug == "merkurial-studio"

    async def test_lookup_by_email(self, user_repo, seeded_user) -> None:
        """Can find the user by email — the dev-login lookup path."""
        found = await user_repo.get_by_email("arnar@merkurial-studio.com")
        assert found is not None
        assert found.vipps_sub == "dev_arnar"
        assert found.company_slug == "merkurial-studio"

    async def test_lookup_by_vipps_sub(self, user_repo, seeded_user) -> None:
        """Can find the user by vipps_sub — the Vipps OIDC lookup path."""
        found = await user_repo.get_by_vipps_sub("dev_arnar")
        assert found is not None
        assert found.email == "arnar@merkurial-studio.com"

    async def test_password_hash_stored(self, user_repo, seeded_user) -> None:
        """Password hash is persisted (needed for dev-login)."""
        found = await user_repo.get_by_email("arnar@merkurial-studio.com")
        assert found is not None
        assert found.password_hash is not None
        assert bcrypt.checkpw(b"12345678", found.password_hash.encode("utf-8"))


class TestDevLoginEndToEnd:
    """Full dev-login flow against live SurrealDB."""

    async def test_dev_login_returns_jwt(self, user_repo, seeded_user) -> None:
        """POST /auth/dev-login with real DB user returns a valid JWT."""
        from fastapi import FastAPI
        from fastapi.responses import JSONResponse
        from httpx import ASGITransport, AsyncClient

        from mercury_core.errors import MercuryError
        from mercury_engine.dependencies import get_user_repo
        from mercury_engine.routes.auth import router as auth_router

        # Build a minimal app with the auth router
        app = FastAPI()

        @app.exception_handler(MercuryError)
        async def err_handler(_req, exc: MercuryError):
            return JSONResponse(
                status_code=exc.status_code,
                content={"error": exc.code, "message": exc.message},
            )

        app.include_router(auth_router)

        # Override the user repo dependency to use our live repo
        app.dependency_overrides[get_user_repo] = lambda: user_repo

        # Make the request
        transport = ASGITransport(app=app)
        async with AsyncClient(transport=transport, base_url="http://test") as client:
            response = await client.post(
                "/auth/dev-login",
                json={
                    "email": "arnar@merkurial-studio.com",
                    "password": "12345678",
                },
            )

        assert response.status_code == 200
        data = response.json()
        assert "access_token" in data
        assert data["token_type"] == "bearer"
        assert data["expires_in"] == 604800  # 7 days

        # Verify the JWT decodes correctly
        claims = verify_token(data["access_token"])
        assert claims.sub == "vipps_dev_arnar"
        assert claims.role == ActorRole.OPERATOR
        assert claims.company_slug == "merkurial-studio"
        assert claims.allowed_companies == ["merkurial-studio"]
        assert claims.name == "Arnar Valur"
        assert claims.email == "arnar@merkurial-studio.com"
        assert claims.iss == "mercury-engine"
