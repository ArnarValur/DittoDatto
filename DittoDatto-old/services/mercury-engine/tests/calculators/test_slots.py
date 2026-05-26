"""Tests for mercury_core.calculators.slots — ported from calculator-slots.test.ts.

Tests the pure slot loop ("Time Tetris") without Firestore.
"""

from datetime import datetime

from mercury_core.availability.context import AvailabilityData, build_availability_context
from mercury_core.calculators.slots import calculate_slots_from_context
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
            "mon": DaySchedule(is_open=True, open="09:00", close="12:00"),
            "tue": DaySchedule(is_open=True, open="09:00", close="12:00"),
            "wed": DaySchedule(is_open=True, open="09:00", close="12:00"),
            "thu": DaySchedule(is_open=True, open="09:00", close="12:00"),
            "fri": DaySchedule(is_open=True, open="09:00", close="12:00"),
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
        "slot_interval": 30,
    }
    defaults.update(overrides)
    return Service(**defaults)


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


FUTURE_MONDAY = "2099-03-16"


# ============================================================================
# Basic Slot Generation
# ============================================================================


class TestBasicSlots:
    def test_generates_slots_for_open_day(self):
        ctx = build_availability_context(empty_data(), FUTURE_MONDAY)
        slots = calculate_slots_from_context(ctx)
        # Store open 09:00-12:00, service 60min, interval 30min
        # 09:00, 09:30, 10:00, 10:30, 11:00 (11:30+60=12:30 > 12:00)
        assert slots == ["09:00", "09:30", "10:00", "10:30", "11:00"]

    def test_returns_empty_for_closed_day(self):
        ctx = build_availability_context(empty_data(), "2099-03-22")  # Saturday
        slots = calculate_slots_from_context(ctx)
        assert slots == []

    def test_respects_different_slot_intervals(self):
        data = empty_data(services=[make_service(slot_interval=60)])
        ctx = build_availability_context(data, FUTURE_MONDAY)
        slots = calculate_slots_from_context(ctx)
        # 60-min interval: 09:00, 10:00, 11:00
        assert slots == ["09:00", "10:00", "11:00"]


# ============================================================================
# Store-Level Concurrency
# ============================================================================


class TestStoreLevelConcurrency:
    def test_blocks_slots_with_existing_bookings(self):
        data = empty_data(
            bookings=[
                Booking(
                    start_time=datetime.fromisoformat("2099-03-16T10:00:00"),
                    end_time=datetime.fromisoformat("2099-03-16T11:00:00"),
                    status=BookingStatus.CONFIRMED,
                    name="Test Store",
                    slug="test-store",
                ),
            ],
        )
        ctx = build_availability_context(data, FUTURE_MONDAY)
        slots = calculate_slots_from_context(ctx)
        assert "10:00" not in slots
        assert "09:00" in slots  # 09:00-10:00 doesn't overlap 10:00-11:00
        assert "11:00" in slots  # 11:00-12:00 starts at booking end

    def test_blocks_slots_with_active_holds(self):
        data = empty_data(
            holds=[
                Hold(
                    slot_time="09:00",
                    duration=60,
                    date="2099-03-16",
                    establishment="store-1",
                    expires_at=datetime(2099, 12, 31),
                ),
            ],
        )
        ctx = build_availability_context(data, FUTURE_MONDAY)
        slots = calculate_slots_from_context(ctx)
        assert "09:00" not in slots


# ============================================================================
# Staff-Aware Slots
# ============================================================================


class TestStaffAwareSlots:
    staff_with_shifts = Staff(
        id="staff-1",
        display_name="Alice",
        is_bookable=True,
        status=StaffStatus.ACTIVE,
        store_ids=["store-1"],
        weekly_shifts={
            "mon": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="12:00")]),
            "tue": ShiftDay(is_working=False, blocks=[]),
            "wed": ShiftDay(is_working=False, blocks=[]),
            "thu": ShiftDay(is_working=False, blocks=[]),
            "fri": ShiftDay(is_working=False, blocks=[]),
            "sat": ShiftDay(is_working=False, blocks=[]),
            "sun": ShiftDay(is_working=False, blocks=[]),
        },
    )

    def test_generates_slots_based_on_staff_working_hours(self):
        data = empty_data(staff=[self.staff_with_shifts])
        ctx = build_availability_context(data, FUTURE_MONDAY)
        slots = calculate_slots_from_context(ctx)
        assert slots == ["09:00", "09:30", "10:00", "10:30", "11:00"]

    def test_blocks_slot_when_staff_has_booking(self):
        data = empty_data(
            staff=[self.staff_with_shifts],
            bookings=[
                Booking(
                    staff="staff-1",
                    start_time=datetime.fromisoformat("2099-03-16T09:00:00"),
                    end_time=datetime.fromisoformat("2099-03-16T10:00:00"),
                    status=BookingStatus.CONFIRMED,
                    name="Test Store",
                    slug="test-store",
                ),
            ],
        )
        ctx = build_availability_context(data, FUTURE_MONDAY)
        slots = calculate_slots_from_context(ctx)
        assert "09:00" not in slots
        assert "09:30" not in slots
        assert "10:00" in slots

    def test_slot_available_if_any_staff_free(self):
        staff2 = Staff(
            id="staff-2",
            display_name="Bob",
            is_bookable=True,
            status=StaffStatus.ACTIVE,
            store_ids=["store-1"],
            weekly_shifts=self.staff_with_shifts.weekly_shifts,
        )
        data = empty_data(
            staff=[self.staff_with_shifts, staff2],
            bookings=[
                Booking(
                    staff="staff-1",
                    start_time=datetime.fromisoformat("2099-03-16T09:00:00"),
                    end_time=datetime.fromisoformat("2099-03-16T10:00:00"),
                    status=BookingStatus.CONFIRMED,
                    name="Test Store",
                    slug="test-store",
                ),
            ],
        )
        ctx = build_availability_context(data, FUTURE_MONDAY)
        slots = calculate_slots_from_context(ctx)
        # Staff-1 blocked at 09:00, but staff-2 is free → available
        assert "09:00" in slots
