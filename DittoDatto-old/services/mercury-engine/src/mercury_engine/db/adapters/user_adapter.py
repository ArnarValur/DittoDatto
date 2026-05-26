"""SurrealDB adapter for user persistence (enceladus/users).

Unlike company-scoped adapters (which use titan/company_{slug}),
the user adapter operates on the pre-scoped enceladus connection.
"""

from __future__ import annotations

import logging

from surrealdb import AsyncSurreal

from mercury_core.models.user import User
from mercury_core.repositories.users import UserRepository
from mercury_engine.db.record import model_to_record, record_to_model

logger = logging.getLogger("mercury-engine.db.adapter.user")

TABLE = "user"


class SurrealUserRepo(UserRepository):
    """SurrealDB implementation of UserRepository.

    Uses the enceladus connection (pre-scoped to enceladus/users).
    """

    def __init__(self, db: AsyncSurreal) -> None:
        self._db = db

    async def get(self, id: str) -> User | None:
        """Fetch a user by SurrealDB record ID."""
        try:
            data = await self._db.select(f"{TABLE}:{id}")
        except Exception:
            return None

        if not data:
            return None
        if isinstance(data, list):
            data = data[0] if data else None
        if not data:
            return None

        return record_to_model(TABLE, data, User)

    async def list(self, **filters: object) -> list[User]:
        """List users (admin use only)."""
        result = await self._db.query(f"SELECT * FROM {TABLE}")
        return self._parse_result(result)

    async def create(self, entity: User) -> User:
        """Create a new user record."""
        data = model_to_record(entity, exclude_id=True, table=TABLE)
        result = await self._db.create(TABLE, data)
        if isinstance(result, list):
            result = result[0] if result else {}
        return record_to_model(TABLE, result, User)

    async def update(self, id: str, entity: User) -> User:
        """Update an existing user."""
        data = model_to_record(entity, exclude_id=True, table=TABLE)
        result = await self._db.merge(f"{TABLE}:{id}", data)
        if isinstance(result, list):
            result = result[0] if result else {}
        return record_to_model(TABLE, result, User)

    async def delete(self, id: str) -> bool:
        """Hard-delete a user (no soft-delete for PII — GDPR right to erasure)."""
        try:
            await self._db.delete(f"{TABLE}:{id}")
            return True
        except Exception:
            return False

    async def count(self, **filters: object) -> int:
        """Count users."""
        result = await self._db.query(f"SELECT count() AS total FROM {TABLE} GROUP ALL")
        data = self._extract_data(result)
        if data and isinstance(data, list) and data:
            return int(data[0].get("total", 0))
        return 0

    async def get_by_vipps_sub(self, vipps_sub: str) -> User | None:
        """Find a user by Vipps subject ID."""
        result = await self._db.query(
            f"SELECT * FROM {TABLE} WHERE vipps_sub = $sub LIMIT 1",
            {"sub": vipps_sub},
        )
        records = self._parse_result(result)
        return records[0] if records else None

    async def get_by_email(self, email: str) -> User | None:
        """Find a user by email address."""
        result = await self._db.query(
            f"SELECT * FROM {TABLE} WHERE email = $email LIMIT 1",
            {"email": email},
        )
        records = self._parse_result(result)
        return records[0] if records else None

    async def upsert(self, user: User) -> User:
        """Create or update a user by vipps_sub.

        If a user with this vipps_sub exists, merge new data.
        Otherwise, create a new record.
        """
        existing = await self.get_by_vipps_sub(user.vipps_sub)
        if existing and existing.id:
            return await self.update(existing.id, user)
        return await self.create(user)

    # ─── Internal helpers ────────────────────────────────────────────────

    def _parse_result(self, result: object) -> list[User]:
        """Parse a SurrealDB query result into User models."""
        data = self._extract_data(result)
        if not data or not isinstance(data, list):
            return []
        return [record_to_model(TABLE, row, User) for row in data]

    @staticmethod
    def _extract_data(result: object) -> list | None:
        """Extract data from SurrealDB response."""
        if not result:
            return None
        if isinstance(result, list):
            if result and hasattr(result[0], "result"):
                return result[0].result  # type: ignore[union-attr]
            return result
        if hasattr(result, "result"):
            return result.result  # type: ignore[union-attr]
        return None
