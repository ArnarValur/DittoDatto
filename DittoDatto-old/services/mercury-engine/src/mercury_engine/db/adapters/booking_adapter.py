"""SurrealDB adapter for Booking repository.

Source: schemas/company-blueprint.surql §2.1
"""

from __future__ import annotations

from datetime import datetime

from surrealdb import AsyncSurreal

from mercury_core.models import Booking
from mercury_core.repositories.bookings import BookingRepository
from mercury_engine.db.record import to_record_id

from .base_adapter import SurrealDBAdapter


class SurrealBookingRepo(SurrealDBAdapter[Booking], BookingRepository):
    """Concrete booking repository backed by SurrealDB."""

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "booking", Booking)

    async def list_by_establishment_and_date_range(
        self, establishment_id: str, start: datetime, end: datetime
    ) -> list[Booking]:
        """List bookings within a time range for occupancy calculations."""
        record_id = to_record_id("establishment", establishment_id)
        result = await self._db.query(
            "SELECT * FROM booking "
            "WHERE establishment = $est "
            "AND start_time >= $start AND start_time < $end "
            "AND deleted_at IS NONE "
            "ORDER BY start_time ASC",
            {"est": record_id, "start": start.isoformat(), "end": end.isoformat()},
        )
        return self._parse_query_result(result)

    async def list_by_user(self, user_id: str) -> list[Booking]:
        """List all bookings for a user, most recent first."""
        result = await self._db.query(
            "SELECT * FROM booking "
            "WHERE user_id = $uid AND deleted_at IS NONE "
            "ORDER BY start_time DESC",
            {"uid": user_id},
        )
        return self._parse_query_result(result)

    async def list_by_status(self, status: str) -> list[Booking]:
        """List bookings with a specific status for dashboards."""
        result = await self._db.query(
            "SELECT * FROM booking "
            "WHERE status = $status AND deleted_at IS NONE "
            "ORDER BY start_time ASC",
            {"status": status},
        )
        return self._parse_query_result(result)
