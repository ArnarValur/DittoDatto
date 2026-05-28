"""Tests for mercury_core.calculators.hold — ported from hold-allocation.test.ts.

Tests staff concurrency, resource allocation, and holdId composite key.
"""

from datetime import datetime

import pytest

from mercury_core.availability.context import AvailabilityData, build_availability_context
from mercury_core.calculators.hold import resolve_hold_allocation
from mercury_core.errors import SlotUnavailableError
from mercury_core.models.booking import Booking
from mercury_core.models.common import (
    BookingPolicy,
    BookingStatus,
    DaySchedule,
    ShiftDay,
    StaffStatus,
    TimeBlock,
)
from mercury_core.models.establishment import Establishment
from mercury_core.models.hold import Hold
from mercury_core.models.resource import Resource, ResourceGroup
from mercury_core.models.service import Service
from mercury_core.models.staff import Staff

# ============================================================================
# Fixtures
# ============================================================================


def make_establishment(**overrides) -> Establishment:
    defaults = {
        "name": "Test Store",
        "slug": "test-store",
        "opening_schedule": {
            "mon": DaySchedule(is_open=True, open="09:00", close="17:00"),
            "tue": DaySchedule(is_open=True, open="09:00", close="17:00"),
            "wed": DaySchedule(is_open=True, open="09:00", close="17:00"),
            "thu": DaySchedule(is_open=True, open="09:00", close="17:00"),
            "fri": DaySchedule(is_open=True, open="09:00", close="17:00"),
            "sat": DaySchedule(is_open=False, open="", close=""),
            "sun": DaySchedule(is_open=False, open="", close=""),
        },
        "timezone": "Europe/Oslo",
        "booking_policy": BookingPolicy(),
    }
    defaults.update(overrides)
    return Establishment(**defaults)


def make_service(**overrides) -> Service:
    defaults = {
        "id": "svc-1",
        "title": "Haircut",
        "duration": 60,
        "price": 500,
        "currency": "NOK",
        "min_booking_notice_minutes": 0,
        "slot_interval": 15,
    }
    defaults.update(overrides)
    return Service(**defaults)


_STANDARD_SHIFTS = {
    "mon": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="17:00")]),
    "tue": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="17:00")]),
    "wed": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="17:00")]),
    "thu": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="17:00")]),
    "fri": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="17:00")]),
    "sat": ShiftDay(is_working=False, blocks=[]),
    "sun": ShiftDay(is_working=False, blocks=[]),
}


def make_staff(**overrides) -> Staff:
    defaults = {
        "id": "staff-1",
        "display_name": "Alice",
        "is_bookable": True,
        "status": StaffStatus.ACTIVE,
        "store_ids": ["store-1"],
        "weekly_shifts": _STANDARD_SHIFTS,
    }
    defaults.update(overrides)
    return Staff(**defaults)


def empty_data(**overrides) -> AvailabilityData:
    defaults = {
        "establishment": make_establishment(),
        "bookings": [],
        "holds": [],
        "services": [make_service()],
        "staff": [],
        "resources": [],
        "resource_groups": [],
    }
    defaults.update(overrides)
    return AvailabilityData(**defaults)


MONDAY = "2099-03-16"


# ============================================================================
# Hold ID Composite Key
# ============================================================================


class TestHoldId:
    def test_generates_hold_id_no_staff_no_resources(self):
        ctx = build_availability_context(empty_data(), MONDAY)
        result = resolve_hold_allocation(ctx, "store-1", "10:00", "user-123")
        assert result.hold_id == "store-1_2099-03-16_10:00_user-123"

    def test_uses_staff_id_as_differentiator(self):
        data = empty_data(staff=[make_staff()])
        ctx = build_availability_context(data, MONDAY)
        result = resolve_hold_allocation(ctx, "store-1", "10:00", "user-123")
        assert result.hold_id == "store-1_2099-03-16_10:00_staff-1"
        assert result.final_staff_id == "staff-1"

    def test_uses_resource_id_as_differentiator(self):
        resources = [
            Resource(
                id="table-1",
                name="Table 1",
                type="table",
                resource_group="rg-1",
                max_capacity=4,
                is_bookable=True,
            ),
        ]
        resource_groups = [ResourceGroup(id="rg-1", name="Main Dining")]
        services = [make_service(required_resource_groups=["rg-1"])]

        data = empty_data(resources=resources, resource_groups=resource_groups, services=services)
        ctx = build_availability_context(data, MONDAY)
        result = resolve_hold_allocation(ctx, "store-1", "10:00", "user-123")
        assert result.hold_id == "store-1_2099-03-16_10:00_table-1"
        assert result.assigned_resource_id == "table-1"


