"""Tests for repository ABCs — verify interface contracts and type compliance.

These tests verify that:
1. Repository ABCs can't be instantiated directly (abstract)
2. Concrete implementations must implement all required methods
3. The package exports are correct and importable
"""

from __future__ import annotations

from datetime import datetime

import pytest

from mercury_core.models import (
    Booking,
    Establishment,
)
from mercury_core.repositories import (
    BookingRepository,
    CustomerRepository,
    DateOverrideRepository,
    EstablishmentRepository,
    HoldRepository,
    Repository,
    ResourceGroupRepository,
    ResourceRepository,
    ServiceGroupRepository,
    ServiceRepository,
    StaffRepository,
)

# =============================================================================
# Test: ABCs cannot be instantiated
# =============================================================================


class TestABCsAreAbstract:
    """Verify that all repository ABCs raise TypeError on direct instantiation."""

    def test_base_repository_is_abstract(self):
        with pytest.raises(TypeError):
            Repository()  # type: ignore[abstract]

    def test_establishment_repository_is_abstract(self):
        with pytest.raises(TypeError):
            EstablishmentRepository()  # type: ignore[abstract]

    def test_service_repository_is_abstract(self):
        with pytest.raises(TypeError):
            ServiceRepository()  # type: ignore[abstract]

    def test_service_group_repository_is_abstract(self):
        with pytest.raises(TypeError):
            ServiceGroupRepository()  # type: ignore[abstract]

    def test_staff_repository_is_abstract(self):
        with pytest.raises(TypeError):
            StaffRepository()  # type: ignore[abstract]

    def test_date_override_repository_is_abstract(self):
        with pytest.raises(TypeError):
            DateOverrideRepository()  # type: ignore[abstract]

    def test_booking_repository_is_abstract(self):
        with pytest.raises(TypeError):
            BookingRepository()  # type: ignore[abstract]

    def test_hold_repository_is_abstract(self):
        with pytest.raises(TypeError):
            HoldRepository()  # type: ignore[abstract]

    def test_resource_repository_is_abstract(self):
        with pytest.raises(TypeError):
            ResourceRepository()  # type: ignore[abstract]

    def test_resource_group_repository_is_abstract(self):
        with pytest.raises(TypeError):
            ResourceGroupRepository()  # type: ignore[abstract]

    def test_customer_repository_is_abstract(self):
        with pytest.raises(TypeError):
            CustomerRepository()  # type: ignore[abstract]


# =============================================================================
# Test: Concrete implementations must fulfill the full contract
# =============================================================================


class ConcreteEstablishmentRepo(EstablishmentRepository):
    """Minimal concrete implementation for testing contract compliance."""

    async def get(self, id: str) -> Establishment | None:
        return None

    async def list(self, **filters: object) -> list[Establishment]:
        return []

    async def create(self, entity: Establishment) -> Establishment:
        return entity

    async def update(self, id: str, entity: Establishment) -> Establishment:
        return entity

    async def delete(self, id: str) -> bool:
        return True

    async def count(self, **filters: object) -> int:
        return 0

    async def get_by_slug(self, slug: str) -> Establishment | None:
        return None

    async def list_active(self) -> list[Establishment]:
        return []

    async def list_published(self) -> list[Establishment]:
        return []


class ConcreteBookingRepo(BookingRepository):
    """Minimal concrete implementation for testing contract compliance."""

    async def get(self, id: str) -> Booking | None:
        return None

    async def list(self, **filters: object) -> list[Booking]:
        return []

    async def create(self, entity: Booking) -> Booking:
        return entity

    async def update(self, id: str, entity: Booking) -> Booking:
        return entity

    async def delete(self, id: str) -> bool:
        return True

    async def count(self, **filters: object) -> int:
        return 0

    async def list_by_establishment_and_date_range(
        self, establishment_id: str, start: datetime, end: datetime
    ) -> list[Booking]:
        return []

    async def list_by_user(self, user_id: str) -> list[Booking]:
        return []

    async def list_by_status(self, status: str) -> list[Booking]:
        return []


class TestConcreteImplementations:
    """Verify that concrete implementations can be instantiated and satisfy isinstance checks."""

    def test_concrete_establishment_repo_is_repository(self):
        repo = ConcreteEstablishmentRepo()
        assert isinstance(repo, Repository)
        assert isinstance(repo, EstablishmentRepository)

    def test_concrete_booking_repo_is_repository(self):
        repo = ConcreteBookingRepo()
        assert isinstance(repo, Repository)
        assert isinstance(repo, BookingRepository)

    async def test_concrete_establishment_crud(self):
        repo = ConcreteEstablishmentRepo()
        assert await repo.get("test") is None
        assert await repo.list() == []
        assert await repo.count() == 0
        assert await repo.get_by_slug("test") is None
        assert await repo.list_active() == []
        assert await repo.list_published() == []

    async def test_concrete_booking_crud(self):
        repo = ConcreteBookingRepo()
        assert await repo.get("test") is None
        assert await repo.list_by_user("user1") == []
        assert await repo.list_by_status("confirmed") == []


# =============================================================================
# Test: Package exports
# =============================================================================


class TestPackageExports:
    """Verify that all expected symbols are importable from the package."""

    def test_all_repositories_importable(self):
        """Every repository ABC should be importable from mercury_core.repositories."""
        from mercury_core.repositories import (  # noqa: F811
            BookingRepository,
            CustomerRepository,
            DateOverrideRepository,
            EstablishmentRepository,
            HoldRepository,
            Repository,
            ResourceGroupRepository,
            ResourceRepository,
            ServiceGroupRepository,
            ServiceRepository,
            StaffRepository,
        )

        # Verify they're all ABCs (have abstract methods)
        repos = [
            Repository,
            EstablishmentRepository,
            ServiceRepository,
            ServiceGroupRepository,
            StaffRepository,
            DateOverrideRepository,
            BookingRepository,
            HoldRepository,
            ResourceRepository,
            ResourceGroupRepository,
            CustomerRepository,
        ]
        for repo_cls in repos:
            assert hasattr(repo_cls, "__abstractmethods__")
