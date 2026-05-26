"""Tests for mercury_core.availability.staff — ported from staff-availability.test.ts.

Pure functions — no database, fully testable.
Tests shift matching, date overrides, and multi-staff slot filtering.

V2 adaptation: DateOverride is a separate model passed as a parameter,
not embedded in Staff (Session 9 scalability decision).
"""

from mercury_core.availability.staff import (
    get_available_staff_for_slot,
    is_staff_available,
)
from mercury_core.models.common import (
    DateOverrideType,
    ShiftDay,
    StaffStatus,
    TimeBlock,
)
from mercury_core.models.staff import DateOverride, Staff
from mercury_core.time import get_day_name

# ============================================================================
# Test Fixtures
# ============================================================================

_STANDARD_SHIFTS = {
    "mon": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="17:00")]),
    "tue": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="17:00")]),
    "wed": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="17:00")]),
    "thu": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="17:00")]),
    "fri": ShiftDay(is_working=True, blocks=[TimeBlock(start="09:00", end="17:00")]),
    "sat": ShiftDay(is_working=False, blocks=[]),
    "sun": ShiftDay(is_working=False, blocks=[]),
}

_SPLIT_SHIFTS = {
    "mon": ShiftDay(
        is_working=True,
        blocks=[TimeBlock(start="09:00", end="12:00"), TimeBlock(start="13:00", end="17:00")],
    ),
    "tue": ShiftDay(
        is_working=True,
        blocks=[TimeBlock(start="09:00", end="12:00"), TimeBlock(start="13:00", end="17:00")],
    ),
    "wed": ShiftDay(is_working=False, blocks=[]),  # Day off
    "thu": ShiftDay(
        is_working=True,
        blocks=[TimeBlock(start="09:00", end="12:00"), TimeBlock(start="13:00", end="17:00")],
    ),
    "fri": ShiftDay(
        is_working=True,
        blocks=[TimeBlock(start="09:00", end="12:00"), TimeBlock(start="13:00", end="17:00")],
    ),
    "sat": ShiftDay(is_working=False, blocks=[]),
    "sun": ShiftDay(is_working=False, blocks=[]),
}

standard_staff = Staff(
    id="staff-1",
    display_name="Alice",
    is_bookable=True,
    status=StaffStatus.ACTIVE,
    store_ids=["store-1"],
    weekly_shifts=_STANDARD_SHIFTS,
)

split_shift_staff = Staff(
    id="staff-2",
    display_name="Bob",
    is_bookable=True,
    status=StaffStatus.ACTIVE,
    store_ids=["store-1"],
    weekly_shifts=_SPLIT_SHIFTS,
)

inactive_staff = Staff(
    id="staff-inactive",
    display_name="Inactive",
    is_bookable=True,
    status=StaffStatus.SUSPENDED,
    store_ids=["store-1"],
    weekly_shifts=_STANDARD_SHIFTS,
)

non_bookable_staff = Staff(
    id="staff-nonbook",
    display_name="Admin",
    is_bookable=False,
    status=StaffStatus.ACTIVE,
    store_ids=["store-1"],
    weekly_shifts=_STANDARD_SHIFTS,
)


# ============================================================================
# get_day_name (used as getDayKey equivalent)
# ============================================================================


class TestGetDayKey:
    def test_returns_correct_day_keys(self):
        assert get_day_name("2026-03-16") == "mon"
        assert get_day_name("2026-03-14") == "sat"
        assert get_day_name("2026-03-15") == "sun"


# ============================================================================
# is_staff_available
# ============================================================================


