"""Establishment repository interface.

Source: schemas/company-blueprint.surql §1.1
Domain model: mercury_core/models/establishment.py
"""

from __future__ import annotations

from abc import abstractmethod

from mercury_core.models import Establishment

from .base import Repository


class EstablishmentRepository(Repository[Establishment]):
    """Repository for establishment aggregate root.

    Each establishment belongs to a company database (titan/company_{slug}).
    The repository is always scoped to a single company DB — no cross-company queries.
    """

    @abstractmethod
    async def get_by_slug(self, slug: str) -> Establishment | None:
        """Find an establishment by its URL slug.

        Slugs are unique within a company database (UNIQUE index in schema).
        Returns None if not found or soft-deleted.
        """

    @abstractmethod
    async def list_active(self) -> list[Establishment]:
        """List all active, non-deleted establishments.

        Filters: is_active=True AND deleted_at IS NONE.
        """

    @abstractmethod
    async def list_published(self) -> list[Establishment]:
        """List all published, active establishments.

        Filters: is_published=True AND is_active=True AND deleted_at IS NONE.
        Used by public-facing endpoints (discovery, marketplace).
        """
