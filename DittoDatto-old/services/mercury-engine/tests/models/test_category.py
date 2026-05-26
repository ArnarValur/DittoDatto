"""Tests for Category model validation.

Session 18 — platform taxonomy model.
"""

from __future__ import annotations

import pytest
from pydantic import ValidationError

from mercury_core.models.category import Category


class TestCategory:
    """Category model validation tests."""

    def test_minimal_valid(self) -> None:
        """Category with just name and slug is valid."""
        cat = Category(name="Hair Salon", slug="hair-salon")
        assert cat.name == "Hair Salon"
        assert cat.slug == "hair-salon"
        assert cat.description is None
        assert cat.icon is None
        assert cat.count == 0
        assert cat.id is None

    def test_full_category(self) -> None:
        """Category with all fields populated."""
        cat = Category(
            id="cat_123",
            name="Thai Massage",
            slug="thai-massage",
            description="Traditional Thai massage services",
            icon="spa",
            count=42,
        )
        assert cat.name == "Thai Massage"
        assert cat.slug == "thai-massage"
        assert cat.description == "Traditional Thai massage services"
        assert cat.icon == "spa"
        assert cat.count == 42

    def test_strips_whitespace(self) -> None:
        """MercuryModel base strips string whitespace."""
        cat = Category(name="  Hair Salon  ", slug=" hair-salon ")
        assert cat.name == "Hair Salon"
        assert cat.slug == "hair-salon"

    def test_count_defaults_to_zero(self) -> None:
        """Count defaults to 0 when not provided."""
        cat = Category(name="Test", slug="test")
        assert cat.count == 0

    def test_missing_name_raises(self) -> None:
        """Name is required."""
        with pytest.raises(ValidationError):
            Category(slug="test")  # type: ignore[call-arg]

    def test_missing_slug_raises(self) -> None:
        """Slug is required."""
        with pytest.raises(ValidationError):
            Category(name="Test")  # type: ignore[call-arg]

    def test_serialization_roundtrip(self) -> None:
        """Model can serialize to dict and back."""
        cat = Category(name="Barber", slug="barber", icon="content_cut")
        data = cat.model_dump()
        restored = Category(**data)
        assert restored.name == cat.name
        assert restored.slug == cat.slug
        assert restored.icon == cat.icon
