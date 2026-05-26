"""SurrealDB adapters for Resource and ResourceGroup repositories.

Source: schemas/company-blueprint.surql §4.1–4.2
"""

from __future__ import annotations

from surrealdb import AsyncSurreal

from mercury_core.models import Resource, ResourceGroup
from mercury_core.repositories.resources import ResourceGroupRepository, ResourceRepository
from mercury_engine.db.record import to_record_id

from .base_adapter import SurrealDBAdapter


class SurrealResourceRepo(SurrealDBAdapter[Resource], ResourceRepository):
    """Concrete resource repository backed by SurrealDB."""

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "resource", Resource)

    async def list_by_establishment(self, establishment_id: str) -> list[Resource]:
        """List all resources for an establishment."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM resource WHERE establishment = $est",
            {"est": record_id},
        )
        return self._parse_query_result(result)

    async def list_by_group(self, group_id: str) -> list[Resource]:
        """List resources in a specific resource group."""
        record_id = to_record_id("resource_group", group_id)
        result = await self._db.query(
            "SELECT * FROM resource WHERE resource_group = $grp",
            {"grp": record_id},
        )
        return self._parse_query_result(result)

    async def list_bookable_by_establishment(self, establishment_id: str) -> list[Resource]:
        """List bookable resources for the reservation engine."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM resource "
            "WHERE establishment = $est AND is_bookable = true "
            "ORDER BY priority DESC, sort_order ASC",
            {"est": record_id},
        )
        return self._parse_query_result(result)


class SurrealResourceGroupRepo(SurrealDBAdapter[ResourceGroup], ResourceGroupRepository):
    """Concrete resource group repository backed by SurrealDB."""

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "resource_group", ResourceGroup)

    async def list_by_establishment(self, establishment_id: str) -> list[ResourceGroup]:
        """List resource groups ordered by sort_order."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM resource_group "
            "WHERE establishment = $est "
            "ORDER BY sort_order ASC",
            {"est": record_id},
        )
        return self._parse_query_result(result)
