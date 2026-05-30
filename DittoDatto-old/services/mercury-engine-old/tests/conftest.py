"""Shared test fixtures for MercuryEngine.

Replaces: packages/mercury-engine/tests/helpers/test-app.ts
"""

from __future__ import annotations

import pytest
from httpx import ASGITransport, AsyncClient

from mercury_engine.main import create_app


@pytest.fixture
def app():
    """Create a fresh FastAPI app instance for each test."""
    return create_app()


@pytest.fixture
async def client(app):
    """Async HTTP client for testing FastAPI endpoints.

    Usage:
        async def test_something(client):
            response = await client.get("/health")
            assert response.status_code == 200
    """
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as c:
        yield c