# ============================================================================
# Staff Concurrency
# ============================================================================


class TestStaffConcurrency:
    def test_assigns_available_staff_when_one_busy(self):
        staff = [make_staff(id="alice"), make_staff(id="bob")]
        bookings = [
            Booking(
                staff="alice",
                start_time=datetime.fromisoformat("2099-03-16T10:00:00"),
                end_time=datetime.fromisoformat("2099-03-16T11:00:00"),
                status=BookingStatus.CONFIRMED,
                name="Test Store",
                slug="test-store",
            ),
        ]
        ctx = build_availability_context(empty_data(staff=staff, bookings=bookings), MONDAY)
        result = resolve_hold_allocation(ctx, "store-1", "10:00", "user-123")
        assert result.final_staff_id == "bob"

    def test_throws_when_all_staff_busy(self):
        staff = [make_staff(id="alice")]
        bookings = [
            Booking(
                staff="alice",
                start_time=datetime.fromisoformat("2099-03-16T10:00:00"),
                end_time=datetime.fromisoformat("2099-03-16T11:00:00"),
                status=BookingStatus.CONFIRMED,
                name="Test Store",
                slug="test-store",
            ),
        ]
        ctx = build_availability_context(empty_data(staff=staff, bookings=bookings), MONDAY)
        with pytest.raises(SlotUnavailableError, match="no longer available"):
            resolve_hold_allocation(ctx, "store-1", "10:00", "user-123")

    def test_throws_when_specific_staff_not_eligible(self):
        staff = [make_staff(id="alice")]
        ctx = build_availability_context(empty_data(staff=staff), MONDAY)
        with pytest.raises(SlotUnavailableError, match="cannot perform"):
            resolve_hold_allocation(ctx, "store-1", "10:00", "user-123", "bob")

    def test_respects_holds_as_occupied(self):
        staff = [make_staff(id="alice")]
        holds = [
            Hold(
                staff="alice",
                slot_time="10:00",
                duration=60,
                date=MONDAY,
                establishment="store-1",
                expires_at=datetime(2099, 12, 31),
            ),
        ]
        ctx = build_availability_context(empty_data(staff=staff, holds=holds), MONDAY)
        with pytest.raises(SlotUnavailableError, match="no longer available"):
            resolve_hold_allocation(ctx, "store-1", "10:00", "user-123")


# ============================================================================
# Store-Level Concurrency
# ============================================================================


class TestStoreLevelConcurrency:
    def test_allows_when_store_free(self):
        ctx = build_availability_context(empty_data(), MONDAY)
        result = resolve_hold_allocation(ctx, "store-1", "10:00", "user-123")
        assert result.hold_id
        assert result.total_duration == 60

    def test_throws_when_store_has_overlapping_booking(self):
        bookings = [
            Booking(
                start_time=datetime.fromisoformat("2099-03-16T10:00:00"),
                end_time=datetime.fromisoformat("2099-03-16T11:00:00"),
                status=BookingStatus.CONFIRMED,
                name="Test Store",
                slug="test-store",
            ),
        ]
        ctx = build_availability_context(empty_data(bookings=bookings), MONDAY)
        with pytest.raises(SlotUnavailableError, match="no longer available"):
            resolve_hold_allocation(ctx, "store-1", "10:00", "user-123")

    def test_allows_non_overlapping_booking(self):
        bookings = [
            Booking(
                start_time=datetime.fromisoformat("2099-03-16T10:00:00"),
                end_time=datetime.fromisoformat("2099-03-16T11:00:00"),
                status=BookingStatus.CONFIRMED,
                name="Test Store",
                slug="test-store",
            ),
        ]
        ctx = build_availability_context(empty_data(bookings=bookings), MONDAY)
        result = resolve_hold_allocation(ctx, "store-1", "11:00", "user-123")
        assert result.hold_id


# ============================================================================
# Edge Cases
# ============================================================================


class TestEdgeCases:
    def test_sanitizes_undefined_string_staff_id(self):
        ctx = build_availability_context(empty_data(), MONDAY)
        result = resolve_hold_allocation(ctx, "store-1", "10:00", "user-123", "undefined")
        assert result.hold_id == "store-1_2099-03-16_10:00_user-123"

    def test_sanitizes_null_string_staff_id(self):
        ctx = build_availability_context(empty_data(), MONDAY)
        result = resolve_hold_allocation(ctx, "store-1", "10:00", "user-123", "null")
        assert result.hold_id == "store-1_2099-03-16_10:00_user-123"
