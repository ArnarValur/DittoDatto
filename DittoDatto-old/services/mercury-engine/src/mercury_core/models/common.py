"""Common types, enums, and base model for MercuryEngine domain objects.

Source of truth: schemas/company-blueprint.surql
Translation: SurrealDB SCHEMAFULL → Pydantic v2
"""

from __future__ import annotations

from datetime import datetime
from enum import StrEnum

from pydantic import BaseModel, ConfigDict, Field

# =============================================================================
# Base Model
# =============================================================================


class MercuryModel(BaseModel):
    """Base model for all MercuryEngine domain objects.

    Conventions:
    - Strips whitespace from strings
    - Uses enum values (not enum instances) for serialization
    - Validates default values
    """

    model_config = ConfigDict(
        str_strip_whitespace=True,
        use_enum_values=True,
        validate_default=True,
    )


class TimestampMixin(BaseModel):
    """Mixin for SurrealDB-managed timestamps."""

    created_at: datetime | None = None
    updated_at: datetime | None = None


class SoftDeleteMixin(BaseModel):
    """Mixin for GDPR soft-delete pattern (Session 9)."""

    deleted_at: datetime | None = None


# =============================================================================
# Enums (from ASSERT $value IN [...] constraints in .surql schemas)
# =============================================================================


class Currency(StrEnum):
    """Supported currencies. Default: NOK (Norwegian Krone)."""

    NOK = "NOK"
    SEK = "SEK"
    DKK = "DKK"
    EUR = "EUR"
    ISK = "ISK"


class StoreType(StrEnum):
    """Establishment classification. Cosmetic only — affects UI/Datto personality.

    Ref: Session 2 decision — storeType does NOT determine feature access or booking modes.
    """

    STORE = "store"
    RESTAURANT = "restaurant"
    VENUE = "venue"


class BookingFormType(StrEnum):
    """Legacy booking form type on establishment. Being superseded by per-service BookingMode."""

    STANDARD = "standard"
    NONE = "none"
    TABLE_RESERVATION = "tableReservation"
    TICKET_SYSTEM = "ticketSystem"


class BookingMode(StrEnum):
    """Per-service booking mode (ADR-0004).

    Determines which booking vertical handles the service.
    """

    STANDARD = "standard"
    TABLE_RESERVATION = "tableReservation"
    TICKET_SYSTEM = "ticketSystem"


class BookingStatus(StrEnum):
    """Booking lifecycle states."""

    CONFIRMED = "confirmed"
    COMPLETED = "completed"
    CANCELLED = "cancelled"
    NO_SHOW = "no-show"
    PENDING = "pending"


class BookingChannel(StrEnum):
    """How a booking was created. Used for CRM analytics."""

    APP = "app"
    WEB = "web"
    VOICE_AGENT = "voice_agent"
    PORTAL = "portal"
    PHONE = "phone"


class PaymentStatus(StrEnum):
    """Hold payment status (Vipps integration, v1.3)."""

    PENDING = "pending"
    INITIATED = "initiated"
    FAILED = "failed"


class StaffStatus(StrEnum):
    """Staff member lifecycle."""

    INVITED = "invited"
    ACTIVE = "active"
    SUSPENDED = "suspended"
    REMOVED = "removed"


class CustomerStatus(StrEnum):
    """CRM customer status."""

    NEW = "new"
    ACTIVE = "active"
    INACTIVE = "inactive"


class CustomerChannel(StrEnum):
    """How the customer was acquired."""

    APP = "app"
    WEB = "web"
    PORTAL = "portal"
    IMPORT = "import"


class ResourceType(StrEnum):
    """Physical or logical resource type."""

    ROOM = "room"
    TABLE = "table"
    STATION = "station"
    EQUIPMENT = "equipment"
    ADDON = "addon"


class ResourcePriority(StrEnum):
    """Resource allocation priority for best-fit algorithm."""

    LOW = "low"
    NORMAL = "normal"
    HIGH = "high"


class DateOverrideType(StrEnum):
    """Staff date override types."""

    OFF = "off"
    SICK = "sick"
    CUSTOM = "custom"


class CoverLayoutMode(StrEnum):
    """Establishment cover image layout."""

    SHOWCASE = "showcase"
    SPOTLIGHT = "spotlight"
    BENTO = "bento"


class LargePartyHandling(StrEnum):
    """How to handle parties exceeding max_guests."""

    EMAIL = "email"
    CALL = "call"
    DATTO = "datto"
    DISABLED = "disabled"


class CapacityMode(StrEnum):
    """Reservation capacity calculation mode."""

    POOL = "pool"
    TABLES = "tables"
    HYBRID = "hybrid"


class StaffRole(StrEnum):
    """Staff role at an establishment (graph edge: works_at)."""

    OWNER = "owner"
    ADMIN = "admin"
    EMPLOYEE = "employee"


class OverCapacityPolicy(StrEnum):
    """What happens when a service booking exceeds resource capacity."""

    REJECT = "reject"
    REQUEST = "request"
    ALLOW = "allow"


# =============================================================================
# Embedded Sub-Models (1:1 objects embedded in parent documents)
# =============================================================================


class TimeBlock(MercuryModel):
    """A time range within a shift or override."""

    start: str  # HH:MM format
    end: str  # HH:MM format
    label: str | None = None


class DaySchedule(MercuryModel):
    """Single day in an opening schedule or weekly shift."""

    is_open: bool = False
    open: str = "09:00"  # HH:MM
    close: str = "17:00"  # HH:MM


class ShiftDay(MercuryModel):
    """Single day in a staff member's weekly shift schedule."""

    is_working: bool = False
    blocks: list[TimeBlock] = Field(default_factory=list)


class SocialLinks(MercuryModel):
    """Social media links for an establishment."""

    fb: str | None = None
    ig: str | None = None
    x: str | None = None


class EstablishmentImages(MercuryModel):
    """Media references for an establishment."""

    logo: str | None = None
    cover: str | None = None
    gallery: list[str] = Field(default_factory=list)


class AggregateRating(MercuryModel):
    """Cached rating summary."""

    average: float = 0.0
    count: int = 0


class BookingPolicy(MercuryModel):
    """Establishment-level booking policy. Embedded in Establishment.

    Source: company-blueprint.surql lines 68-78
    """

    max_bookable_future_days: int = 60
    min_booking_notice_minutes: int = 60
    slot_interval: int = 15
    client_cancel_enabled: bool = True
    min_cancel_notice_hours: int = 24
    client_reschedule_enabled: bool = True
    min_reschedule_notice_hours: int = 24
    booking_confirmation_message: str | None = None
    no_show_fee_percent: int = 0


class ReservationConfig(MercuryModel):
    """Restaurant-specific reservation settings. Embedded in Establishment.

    Source: company-blueprint.surql lines 90-101
    """

    max_guests: int = 8
    large_party_handling: LargePartyHandling = LargePartyHandling.EMAIL
    large_party_contact: str | None = None
    default_duration: int = 90
    slot_interval: int = 30
    buffer_between_slots: int = 0
    capacity_mode: CapacityMode = CapacityMode.POOL
    total_capacity: int | None = None
    auto_confirm: bool = True
