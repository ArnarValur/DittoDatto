"""SurrealDB adapter for Establishment repository.

Source: schemas/company-blueprint.surql §1.1
"""

from __future__ import annotations

from surrealdb import AsyncSurreal

from mercury_core.models import Establishment
from mercury_core.repositories.establishments import EstablishmentRepository

from .base_adapter import SurrealDBAdapter


class SurrealEstablishmentRepo(SurrealDBAdapter[Establishment], EstablishmentRepository):
    """Concrete establishment repository backed by SurrealDB."""

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "establishment", Establishment)

    async def get_by_slug(self, slug: str) -> Establishment | None:
        """Find establishment by URL slug (UNIQUE index)."""
        result = await self._db.query(
            "SELECT * FROM establishment WHERE slug = $slug AND deleted_at IS NONE",
            {"slug": slug},
        )
        records = self._parse_query_result(result)
        return records[0] if records else None

    async def list_active(self) -> list[Establishment]:
        """List active, non-deleted establishments."""
        result = await self._db.query(
            "SELECT * FROM establishment WHERE is_active = true AND deleted_at IS NONE"
        )
        return self._parse_query_result(result)

    async def list_published(self) -> list[Establishment]:
        """List published, active establishments for public discovery."""
        result = await self._db.query(
            "SELECT * FROM establishment "
            "WHERE is_published = true AND is_active = true AND deleted_at IS NONE"
        )
        return self._parse_query_result(result)
