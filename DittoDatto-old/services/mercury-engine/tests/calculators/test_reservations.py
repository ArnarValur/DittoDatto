"""Tests for mercury_core.calculators.reservations — ported from reservations-calculator.test.ts.

Tests time slot generation, overlap detection, best-fit table assignment,
and slot availability (pool mode vs table mode).
"""

from datetime import datetime
from zoneinfo import ZoneInfo

from mercury_core.calculators.reservations import (
    Reservation,
    SlotFilterOptions,
    calculate_slot_availability,
    find_best_table,
    generate_time_slots,
    get_overlapping_reservations,
)
from mercury_core.models.common import ReservationConfig
from mercury_core.models.establishment import Establishment
from mercury_core.models.resource import Resource

# ============================================================================
# Test Fixtures
# ============================================================================


def make_reservation(**overrides) -> Reservation:
    defaults = {
        "id": "res-1",
        "time": "18:00",
        "duration": 90,
        "status": "confirmed",
        "guest_count": 2,
    }
    defaults.update(overrides)
    return Reservation(**defaults)


def make_table(**overrides) -> Resource:
    defaults = {
        "name": f"Table {overrides.get('id', '?')}",
        "type": "table",
        "is_bookable": True,
        "priority": "normal",
        "max_capacity": 4,
        "min_capacity": 1,
        "resource_group": "dining-tables",
        "allow_overlapping": False,
    }
    defaults.update(overrides)
    return Resource(**defaults)


def make_establishment(**overrides) -> Establishment:
    defaults = {
        "name": "Test Restaurant",
        "slug": "test-restaurant",
        "reservation_config": ReservationConfig(
            total_capacity=20,
            max_guests=8,
            auto_confirm=True,
            default_duration=90,
            slot_interval=30,
        ),
        "timezone": "Europe/Oslo",
    }
    defaults.update(overrides)
    return Establishment(**defaults)


# ============================================================================
# generateTimeSlots
# ============================================================================


class TestGenerateTimeSlots:
    def test_generates_slots_between_start_and_end(self):
        slots = generate_time_slots("18:00", "22:00", 30)
        assert slots == [
            "18:00", "18:30", "19:00", "19:30",
            "20:00", "20:30", "21:00", "21:30",
        ]

    def test_respects_different_intervals(self):
        slots = generate_time_slots("09:00", "11:00", 60)
        assert slots == ["09:00", "10:00"]

    def test_returns_empty_when_start_equals_end(self):
        slots = generate_time_slots("18:00", "18:00", 30)
        assert slots == []

    def test_filters_past_slots_when_today(self):
        now = datetime.now(ZoneInfo("Europe/Oslo"))
        today = now.strftime("%Y-%m-%d")

        slots = generate_time_slots(
            "00:00", "23:59", 60,
            SlotFilterOptions(store_timezone="Europe/Oslo", request_date=today),
        )
        assert "00:00" not in slots

    def test_does_not_filter_slots_for_future_dates(self):
        slots = generate_time_slots(
            "00:00", "03:00", 60,
            SlotFilterOptions(store_timezone="Europe/Oslo", request_date="2099-12-31"),
        )
        assert "00:00" in slots
        assert "01:00" in slots
        assert "02:00" in slots


# ============================================================================
# getOverlappingReservations
# ============================================================================


class TestGetOverlappingReservations:
    reservations = [
        make_reservation(id="r1", time="18:00", duration=90),
        make_reservation(id="r2", time="20:00", duration=90),
        make_reservation(id="r3", time="18:30", duration=60, status="cancelled"),
    ]

    def test_finds_overlapping_reservations(self):
        result = get_overlapping_reservations(self.reservations, "18:30", 60)
        assert any(r.id == "r1" for r in result)

    def test_excludes_cancelled(self):
        result = get_overlapping_reservations(self.reservations, "18:30", 60)
        assert not any(r.id == "r3" for r in result)

    def test_excludes_no_show(self):
        with_no_show = [
            *self.reservations,
            make_reservation(id="r4", time="18:00", duration=90, status="no_show"),
        ]
        result = get_overlapping_reservations(with_no_show, "18:00", 90)
        assert not any(r.id == "r4" for r in result)

    def test_does_not_include_non_overlapping(self):
        result = get_overlapping_reservations(self.reservations, "16:00", 60)
        assert result == []

    def test_adjacent_but_non_overlapping(self):
        # r1 ends at 19:30, slot starts at 19:30 → no overlap
        result = get_overlapping_reservations(self.reservations, "19:30", 60)
        assert not any(r.id == "r1" for r in result)


# ============================================================================
# findBestTable
# ============================================================================


