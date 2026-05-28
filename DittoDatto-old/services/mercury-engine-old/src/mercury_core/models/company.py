"""Company model for the platform registry.

Stored in titan/platform.company.
Each company record maps to a titan/company_{slug} database.

Schema source: schemas/platform.surql §1 (company table)
"""

from __future__ import annotations

from enum import StrEnum

from pydantic import Field

from mercury_core.models.common import MercuryModel, SoftDeleteMixin, TimestampMixin


class CompanyTier(StrEnum):
    """Subscription tier. Determines feature access and limits."""

    FREE = "free"
    PREMIUM = "premium"


class OnboardingStatus(StrEnum):
    """Company onboarding progress.

    Tracks the Reverse Conductor pattern:
    not_started → ai_suggested → verified → complete.
    """

    NOT_STARTED = "not_started"
    AI_SUGGESTED = "ai_suggested"
    VERIFIED = "verified"
    COMPLETE = "complete"


class EnabledFeatures(MercuryModel):
    """Feature flags for a company.

    Transitional SaaS scaffolding — will become Datto-mediated in v1.5.
    """

    table_reservation: bool = False
    ai_assistance: bool = False
    ticket_system: bool = False
    event_system: bool = False


class StorePolicy(MercuryModel):
    """Company-level store creation policy."""

    max_stores: int = 1
    can_create_own_stores: bool = False


class CompanySocialLinks(MercuryModel):
    """Social media links for a company."""

    fb: str | None = None
    ig: str | None = None
    x: str | None = None


class Company(MercuryModel, TimestampMixin, SoftDeleteMixin):
    """Platform company registry record.

    Each company here corresponds to a titan/company_{slug} database.
    Managed by platform admins via the admin panel.

    Attributes:
        owner_id: User ID of the company owner (cross-DB ref to enceladus).
        owner_email: Owner email for quick access (denormalized).
        name: Legal/display name.
        slug: URL-safe unique identifier. Maps to database name.
        tier: Subscription level (free/premium).
        onboarding_status: Tracks provisioning progress.
        enabled_features: Feature flags for SaaS gating.
        store_policy: How many establishments the company can create.
        db_slug: Database identifier (usually same as slug).
    """

    id: str | None = None
    owner_id: str
    owner_email: str | None = None
    name: str
    slug: str
    description: str | None = None
    website: str | None = None

    # Address
    address: str | None = None
    city: str | None = None
    zip: str | None = None
    country: str = "NO"

    # Contact
    email: str | None = None
    phone: str | None = None
    logo_url: str | None = None

    # Tier & onboarding
    tier: CompanyTier = CompanyTier.FREE
    onboarding_status: OnboardingStatus = OnboardingStatus.NOT_STARTED

    # Feature flags & policies
    enabled_features: EnabledFeatures = Field(default_factory=EnabledFeatures)
    store_policy: StorePolicy = Field(default_factory=StorePolicy)
    social_links: CompanySocialLinks | None = None

    # Database reference
    db_slug: str = ""

    # Manager/member references (cross-DB user IDs)
    manager_ids: list[str] | None = None
    member_ids: list[str] | None = None
