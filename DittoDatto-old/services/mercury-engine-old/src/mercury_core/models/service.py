"""Service and ServiceGroup models.

Source: schemas/company-blueprint.surql §1.2–1.3
Zod origin: packages/shared-types/src/service.ts, service-group.ts
"""

from __future__ import annotations

from pydantic import Field

from .common import (
    BookingMode,
    Currency,
    MercuryModel,
    OverCapacityPolicy,
    SoftDeleteMixin,
    TimestampMixin,
)


class Service(MercuryModel, TimestampMixin, SoftDeleteMixin):
    """A bookable service offered by an establishment.

    Booking mode is per-service (ADR-0004), not per-establishment.
    """

    id: str | None = None

    # Relationships (record IDs as strings — resolved by repository layer)
    establishment: str = ""
    group: str | None = None  # record<service_group>
    assigned_staff: list[str] = Field(default_factory=list)  # array<record<staff>>
    required_resource_groups: list[str] = Field(default_factory=list)

    # Identity
    title: str = ""
    description: str | None = None

    # Booking mode (ADR-0004)
    booking_mode: BookingMode = BookingMode.STANDARD

    # Media
    cover_image: str | None = None
    gallery: list[str] | None = None

    # Taxonomy
    service_type: list[str] = Field(default_factory=list)
    subcategory: str | None = None

    # AI / Discovery
    keywords: list[str] = Field(default_factory=list)
    ai_description: str | None = None
    embedding: list[float] | None = None

    # Time & Pricing
    duration: int = 30  # minutes
    price: float = 0.0
    buffer_time: int = 0  # minutes
    currency: Currency = Currency.NOK

    # Policies
    over_capacity_policy: OverCapacityPolicy = OverCapacityPolicy.REJECT
    min_booking_notice_minutes: int = 0
    slot_interval: int = 15

    # Status
    is_active: bool = True


class ServiceGroup(MercuryModel, TimestampMixin, SoftDeleteMixin):
    """Logical grouping of services for display and booking panel.

    Source: company-blueprint.surql §1.3
    """

    id: str | None = None
    establishment: str = ""
    name: str = ""
    description: str | None = None
    staff_ids: list[str] | None = None
    sort_order: int = 0
    show_on_booking_panel: bool = True
    multi_select: bool = False
