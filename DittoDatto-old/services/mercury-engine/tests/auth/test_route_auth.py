"""Tests for auth enforcement on route endpoints.

Verifies that write endpoints (POST/PUT/DELETE) reject:
- Unauthenticated requests (401)
- Wrong-company operator requests (403)

And that read endpoints (GET) remain public where expected.

Session 16.5 — wiring require_operator onto write endpoints.
"""

from __future__ import annotations

from unittest.mock import AsyncMock, MagicMock

import pytest
from starlette.testclient import TestClient

from mercury_core.models.auth import ActorRole, TokenClaims
from mercury_engine.auth.token_service import mint_token
from mercury_engine.main import create_app

SLUG = "merkurial-studio"
OTHER_SLUG = "dittodatto"


# ─── Fixtures ────────────────────────────────────────────────────────────


@pytest.fixture
def app():
    """Create the full app with mocked SurrealDB client."""
    application = create_app()

    # Mock db so routes don't need a live SurrealDB.
    # Return None/empty from all SurrealDB calls so the adapter
    # short-circuits before hitting record parsing.
    mock_db = MagicMock()
    mock_conn = AsyncMock()
    mock_conn.select = AsyncMock(return_value=None)
    mock_conn.query = AsyncMock(return_value=[])
    mock_conn.create = AsyncMock(return_value=[])
    mock_conn.merge = AsyncMock(return_value=[])
    mock_conn.delete = AsyncMock(return_value=None)
    mock_db.titan = AsyncMock(return_value=mock_conn)
    mock_db.enceladus = AsyncMock(return_value=mock_conn)
    application.state.db = mock_db

    return application


@pytest.fixture
def client(app):
    return TestClient(app)


@pytest.fixture
def operator_token():
    """Valid operator JWT for merkurial-studio."""
    claims = TokenClaims(
        sub="vipps_arnar",
        role=ActorRole.OPERATOR,
        company_slug=SLUG,
        allowed_companies=[SLUG],
    )
    return mint_token(claims)


@pytest.fixture
def other_operator_token():
    """Valid operator JWT for a DIFFERENT company."""
    claims = TokenClaims(
        sub="vipps_other",
        role=ActorRole.OPERATOR,
        company_slug=OTHER_SLUG,
        allowed_companies=[OTHER_SLUG],
    )
    return mint_token(claims)


@pytest.fixture
def auth_headers(operator_token):
    return {"Authorization": f"Bearer {operator_token}"}


@pytest.fixture
def wrong_company_headers(other_operator_token):
    return {"Authorization": f"Bearer {other_operator_token}"}


# ─── Endpoint inventory ─────────────────────────────────────────────────

# Each tuple: (method, path, needs_body)
OPERATOR_ENDPOINTS = [
    # Establishments
    ("POST", f"/companies/{SLUG}/establishments", True),
    ("PUT", f"/companies/{SLUG}/establishments/est1", True),
    ("DELETE", f"/companies/{SLUG}/establishments/est1", False),
    # Services
    ("POST", f"/companies/{SLUG}/services", True),
    ("PUT", f"/companies/{SLUG}/services/svc1", True),
    ("DELETE", f"/companies/{SLUG}/services/svc1", False),
    # Staff
    ("POST", f"/companies/{SLUG}/staff", True),
    ("PUT", f"/companies/{SLUG}/staff/stf1", True),
    ("DELETE", f"/companies/{SLUG}/staff/stf1", False),
    # Bookings
    ("GET", f"/companies/{SLUG}/bookings", False),  # list = operator-only
    ("POST", f"/companies/{SLUG}/bookings", True),
    ("PUT", f"/companies/{SLUG}/bookings/bk1", True),
    ("DELETE", f"/companies/{SLUG}/bookings/bk1", False),
]

AUTH_ONLY_ENDPOINTS = [
    # Holds — require_auth (any user), not require_operator
    ("POST", f"/companies/{SLUG}/holds", True),
    ("GET", f"/companies/{SLUG}/holds/h1", False),
    ("DELETE", f"/companies/{SLUG}/holds/h1", False),
    ("POST", f"/companies/{SLUG}/holds/h1/confirm", False),
]

