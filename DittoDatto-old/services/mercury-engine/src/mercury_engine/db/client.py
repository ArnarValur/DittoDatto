"""SurrealDB dual-connection manager for MercuryEngine.

Manages two connections per ADR-0009 namespace architecture:
- titan: Company data (establishment, service, staff, booking, ...)
- enceladus: User PII (GDPR-isolated)

Connection lifecycle is tied to FastAPI's lifespan events.
Each company request scopes the titan connection to the correct database
via `db.use("titan", f"company_{slug}")`.

SurrealDB Python SDK: https://surrealdb.com/docs/sdk/python
"""

from __future__ import annotations

import logging

from surrealdb import AsyncSurreal

from mercury_engine.config import settings

logger = logging.getLogger("mercury-engine.db.client")


class SurrealDBClient:
    """Dual-connection SurrealDB client for MercuryEngine.

    Usage:
        client = SurrealDBClient()
        await client.connect()

        # Company-scoped operations
        db = await client.titan("sawasdee")
        result = await db.select("establishment")

        # User PII operations
        db = await client.enceladus()
        result = await db.select("user")

        await client.disconnect()
    """

    def __init__(self) -> None:
        self._titan_conn: AsyncSurreal | None = None
        self._enceladus_conn: AsyncSurreal | None = None
        self._connected = False

    @property
    def is_connected(self) -> bool:
        """Whether both connections are active."""
        return self._connected

    async def connect(self) -> None:
        """Open both SurrealDB connections and authenticate.

        Supports two auth modes:
        - Root: user="root" → signin without NS (global access), then scope via db.use()
        - Namespace: user="mercury" → signin with NS param (scoped access)

        Root mode is used for development. Namespace-level service accounts
        (defined in schemas/init.surql) are used in production.
        """
        url = settings.surrealdb_url

        logger.info("Connecting to SurrealDB at %s", url)

        # Titan connection (company data)
        self._titan_conn = AsyncSurreal(url)
        await self._titan_conn.connect()
        await self._titan_conn.signin(
            self._build_signin_params(
                settings.surrealdb_titan_user,
                settings.surrealdb_titan_password,
                namespace="titan",
            )
        )
        logger.info("✅ Titan connection established (namespace: titan)")

        # Enceladus connection (user PII)
        self._enceladus_conn = AsyncSurreal(url)
        await self._enceladus_conn.connect()
        await self._enceladus_conn.signin(
            self._build_signin_params(
                settings.surrealdb_enceladus_user,
                settings.surrealdb_enceladus_password,
                namespace="enceladus",
            )
        )
        await self._enceladus_conn.use("enceladus", "users")
        logger.info("✅ Enceladus connection established (database: enceladus/users)")

        self._connected = True
        logger.info("🚀 SurrealDB client ready — both connections active")

    @staticmethod
    def _build_signin_params(user: str, password: str, *, namespace: str) -> dict[str, str]:
        """Build signin params, omitting NS for root-level auth."""
        params = {"user": user, "password": password}
        if user != "root":
            params["NS"] = namespace
        return params

    async def disconnect(self) -> None:
        """Close both connections cleanly.

        Per SDB Agent guidance: always call close() during shutdown events.
        """
        if self._titan_conn:
            await self._titan_conn.close()
            self._titan_conn = None
            logger.info("Titan connection closed")

        if self._enceladus_conn:
            await self._enceladus_conn.close()
            self._enceladus_conn = None
            logger.info("Enceladus connection closed")

        self._connected = False
        logger.info("SurrealDB client disconnected")

    async def titan(self, company_slug: str) -> AsyncSurreal:
        """Get a titan connection scoped to a company database.

        Calls db.use("titan", f"company_{company_slug}") to scope
        all subsequent queries to the correct company database.

        Args:
            company_slug: The company URL slug (e.g., "sawasdee").

        Returns:
            An AsyncSurreal connection scoped to the company database.

        Raises:
            RuntimeError: If the client is not connected.
        """
        if not self._titan_conn:
            msg = "SurrealDB client not connected. Call connect() first."
            raise RuntimeError(msg)

        database = f"company_{company_slug}"
        await self._titan_conn.use("titan", database)
        return self._titan_conn

    async def enceladus(self) -> AsyncSurreal:
        """Get the enceladus/users connection for user PII operations.

        The connection is pre-scoped to enceladus/users during connect().

        Returns:
            An AsyncSurreal connection to enceladus/users.

        Raises:
            RuntimeError: If the client is not connected.
        """
        if not self._enceladus_conn:
            msg = "SurrealDB client not connected. Call connect() first."
            raise RuntimeError(msg)

        return self._enceladus_conn

    async def platform(self) -> AsyncSurreal:
        """Get titan connection scoped to the platform database.

        The platform database (titan/platform) holds the company registry,
        system alerts, icon collections, and audit logs.

        Returns:
            An AsyncSurreal connection scoped to titan/platform.

        Raises:
            RuntimeError: If the client is not connected.
        """
        if not self._titan_conn:
            msg = "SurrealDB client not connected. Call connect() first."
            raise RuntimeError(msg)

        await self._titan_conn.use("titan", "platform")
        return self._titan_conn

    async def discovery(self) -> AsyncSurreal:
        """Get titan connection scoped to the discovery database.

        The discovery database (titan/discovery) holds categories, areas,
        establishment listings, and search events.

        Returns:
            An AsyncSurreal connection scoped to titan/discovery.

        Raises:
            RuntimeError: If the client is not connected.
        """
        if not self._titan_conn:
            msg = "SurrealDB client not connected. Call connect() first."
            raise RuntimeError(msg)

        await self._titan_conn.use("titan", "discovery")
        return self._titan_conn

    async def health(self) -> dict:
        """Check both connections are alive.

        Returns a dict with connection status for monitoring.
        """
        result: dict[str, object] = {
            "connected": self._connected,
            "titan": False,
            "enceladus": False,
        }

        if self._titan_conn:
            try:
                await self._titan_conn.query("RETURN true")
                result["titan"] = True
            except Exception as e:
                logger.warning("Titan health check failed: %s", e)

        if self._enceladus_conn:
            try:
                await self._enceladus_conn.query("RETURN true")
                result["enceladus"] = True
            except Exception as e:
                logger.warning("Enceladus health check failed: %s", e)

        return result
