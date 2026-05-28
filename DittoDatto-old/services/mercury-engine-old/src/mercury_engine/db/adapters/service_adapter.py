"""SurrealDB adapters for Service and ServiceGroup repositories.

Source: schemas/company-blueprint.surql §1.2–1.3
"""

from __future__ import annotations

from surrealdb import AsyncSurreal

from mercury_core.models import Service, ServiceGroup
from mercury_core.repositories.services import ServiceGroupRepository, ServiceRepository
from mercury_engine.db.record import to_record_id

from .base_adapter import SurrealDBAdapter


class SurrealServiceRepo(SurrealDBAdapter[Service], ServiceRepository):
    """Concrete service repository backed by SurrealDB."""

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "service", Service)

    async def list_by_establishment(self, establishment_id: str) -> list[Service]:
        """List all non-deleted services for an establishment."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM service "
            "WHERE establishment = $est AND deleted_at IS NONE",
            {"est": record_id},
        )
        return self._parse_query_result(result)

    async def list_active_by_establishment(self, establishment_id: str) -> list[Service]:
        """List active, non-deleted services for public booking flows."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM service "
            "WHERE establishment = $est AND is_active = true AND deleted_at IS NONE",
            {"est": record_id},
        )
        return self._parse_query_result(result)


class SurrealServiceGroupRepo(SurrealDBAdapter[ServiceGroup], ServiceGroupRepository):
    """Concrete service group repository backed by SurrealDB."""

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "service_group", ServiceGroup)

    async def list_by_establishment(self, establishment_id: str) -> list[ServiceGroup]:
        """List service groups ordered by sort_order."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM service_group "
            "WHERE establishment = $est AND deleted_at IS NONE "
            "ORDER BY sort_order ASC",
            {"est": record_id},
        )
        return self._parse_query_result(result)
