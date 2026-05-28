"""MercuryEngine — Booking Receipt & Cancellation Policy.

Replaces:
    packages/mercury-engine/src/core/bookings/booking.ts → buildBookingReceipt
    packages/mercury-engine/src/core/bookings/booking.ts → checkCancellationPolicy

Pure functions — construct a booking snapshot and enforce cancellation rules.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timedelta

from mercury_core.errors import PolicyViolationError
from mercury_core.models.hold import Hold
from mercury_core.models.service import Service
from mercury_core.time import minutes_to_time, parse_time

# ============================================================================
# Booking Receipt
# ============================================================================


@dataclass
class BookingReceiptInput:
    """Input for building a booking receipt from a hold + services."""

    hold: Hold
    services: list[Service]
    user_name: str = ""
    user_email: str = ""
    store_name: str = ""
    payment_id: str | None = None
    notes: str | None = None


@dataclass
class BookingReceiptItem:
    """Single service within the receipt."""

    service_id: str
    title: str
    price: float
    duration: int
    staff_id: str | None = None


@dataclass
class BookingReceipt:
    """Immutable booking receipt (fiscal snapshot)."""

    id: str  # payment_id or generated
    user_id: str
    establishment: str
    service_id: str  # primary service
    status: str = "confirmed"
    start_time: str = ""
    end_time: str = ""
    duration: int = 0
    price_at_time_of_booking: float = 0.0
    service_title: str = ""
    user_name: str = ""
    user_email: str = ""
    store_name: str = ""
    staff_id: str | None = None
    notes: str | None = None
    items: list[BookingReceiptItem] = field(default_factory=list)


def build_booking_receipt(input_data: BookingReceiptInput) -> BookingReceipt:
    """Build an immutable booking receipt from a hold and service catalog.

    This is the snapshot pattern — prices, titles, and durations are frozen
    at the time of booking (Norwegian law, fiscal compliance).

    Args:
        input_data: Hold + services + user info.

    Returns:
        BookingReceipt with all computed fields.
    """
    hold = input_data.hold
    services = input_data.services

    # Resolve service IDs — V1 has serviceIds array, V2 Hold has services list
    service_ids = hold.services if hold.services else []

    # Legacy fallback — if no services list, might have a single service ref
    # (V1 had `serviceId` as well as `serviceIds`)
    if not service_ids:
        # In V2 we don't have a separate serviceId field, but the hold may
        # have been constructed with just one service
        service_ids = []

    # Match services to the hold
    if service_ids:
        matched_services = []
        for sid in service_ids:
            svc = next((s for s in services if s.id == sid), None)
            if svc:
                matched_services.append(svc)
    else:
        # Legacy: use all provided services
        matched_services = list(services)

    # Aggregate
    total_duration = sum(s.duration for s in matched_services)
    total_price = sum(s.price for s in matched_services)
    service_title = ", ".join(s.title for s in matched_services)
    primary_service_id = matched_services[0].id if matched_services else ""

    # Time computation
    slot_start = parse_time(hold.slot_time)
    slot_end = slot_start + total_duration
    start_time = f"{hold.date}T{hold.slot_time}:00"
    end_time = f"{hold.date}T{minutes_to_time(slot_end)}:00"

    # Build items
    items = [
        BookingReceiptItem(
            service_id=s.id or "",
            title=s.title,
            price=s.price,
            duration=s.duration,
            staff_id=hold.staff,
        )
        for s in matched_services
    ]

    # Trim notes
    notes = input_data.notes.strip() if input_data.notes else None
    if notes == "":
        notes = None

    return BookingReceipt(
        id=input_data.payment_id or hold.id or "",
        user_id=hold.user_id,
        establishment=hold.establishment,
        service_id=primary_service_id or "",
        status="confirmed",
        start_time=start_time,
        end_time=end_time,
        duration=total_duration,
        price_at_time_of_booking=total_price,
        service_title=service_title,
        user_name=input_data.user_name,
        user_email=input_data.user_email,
        store_name=input_data.store_name,
        staff_id=hold.staff,
        notes=notes,
        items=items,
    )


# ============================================================================
# Cancellation Policy
# ============================================================================


@dataclass
class CancellationPolicyInput:
    """Policy check input for the V1 contract."""

    client_cancel_enabled: bool = True
    min_cancel_notice_hours: int = 0


def check_cancellation_policy(
    booking_start_time: str | datetime,
    policy: CancellationPolicyInput,
    now: datetime | None = None,
) -> None:
    """Check if a cancellation is allowed under the given policy.

    Args:
        booking_start_time: When the booking starts (ISO string or datetime).
        policy: The cancellation policy to enforce.
        now: Current time (defaults to datetime.now()).

    Raises:
        PolicyViolationError: If cancellation is not allowed.
    """
    if not policy.client_cancel_enabled:
        raise PolicyViolationError("This establishment does not allow customer cancellations")

    if policy.min_cancel_notice_hours <= 0:
        return  # No notice requirement

    # Parse booking start
    if isinstance(booking_start_time, str):
        booking_start = datetime.fromisoformat(booking_start_time)
    else:
        booking_start = booking_start_time

    current_time = now or datetime.now()
    deadline = booking_start - timedelta(hours=policy.min_cancel_notice_hours)

    if current_time > deadline:
        raise PolicyViolationError(
            "Cancellation deadline has passed",
            details={
                "deadline": deadline.isoformat(),
                "notice_hours": policy.min_cancel_notice_hours,
            },
        )
