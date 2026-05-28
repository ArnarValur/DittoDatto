"""Tests for the dev-login endpoint.

Covers:
- Valid credentials → JWT
- Invalid password → 401
- Unknown email → 401
- Endpoint presence in dev vs production
"""

from __future__ import annotations

from unittest.mock import AsyncMock, patch

import bcrypt
import pytest
from starlette.testclient import TestClient

from mercury_core.models.auth import ActorRole
from mercury_core.models.user import User

# ─── Fixtures ────────────────────────────────────────────────────────────


@pytest.fixture
def dev_user() -> User:
    """Seeded dev user matching the Merkurial Studio seed."""
    password_hash = bcrypt.hashpw(b"12345678", bcrypt.gensalt()).decode("utf-8")
    return User(
        id="dev_arnar",
        vipps_sub="dev_arnar",
        name="Arnar Valur",
        email="arnar@merkurial-studio.com",
        phone=None,
        role=ActorRole.OPERATOR,
        company_slug="merkurial-studio",
        password_hash=password_hash,
    )


@pytest.fixture
def app_with_auth(dev_user: User):
    """Create a FastAPI app with the auth router and mocked user repo."""
    from fastapi import FastAPI
    from fastapi.responses import JSONResponse

    from mercury_core.errors import MercuryError
    from mercury_engine.routes.auth import router as auth_router

    test_app = FastAPI()

    @test_app.exception_handler(MercuryError)
    async def error_handler(_req, exc: MercuryError):
        return JSONResponse(
            status_code=exc.status_code,
            content={"error": exc.code, "message": exc.message},
        )

    # Mock the user repo dependency
    mock_repo = AsyncMock()
    mock_repo.get_by_email = AsyncMock(return_value=dev_user)

    test_app.include_router(auth_router)

    # Override the dependency
    from mercury_engine.dependencies import get_user_repo

    test_app.dependency_overrides[get_user_repo] = lambda: mock_repo

    return test_app, mock_repo


@pytest.fixture
def client(app_with_auth):
    app, _ = app_with_auth
    return TestClient(app)


@pytest.fixture
def mock_repo(app_with_auth):
    _, repo = app_with_auth
    return repo


# ─── Success Cases ───────────────────────────────────────────────────────


class TestDevLoginSuccess:
    """Successful dev-login flows."""

    def test_valid_credentials(self, client: TestClient) -> None:
        """Valid email + password returns a JWT."""
        response = client.post(
            "/auth/dev-login",
            json={"email": "arnar@merkurial-studio.com", "password": "12345678"},
        )
        assert response.status_code == 200
        data = response.json()
        assert "access_token" in data
        assert data["token_type"] == "bearer"
        assert data["expires_in"] == 604800  # 7 days

    def test_token_is_valid_jwt(self, client: TestClient) -> None:
        """Returned token can be decoded by the token service."""
        from mercury_engine.auth.token_service import verify_token

        response = client.post(
            "/auth/dev-login",
            json={"email": "arnar@merkurial-studio.com", "password": "12345678"},
        )
        data = response.json()
        claims = verify_token(data["access_token"])

        assert claims.sub == "vipps_dev_arnar"
        assert claims.role == ActorRole.OPERATOR
        assert claims.company_slug == "merkurial-studio"
        assert claims.name == "Arnar Valur"


# ─── Failure Cases ───────────────────────────────────────────────────────


class TestDevLoginFailure:
    """Dev-login rejection cases."""

    def test_wrong_password(self, client: TestClient) -> None:
        """Wrong password returns 401."""
        response = client.post(
            "/auth/dev-login",
            json={"email": "arnar@merkurial-studio.com", "password": "wrong"},
        )
        assert response.status_code == 401

    def test_unknown_email(self, client: TestClient, mock_repo: AsyncMock) -> None:
        """Unknown email returns 401."""
        mock_repo.get_by_email = AsyncMock(return_value=None)

        response = client.post(
            "/auth/dev-login",
            json={"email": "nobody@example.com", "password": "12345678"},
        )
        assert response.status_code == 401

    def test_user_without_password_hash(
        self, client: TestClient, mock_repo: AsyncMock
    ) -> None:
        """User with no password_hash (Vipps-only) returns 401."""
        user_no_pw = User(
            id="vipps_only",
            vipps_sub="vipps_only",
            name="Vipps User",
            email="vipps@example.com",
            role=ActorRole.OPERATOR,
            password_hash=None,
        )
        mock_repo.get_by_email = AsyncMock(return_value=user_no_pw)

        response = client.post(
            "/auth/dev-login",
            json={"email": "vipps@example.com", "password": "12345678"},
        )
        assert response.status_code == 401


# ─── Environment Gate ────────────────────────────────────────────────────


class TestDevLoginEnvironmentGate:
    """Dev-login should not be registered in production."""

    def test_production_mode_no_auth_route(self) -> None:
        """In production mode, the auth router is not registered."""
        with patch("mercury_engine.config.settings.environment", "production"):
            from mercury_engine.main import create_app

            production_app = create_app()

            prod_client = TestClient(production_app)
            response = prod_client.post(
                "/auth/dev-login",
                json={"email": "arnar@merkurial-studio.com", "password": "12345678"},
            )
            # 404 because the route doesn't exist, or 405 Method Not Allowed
            assert response.status_code in (404, 405)
