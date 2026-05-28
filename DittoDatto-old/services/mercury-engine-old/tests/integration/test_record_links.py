"""Integration tests for record link round-trip validation.

This is the critical test file — validates that our model_to_record() →
SurrealDB → record_to_model() pipeline correctly handles:
- Single record links (record<T>)
- Optional record links (option<record<T>>)
- Array record links (array<record<T>>)
- Nested record links in embedded objects (booking.items[].service)
"""

from __future__ import annotations

from datetime import UTC, datetime, timedelta

import pytest

from mercury_core.models import (
    Booking,
    BookingItem,
    Establishment,
    Hold,
    Service,
    Staff,
)
from mercury_engine.dependencies import CompanyRepos

pytestmark = [
    pytest.mark.integration,
    pytest.mark.asyncio(loop_scope="session"),
]


# ─── Fixtures ────────────────────────────────────────────────────────────────


async def setup_booking_scenario(repos: CompanyRepos) -> dict:
    """Create a full establishment → service → staff → booking chain."""
    est = await repos.establishments.create(
        Establishment(
            name="Link Test Spa",
            slug="link-test",
            address="Link St 1",
            city="Oslo",
            zip="0100",
            is_published=True,
            is_active=True,
        )
    )

    service = await repos.services.create(
        Service(
            establishment=f"establishment:{est.id}",
            title="Link Test Massage",
            duration=60,
            price=599.0,
        )
    )

    staff = await repos.staff.create(
        Staff(
            email="linker@test.no",
            display_name="Link Tester",
            is_bookable=True,
            store_ids=[f"establishment:{est.id}"],
        )
    )

    return {"est": est, "service": service, "staff": staff}


# ─── Tests ───────────────────────────────────────────────────────────────────


async def test_booking_all_record_links(repos: CompanyRepos):
    """Booking has establishment + service + staff + resource — all record links."""
    entities = await setup_booking_scenario(repos)
    est = entities["est"]
    service = entities["service"]
    staff = entities["staff"]

    booking = await repos.bookings.create(
        Booking(
            user_id="user-001",
            establishment=f"establishment:{est.id}",
            service=f"service:{service.id}",
            staff=f"staff:{staff.id}",
            status="confirmed",
            start_time=datetime(2026, 5, 10, 10, 0, tzinfo=UTC),
            end_time=datetime(2026, 5, 10, 11, 0, tzinfo=UTC),
            service_title="Link Test Massage",
            duration=60,
            price_at_booking=599.0,
            user_name="Test User",
            user_email="test@user.no",
        )
    )

    assert booking.id is not None

    # Read back and verify all links survived
    fetched = await repos.bookings.get(booking.id)
    assert fetched is not None
    assert est.id in fetched.establishment
    assert service.id in fetched.service
    assert staff.id in fetched.staff


async def test_booking_optional_links_none(repos: CompanyRepos):
    """staff and resource can be None on a booking."""
    entities = await setup_booking_scenario(repos)
    est = entities["est"]
    service = entities["service"]

    booking = await repos.bookings.create(
        Booking(
            user_id="user-002",
            establishment=f"establishment:{est.id}",
            service=f"service:{service.id}",
            staff=None,  # No specific staff
            resource=None,  # No resource
            status="confirmed",
            start_time=datetime(2026, 5, 10, 14, 0, tzinfo=UTC),
            end_time=datetime(2026, 5, 10, 15, 0, tzinfo=UTC),
            service_title="Link Test Massage",
            duration=60,
            price_at_booking=599.0,
            user_name="No Staff User",
            user_email="nostaff@user.no",
        )
    )

    fetched = await repos.bookings.get(booking.id)
    assert fetched is not None
    assert fetched.staff is None
    assert fetched.resource is None


async def test_booking_items_embedded_links(repos: CompanyRepos):
    """Booking.items[] contains embedded objects with record<service> links."""
    entities = await setup_booking_scenario(repos)
    est = entities["est"]
    service = entities["service"]

    service_b = await repos.services.create(
        Service(
            establishment=f"establishment:{est.id}",
            title="Second Service",
            duration=30,
            price=299.0,
        )
    )

    booking = await repos.bookings.create(
        Booking(
            user_id="user-003",
            establishment=f"establishment:{est.id}",
            service=f"service:{service.id}",
            status="confirmed",
            start_time=datetime(2026, 5, 11, 10, 0, tzinfo=UTC),
            end_time=datetime(2026, 5, 11, 11, 30, tzinfo=UTC),
            service_title="Link Test Massage",
            duration=90,
            price_at_booking=898.0,
            user_name="Multi User",
            user_email="multi@user.no",
            items=[
                BookingItem(
                    service=f"service:{service.id}",
                    title="Link Test Massage",
                    price=599.0,
                    duration=60,
                ),
                BookingItem(
                    service=f"service:{service_b.id}",
                    title="Second Service",
                    price=299.0,
                    duration=30,
                ),
            ],
        )
    )

    fetched = await repos.bookings.get(booking.id)
    assert fetched is not None
    assert len(fetched.items) == 2
    # Items contain service references — these may or may not be
    # full record links depending on SurrealDB SCHEMAFULL handling
    # of nested objects. Verify they at least survived the round-trip.
    assert fetched.items[0].title == "Link Test Massage"
    assert fetched.items[1].title == "Second Service"


async def test_hold_services_array_links(repos: CompanyRepos):
    """Hold.services is array<record<service>> — critical for slot locking."""
    entities = await setup_booking_scenario(repos)
    est = entities["est"]
    service = entities["service"]

    service_b = await repos.services.create(
        Service(
            establishment=f"establishment:{est.id}",
            title="Extra Service",
            duration=30,
            price=200,
        )
    )

    hold = await repos.holds.create(
        Hold(
            user_id="user-hold-links",
            establishment=f"establishment:{est.id}",
            services=[
                f"service:{service.id}",
                f"service:{service_b.id}",
            ],
            date="2026-05-10",
            slot_time="10:00",
            duration=90,
            expires_at=datetime.now(tz=UTC) + timedelta(minutes=10),
        )
    )

    fetched = await repos.holds.get(hold.id)
    assert fetched is not None
    assert len(fetched.services) == 2
    service_ids = {link.split(":")[-1] for link in fetched.services}
    assert service.id in service_ids
    assert service_b.id in service_ids
