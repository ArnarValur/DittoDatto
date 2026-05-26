"""Tests for SurrealDB record ID serialization utilities.

Tests the bidirectional mapping between SurrealDB's `table:id` format
and Pydantic models' plain `id: str` convention.
"""

from __future__ import annotations

from mercury_core.models import Establishment, Service
from mercury_engine.db.record import (
    make_record_id,
    model_to_record,
    parse_record_id,
    record_to_model,
)

# =============================================================================
# parse_record_id
# =============================================================================


class TestParseRecordId:
    """Test extracting clean IDs from SurrealDB record references."""

    def test_table_colon_id(self):
        assert parse_record_id("establishment:abc123") == "abc123"

    def test_plain_id(self):
        assert parse_record_id("abc123") == "abc123"

    def test_uuid_format(self):
        """SurrealDB often generates UUID-style IDs."""
        assert parse_record_id("service:8f3a2b1c") == "8f3a2b1c"

    def test_dict_with_id_key(self):
        assert parse_record_id({"id": "staff:xyz789"}) == "xyz789"

    def test_dict_without_id_key(self):
        assert parse_record_id({}) == ""

    def test_nested_colon(self):
        """Handle IDs that themselves contain colons (unlikely but defensive)."""
        assert parse_record_id("table:id:with:colons") == "id:with:colons"

    def test_recordid_like_object(self):
        """Test with the actual SurrealDB SDK RecordID class."""
        from surrealdb import RecordID

        r = RecordID("establishment", "abc123")
        assert parse_record_id(r) == "abc123"


# =============================================================================
# make_record_id
# =============================================================================


class TestMakeRecordId:
    """Test creating SurrealDB record references."""

    def test_basic(self):
        assert make_record_id("establishment", "abc123") == "establishment:abc123"

    def test_no_double_prefix(self):
        """Don't double-prefix if already formatted."""
        assert make_record_id("staff", "staff:xyz") == "staff:xyz"

    def test_different_table(self):
        assert make_record_id("booking", "b001") == "booking:b001"


# =============================================================================
# record_to_model
# =============================================================================


class TestRecordToModel:
    """Test converting SurrealDB records to Pydantic models."""

    def test_establishment_basic(self):
        data = {
            "id": "establishment:abc123",
            "name": "Sawasdee",
            "slug": "sawasdee",
            "address": "Karl Johans gate 1",
            "city": "Oslo",
            "zip": "0154",
            "country": "NO",
            "is_published": True,
            "is_active": True,
        }
        model = record_to_model("establishment", data, Establishment)
        assert model.id == "abc123"  # Prefix stripped
        assert model.name == "Sawasdee"
        assert model.slug == "sawasdee"
        assert model.is_published is True

    def test_service_with_record_links(self):
        """Record links (establishment, group) should be preserved as-is."""
        data = {
            "id": "service:svc001",
            "establishment": "establishment:abc123",
            "group": "service_group:grp001",
            "title": "Thai Massage",
            "duration": 60,
            "price": 500.0,
        }
        model = record_to_model("service", data, Service)
        assert model.id == "svc001"
        # Record links preserved with table prefix
        assert model.establishment == "establishment:abc123"
        assert model.group == "service_group:grp001"

    def test_missing_id(self):
        """Handle records without an id field (shouldn't happen, but defensive)."""
        data = {"name": "Test", "slug": "test"}
        model = record_to_model("establishment", data, Establishment)
        assert model.id is None

    def test_extra_fields_ignored(self):
        """SurrealDB may return metadata fields not in the Pydantic model."""
        data = {
            "id": "establishment:abc123",
            "name": "Test",
            "slug": "test",
            "_surreal_meta": "some_value",  # Not in Pydantic model
        }
        # Should not raise — Pydantic ignores extra fields by default
        model = record_to_model("establishment", data, Establishment)
        assert model.name == "Test"


# =============================================================================
# model_to_record
# =============================================================================


class TestModelToRecord:
    """Test converting Pydantic models to SurrealDB-compatible dicts."""

    def test_excludes_id_by_default(self):
        """On create, don't send id — let SurrealDB generate it."""
        model = Establishment(name="Test", slug="test")
        data = model_to_record(model)
        assert "id" not in data

    def test_includes_id_when_told(self):
        """On update, include the id."""
        model = Establishment(id="abc123", name="Test", slug="test")
        data = model_to_record(model, exclude_id=False)
        assert data["id"] == "abc123"

    def test_excludes_none_values(self):
        """Don't send None — let SurrealDB defaults apply."""
        model = Establishment(name="Test", slug="test", phone=None, email=None)
        data = model_to_record(model)
        assert "phone" not in data
        assert "email" not in data

    def test_excludes_timestamps(self):
        """Server-managed fields should not be sent."""
        model = Establishment(name="Test", slug="test")
        data = model_to_record(model)
        assert "created_at" not in data
        assert "updated_at" not in data

    def test_enums_serialize_as_strings(self):
        """StrEnum values should be plain strings, not enum objects."""
        model = Service(title="Massage", duration=60, price=500)
        data = model_to_record(model)
        assert data["booking_mode"] == "standard"
        assert data["currency"] == "NOK"
        assert isinstance(data["booking_mode"], str)

    def test_nested_objects_included(self):
        """Embedded sub-models should be serialized as dicts."""
        from mercury_core.models import BookingPolicy

        policy = BookingPolicy(slot_interval=30, min_cancel_notice_hours=12)
        model = Establishment(name="Test", slug="test", booking_policy=policy)
        data = model_to_record(model)
        assert data["booking_policy"]["slot_interval"] == 30
        assert data["booking_policy"]["min_cancel_notice_hours"] == 12

    def test_record_links_converted_to_record_id(self):
        """Record link strings should become RecordID objects when table is specified."""
        from surrealdb import RecordID

        model = Service(
            title="Massage",
            establishment="establishment:abc123",
            duration=60,
            price=500,
        )
        data = model_to_record(model, table="service")
        assert isinstance(data["establishment"], RecordID)
        assert str(data["establishment"]) == "establishment:abc123"

    def test_no_record_link_conversion_without_table(self):
        """Without table param, record links stay as strings."""
        model = Service(
            title="Massage",
            establishment="establishment:abc123",
            duration=60,
            price=500,
        )
        data = model_to_record(model)
        assert isinstance(data["establishment"], str)


class TestRecordToModelWithRecordIDs:
    """Test that RecordID objects from SurrealDB are properly stringified."""

    def test_record_id_in_id_field(self):
        """SurrealDB may return RecordID objects for the id field."""
        from surrealdb import RecordID

        data = {
            "id": RecordID("establishment", "abc123"),
            "name": "Test",
            "slug": "test",
        }
        model = record_to_model("establishment", data, Establishment)
        assert model.id == "abc123"

    def test_record_id_in_link_field(self):
        """Record link fields may be RecordID objects from SurrealDB."""
        from surrealdb import RecordID

        data = {
            "id": RecordID("service", "svc001"),
            "establishment": RecordID("establishment", "abc123"),
            "title": "Massage",
            "duration": 60,
            "price": 500.0,
        }
        model = record_to_model("service", data, Service)
        assert model.id == "svc001"
        assert model.establishment == "establishment:abc123"
