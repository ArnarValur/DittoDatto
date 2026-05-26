"""Tests for Company model validation.

Session 18 — platform company registry model.
"""

from __future__ import annotations

import pytest
from pydantic import ValidationError

from mercury_core.models.company import (
    Company,
    CompanySocialLinks,
    CompanyTier,
    EnabledFeatures,
    OnboardingStatus,
    StorePolicy,
)


class TestCompany:
    """Company model validation tests."""

    def test_minimal_valid(self) -> None:
        """Company with required fields only."""
        co = Company(
            owner_id="user_123",
            name="Merkurial Studio",
            slug="merkurial-studio",
        )
        assert co.name == "Merkurial Studio"
        assert co.slug == "merkurial-studio"
        assert co.owner_id == "user_123"
        assert co.tier == CompanyTier.FREE
        assert co.onboarding_status == OnboardingStatus.NOT_STARTED
        assert co.country == "NO"
        assert co.db_slug == ""

    def test_full_company(self) -> None:
        """Company with all fields populated."""
        co = Company(
            id="company_1",
            owner_id="user_123",
            owner_email="arnar@merkurial-studio.com",
            name="Merkurial Studio",
            slug="merkurial-studio",
            description="Creative studio",
            website="https://merkurial-studio.com",
            address="Storgata 1",
            city="Drammen",
            zip="3015",
            country="NO",
            email="hello@merkurial-studio.com",
            phone="+4712345678",
            logo_url="https://cdn.example.com/logo.png",
            tier=CompanyTier.PREMIUM,
            onboarding_status=OnboardingStatus.COMPLETE,
            db_slug="merkurial-studio",
        )
        assert co.tier == "premium"
        assert co.onboarding_status == "complete"
        assert co.city == "Drammen"

    def test_missing_owner_id_raises(self) -> None:
        """owner_id is required."""
        with pytest.raises(ValidationError):
            Company(name="Test", slug="test")  # type: ignore[call-arg]

    def test_missing_name_raises(self) -> None:
        """name is required."""
        with pytest.raises(ValidationError):
            Company(owner_id="u1", slug="test")  # type: ignore[call-arg]

    def test_missing_slug_raises(self) -> None:
        """slug is required."""
        with pytest.raises(ValidationError):
            Company(owner_id="u1", name="Test")  # type: ignore[call-arg]


class TestEnabledFeatures:
    """EnabledFeatures sub-model tests."""

    def test_defaults_all_false(self) -> None:
        """All features default to disabled."""
        f = EnabledFeatures()
        assert f.table_reservation is False
        assert f.ai_assistance is False
        assert f.ticket_system is False
        assert f.event_system is False

    def test_enable_features(self) -> None:
        """Individual features can be enabled."""
        f = EnabledFeatures(table_reservation=True, ai_assistance=True)
        assert f.table_reservation is True
        assert f.ai_assistance is True
        assert f.ticket_system is False


class TestStorePolicy:
    """StorePolicy sub-model tests."""

    def test_defaults(self) -> None:
        """Default policy: 1 store, no self-creation."""
        p = StorePolicy()
        assert p.max_stores == 1
        assert p.can_create_own_stores is False

    def test_premium_policy(self) -> None:
        """Premium policy with multiple stores."""
        p = StorePolicy(max_stores=5, can_create_own_stores=True)
        assert p.max_stores == 5
        assert p.can_create_own_stores is True


class TestCompanyTier:
    """Tier enum tests."""

    def test_free_value(self) -> None:
        assert CompanyTier.FREE == "free"

    def test_premium_value(self) -> None:
        assert CompanyTier.PREMIUM == "premium"


class TestOnboardingStatus:
    """Onboarding status enum tests."""

    def test_all_values(self) -> None:
        """All four statuses match the SurrealDB assertion."""
        assert OnboardingStatus.NOT_STARTED == "not_started"
        assert OnboardingStatus.AI_SUGGESTED == "ai_suggested"
        assert OnboardingStatus.VERIFIED == "verified"
        assert OnboardingStatus.COMPLETE == "complete"


class TestCompanySocialLinks:
    """Social links sub-model tests."""

    def test_all_optional(self) -> None:
        """All fields default to None."""
        s = CompanySocialLinks()
        assert s.fb is None
        assert s.ig is None
        assert s.x is None

    def test_partial_links(self) -> None:
        """Can set individual links."""
        s = CompanySocialLinks(ig="@merkurial")
        assert s.ig == "@merkurial"
        assert s.fb is None


class TestCompanySerialization:
    """Serialization roundtrip tests."""

    def test_model_dump_and_restore(self) -> None:
        """Company serializes cleanly and restores."""
        co = Company(
            owner_id="u1",
            name="Test Co",
            slug="test-co",
            tier=CompanyTier.PREMIUM,
            enabled_features=EnabledFeatures(table_reservation=True),
            store_policy=StorePolicy(max_stores=3),
        )
        data = co.model_dump()
        restored = Company(**data)
        assert restored.name == "Test Co"
        assert restored.tier == "premium"
        assert restored.enabled_features.table_reservation is True
        assert restored.store_policy.max_stores == 3
