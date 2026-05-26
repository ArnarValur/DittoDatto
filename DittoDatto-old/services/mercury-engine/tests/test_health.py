"""Smoke tests for the FastAPI application.

Verifies: server starts, health check responds, error handler works.
"""

from __future__ import annotations

import pytest
from httpx import AsyncClient

from mercury_core.errors import MercuryError, NotFoundError


@pytest.mark.asyncio
async def test_health_check(client: AsyncClient):
    """GET /health returns 200 with correct shape."""
    response = await client.get("/health")

    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "ok"
    assert data["service"] == "mercury-engine"
    assert data["version"] == "2.0.0-alpha"
    assert "timestamp" in data


@pytest.mark.asyncio
async def test_root_endpoint(client: AsyncClient):
    """GET / returns service info and route listing."""
    response = await client.get("/")

    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "MercuryEngine"
    assert "endpoints" in data
    assert data["endpoints"]["health"] == "/health"


@pytest.mark.asyncio
async def test_mercury_error_handler(app, client: AsyncClient):
    """MercuryError is caught and returned as structured JSON."""
    # Add a test route that raises a MercuryError
    @app.get("/test-error")
    async def raise_error():
        raise NotFoundError("Establishment", "est_123")

    response = await client.get("/test-error")

    assert response.status_code == 404
    data = response.json()
    assert data["error"] == "not-found"
    assert "est_123" in data["message"]


@pytest.mark.asyncio
async def test_mercury_error_with_details(app, client: AsyncClient):
    """MercuryError details are passed through to response."""

    @app.get("/test-error-details")
    async def raise_detailed_error():
        raise MercuryError(
            code="test-error",
            message="Something went wrong",
            status_code=422,
            details={"field": "start_time", "reason": "in the past"},
        )

    response = await client.get("/test-error-details")

    assert response.status_code == 422
    data = response.json()
    assert data["details"]["field"] == "start_time"
