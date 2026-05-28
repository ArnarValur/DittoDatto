"""Tests for auth middleware dependencies.

Covers:
- require_auth: valid/missing/invalid tokens
- require_operator: role check + company access guard
- company_access_guard: operator/agent slug matching
"""

from __future__ import annotations

import pytest
from starlette.testclient import TestClient

from mercury_core.errors import ForbiddenError
from mercury_core.models.auth import ActorRole, TokenClaims
from mercury_engine.auth.middleware import (
    company_access_guard,
    require_auth,
)
from mercury_engine.auth.token_service import mint_token

# ─── company_access_guard (unit tests — no HTTP) ────────────────────────


class TestCompanyAccessGuard:
    """Company access guard — pure function, no async/HTTP needed."""

    def test_operator_matching_slug(self) -> None:
        """Operator with matching company_slug passes."""
        claims = TokenClaims(
            sub="vipps_123",
            role=ActorRole.OPERATOR,
            company_slug="merkurial-studio",
            allowed_companies=["merkurial-studio"],
        )
        # Should not raise
        company_access_guard(claims, "merkurial-studio")

    def test_operator_mismatching_slug(self) -> None:
        """Operator accessing wrong company is forbidden."""
        claims = TokenClaims(
            sub="vipps_123",
            role=ActorRole.OPERATOR,
            company_slug="merkurial-studio",
            allowed_companies=["merkurial-studio"],
        )
        with pytest.raises(ForbiddenError, match="does not have access"):
            company_access_guard(claims, "dittodatto")

    def test_agent_wildcard_access(self) -> None:
        """Agent with ['*'] can access any company."""
        claims = TokenClaims(
            sub="agent_ditto",
            role=ActorRole.AGENT,
            allowed_companies=["*"],
        )
        company_access_guard(claims, "merkurial-studio")
        company_access_guard(claims, "dittodatto")
        company_access_guard(claims, "any-company")

    def test_agent_specific_slug_allowed(self) -> None:
        """Agent with specific slugs can access listed companies."""
        claims = TokenClaims(
            sub="agent_datto",
            role=ActorRole.AGENT,
            allowed_companies=["merkurial-studio", "dittodatto"],
        )
        company_access_guard(claims, "merkurial-studio")
        company_access_guard(claims, "dittodatto")

    def test_agent_specific_slug_denied(self) -> None:
        """Agent without slug in list is forbidden."""
        claims = TokenClaims(
            sub="agent_datto",
            role=ActorRole.AGENT,
            allowed_companies=["merkurial-studio"],
        )
        with pytest.raises(ForbiddenError, match="does not have access"):
            company_access_guard(claims, "other-company")


# ─── require_auth (integration via FastAPI TestClient) ───────────────────


class TestRequireAuth:
    """Tests for require_auth dependency via a minimal FastAPI app."""

    @pytest.fixture
    def app(self):
        """Create a minimal FastAPI app with a protected endpoint."""
        from fastapi import Depends, FastAPI
        from fastapi.responses import JSONResponse

        from mercury_core.errors import MercuryError

        test_app = FastAPI()

        @test_app.exception_handler(MercuryError)
        async def error_handler(_req, exc: MercuryError):
            return JSONResponse(
                status_code=exc.status_code,
                content={"error": exc.code, "message": exc.message},
            )

        @test_app.get("/protected")
        async def protected(claims: TokenClaims = Depends(require_auth)):
            return {"sub": claims.sub, "role": claims.role}

        return test_app

    @pytest.fixture
    def client(self, app):
        return TestClient(app)

    def test_valid_token(self, client: TestClient) -> None:
        """Valid Bearer token returns claims."""
        claims = TokenClaims(
            sub="vipps_arnar",
            role=ActorRole.OPERATOR,
            company_slug="merkurial-studio",
        )
        token = mint_token(claims)

        response = client.get("/protected", headers={"Authorization": f"Bearer {token}"})
        assert response.status_code == 200
        data = response.json()
        assert data["sub"] == "vipps_arnar"
        assert data["role"] == "business"

    def test_missing_header(self, client: TestClient) -> None:
        """Missing Authorization header returns 401."""
        response = client.get("/protected")
        assert response.status_code == 401

    def test_invalid_token(self, client: TestClient) -> None:
        """Invalid JWT returns 401."""
        response = client.get("/protected", headers={"Authorization": "Bearer garbage.token.here"})
        assert response.status_code == 401

    def test_wrong_scheme(self, client: TestClient) -> None:
        """Non-Bearer scheme returns 401."""
        response = client.get("/protected", headers={"Authorization": "Basic dXNlcjpwYXNz"})
        assert response.status_code == 401

    def test_expired_token(self, client: TestClient) -> None:
        """Expired token returns 401."""
        claims = TokenClaims(
            sub="vipps_arnar",
            role=ActorRole.OPERATOR,
        )
        token = mint_token(claims, expiry_seconds=-10)

        response = client.get("/protected", headers={"Authorization": f"Bearer {token}"})
        assert response.status_code == 401


