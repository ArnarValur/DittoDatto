"""Integration tests for Staff adapter against live SurrealDB.

Tests CRUD plus:
- store_ids as array<record<establishment>>
- list_by_establishment filtering
- bookable staff filtering
"""

from __future__ import annotations

import pytest

from mercury_core.models import Establishment, Staff
from mercury_engine.dependencies import CompanyRepos

pytestmark = [
    pytest.mark.integration,
    pytest.mark.asyncio(loop_scope="session"),
]


async def create_establishment(repos: CompanyRepos, slug: str) -> Establishment:
    """Create a test establishment."""
    return await repos.establishments.create(
        Establishment(
            name=f"Est {slug}",
            slug=slug,
            address="Test St",
            city="Oslo",
            zip="0100",
            is_published=True,
            is_active=True,
        )
    )


async def test_create_and_read_staff(repos: CompanyRepos):
    """Basic CRUD: create a staff member, read back by ID."""
    created = await repos.staff.create(
        Staff(
            email="alice@test.no",
            display_name="Alice Nordmann",
            is_bookable=True,
            position="Therapist",
        )
    )

    assert created.id is not None
    assert created.email == "alice@test.no"
    assert created.display_name == "Alice Nordmann"
    assert created.is_bookable is True

    fetched = await repos.staff.get(created.id)
    assert fetched is not None
    assert fetched.display_name == "Alice Nordmann"


async def test_staff_store_ids_links(repos: CompanyRepos):
    """staff.store_ids is array<record<establishment>> — verify round-trip."""
    est_a = await create_establishment(repos, "est-a")
    est_b = await create_establishment(repos, "est-b")

    staff = await repos.staff.create(
        Staff(
            email="multi@test.no",
            display_name="Multi Store Staff",
            store_ids=[
                f"establishment:{est_a.id}",
                f"establishment:{est_b.id}",
            ],
        )
    )

    assert len(staff.store_ids) == 2

    fetched = await repos.staff.get(staff.id)
    assert fetched is not None
    assert len(fetched.store_ids) == 2
    ids_in_links = {link.split(":")[-1] for link in fetched.store_ids}
    assert est_a.id in ids_in_links
    assert est_b.id in ids_in_links


async def test_list_by_establishment(repos: CompanyRepos):
    """Filter staff by establishment ID."""
    est = await create_establishment(repos, "filter-est")

    await repos.staff.create(
        Staff(
            email="here@test.no",
            display_name="Here Staff",
            store_ids=[f"establishment:{est.id}"],
        )
    )
    await repos.staff.create(
        Staff(
            email="elsewhere@test.no",
            display_name="Elsewhere Staff",
            store_ids=[],
        )
    )

    filtered = await repos.staff.list_by_establishment(est.id)
    assert len(filtered) == 1
    assert filtered[0].display_name == "Here Staff"


async def test_bookable_staff(repos: CompanyRepos):
    """list_bookable should return only is_bookable=True staff for an establishment."""
    est = await create_establishment(repos, "bookable-est")

    await repos.staff.create(
        Staff(
            email="bookable@test.no",
            display_name="Bookable",
            is_bookable=True,
            store_ids=[f"establishment:{est.id}"],
        )
    )
    await repos.staff.create(
        Staff(
            email="not@test.no",
            display_name="Not Bookable",
            is_bookable=False,
            store_ids=[f"establishment:{est.id}"],
        )
    )

    bookable = await repos.staff.list_bookable(est.id)
    assert len(bookable) == 1
    assert bookable[0].display_name == "Bookable"


async def test_soft_delete_staff(repos: CompanyRepos):
    """Soft delete sets deleted_at; get() returns None."""
    staff = await repos.staff.create(
        Staff(email="delete@test.no", display_name="Delete Me")
    )

    await repos.staff.delete(staff.id)
    assert await repos.staff.get(staff.id) is None


async def test_update_staff(repos: CompanyRepos):
    """Update staff fields via merge."""
    created = await repos.staff.create(
        Staff(
            email="update@test.no",
            display_name="Before",
            position="Junior",
        )
    )

    updated = await repos.staff.update(
        created.id,
        Staff(
            email="update@test.no",
            display_name="After",
            position="Senior",
        ),
    )

    assert updated.display_name == "After"
    assert updated.position == "Senior"
