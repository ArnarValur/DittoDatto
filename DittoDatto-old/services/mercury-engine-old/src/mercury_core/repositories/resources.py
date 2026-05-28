"""Resource and ResourceGroup repository interfaces.

Source: schemas/company-blueprint.surql §4.1–4.2
Domain models: mercury_core/models/resource.py
"""

from __future__ import annotations

from abc import abstractmethod

from mercury_core.models import Resource, ResourceGroup

from .base import Repository


class ResourceRepository(Repository[Resource]):
    """Repository for resource aggregate root.

    Resources are physical or logical assets (rooms, tables, stations, equipment).
    Used by the reservation engine for table allocation and best-fit matching.
    """

    @abstractmethod
    async def list_by_establishment(self, establishment_id: str) -> list[Resource]:
        """List all resources for an establishment."""

    @abstractmethod
    async def list_by_group(self, group_id: str) -> list[Resource]:
        """List resources belonging to a specific resource group.

        Used by the booking engine when a service requires specific resource groups.
        """

    @abstractmethod
    async def list_bookable_by_establishment(self, establishment_id: str) -> list[Resource]:
        """List bookable resources for an establishment.

        Filters: is_bookable=True AND establishment matches.
        Used by the reservation engine.
        """


class ResourceGroupRepository(Repository[ResourceGroup]):
    """Repository for resource group aggregate root.

    Groups organize resources (e.g., "Indoor Tables", "Outdoor Terrace").
    """

    @abstractmethod
    async def list_by_establishment(self, establishment_id: str) -> list[ResourceGroup]:
        """List all resource groups for an establishment, ordered by sort_order."""
