"""Hold repository interface.

Source: schemas/company-blueprint.surql §2.2
Domain model: mercury_core/models/hold.py

Holds are transient slot locks with TTL. MercuryEngine manages expiration.
"""

from __future__ import annotations

from abc import abstractmethod

from mercury_core.models import Hold

from .base import Repository


class HoldRepository(Repository[Hold]):
    """Repository for hold aggregate root.

    Holds lock time slots temporarily while a user completes booking.
    TTL-managed: expired holds should be cleaned up periodically.
    """

    @abstractmethod
    async def list_active_by_establishment(self, establishment_id: str) -> list[Hold]:
        """List all non-expired holds for an establishment.

        Filters: expires_at > now() AND establishment matches.
        Used by the slot engine to exclude held slots from availability.
        """

    @abstractmethod
    async def list_by_date(self, establishment_id: str, date: str) -> list[Hold]:
        """List holds for a specific date at an establishment.

        Args:
            establishment_id: Establishment record ID (without table prefix).
            date: Date string (YYYY-MM-DD).
        """

    @abstractmethod
    async def delete_expired(self) -> int:
        """Remove all holds past their expires_at.

        Returns the count of expired holds deleted.
        This is a hard delete (not soft-delete) — holds are transient.
        """
