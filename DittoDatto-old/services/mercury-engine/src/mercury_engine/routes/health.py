"""Health check route.

Replaces: app.get('/health', ...) in server.ts
Required for: Cloud Run readiness checks, Docker HEALTHCHECK, monitoring.
"""

from __future__ import annotations

from datetime import UTC, datetime

from fastapi import APIRouter, Request

router = APIRouter()


@router.get("/health")
async def health_check(request: Request) -> dict:
    """Health check endpoint.

    Returns service identity, version, timestamp, and SurrealDB status.
    Used by Cloud Run for readiness probes and by monitoring tools.
    """
    result: dict[str, object] = {
        "status": "ok",
        "service": "mercury-engine",
        "version": "2.0.0-alpha",
        "timestamp": datetime.now(tz=UTC).isoformat(),
    }

    # Include SurrealDB connection status if client exists
    db = getattr(request.app.state, "db", None)
    if db:
        result["surrealdb"] = await db.health()
    else:
        result["surrealdb"] = {"connected": False, "titan": False, "enceladus": False}

    return result

