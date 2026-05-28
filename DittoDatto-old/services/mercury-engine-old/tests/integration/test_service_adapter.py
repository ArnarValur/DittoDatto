"""Integration tests for Service adapter — record link validation.

Tests CRUD plus the critical record link serialization:
- establishment (single record<establishment>)
- group (optional record<service_group>)
- assigned_staff (array<record<staff>>)
- required_resource_groups (array<record<resource_group>>)
"""

from __future__ import annotations

import pytest

from mercury_core.models import Establishment, Service, Staff
from mercury_engine.dependencies import CompanyRepos

pytestmark = [
    pytest.mark.integration,
    pytest.mark.asyncio(loop_scope="session"),
]


# ─── Helpers ─────────────────────────────────────────────────────────────────


async def create_establishment(repos: CompanyRepos, slug: str = "test-spa") -> Establishment:
    """Create a test establishment and return it with its ID."""
    return await repos.establishments.create(
        Establishment(
            name="Test Spa",
            slug=slug,
            address="Test St 1",
            city="Oslo",
            zip="0100",
            is_published=True,
            is_active=True,
        )
    )


async def create_staff(repos: CompanyRepos, name: str = "Test Staff") -> Staff:
    """Create a test staff member."""
    return await repos.staff.create(
        Staff(
            email=f"{name.lower().replace(' ', '.')}@test.no",
            display_name=name,
            is_bookable=True,
        )
    )


# ─── CRUD Tests ──────────────────────────────────────────────────────────────


async def test_create_service_with_establishment_link(repos: CompanyRepos):
    """Service.establishment is a record<establishment> — verify round-trip."""
    est = await create_establishment(repos)

    service = await repos.services.create(
        Service(
            establishment=f"establishment:{est.id}",
            title="Thai Massage",
            duration=60,
            price=599.0,
        )
    )

    assert service.id is not None
    assert service.title == "Thai Massage"
    assert service.duration == 60
    assert service.price == 599.0

    # Record link should come back as "establishment:xxx" string
    assert est.id in service.establishment

    # Read back by ID
    fetched = await repos.services.get(service.id)
    assert fetched is not None
    assert fetched.title == "Thai Massage"
    assert est.id in fetched.establishment


async def test_list_by_establishment(repos: CompanyRepos):
    """Filter services by establishment ID."""
    est_a = await create_establishment(repos, slug="spa-a")
    est_b = await create_establishment(repos, slug="spa-b")

    await repos.services.create(
        Service(
            establishment=f"establishment:{est_a.id}",
            title="Service A1",
            duration=30,
            price=100,
        )
    )
    await repos.services.create(
        Service(
            establishment=f"establishment:{est_a.id}",
            title="Service A2",
            duration=30,
            price=200,
        )
    )
    await repos.services.create(
        Service(
            establishment=f"establishment:{est_b.id}",
            title="Service B1",
            duration=45,
            price=300,
        )
    )

    services_a = await repos.services.list_active_by_establishment(est_a.id)
    assert len(services_a) == 2
    titles = {s.title for s in services_a}
    assert titles == {"Service A1", "Service A2"}

    services_b = await repos.services.list_active_by_establishment(est_b.id)
    assert len(services_b) == 1
    assert services_b[0].title == "Service B1"


async def test_assigned_staff_array_links(repos: CompanyRepos):
    """Service.assigned_staff is array<record<staff>> — verify round-trip."""
    est = await create_establishment(repos)
    staff_a = await create_staff(repos, "Alice")
    staff_b = await create_staff(repos, "Bob")

    service = await repos.services.create(
        Service(
            establishment=f"establishment:{est.id}",
            title="Group Massage",
            duration=90,
            price=899.0,
            assigned_staff=[
                f"staff:{staff_a.id}",
                f"staff:{staff_b.id}",
            ],
        )
    )

    assert len(service.assigned_staff) == 2

    # Read back — staff links should survive the round-trip
    fetched = await repos.services.get(service.id)
    assert fetched is not None
    assert len(fetched.assigned_staff) == 2
    # Each element should contain the staff ID
    staff_ids_in_links = {link.split(":")[-1] for link in fetched.assigned_staff}
    assert staff_a.id in staff_ids_in_links
    assert staff_b.id in staff_ids_in_links


async def test_optional_record_link_none(repos: CompanyRepos):
    """Service.group (optional record<service_group>) can be None."""
    est = await create_establishment(repos)

    service = await repos.services.create(
        Service(
            establishment=f"establishment:{est.id}",
            title="Solo Service",
            duration=30,
            price=100,
            group=None,
        )
    )

    fetched = await repos.services.get(service.id)
    assert fetched is not None
    assert fetched.group is None


async def test_update_service(repos: CompanyRepos):
    """Update a service and verify fields are merged."""
    est = await create_establishment(repos)

    created = await repos.services.create(
        Service(
            establishment=f"establishment:{est.id}",
            title="Original Title",
            duration=30,
            price=100,
        )
    )

    updated = await repos.services.update(
        created.id,
        Service(
            establishment=f"establishment:{est.id}",
            title="Updated Title",
            duration=45,
            price=200,
        ),
    )

    assert updated.title == "Updated Title"
    assert updated.duration == 45
    assert updated.price == 200.0


async def test_soft_delete_service(repos: CompanyRepos):
    """Soft-delete a service — it should disappear from active lists."""
    est = await create_establishment(repos)

    svc = await repos.services.create(
        Service(
            establishment=f"establishment:{est.id}",
            title="Delete Me",
            duration=30,
            price=100,
        )
    )

    await repos.services.delete(svc.id)
    assert await repos.services.get(svc.id) is None

    active = await repos.services.list_active_by_establishment(est.id)
    assert len(active) == 0
