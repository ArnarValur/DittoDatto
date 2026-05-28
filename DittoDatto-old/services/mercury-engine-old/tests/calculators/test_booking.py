"""Tests for mercury_core.calculators.booking — ported from booking-receipt.test.ts.

Tests booking receipt construction (snapshot pattern) and cancellation policy enforcement.
"""

from datetime import datetime

import pytest

from mercury_core.calculators.booking import (
    BookingReceiptInput,
    CancellationPolicyInput,
    build_booking_receipt,
    check_cancellation_policy,
)
from mercury_core.errors import PolicyViolationError
from mercury_core.models.hold import Hold
from mercury_core.models.service import Service

# ============================================================================
# Fixtures
# ============================================================================


def make_hold(**overrides) -> Hold:
    defaults = {
        "id": "store-1_2099-03-16_10:00_user-123",
        "user_id": "user-123",
        "establishment": "store-1",
        "services": ["svc-1"],
        "date": "2099-03-16",
        "slot_time": "10:00",
        "duration": 60,
        "expires_at": datetime(2099, 12, 31),
        "created_at": datetime(2026, 1, 1),
    }
    defaults.update(overrides)
    return Hold(**defaults)


def make_service(**overrides) -> Service:
    defaults = {
        "id": "svc-1",
        "title": "Haircut",
        "duration": 60,
        "price": 500,
        "currency": "NOK",
    }
    defaults.update(overrides)
    return Service(**defaults)


def default_input(**overrides) -> BookingReceiptInput:
    defaults = {
        "hold": make_hold(),
        "services": [make_service()],
        "user_name": "John Doe",
        "user_email": "john@example.com",
        "store_name": "Cool Barbers",
        "payment_id": "pay_abc123",
    }
    defaults.update(overrides)
    return BookingReceiptInput(**defaults)


# ============================================================================
# buildBookingReceipt
# ============================================================================


class TestBuildBookingReceipt:
    def test_creates_booking_with_correct_identity(self):
        result = build_booking_receipt(default_input())
        assert result.id == "pay_abc123"
        assert result.user_id == "user-123"
        assert result.establishment == "store-1"
        assert result.service_id == "svc-1"
        assert result.status == "confirmed"

    def test_aggregates_price_and_duration(self):
        inp = default_input(
            hold=make_hold(services=["svc-1", "svc-2"]),
            services=[
                make_service(id="svc-1", title="Haircut", duration=30, price=300),
                make_service(id="svc-2", title="Beard Trim", duration=15, price=150),
            ],
        )
        result = build_booking_receipt(inp)
        assert result.duration == 45
        assert result.price_at_time_of_booking == 450
        assert result.service_title == "Haircut, Beard Trim"

    def test_calculates_correct_start_end_times(self):
        result = build_booking_receipt(default_input())
        assert result.start_time == "2099-03-16T10:00:00"
        assert result.end_time == "2099-03-16T11:00:00"

    def test_handles_slot_crossing_hour_boundaries(self):
        inp = default_input(
            hold=make_hold(slot_time="10:45"),
            services=[make_service(duration=90)],
        )
        result = build_booking_receipt(inp)
        assert result.start_time == "2099-03-16T10:45:00"
        assert result.end_time == "2099-03-16T12:15:00"

    def test_builds_items_array(self):
        inp = default_input(
            hold=make_hold(services=["svc-1", "svc-2"], staff="staff-1"),
            services=[
                make_service(id="svc-1", title="Haircut"),
                make_service(id="svc-2", title="Wash"),
            ],
        )
        result = build_booking_receipt(inp)
        assert len(result.items) == 2
        assert result.items[0].service_id == "svc-1"
        assert result.items[0].staff_id == "staff-1"
        assert result.items[1].service_id == "svc-2"

    def test_includes_staff_id_when_hold_has_staff(self):
        inp = default_input(hold=make_hold(staff="staff-alice"))
        result = build_booking_receipt(inp)
        assert result.staff_id == "staff-alice"

    def test_omits_staff_id_when_hold_has_no_staff(self):
        result = build_booking_receipt(default_input())
        assert result.staff_id is None

    def test_attaches_store_name(self):
        result = build_booking_receipt(default_input())
        assert result.store_name == "Cool Barbers"

    def test_trims_notes_and_omits_if_empty(self):
        inp = default_input(notes="  No allergies  ")
        result = build_booking_receipt(inp)
        assert result.notes == "No allergies"

        inp2 = default_input(notes="   ")
        result2 = build_booking_receipt(inp2)
        assert result2.notes is None

    def test_falls_back_to_legacy_service_id(self):
        # When hold has no services list, uses all provided services
        inp = default_input(
            hold=make_hold(services=[]),
            services=[make_service(id="legacy-svc")],
        )
        result = build_booking_receipt(inp)
        assert result.service_id == "legacy-svc"


# ============================================================================
# checkCancellationPolicy
# ============================================================================


class TestCheckCancellationPolicy:
    def test_allows_cancellation_when_policy_permits(self):
        # Should not raise
        check_cancellation_policy(
            "2099-03-16T14:00:00",
            CancellationPolicyInput(client_cancel_enabled=True, min_cancel_notice_hours=0),
        )

    def test_throws_when_cancel_disabled(self):
        with pytest.raises(PolicyViolationError, match="does not allow"):
            check_cancellation_policy(
                "2099-03-16T14:00:00",
                CancellationPolicyInput(client_cancel_enabled=False, min_cancel_notice_hours=0),
            )

    def test_allows_cancellation_before_deadline(self):
        booking_start = datetime.fromisoformat("2099-03-16T14:00:00")
        now = datetime.fromisoformat("2099-03-16T10:00:00")  # 4 hours before
        check_cancellation_policy(
            booking_start,
            CancellationPolicyInput(client_cancel_enabled=True, min_cancel_notice_hours=2),
            now=now,
        )

    def test_throws_when_past_deadline(self):
        booking_start = datetime.fromisoformat("2099-03-16T14:00:00")
        now = datetime.fromisoformat("2099-03-16T13:00:00")  # 1 hour before, needs 2
        with pytest.raises(PolicyViolationError, match="deadline has passed"):
            check_cancellation_policy(
                booking_start,
                CancellationPolicyInput(client_cancel_enabled=True, min_cancel_notice_hours=2),
                now=now,
            )

    def test_allows_cancellation_exactly_at_deadline(self):
        booking_start = datetime.fromisoformat("2099-03-16T14:00:00")
        now = datetime.fromisoformat("2099-03-16T12:00:00")  # Exactly 2 hours
        check_cancellation_policy(
            booking_start,
            CancellationPolicyInput(client_cancel_enabled=True, min_cancel_notice_hours=2),
            now=now,
        )

    def test_handles_string_booking_start_time(self):
        check_cancellation_policy(
            "2099-03-16T14:00:00",
            CancellationPolicyInput(client_cancel_enabled=True, min_cancel_notice_hours=2),
            now=datetime.fromisoformat("2099-03-16T10:00:00"),
        )
