"""Service and ServiceGroup repository interfaces.

Source: schemas/company-blueprint.surql §1.2–1.3
Domain models: mercury_core/models/service.py
"""

from __future__ import annotations

from abc import abstractmethod

from mercury_core.models import Service, ServiceGroup

from .base import Repository


class ServiceRepository(Repository[Service]):
    """Repository for service aggregate root.

    Services belong to an establishment within a company database.
    Record link: service.establishment → record<establishment>.
    """

    @abstractmethod
    async def list_by_establishment(self, establishment_id: str) -> list[Service]:
        """List all non-deleted services for an establishment.

        Args:
            establishment_id: The establishment record ID (without table prefix).
        """

    @abstractmethod
    async def list_active_by_establishment(self, establishment_id: str) -> list[Service]:
        """List active, non-deleted services for an establishment.

        Filters: is_active=True AND deleted_at IS NONE AND establishment matches.
        Used by public booking flows.
        """


class ServiceGroupRepository(Repository[ServiceGroup]):
    """Repository for service group aggregate root.

    Groups organize services for the booking panel display.
    """

    @abstractmethod
    async def list_by_establishment(self, establishment_id: str) -> list[ServiceGroup]:
        """List all service groups for an establishment, ordered by sort_order."""
