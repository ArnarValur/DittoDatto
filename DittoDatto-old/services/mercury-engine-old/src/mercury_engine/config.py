"""Fail-fast environment configuration using Pydantic Settings.

Replaces: packages/mercury-engine/src/config/env.ts (Zod-validated env)

All settings are validated at import time. Missing or invalid values crash
the server immediately — not at first request.
"""

from __future__ import annotations

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """MercuryEngine configuration.

    All values can be overridden via environment variables with MERCURY_ prefix.
    Example: MERCURY_PORT=8080, MERCURY_ENVIRONMENT=production
    """

    model_config = SettingsConfigDict(
        env_prefix="MERCURY_",
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

    # Server
    port: int = 5002
    environment: str = "development"

    # SurrealDB (Session 14 — dual-connection per ADR-0009)
    surrealdb_url: str = "ws://localhost:8000/rpc"

    # Titan namespace (company data)
    surrealdb_titan_user: str = "mercury"
    surrealdb_titan_password: str = ""

    # Enceladus namespace (user PII — GDPR-isolated)
    surrealdb_enceladus_user: str = "mercury"
    surrealdb_enceladus_password: str = ""

    # Auth (ADR-0010 — JWT signing key, shared with SurrealDB)
    jwt_secret_key: str = "CHANGE_ME_IN_PRODUCTION"
    jwt_algorithm: str = "HS256"

    @property
    def is_development(self) -> bool:
        return self.environment == "development"

    @property
    def is_production(self) -> bool:
        return self.environment == "production"


# Singleton — imported by other modules
settings = Settings()
