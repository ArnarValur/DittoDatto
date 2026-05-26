"""Booking repository interface.

Source: schemas/company-blueprint.surql §2.1
Domain model: mercury_core/models/booking.py
"""

from __future__ import annotations

from abc import abstractmethod
from datetime import datetime

from mercury_core.models import Booking

from .base import Repository


class BookingRepository(Repository[Booking]):
    """Repository for booking aggregate root.

    Bookings are the core transactional entity. Fiscal snapshot fields
    (service_title, price_at_booking) are immutable once created.
    """

    @abstractmethod
    async def list_by_establishment_and_date_range(
        self, establishment_id: str, start: datetime, end: datetime
    ) -> list[Booking]:
        """List bookings for an establishment within a time range.

        Used by the availability engine to calculate occupancy maps.
        Includes all statuses (confirmed, pending, completed) — caller
        filters by status as needed.

        Args:
            establishment_id: Establishment record ID (without table prefix).
            start: Range start (inclusive).
            end: Range end (exclusive).
        """

    @abstractmethod
    async def list_by_user(self, user_id: str) -> list[Booking]:
        """List all bookings for a user (across all establishments in this company).

        Used for "My Bookings" views. Returns most recent first.
        """

    @abstractmethod
    async def list_by_status(self, status: str) -> list[Booking]:
        """List bookings with a specific status.

        Used for operational dashboards (e.g., pending bookings).
        """
