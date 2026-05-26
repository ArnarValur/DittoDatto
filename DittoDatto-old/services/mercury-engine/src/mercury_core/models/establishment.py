"""Establishment model — the core business entity in DittoDatto.

Source: schemas/company-blueprint.surql §1.1 (establishment table)
Zod origin: packages/shared-types/src/store.ts (StoreSchema)

Note: Called "establishment" in SurrealDB/Pydantic, "store" in Zod/Firestore.
The repository layer maps between naming conventions (Session 2 decision).
"""

from __future__ import annotations

from .common import (
    AggregateRating,
    BookingFormType,
    BookingPolicy,
    CoverLayoutMode,
    DaySchedule,
    EstablishmentImages,
    MercuryModel,
    ReservationConfig,
    SocialLinks,
    SoftDeleteMixin,
    StoreType,
    TimestampMixin,
)


class Establishment(MercuryModel, TimestampMixin, SoftDeleteMixin):
    """A business location registered on the DittoDatto platform.

    Each establishment belongs to a company database (titan/company_{slug}).
    companyId is implicit via database isolation — not stored on the record.
    """

    id: str | None = None

    # Identity
    name: str
    slug: str

    # Address
    address: str = ""
    city: str = ""
    zip: str = ""
    country: str = "NO"

    # Geo — native SurrealDB geometry<point> → (lat, lng) tuple
    location: tuple[float, float] | None = None

    # Contact & Branding
    phone: str | None = None
    email: str | None = None
    website: str | None = None
    social_links: SocialLinks | None = None
    about: str | None = None

    # Media
    images: EstablishmentImages = EstablishmentImages()
    cover_layout_mode: CoverLayoutMode = CoverLayoutMode.BENTO

    # Schedule (embedded — always fetched with establishment)
    opening_schedule: dict[str, DaySchedule] = {}
    timezone: str = "Europe/Oslo"

    # Booking Policy (embedded 1:1)
    booking_policy: BookingPolicy | None = None

    # Classification
    store_type: StoreType = StoreType.STORE
    category: str | None = None

    # Feature flags
    resources_enabled: bool = False
    booking_form_type: BookingFormType = BookingFormType.STANDARD

    # Reservation config (embedded, optional — restaurants only)
    reservation_config: ReservationConfig | None = None

    # Status & Metrics
    is_published: bool = False
    is_active: bool = True
    aggregate_rating: AggregateRating | None = None
    favorites_count: int = 0