class TestIsStaffAvailable:
    # --- Basic schedule matching ---

    def test_returns_true_when_slot_fits_within_shift(self):
        # Monday, 10:00-11:00 (600-660) — within 09:00-17:00
        assert is_staff_available(standard_staff, "2026-03-16", 600, 660) is True

    def test_returns_false_when_slot_outside_working_hours(self):
        # Monday, 07:00-08:00 (420-480) — before 09:00
        assert is_staff_available(standard_staff, "2026-03-16", 420, 480) is False

    def test_returns_false_on_days_off(self):
        # Saturday — not working
        assert is_staff_available(standard_staff, "2026-03-14", 600, 660) is False

    def test_returns_true_when_slot_exactly_matches_shift(self):
        # Monday, exactly 09:00-17:00 (540-1020)
        assert is_staff_available(standard_staff, "2026-03-16", 540, 1020) is True

    def test_returns_false_when_slot_extends_beyond_shift(self):
        # Monday, 16:00-18:00 (960-1080) — extends past 17:00
        assert is_staff_available(standard_staff, "2026-03-16", 960, 1080) is False

    # --- Split shifts ---

    def test_returns_true_for_slot_in_first_block(self):
        # Monday, 10:00-11:00 (600-660) — within 09:00-12:00
        assert is_staff_available(split_shift_staff, "2026-03-16", 600, 660) is True

    def test_returns_true_for_slot_in_second_block(self):
        # Monday, 14:00-15:00 (840-900) — within 13:00-17:00
        assert is_staff_available(split_shift_staff, "2026-03-16", 840, 900) is True

    def test_returns_false_for_slot_spanning_gap(self):
        # Monday, 11:30-13:30 (690-810) — spans 12:00-13:00 gap
        assert is_staff_available(split_shift_staff, "2026-03-16", 690, 810) is False

    def test_returns_false_on_day_off_in_split_schedule(self):
        # Wednesday — Bob's day off
        assert is_staff_available(split_shift_staff, "2026-03-18", 600, 660) is False

    # --- Status checks ---

    def test_returns_false_for_inactive_staff(self):
        assert is_staff_available(inactive_staff, "2026-03-16", 600, 660) is False

    def test_returns_false_for_non_bookable_staff(self):
        assert is_staff_available(non_bookable_staff, "2026-03-16", 600, 660) is False

    # --- Date overrides ---

    def test_returns_false_for_date_override_off(self):
        overrides = [DateOverride(staff="staff-1", date="2026-03-16", type=DateOverrideType.OFF)]
        assert is_staff_available(standard_staff, "2026-03-16", 600, 660, overrides) is False

    def test_returns_false_for_date_override_sick(self):
        overrides = [DateOverride(staff="staff-1", date="2026-03-16", type=DateOverrideType.SICK)]
        assert is_staff_available(standard_staff, "2026-03-16", 600, 660, overrides) is False

    def test_uses_custom_blocks_from_override(self):
        overrides = [
            DateOverride(
                staff="staff-1",
                date="2026-03-16",
                type=DateOverrideType.CUSTOM,
                blocks=[TimeBlock(start="10:00", end="14:00")],
            ),
        ]
        # Within custom block
        assert is_staff_available(standard_staff, "2026-03-16", 600, 660, overrides) is True
        # Outside custom block (before)
        assert is_staff_available(standard_staff, "2026-03-16", 540, 570, overrides) is False
        # Outside custom block (after)
        assert is_staff_available(standard_staff, "2026-03-16", 900, 960, overrides) is False

    def test_date_override_takes_priority_over_weekly(self):
        overrides = [DateOverride(staff="staff-1", date="2026-03-16", type=DateOverrideType.OFF)]
        # Monday 10:00 — normally available, but override says "off"
        assert is_staff_available(standard_staff, "2026-03-16", 600, 660, overrides) is False

    # --- Edge: no schedule data ---

    def test_returns_false_when_no_weekly_shifts(self):
        no_schedule_staff = Staff(
            id="staff-noschedule",
            display_name="NoSchedule",
            is_bookable=True,
            status=StaffStatus.ACTIVE,
            store_ids=["store-1"],
            # weekly_shifts is None (default)
        )
        assert is_staff_available(no_schedule_staff, "2026-03-16", 600, 660) is False


# ============================================================================
# get_available_staff_for_slot
# ============================================================================


class TestGetAvailableStaffForSlot:
    all_staff = [standard_staff, split_shift_staff, inactive_staff, non_bookable_staff]

    def test_returns_available_staff_for_monday_morning(self):
        # Monday 10:00-11:00 — both standard and split shift are available
        result = get_available_staff_for_slot(self.all_staff, "2026-03-16", 600, 660)
        assert "staff-1" in result
        assert "staff-2" in result
        assert "staff-inactive" not in result
        assert "staff-nonbook" not in result

    def test_excludes_split_shift_during_lunch(self):
        # Monday 12:00-13:00 (720-780) — standard ok, split has gap
        result = get_available_staff_for_slot(self.all_staff, "2026-03-16", 720, 780)
        assert "staff-1" in result
        assert "staff-2" not in result

    def test_returns_empty_on_saturday(self):
        result = get_available_staff_for_slot(self.all_staff, "2026-03-14", 600, 660)
        assert result == []

    def test_returns_empty_when_no_staff(self):
        result = get_available_staff_for_slot([], "2026-03-16", 600, 660)
        assert result == []