PUBLIC_GET_ENDPOINTS = [
    # These GETs should remain public (no auth required)
    ("GET", f"/companies/{SLUG}/establishments", False),
    ("GET", f"/companies/{SLUG}/establishments/est1", False),
    ("GET", f"/companies/{SLUG}/services", False),
    ("GET", f"/companies/{SLUG}/services/svc1", False),
    ("GET", f"/companies/{SLUG}/staff", False),
    ("GET", f"/companies/{SLUG}/staff/stf1", False),
    ("GET", f"/companies/{SLUG}/bookings/bk1", False),  # single = public
]


# ─── Minimal body for POST/PUT (avoids Pydantic validation errors) ────

DUMMY_BODY = {"id": "test", "name": "Test"}


def _request(client, method, path, headers=None, body=None):
    """Execute an HTTP request on the test client."""
    kwargs = {}
    if headers:
        kwargs["headers"] = headers
    if body:
        kwargs["json"] = body

    return getattr(client, method.lower())(path, **kwargs)


# ─── Test: Unauthenticated requests are rejected ─────────────────────────


class TestUnauthenticatedRejection:
    """All protected endpoints return 401 without a Bearer token."""

    @pytest.mark.parametrize("method,path,needs_body", OPERATOR_ENDPOINTS)
    def test_operator_endpoints_reject_unauthenticated(
        self, client, method, path, needs_body
    ):
        body = DUMMY_BODY if needs_body else None
        response = _request(client, method, path, body=body)
        assert response.status_code == 401, (
            f"{method} {path} should return 401, got {response.status_code}"
        )

    @pytest.mark.parametrize("method,path,needs_body", AUTH_ONLY_ENDPOINTS)
    def test_hold_endpoints_reject_unauthenticated(
        self, client, method, path, needs_body
    ):
        body = DUMMY_BODY if needs_body else None
        response = _request(client, method, path, body=body)
        assert response.status_code == 401, (
            f"{method} {path} should return 401, got {response.status_code}"
        )


# ─── Test: Wrong-company operator gets 403 ───────────────────────────────


class TestWrongCompanyRejection:
    """Operator for company B cannot access company A's write endpoints."""

    @pytest.mark.parametrize("method,path,needs_body", OPERATOR_ENDPOINTS)
    def test_operator_endpoints_reject_wrong_company(
        self, client, wrong_company_headers, method, path, needs_body
    ):
        body = DUMMY_BODY if needs_body else None
        response = _request(client, method, path, headers=wrong_company_headers, body=body)
        assert response.status_code == 403, (
            f"{method} {path} should return 403 for wrong company, got {response.status_code}"
        )


# ─── Test: Public GET endpoints remain open ──────────────────────────────


class TestPublicEndpointsRemainOpen:
    """Public GET endpoints should NOT require auth."""

    @pytest.mark.parametrize("method,path,needs_body", PUBLIC_GET_ENDPOINTS)
    def test_public_gets_dont_return_401(
        self, client, method, path, needs_body
    ):
        response = _request(client, method, path)
        # We expect anything EXCEPT 401/403 — probably 500 (no real DB)
        # or 422 (validation). The point is it's NOT an auth rejection.
        assert response.status_code not in (401, 403), (
            f"{method} {path} should be public, got {response.status_code}"
        )


# ─── Test: Authenticated operator passes auth gate ───────────────────────


class TestAuthenticatedOperatorAccepted:
    """Correct operator token passes the auth check (may fail downstream on DB)."""

    @pytest.mark.parametrize("method,path,needs_body", OPERATOR_ENDPOINTS)
    def test_operator_endpoints_accept_valid_token(
        self, client, auth_headers, method, path, needs_body
    ):
        body = DUMMY_BODY if needs_body else None
        response = _request(client, method, path, headers=auth_headers, body=body)
        # Should NOT be 401 or 403 — the auth gate passed.
        # Will likely be 422 (Pydantic) or 500 (no DB), which is fine.
        assert response.status_code not in (401, 403), (
            f"{method} {path} should accept valid operator token, got {response.status_code}"
        )
