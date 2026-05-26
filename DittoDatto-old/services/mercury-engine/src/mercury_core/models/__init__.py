"""Pydantic models for the DittoDatto booking domain.

These models are the source of truth for the platform (replacing Zod schemas).
Ported from: schemas/company-blueprint.surql + packages/shared-types/src/
"""

from .auth import ActorRole, DevLoginRequest, TokenClaims, TokenResponse
from .booking import Booking, BookingItem
from .category import Category
from .common import (
    AggregateRating,
    BookingChannel,
    BookingFormType,
    BookingMode,
    BookingPolicy,
    BookingStatus,
    CapacityMode,
    CoverLayoutMode,
    Currency,
    CustomerChannel,
    CustomerStatus,
    DateOverrideType,
    DaySchedule,
    EstablishmentImages,
    LargePartyHandling,
    MercuryModel,
    OverCapacityPolicy,
    PaymentStatus,
    ReservationConfig,
    ResourcePriority,
    ResourceType,
    ShiftDay,
    SocialLinks,
    SoftDeleteMixin,
    StaffRole,
    StaffStatus,
    StoreType,
    TimeBlock,
    TimestampMixin,
)
from .company import (
    Company,
    CompanySocialLinks,
    CompanyTier,
    EnabledFeatures,
    OnboardingStatus,
    StorePolicy,
)
from .customer import Customer
from .establishment import Establishment
from .hold import Hold
from .resource import Resource, ResourceGroup
from .service import Service, ServiceGroup
from .staff import DateOverride, Staff
from .user import User

__all__ = [
    # Base
    "MercuryModel",
    "TimestampMixin",
    "SoftDeleteMixin",
    # Auth models
    "ActorRole",
    "TokenClaims",
    "DevLoginRequest",
    "TokenResponse",
    "User",
    # Domain models
    "Establishment",
    "Service",
    "ServiceGroup",
    "Staff",
    "DateOverride",
    "Booking",
    "BookingItem",
    "Hold",
    "Resource",
    "ResourceGroup",
    "Customer",
    # Platform models (admin)
    "Category",
    "Company",
    "CompanyTier",
    "OnboardingStatus",
    "EnabledFeatures",
    "StorePolicy",
    "CompanySocialLinks",
    # Embedded models
    "BookingPolicy",
    "ReservationConfig",
    "DaySchedule",
    "ShiftDay",
    "TimeBlock",
    "SocialLinks",
    "EstablishmentImages",
    "AggregateRating",
    # Enums
    "Currency",
    "StoreType",
    "BookingFormType",
    "BookingMode",
    "BookingStatus",
    "BookingChannel",
    "PaymentStatus",
    "StaffStatus",
    "StaffRole",
    "CustomerStatus",
    "CustomerChannel",
    "ResourceType",
    "ResourcePriority",
    "DateOverrideType",
    "CoverLayoutMode",
    "LargePartyHandling",
    "CapacityMode",
    "OverCapacityPolicy",
]
