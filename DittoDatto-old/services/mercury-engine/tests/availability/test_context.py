"""Tests for mercury_core.availability.context — ported from availability-context.test.ts.

Pure function — tests data preparation logic used by calculator and hold.
"""

from datetime import datetime

from mercury_core.availability.context import AvailabilityData, build_availability_context
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


def make_staff(**overrides) -> Staff:
    defaults = {
        "id": "staff-1",
        "display_name": "Alice",
        "is_bookable": True,
        "status": StaffStatus.ACTIVE,
        "store_ids": ["store-1"],
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


MONDAY = "2026-03-16"


# ============================================================================
# Staff Normalization
# ============================================================================


class TestStaffNormalization:
    def test_fills_missing_weekly_shifts_from_store_hours(self):
        staff = make_staff(weekly_shifts=None)
        ctx = build_availability_context(empty_data(staff=[staff]), MONDAY)

        normalized = ctx.normalized_staff[0]
        assert normalized.weekly_shifts is not None
        mon_shift = normalized.weekly_shifts["mon"]
        assert mon_shift.is_working is True
        assert len(mon_shift.blocks) == 1
        assert mon_shift.blocks[0].start == "09:00"
        assert mon_shift.blocks[0].end == "17:00"
        # Weekends default to off
        assert normalized.weekly_shifts["sat"].is_working is False

    def test_does_not_modify_staff_with_existing_shifts(self):
        shifts = {
            "mon": ShiftDay(is_working=True, blocks=[TimeBlock(start="10:00", end="14:00")]),
            "tue": ShiftDay(is_working=False, blocks=[]),
            "wed": ShiftDay(is_working=False, blocks=[]),
            "thu": ShiftDay(is_working=False, blocks=[]),
            "fri": ShiftDay(is_working=False, blocks=[]),
            "sat": ShiftDay(is_working=False, blocks=[]),
            "sun": ShiftDay(is_working=False, blocks=[]),
        }
        staff = make_staff(weekly_shifts=shifts)
        ctx = build_availability_context(empty_data(staff=[staff]), MONDAY)

        assert ctx.normalized_staff[0].weekly_shifts["mon"].blocks[0].start == "10:00"
        assert ctx.normalized_staff[0].weekly_shifts["mon"].blocks[0].end == "14:00"


# ============================================================================
# Staff-Service Assignment Filtering
# ============================================================================


class TestStaffServiceFiltering:
    def test_keeps_all_staff_when_no_assigned_staff(self):
        staff = [make_staff(id="s1"), make_staff(id="s2")]
        ctx = build_availability_context(empty_data(staff=staff), MONDAY)
        assert [s.id for s in ctx.eligible_staff] == ["s1", "s2"]

    def test_filters_to_intersection(self):
        staff = [make_staff(id="s1"), make_staff(id="s2"), make_staff(id="s3")]
        services = [
            make_service(id="svc-1", assigned_staff=["s1", "s2"]),
            make_service(id="svc-2", assigned_staff=["s2", "s3"]),
        ]
        ctx = build_availability_context(empty_data(staff=staff, services=services), MONDAY)
        # Only s2 is eligible for BOTH services
        assert [s.id for s in ctx.eligible_staff] == ["s2"]

    def test_narrows_to_specific_staff_id(self):
        staff = [make_staff(id="s1"), make_staff(id="s2")]
        ctx = build_availability_context(empty_data(staff=staff), MONDAY, staff_id="s1")
        assert [s.id for s in ctx.eligible_staff] == ["s1"]


# ============================================================================
# Policy Derivation
# ============================================================================


class TestPolicyDerivation:
    def test_uses_max_notice_across_services(self):
        services = [
            make_service(id="svc-1", min_booking_notice_minutes=30),
            make_service(id="svc-2", min_booking_notice_minutes=60),
        ]
        ctx = build_availability_context(empty_data(services=services), MONDAY)
        assert ctx.notice_cutoff_minutes == 60

    def test_uses_min_slot_interval_across_services(self):
        services = [
            make_service(id="svc-1", slot_interval=30),
            make_service(id="svc-2", slot_interval=15),
        ]
        ctx = build_availability_context(empty_data(services=services), MONDAY)
        assert ctx.slot_interval == 15

    def test_sums_total_duration(self):
        services = [
            make_service(id="svc-1", duration=30),
            make_service(id="svc-2", duration=45),
        ]
        ctx = build_availability_context(empty_data(services=services), MONDAY)
        assert ctx.total_duration == 75


# ============================================================================
# Resource Group Extraction
# ============================================================================


class TestResourceGroups:
    def test_extracts_and_deduplicates_group_ids(self):
        services = [
            make_service(id="svc-1", required_resource_groups=["rg-1", "rg-2"]),
            make_service(id="svc-2", required_resource_groups=["rg-2", "rg-3"]),
        ]
        ctx = build_availability_context(empty_data(services=services), MONDAY)
        assert sorted(ctx.unique_required_group_ids) == ["rg-1", "rg-2", "rg-3"]
        assert ctx.has_resource_requirements is True

    def test_sets_has_resource_requirements_false(self):
        ctx = build_availability_context(empty_data(), MONDAY)
        assert ctx.has_resource_requirements is False
        assert ctx.unique_required_group_ids == []


# ============================================================================
# Schedule
# ============================================================================


class TestSchedule:
    def test_parses_open_close_times(self):
        ctx = build_availability_context(empty_data(), MONDAY)
        assert ctx.open_time == 540  # 09:00
        assert ctx.close_time == 1020  # 17:00
        assert ctx.schedule is not None
        assert ctx.schedule.is_open is True

    def test_returns_closed_schedule_for_closed_days(self):
        # Saturday = closed
        ctx = build_availability_context(empty_data(), "2026-03-21")
        assert ctx.schedule is not None
        assert ctx.schedule.is_open is False


# ============================================================================
# Occupancy Maps
# ============================================================================


class TestOccupancy:
    def test_builds_store_level_occupied_intervals(self):
        bookings = [
            Booking(
                start_time=datetime.fromisoformat("2026-03-16T10:00:00"),
                end_time=datetime.fromisoformat("2026-03-16T11:00:00"),
                status=BookingStatus.CONFIRMED,
                name="Test Store",
                slug="test-store",
            ),
        ]
        ctx = build_availability_context(empty_data(bookings=bookings), MONDAY)
        assert len(ctx.store_occupied) == 1
        assert ctx.store_occupied[0].start == 600  # 10:00
        assert ctx.store_occupied[0].end == 660  # 11:00

    def test_builds_per_staff_occupancy(self):
        staff = [make_staff(id="staff-1")]
        bookings = [
            Booking(
                staff="staff-1",
                start_time=datetime.fromisoformat("2026-03-16T14:00:00"),
                end_time=datetime.fromisoformat("2026-03-16T15:00:00"),
                status=BookingStatus.CONFIRMED,
                name="Test Store",
                slug="test-store",
            ),
        ]
        ctx = build_availability_context(empty_data(staff=staff, bookings=bookings), MONDAY)
        assert len(ctx.staff_occupancy["staff-1"]) == 1
        assert ctx.staff_occupancy["staff-1"][0].start == 840  # 14:00
