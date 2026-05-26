"""SurrealDB adapters for Staff and DateOverride repositories.

Source: schemas/company-blueprint.surql §1.4, §3.1
"""

from __future__ import annotations

from surrealdb import AsyncSurreal

from mercury_core.models import DateOverride, Staff
from mercury_core.repositories.staff import DateOverrideRepository, StaffRepository
from mercury_engine.db.record import to_record_id

from .base_adapter import SurrealDBAdapter


class SurrealStaffRepo(SurrealDBAdapter[Staff], StaffRepository):
    """Concrete staff repository backed by SurrealDB."""

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "staff", Staff)

    async def list_by_establishment(self, establishment_id: str) -> list[Staff]:
        """List staff assigned to an establishment via store_ids array."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM staff "
            "WHERE $est IN store_ids AND deleted_at IS NONE",
            {"est": record_id},
        )
        return self._parse_query_result(result)

    async def list_bookable(self, establishment_id: str) -> list[Staff]:
        """List bookable staff for the slot generation engine."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM staff "
            "WHERE $est IN store_ids AND is_bookable = true AND deleted_at IS NONE",
            {"est": record_id},
        )
        return self._parse_query_result(result)

    async def get_by_email(self, email: str) -> Staff | None:
        """Find staff by email (indexed field)."""
        result = await self._db.query(
            "SELECT * FROM staff WHERE email = $email AND deleted_at IS NONE",
            {"email": email},
        )
        records = self._parse_query_result(result)
        return records[0] if records else None

    async def get_by_user_id(self, user_id: str) -> Staff | None:
        """Find staff by cross-DB user reference (enceladus/users)."""
        result = await self._db.query(
            "SELECT * FROM staff WHERE user_id = $uid AND deleted_at IS NONE",
            {"uid": user_id},
        )
        records = self._parse_query_result(result)
        return records[0] if records else None


class SurrealDateOverrideRepo(SurrealDBAdapter[DateOverride], DateOverrideRepository):
    """Concrete date override repository backed by SurrealDB."""

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "date_override", DateOverride)

    async def list_by_staff(self, staff_id: str) -> list[DateOverride]:
        """List all overrides for a staff member."""
        record_id = to_record_id("staff", staff_id)
        result = await self._db.query(
            "SELECT * FROM date_override WHERE staff = $staff",
            {"staff": record_id},
        )
        return self._parse_query_result(result)

    async def list_by_staff_and_range(
        self, staff_id: str, start_date: str, end_date: str
    ) -> list[DateOverride]:
        """List overrides within a date range for availability calculations."""
        record_id = to_record_id("staff", staff_id)
        result = await self._db.query(
            "SELECT * FROM date_override "
            "WHERE staff = $staff AND date >= $start AND date <= $end",
            {"staff": record_id, "start": start_date, "end": end_date},
        )
        return self._parse_query_result(result)

    async def get_by_staff_and_date(self, staff_id: str, date: str) -> DateOverride | None:
        """Get specific override (UNIQUE index on staff+date)."""
        record_id = to_record_id("staff", staff_id)
        result = await self._db.query(
            "SELECT * FROM date_override WHERE staff = $staff AND date = $date",
            {"staff": record_id, "date": date},
        )
        records = self._parse_query_result(result)
        return records[0] if records else None
