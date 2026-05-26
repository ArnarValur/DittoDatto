"""SurrealDB adapter for Hold repository.

Source: schemas/company-blueprint.surql §2.2

Holds are transient — they use hard delete, not soft-delete.
"""

from __future__ import annotations

from surrealdb import AsyncSurreal

from mercury_core.models import Hold
from mercury_core.repositories.holds import HoldRepository
from mercury_engine.db.record import to_record_id

from .base_adapter import SurrealDBAdapter


class SurrealHoldRepo(SurrealDBAdapter[Hold], HoldRepository):
    """Concrete hold repository backed by SurrealDB.

    Overrides the base delete() to use hard delete — holds are transient
    slot locks, not business records needing audit trails.
    """

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "hold", Hold)

    async def list(self, **filters: object) -> list[Hold]:
        """List holds (no soft-delete filter — holds don't have deleted_at)."""
        query = "SELECT * FROM hold"
        bindings: dict[str, object] = {}

        first = True
        for key, value in filters.items():
            query += f" {'WHERE' if first else 'AND'} {key} = ${key}"
            bindings[key] = value
            first = False

        result = await self._db.query(query, bindings)
        return self._parse_query_result(result)

    async def delete(self, id: str) -> bool:
        """Hard delete — holds are transient, no need for soft-delete."""
        record_id = to_record_id("hold", id)
        await self._db.delete(record_id)
        return True

    async def list_active_by_establishment(self, establishment_id: str) -> list[Hold]:
        """List non-expired holds for availability calculations."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM hold "
            "WHERE establishment = $est AND expires_at > time::now()",
            {"est": record_id},
        )
        return self._parse_query_result(result)

    async def list_by_date(self, establishment_id: str, date: str) -> list[Hold]:
        """List holds for a specific date."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM hold WHERE establishment = $est AND date = $date",
            {"est": record_id, "date": date},
        )
        return self._parse_query_result(result)

    async def delete_expired(self) -> int:
        """Hard delete all expired holds. Returns count deleted."""
        result = await self._db.query(
            "DELETE FROM hold WHERE expires_at <= time::now() RETURN BEFORE"
        )
        data = self._extract_result_data(result)
        return len(data) if data else 0
