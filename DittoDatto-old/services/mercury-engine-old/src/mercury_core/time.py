"""MercuryEngine — Time utility functions.

Replaces: packages/mercury-engine/src/core/shared/time.ts

Pure functions, zero dependencies beyond stdlib.
Foundation of the engine's time handling.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
from zoneinfo import ZoneInfo

# Day names indexed by weekday (Monday=0 in Python's isoweekday is 1..7,
# but we use .weekday() which gives Mon=0..Sun=6).
_DAYS = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]

_DEFAULT_TZ = "Europe/Oslo"


def get_day_name(date_str: str) -> str:
    """Get day name from ISO date string.

    Args:
        date_str: Date in YYYY-MM-DD format.

    Returns:
        Day name as 'mon', 'tue', 'wed', etc.
    """
    year, month, day = (int(p) for p in date_str.split("-"))
    # Use UTC to avoid timezone interpretation issues (matches V1 behavior).
    dt = datetime(year, month, day, tzinfo=UTC)
    return _DAYS[dt.weekday()]


def parse_time(time_str: str) -> int:
    """Parse time string to minutes from midnight.

    Args:
        time_str: Time string in HH:MM or H:MM format.

    Returns:
        Minutes since midnight.
    """
    h, m = (int(p) for p in time_str.split(":"))
    return h * 60 + m


def minutes_to_time(minutes: int) -> str:
    """Convert minutes from midnight to time string.

    Args:
        minutes: Minutes since midnight.

    Returns:
        Time string in HH:MM format.
    """
    h = minutes // 60
    m = minutes % 60
    return f"{h:02d}:{m:02d}"


def minutes_from_midnight(
    input_time: str | datetime,
    tz: str = _DEFAULT_TZ,
) -> int:
    """Convert ISO date string or datetime to minutes from midnight in a timezone.

    Args:
        input_time: ISO date string (e.g. '2026-03-14T09:00:00') or datetime.
        tz: IANA timezone string (default: 'Europe/Oslo').

    Returns:
        Minutes since midnight in the given timezone.
    """
    if isinstance(input_time, str):
        # Parse timezone-naive string and treat as local time in the given tz.
        # V1 does: new Date(input) which treats 'YYYY-MM-DDTHH:MM:SS' as local,
        # then extracts hour/minute in the target timezone.
        # For timezone-naive strings like "2026-03-14T09:00:00", we interpret
        # them as already being in the target timezone (matches V1 booking storage).
        dt = datetime.fromisoformat(input_time)
        if dt.tzinfo is None:
            # Treat as already in the target timezone — just extract h:m.
            return dt.hour * 60 + dt.minute
        # If it has tzinfo, convert to target timezone.
        dt = dt.astimezone(ZoneInfo(tz))
    else:
        dt = input_time.astimezone(ZoneInfo(tz))

    return dt.hour * 60 + dt.minute


@dataclass(frozen=True)
class StoreTimeContext:
    """Timezone-aware 'now' context for a store.

    Attributes:
        is_today: Whether the requested date matches 'today' in the store's timezone.
        store_now_minutes: Current time in the store's timezone, as minutes from midnight.
    """

    is_today: bool
    store_now_minutes: int


def get_store_now(store_timezone: str, request_date: str) -> StoreTimeContext:
    """Get timezone-aware 'now' context for a store.

    Used by both the appointment and reservation calculators.

    Args:
        store_timezone: IANA timezone (e.g. 'Europe/Oslo').
        request_date: The date being requested, 'YYYY-MM-DD'.

    Returns:
        StoreTimeContext with is_today and store_now_minutes.
    """
    tz_name = store_timezone or _DEFAULT_TZ
    tz = ZoneInfo(tz_name)
    now = datetime.now(tz)

    # 'Today' in the store's timezone (YYYY-MM-DD)
    store_today = now.strftime("%Y-%m-%d")
    is_today = store_today == request_date

    store_now_minutes = 0
    if is_today:
        store_now_minutes = now.hour * 60 + now.minute

    return StoreTimeContext(is_today=is_today, store_now_minutes=store_now_minutes)


def is_slot_in_past(
    slot_minutes: int,
    ctx: StoreTimeContext,
    notice_cutoff_min: int,
) -> bool:
    """Check if a slot is too close to 'now'.

    Returns True if the slot should be EXCLUDED.

    Args:
        slot_minutes: Slot start as minutes from midnight.
        ctx: StoreTimeContext from get_store_now().
        notice_cutoff_min: Minimum notice required (minutes).

    Returns:
        True if the slot is in the past or within the notice cutoff.
    """
    if not ctx.is_today:
        return False
    return slot_minutes - ctx.store_now_minutes < notice_cutoff_min
