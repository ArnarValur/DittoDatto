"""Staff and DateOverride repository interfaces.

Source: schemas/company-blueprint.surql §1.4, §3.1
Domain models: mercury_core/models/staff.py
"""

from __future__ import annotations

from abc import abstractmethod

from mercury_core.models import DateOverride, Staff

from .base import Repository


class StaffRepository(Repository[Staff]):
    """Repository for staff aggregate root.

    Staff members can be assigned to multiple establishments within
    the same company database (store_ids array).
    """

    @abstractmethod
    async def list_by_establishment(self, establishment_id: str) -> list[Staff]:
        """List all non-deleted staff assigned to an establishment.

        Checks staff.store_ids array for the establishment record link.
        """

    @abstractmethod
    async def list_bookable(self, establishment_id: str) -> list[Staff]:
        """List bookable, non-deleted staff for an establishment.

        Filters: is_bookable=True AND store contains establishment AND deleted_at IS NONE.
        Used by the slot generation engine.
        """

    @abstractmethod
    async def get_by_email(self, email: str) -> Staff | None:
        """Find a staff member by email address.

        Emails are indexed but not unique (staff can exist across companies).
        Returns the first match, or None.
        """

    @abstractmethod
    async def get_by_user_id(self, user_id: str) -> Staff | None:
        """Find a staff member by their cross-DB user reference.

        user_id is a string reference to enceladus/users (cross-namespace).
        """


class DateOverrideRepository(Repository[DateOverride]):
    """Repository for staff date overrides.

    Separate table for scalability — staff accumulate overrides over years.
    Source: company-blueprint.surql §3.1
    """

    @abstractmethod
    async def list_by_staff(self, staff_id: str) -> list[DateOverride]:
        """List all overrides for a staff member."""

    @abstractmethod
    async def list_by_staff_and_range(
        self, staff_id: str, start_date: str, end_date: str
    ) -> list[DateOverride]:
        """List overrides for a staff member within a date range.

        Args:
            staff_id: Staff record ID (without table prefix).
            start_date: Start date inclusive (YYYY-MM-DD).
            end_date: End date inclusive (YYYY-MM-DD).

        Used by the availability engine to check for day-offs, sick days,
        and custom shift overrides within a booking window.
        """

    @abstractmethod
    async def get_by_staff_and_date(self, staff_id: str, date: str) -> DateOverride | None:
        """Get a specific override for a staff member on a date.

        The (staff, date) pair has a UNIQUE index in the schema.
        """
