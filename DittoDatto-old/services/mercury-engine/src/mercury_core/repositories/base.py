"""Generic repository interface for aggregate root persistence.

Defines the standard CRUD contract that all domain repositories extend.
Concrete implementations (SurrealDB, in-memory for tests, etc.) implement
this interface without the domain layer knowing about persistence details.

Design decisions:
- Generic[T] for type safety across all aggregate roots
- All methods are async — persistence is inherently I/O
- Soft-delete pattern: delete() marks deleted_at, not physical removal
- Filters use **kwargs for flexibility at the interface level;
  concrete adapters define the supported filter keys
"""

from __future__ import annotations

from abc import ABC, abstractmethod
from typing import Generic, TypeVar

from mercury_core.models.common import MercuryModel

T = TypeVar("T", bound=MercuryModel)


class Repository(ABC, Generic[T]):
    """Base repository contract for aggregate root persistence.

    Every domain entity with its own table gets a repository that extends
    this interface with domain-specific query methods.
    """

    @abstractmethod
    async def get(self, id: str) -> T | None:
        """Fetch a single entity by ID.

        Returns None if not found or soft-deleted.
        """

    @abstractmethod
    async def list(self, **filters: object) -> list[T]:
        """List entities matching the given filters.

        Always excludes soft-deleted records (deleted_at IS NONE).
        Concrete repositories define which filter keys are supported.
        """

    @abstractmethod
    async def create(self, entity: T) -> T:
        """Persist a new entity.

        Returns the entity with server-generated fields populated
        (id, created_at, updated_at).
        """

    @abstractmethod
    async def update(self, id: str, entity: T) -> T:
        """Update an existing entity.

        Returns the updated entity with refreshed updated_at.
        Raises NotFoundError if the entity doesn't exist.
        """

    @abstractmethod
    async def delete(self, id: str) -> bool:
        """Soft-delete an entity by setting deleted_at.

        Returns True if the entity was found and marked deleted,
        False if it was already deleted or not found.
        """

    @abstractmethod
    async def count(self, **filters: object) -> int:
        """Count entities matching the given filters.

        Always excludes soft-deleted records.
        """
