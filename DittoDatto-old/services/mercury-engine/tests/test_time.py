"""Tests for mercury_core.time — ported from core/shared/time.test.ts.

Pure functions — zero dependencies, zero mocking needed.
These are the foundation of the engine's time handling.
"""

from datetime import datetime
from zoneinfo import ZoneInfo

from mercury_core.time import (
    StoreTimeContext,
    get_day_name,
    get_store_now,
    is_slot_in_past,
    minutes_from_midnight,
    minutes_to_time,
    parse_time,
)

# ============================================================================
# get_day_name
# ============================================================================


class TestGetDayName:
    def test_returns_correct_day_for_known_dates(self):
        # 2026-03-14 is a Saturday
        assert get_day_name("2026-03-14") == "sat"
        # 2026-03-15 is a Sunday
        assert get_day_name("2026-03-15") == "sun"
        # 2026-03-16 is a Monday
        assert get_day_name("2026-03-16") == "mon"

    def test_handles_month_boundaries(self):
        # 2026-02-28 is a Saturday
        assert get_day_name("2026-02-28") == "sat"
        # 2026-03-01 is a Sunday
        assert get_day_name("2026-03-01") == "sun"

    def test_handles_year_boundaries(self):
        # 2025-12-31 is a Wednesday
        assert get_day_name("2025-12-31") == "wed"
        # 2026-01-01 is a Thursday
        assert get_day_name("2026-01-01") == "thu"

    def test_uses_utc_to_avoid_timezone_day_shift(self):
        # Key scenario: midnight UTC dates should not shift to prev/next day.
        assert get_day_name("2026-03-09") == "mon"


# ============================================================================
# parse_time
# ============================================================================


class TestParseTime:
    def test_parses_hhmm_to_minutes(self):
        assert parse_time("00:00") == 0
        assert parse_time("09:00") == 540
        assert parse_time("09:15") == 555
        assert parse_time("12:00") == 720
        assert parse_time("23:59") == 1439

    def test_handles_single_digit_hours(self):
        assert parse_time("9:00") == 540


# ============================================================================
# minutes_to_time
# ============================================================================


class TestMinutesToTime:
    def test_converts_minutes_to_hhmm(self):
        assert minutes_to_time(0) == "00:00"
        assert minutes_to_time(540) == "09:00"
        assert minutes_to_time(555) == "09:15"
        assert minutes_to_time(720) == "12:00"
        assert minutes_to_time(1439) == "23:59"

    def test_is_inverse_of_parse_time(self):
        times = ["00:00", "09:00", "09:15", "12:30", "18:45", "23:59"]
        for t in times:
            assert minutes_to_time(parse_time(t)) == t


# ============================================================================
# minutes_from_midnight
# ============================================================================


class TestMinutesFromMidnight:
    def test_converts_timezone_naive_local_time_string(self):
        # "2026-03-14T09:00:00" treated as local → 540 minutes
        result = minutes_from_midnight("2026-03-14T09:00:00", "Europe/Oslo")
        assert result == 540

    def test_converts_midnight(self):
        result = minutes_from_midnight("2026-03-14T00:00:00", "Europe/Oslo")
        assert result == 0

    def test_defaults_to_europe_oslo(self):
        with_explicit = minutes_from_midnight("2026-03-14T12:00:00", "Europe/Oslo")
        with_default = minutes_from_midnight("2026-03-14T12:00:00")
        assert with_explicit == with_default


# ============================================================================
# get_store_now
# ============================================================================


class TestGetStoreNow:
    def test_returns_is_today_false_for_future_dates(self):
        ctx = get_store_now("Europe/Oslo", "2099-12-31")
        assert ctx.is_today is False
        assert ctx.store_now_minutes == 0

    def test_returns_is_today_false_for_past_dates(self):
        ctx = get_store_now("Europe/Oslo", "2020-01-01")
        assert ctx.is_today is False
        assert ctx.store_now_minutes == 0

    def test_returns_is_today_true_for_today(self):
        # Get today's date in Europe/Oslo timezone
        now = datetime.now(ZoneInfo("Europe/Oslo"))
        today = now.strftime("%Y-%m-%d")
        ctx = get_store_now("Europe/Oslo", today)
        assert ctx.is_today is True
        assert ctx.store_now_minutes > 0  # unless running at midnight

    def test_defaults_to_europe_oslo_when_empty_string(self):
        ctx = get_store_now("", "2099-12-31")
        assert ctx.is_today is False  # just verifying it doesn't crash


# ============================================================================
# is_slot_in_past
# ============================================================================


class TestIsSlotInPast:
    def test_returns_false_when_not_today(self):
        ctx = StoreTimeContext(is_today=False, store_now_minutes=600)
        # Even if slot is at 09:00 (540) and "now" is 10:00 (600), not today → not past
        assert is_slot_in_past(540, ctx, 0) is False

    def test_returns_true_when_slot_is_before_now(self):
        ctx = StoreTimeContext(is_today=True, store_now_minutes=600)  # 10:00
        # Slot at 09:00 (540) with 0 notice → 540 - 600 = -60 < 0 → past
        assert is_slot_in_past(540, ctx, 0) is True

    def test_returns_false_when_slot_is_after_now(self):
        ctx = StoreTimeContext(is_today=True, store_now_minutes=600)  # 10:00
        # Slot at 11:00 (660) with 0 notice → 660 - 600 = 60 >= 0 → not past
        assert is_slot_in_past(660, ctx, 0) is False

    def test_enforces_notice_cutoff(self):
        ctx = StoreTimeContext(is_today=True, store_now_minutes=600)  # 10:00
        # Slot at 10:30 (630) with 60 min notice → 630 - 600 = 30 < 60 → past
        assert is_slot_in_past(630, ctx, 60) is True
        # Slot at 11:15 (675) with 60 min notice → 675 - 600 = 75 >= 60 → ok
        assert is_slot_in_past(675, ctx, 60) is False

    def test_edge_case_slot_exactly_at_notice_boundary(self):
        ctx = StoreTimeContext(is_today=True, store_now_minutes=600)  # 10:00
        # Slot at 11:00 (660) with 60 min notice → 660 - 600 = 60, NOT < 60 → not past
        assert is_slot_in_past(660, ctx, 60) is False
