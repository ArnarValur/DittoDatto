"""Integration tests for Hold adapter — hard delete + record links.

Holds are transient slot locks:
- No soft-delete (hard delete only)
- Record links: establishment, services[], staff, resource
- TTL expiry via expires_at
"""

from __future__ import annotations

from datetime import UTC, datetime, timedelta

import pytest

from mercury_core.models import Establishment, Hold, Service, Staff
from mercury_engine.dependencies import CompanyRepos

pytestmark = [
    pytest.mark.integration,
    pytest.mark.asyncio(loop_scope="session"),
]


async def create_establishment(repos: CompanyRepos) -> Establishment:
    return await repos.establishments.create(
        Establishment(
            name="Hold Test Spa",
            slug="hold-test",
            address="Test St",
            city="Oslo",
            zip="0100",
            is_published=True,
            is_active=True,
        )
    )


async def test_create_and_read_hold(repos: CompanyRepos):
    """Create a hold and read it back."""
    est = await create_establishment(repos)
    service = await repos.services.create(
        Service(
            establishment=f"establishment:{est.id}",
            title="Test Service",
            duration=60,
            price=500,
        )
    )

    expires = datetime.now(tz=UTC) + timedelta(minutes=10)
    hold = await repos.holds.create(
        Hold(
            user_id="test-user-1",
            establishment=f"establishment:{est.id}",
            services=[f"service:{service.id}"],
            date="2026-05-10",
            slot_time="10:00",
            duration=60,
            expires_at=expires,
        )
    )

    assert hold.id is not None
    assert hold.user_id == "test-user-1"
    assert hold.date == "2026-05-10"
    assert hold.slot_time == "10:00"
    assert hold.duration == 60

    fetched = await repos.holds.get(hold.id)
    assert fetched is not None
    assert fetched.user_id == "test-user-1"


async def test_hard_delete_hold(repos: CompanyRepos):
    """Holds use hard delete — no deleted_at, record is gone."""
    est = await create_establishment(repos)

    hold = await repos.holds.create(
        Hold(
            user_id="test-delete",
            establishment=f"establishment:{est.id}",
            services=[],
            date="2026-05-10",
            slot_time="11:00",
            duration=30,
            expires_at=datetime.now(tz=UTC) + timedelta(minutes=5),
        )
    )

    result = await repos.holds.delete(hold.id)
    assert result is True

    # Hard delete — record is truly gone
    fetched = await repos.holds.get(hold.id)
    assert fetched is None


async def test_hold_record_links(repos: CompanyRepos):
    """Hold links to establishment, services, and staff — verify round-trip."""
    est = await create_establishment(repos)
    service = await repos.services.create(
        Service(
            establishment=f"establishment:{est.id}",
            title="Linked Service",
            duration=45,
            price=400,
        )
    )
    staff = await repos.staff.create(
        Staff(email="hold-staff@test.no", display_name="Hold Staff")
    )

    hold = await repos.holds.create(
        Hold(
            user_id="test-links",
            establishment=f"establishment:{est.id}",
            services=[f"service:{service.id}"],
            staff=f"staff:{staff.id}",
            date="2026-05-11",
            slot_time="14:00",
            duration=45,
            expires_at=datetime.now(tz=UTC) + timedelta(minutes=10),
        )
    )

    fetched = await repos.holds.get(hold.id)
    assert fetched is not None
    assert est.id in fetched.establishment
    assert len(fetched.services) == 1
    assert service.id in fetched.services[0]
    assert staff.id in fetched.staff


async def test_list_by_date(repos: CompanyRepos):
    """List holds for a specific date."""
    est = await create_establishment(repos)

    await repos.holds.create(
        Hold(
            user_id="u1",
            establishment=f"establishment:{est.id}",
            services=[],
            date="2026-05-10",
            slot_time="09:00",
            duration=30,
            expires_at=datetime.now(tz=UTC) + timedelta(hours=1),
        )
    )
    await repos.holds.create(
        Hold(
            user_id="u2",
            establishment=f"establishment:{est.id}",
            services=[],
            date="2026-05-11",
            slot_time="10:00",
            duration=30,
            expires_at=datetime.now(tz=UTC) + timedelta(hours=1),
        )
    )

    holds_10 = await repos.holds.list_by_date(est.id, "2026-05-10")
    assert len(holds_10) == 1
    assert holds_10[0].user_id == "u1"