# ─── require_admin (Session 18 — ADR-0011) ───────────────────────────────


class TestRequireAdmin:
    """Tests for require_admin middleware dependency."""

    @pytest.fixture
    def app(self):
        """Create a minimal FastAPI app with an admin-protected endpoint."""
        from fastapi import Depends, FastAPI
        from fastapi.responses import JSONResponse

        from mercury_core.errors import MercuryError
        from mercury_engine.auth.middleware import require_admin

        test_app = FastAPI()

        @test_app.exception_handler(MercuryError)
        async def error_handler(_req, exc: MercuryError):
            return JSONResponse(
                status_code=exc.status_code,
                content={"error": exc.code, "message": exc.message},
            )

        @test_app.get("/admin-only")
        async def admin_only(claims: TokenClaims = Depends(require_admin)):
            return {"sub": claims.sub, "role": claims.role}

        return test_app

    @pytest.fixture
    def client(self, app):
        return TestClient(app)

    def test_admin_token_accepted(self, client: TestClient) -> None:
        """Admin token passes require_admin."""
        claims = TokenClaims(
            sub="vipps_admin",
            role=ActorRole.ADMIN,
            allowed_companies=["*"],
        )
        token = mint_token(claims)

        response = client.get(
            "/admin-only",
            headers={"Authorization": f"Bearer {token}"},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["sub"] == "vipps_admin"
        assert data["role"] == "admin"

    def test_super_admin_token_accepted(self, client: TestClient) -> None:
        """Super_admin token passes require_admin."""
        claims = TokenClaims(
            sub="vipps_superadmin",
            role=ActorRole.SUPER_ADMIN,
            allowed_companies=["*"],
        )
        token = mint_token(claims)

        response = client.get(
            "/admin-only",
            headers={"Authorization": f"Bearer {token}"},
        )
        assert response.status_code == 200
        assert response.json()["role"] == "super_admin"

    def test_operator_token_rejected(self, client: TestClient) -> None:
        """Operator token is forbidden at admin endpoints."""
        claims = TokenClaims(
            sub="vipps_arnar",
            role=ActorRole.OPERATOR,
            company_slug="merkurial-studio",
        )
        token = mint_token(claims)

        response = client.get(
            "/admin-only",
            headers={"Authorization": f"Bearer {token}"},
        )
        assert response.status_code == 403

    def test_agent_token_rejected(self, client: TestClient) -> None:
        """Agent token is forbidden at admin endpoints."""
        claims = TokenClaims(
            sub="agent_ditto",
            role=ActorRole.AGENT,
            allowed_companies=["*"],
        )
        token = mint_token(claims)

        response = client.get(
            "/admin-only",
            headers={"Authorization": f"Bearer {token}"},
        )
        assert response.status_code == 403

    def test_unauthenticated_rejected(self, client: TestClient) -> None:
        """No token returns 401."""
        response = client.get("/admin-only")
        assert response.status_code == 401
