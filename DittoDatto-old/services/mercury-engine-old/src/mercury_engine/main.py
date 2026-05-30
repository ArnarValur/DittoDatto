"""MercuryEngine — FastAPI application.

Replaces: packages/mercury-engine/src/server.ts (Hono)

Architecture: App factory pattern for testability.
- create_app() builds the FastAPI instance with all middleware and routes
- The module-level `app` is used by uvicorn for production
- Tests call create_app() directly for isolated test instances
- SurrealDB connections managed via async lifespan context manager
"""

from __future__ import annotations

import logging
from collections.abc import AsyncGenerator
from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from mercury_core.errors import MercuryError

from .config import settings
from .db.client import SurrealDBClient
from .routes.admin import router as admin_router
from .routes.bookings import router as bookings_router
from .routes.establishments import router as establishments_router
from .routes.health import router as health_router
from .routes.holds import router as holds_router
from .routes.services import router as services_router
from .routes.staff import router as staff_router

logger = logging.getLogger("mercury-engine")


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None]:
    """Manage SurrealDB connection lifecycle.

    Connects on startup, disconnects on shutdown.
    The client is stored on app.state.db for dependency injection.
    """
    db = SurrealDBClient()
    try:
        await db.connect()
        app.state.db = db
        logger.info("SurrealDB client attached to app.state")
        yield
    except Exception:
        logger.warning(
            "SurrealDB connection failed — running without persistence. "
            "Set MERCURY_SURREALDB_* env vars to connect."
        )
        app.state.db = None
        yield
    finally:
        if app.state.db:
            await app.state.db.disconnect()


def create_app() -> FastAPI:
    """Create and configure the FastAPI application.

    Returns a fully configured app with CORS, error handling, and routes.
    """
    application = FastAPI(
        title="MercuryEngine",
        description="Booking Engine for DittoDatto",
        version="2.0.0-alpha",
        docs_url="/docs" if settings.is_development else None,
        redoc_url="/redoc" if settings.is_development else None,
        lifespan=lifespan,
    )

    # ─── CORS (mirrors V1 server.ts) ─────────────────────────────────────
    application.add_middleware(
        CORSMiddleware,
        allow_origins=[
            "http://localhost:3000",
            "http://localhost:3001",
            "http://localhost:3002",
        ],
        allow_origin_regex=r"https://(.*\.)?dittodatto\.no$",
        allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allow_headers=["Content-Type", "Authorization"],
    )

    # ─── Error Handler (replaces error-handler.ts) ───────────────────────
    @application.exception_handler(MercuryError)
    async def mercury_error_handler(_request: Request, exc: MercuryError) -> JSONResponse:
        return JSONResponse(
            status_code=exc.status_code,
            content={
                "error": exc.code,
                "message": exc.message,
                "details": exc.details,
            },
        )

    # ─── Routes ──────────────────────────────────────────────────────────
    application.include_router(health_router)
    application.include_router(establishments_router)
    application.include_router(services_router)
    application.include_router(staff_router)
    application.include_router(bookings_router)
    application.include_router(holds_router)
    application.include_router(admin_router)  # Always-on — middleware-protected (ADR-0011)

    # ─── Dev-only auth route (ADR-0010 §8) ───────────────────────────────
    if settings.is_development:
        from .routes.auth import router as auth_router

        application.include_router(auth_router)
        logger.info("🔓 Dev auth routes registered (POST /auth/dev-login)")

    @application.get("/")
    async def root() -> dict:
        """Root endpoint listing available routes."""
        return {
            "name": "MercuryEngine",
            "description": "Booking Engine for DittoDatto",
            "version": "2.0.0-alpha",
            "endpoints": {
                "health": "/health",
                "docs": "/docs" if settings.is_development else "(disabled)",
                "establishments": "/companies/{slug}/establishments",
                "services": "/companies/{slug}/services",
                "staff": "/companies/{slug}/staff",
                "bookings": "/companies/{slug}/bookings",
                "holds": "/companies/{slug}/holds",
                "admin": "/admin/*",
            },
        }

    return application


# Module-level app instance — used by `uvicorn mercury_engine.main:app`
app = create_app()


def main() -> None:
    """Entry point for `mercury-engine` CLI command."""
    import uvicorn

    logger.info("🚀 MercuryEngine starting on port %d", settings.port)
    logger.info("   Environment: %s", settings.environment)

    uvicorn.run(
        "mercury_engine.main:app",
        host="0.0.0.0",
        port=settings.port,
        reload=settings.is_development,
    )
