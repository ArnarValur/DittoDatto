"""Booking model — the core transactional entity.

Source: schemas/company-blueprint.surql §2.1
Zod origin: packages/shared-types/src/booking.ts

Fiscal snapshot fields (service_title, price_at_booking) are immutable at booking
time — Norwegian law requires preserving the price agreed at time of transaction.
"""

from __future__ import annotations

from datetime import datetime

from pydantic import Field

from .common import (
    BookingChannel,
    BookingStatus,
    Currency,
    MercuryModel,
    SoftDeleteMixin,
    TimestampMixin,
)


class BookingItem(MercuryModel):
    """Individual service within a multi-service booking.

    Embeds fiscal snapshot of each service at booking time.
    """

    service: str  # record<service>
    title: str
    price: float
    duration: int  # minutes
    staff: str | None = None  # record<staff>


class Booking(MercuryModel, TimestampMixin, SoftDeleteMixin):
    """A confirmed or pending booking.

    Key design decisions:
    - Fiscal snapshot: service_title + price_at_booking frozen at booking time
    - User snapshot: user_name + user_email preserved if user deletes account
    - Multi-service: items[] array for composite bookings (same-store only)
    """

    id: str | None = None

    # Relationships (record IDs as strings)
    user_id: str = ""
    establishment: str = ""  # record<establishment>
    service: str = ""  # record<service>
    staff: str | None = None  # record<staff>
    resource: str | None = None  # record<resource>
    addon_resources: list[str] = Field(default_factory=list)

    # Status & Time
    status: BookingStatus = BookingStatus.PENDING
    start_time: datetime | None = None
    end_time: datetime | None = None

    # Fiscal snapshot (immutable — Norwegian law)
    service_title: str = ""
    duration: int = 0  # minutes
    price_at_booking: float = 0.0
    currency: Currency = Currency.NOK

    # User snapshot (preserved if user deletes account)
    user_name: str = ""
    user_email: str = ""
    user_phone: str | None = None

    # Multi-service items (embedded array)
    items: list[BookingItem] = Field(default_factory=list)

    # Metadata
    channel: BookingChannel = BookingChannel.APP
    attendee_count: int = 1
    notes: str | None = None
    cancellation_reason: str | None = None
    payment_id: str | None = None
