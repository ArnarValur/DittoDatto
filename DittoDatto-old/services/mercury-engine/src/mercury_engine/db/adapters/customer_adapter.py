"""SurrealDB adapter for Customer repository.

Source: schemas/company-blueprint.surql §1.5

Customers are cross-DB projections from enceladus/users.
Direction: enceladus → company_X. Never reverse.
"""

from __future__ import annotations

from surrealdb import AsyncSurreal

from mercury_core.models import Customer
from mercury_core.repositories.customers import CustomerRepository
from mercury_engine.db.record import to_record_id

from .base_adapter import SurrealDBAdapter


class SurrealCustomerRepo(SurrealDBAdapter[Customer], CustomerRepository):
    """Concrete customer repository backed by SurrealDB."""

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "customer", Customer)

    async def get_by_email(self, email: str) -> Customer | None:
        """Find customer by email (indexed field)."""
        result = await self._db.query(
            "SELECT * FROM customer WHERE email = $email AND deleted_at IS NONE",
            {"email": email},
        )
        records = self._parse_query_result(result)
        return records[0] if records else None

    async def get_by_user_id(self, user_id: str) -> Customer | None:
        """Find customer by cross-DB user reference."""
        result = await self._db.query(
            "SELECT * FROM customer WHERE user_id = $uid AND deleted_at IS NONE",
            {"uid": user_id},
        )
        records = self._parse_query_result(result)
        return records[0] if records else None

    async def list_by_establishment(self, establishment_id: str) -> list[Customer]:
        """List customers associated with an establishment."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM customer "
            "WHERE $est IN store_ids AND deleted_at IS NONE",
            {"est": record_id},
        )
        return self._parse_query_result(result)