class TestFindBestTable:
    tables = [
        make_table(id="table-2", min_capacity=1, max_capacity=2, priority="high"),
        make_table(id="table-4", min_capacity=1, max_capacity=4, priority="normal"),
        make_table(id="table-8", min_capacity=4, max_capacity=8, priority="normal"),
        make_table(id="table-vip", min_capacity=1, max_capacity=6, priority="low"),
    ]

    def test_assigns_best_fit_for_party_of_2(self):
        result = find_best_table(self.tables, [], "18:00", 90, 2)
        assert result is not None
        assert result.id == "table-2"

    def test_assigns_table_4_when_table_2_occupied(self):
        occupied = [make_reservation(id="r1", time="18:00", duration=90, table_id="table-2")]
        result = find_best_table(self.tables, occupied, "18:00", 90, 2)
        assert result is not None
        assert result.id == "table-4"

    def test_assigns_table_8_for_party_of_5(self):
        result = find_best_table(self.tables, [], "18:00", 90, 5)
        assert result is not None
        assert result.id == "table-8"

    def test_assigns_vip_when_only_option(self):
        occupied = [make_reservation(id="r1", time="18:00", duration=90, table_id="table-8")]
        result = find_best_table(self.tables, occupied, "18:00", 90, 6)
        assert result is not None
        assert result.id == "table-vip"

    def test_returns_none_when_no_table_fits(self):
        result = find_best_table(self.tables, [], "18:00", 90, 10)
        assert result is None

    def test_returns_none_when_all_suitable_occupied(self):
        occupied = [
            make_reservation(id="r1", time="18:00", duration=90, table_id="table-2"),
            make_reservation(id="r2", time="18:00", duration=90, table_id="table-4"),
        ]
        # Party of 2 — table-vip (min=1, max=6) still fits!
        result = find_best_table(self.tables, occupied, "18:00", 90, 2)
        assert result is not None
        assert result.id == "table-vip"

    def test_skips_non_bookable_tables(self):
        tables = [make_table(id="table-closed", min_capacity=1, max_capacity=4, is_bookable=False)]
        result = find_best_table(tables, [], "18:00", 90, 2)
        assert result is None

    def test_considers_time_occupied_at_different_time_is_free(self):
        occupied = [
            make_reservation(id="r1", time="16:00", duration=90, table_id="table-2"),
        ]
        result = find_best_table(self.tables, occupied, "18:00", 90, 2)
        assert result is not None
        assert result.id == "table-2"


# ============================================================================
# calculateSlotAvailability
# ============================================================================


class TestSlotAvailabilityTableMode:
    tables = [
        make_table(id="t1", min_capacity=1, max_capacity=4),
        make_table(id="t2", min_capacity=1, max_capacity=4),
    ]

    def test_returns_available_with_table_id(self):
        store = make_establishment()
        result = calculate_slot_availability(store, "18:00", 90, 2, [], self.tables)
        assert result.available is True
        assert result.table_id is not None

    def test_returns_unavailable_when_all_occupied(self):
        store = make_establishment()
        occupied = [
            make_reservation(id="r1", time="18:00", duration=90, table_id="t1"),
            make_reservation(id="r2", time="18:00", duration=90, table_id="t2"),
        ]
        result = calculate_slot_availability(store, "18:00", 90, 2, occupied, self.tables)
        assert result.available is False
        assert "No suitable table" in (result.reason or "")

    def test_reports_remaining_capacity(self):
        store = make_establishment()
        occupied = [
            make_reservation(id="r1", time="18:00", duration=90, table_id="t1"),
        ]
        result = calculate_slot_availability(store, "18:00", 90, 2, occupied, self.tables)
        assert result.available is True
        assert result.remaining_capacity == 1  # 1 table left


class TestSlotAvailabilityPoolMode:
    def test_returns_available_under_capacity(self):
        store = make_establishment()
        result = calculate_slot_availability(store, "18:00", 90, 4, [])
        assert result.available is True
        assert result.remaining_capacity == 20

    def test_returns_unavailable_when_exceeds_capacity(self):
        store = make_establishment()
        occupied = [make_reservation(id="r1", time="18:00", duration=90, guest_count=18)]
        result = calculate_slot_availability(store, "18:00", 90, 4, occupied)
        assert result.available is False
        assert result.remaining_capacity == 2  # 20 - 18 = 2, party needs 4

    def test_returns_unavailable_without_config(self):
        store = make_establishment(reservation_config=None)
        result = calculate_slot_availability(store, "18:00", 90, 2, [])
        assert result.available is False
        assert "No capacity" in (result.reason or "")
