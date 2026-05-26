"""Record ID serialization utilities for SurrealDB ↔ Pydantic mapping.

SurrealDB convention: Record IDs are `table:id` (e.g., `establishment:abc123`).
Pydantic convention: Models use `id: str | None` with just the ID part.

This module handles the bidirectional mapping:
- On read (SurrealDB → Pydantic): strip the table prefix, stringify RecordID objects
- On write (Pydantic → SurrealDB): convert record link strings to RecordID objects
- For record links: SurrealDB SCHEMAFULL requires proper RecordID types, not strings

See also: SDB Agent guidance on record link handling.
"""

from __future__ import annotations

import logging
from typing import TypeVar

from surrealdb import RecordID

from mercury_core.models.common import MercuryModel

logger = logging.getLogger("mercury-engine.db.record")

T = TypeVar("T", bound=MercuryModel)

# ─── Record Link Registry ───────────────────────────────────────────────────
# Maps (table, field_name) → target_table for fields defined as record<T>
# in schemas/company-blueprint.surql. Used by model_to_record() to convert
# plain strings like "establishment:abc123" into proper RecordID objects.
#
# Array record link fields are also listed — their values are list[str]
# where each string is "table:id".

RECORD_LINK_FIELDS: dict[str, dict[str, str]] = {
    "service": {
        "establishment": "establishment",
        "group": "service_group",
    },
    "service_group": {
        "establishment": "establishment",
    },
    "booking": {
        "establishment": "establishment",
        "service": "service",
        "staff": "staff",
        "resource": "resource",
    },
    "hold": {
        "establishment": "establishment",
        "staff": "staff",
    },
    "date_override": {
        "staff": "staff",
    },
    "resource": {
        "establishment": "establishment",
        "resource_group": "resource_group",
    },
    "resource_group": {
        "establishment": "establishment",
    },
    "works_at": {
        "in": "staff",
        "out": "establishment",
    },
}

# Fields that are array<record<T>> — need each element converted
ARRAY_RECORD_LINK_FIELDS: dict[str, dict[str, str]] = {
    "service": {
        "assigned_staff": "staff",
        "required_resource_groups": "resource_group",
    },
    "booking": {
        "addon_resources": "resource",
    },
    "hold": {
        "services": "service",
    },
    "staff": {
        "store_ids": "establishment",
    },
    "customer": {
        "store_ids": "establishment",
    },
}

# Fields inside embedded objects that are record links.
# Format: {parent_table: {array_field: {nested_field: target_table}}}
# E.g., booking.items[].service → record<service>, booking.items[].staff → record<staff>
EMBEDDED_RECORD_LINK_FIELDS: dict[str, dict[str, dict[str, str]]] = {
    "booking": {
        "items": {
            "service": "service",
            "staff": "staff",
        },
    },
}


def parse_record_id(thing: str | dict | object) -> str:
    """Extract clean ID from a SurrealDB record reference.

    Handles multiple formats the SDK may return:
    - String: 'establishment:abc123' → 'abc123'
    - Dict with 'id' key: {'id': 'establishment:abc123', ...} → 'abc123'
    - RecordID object: has .table_name and .id attributes → str(id)
    - Plain string without colon: 'abc123' → 'abc123'

    Args:
        thing: A SurrealDB record ID in any format.

    Returns:
        The clean ID string without table prefix.
    """
    if isinstance(thing, dict):
        raw = str(thing.get("id", ""))
    elif isinstance(thing, RecordID):
        return str(thing.id)
    elif hasattr(thing, "id") and hasattr(thing, "table_name"):
        # Defensive: future RecordID-like objects
        return str(thing.id)  # type: ignore[union-attr]
    else:
        raw = str(thing)

    # Strip table prefix if present (e.g., 'establishment:abc123' → 'abc123')
    if ":" in raw:
        return raw.split(":", 1)[1]
    return raw


def _stringify_record_ids(data: dict) -> dict:
    """Recursively convert RecordID objects to 'table:id' strings for Pydantic.

    SurrealDB SDK returns RecordID objects for record link fields.
    Pydantic expects plain strings. Recurses into nested dicts and
    list items to handle embedded objects (e.g., booking.items[]).
    """
    result = {}
    for key, value in data.items():
        if isinstance(value, RecordID):
            result[key] = str(value)
        elif isinstance(value, list):
            result[key] = [_stringify_list_item(v) for v in value]
        elif isinstance(value, dict):
            result[key] = _stringify_record_ids(value)
        else:
            result[key] = value
    return result


def _stringify_list_item(item: object) -> object:
    """Convert a list item's RecordID objects to strings."""
    if isinstance(item, RecordID):
        return str(item)
    if isinstance(item, dict):
        return _stringify_record_ids(item)
    return item


def make_record_id(table: str, id: str) -> str:
    """Create a SurrealDB record reference string from table name and ID.

    Used for select/update/delete operations that accept a 'thing' string.

    Args:
        table: Table name (e.g., 'establishment').
        id: Record ID (e.g., 'abc123').

    Returns:
        Full record reference (e.g., 'establishment:abc123').
    """
    # Don't double-prefix
    if id.startswith(f"{table}:"):
        return id
    return f"{table}:{id}"


def to_record_id(table: str, id: str) -> RecordID:
    """Create a RecordID object for use in query parameter bindings.

    SurrealDB SCHEMAFULL requires RecordID objects (not strings) when
    comparing against record<T> or array<record<T>> fields in queries.

    Args:
        table: Table name (e.g., 'establishment').
        id: Record ID without table prefix (e.g., 'abc123'),
            or full reference (e.g., 'establishment:abc123').

    Returns:
        A RecordID object.
    """
    if ":" in id:
        parts = id.split(":", 1)
        return RecordID(parts[0], parts[1])
    return RecordID(table, id)


def _str_to_record_id(value: str, target_table: str) -> RecordID:
    """Convert a 'table:id' string to a RecordID object.

    If the string already has the table prefix, use it.
    Otherwise, prepend the target_table.
    """
    if ":" in value:
        table, record_id = value.split(":", 1)
        return RecordID(table, record_id)
    return RecordID(target_table, value)


def record_to_model(table: str, data: dict, model_class: type[T]) -> T:
    """Convert a SurrealDB record dict to a Pydantic model instance.

    Handles:
    - ID extraction: strips table prefix from the 'id' field
    - RecordID objects: stringified to 'table:id' for Pydantic
    - Record link fields: converted to strings
    - Datetime fields: SurrealDB returns ISO strings, Pydantic parses them
    - Nested objects: passed through to Pydantic validation

    Args:
        table: The SurrealDB table name.
        data: The raw record dict from SurrealDB.
        model_class: The Pydantic model class to instantiate.

    Returns:
        A validated Pydantic model instance.
    """
    # First, stringify any RecordID objects in the data
    cleaned = _stringify_record_ids(data)

    # Extract clean ID
    if "id" in cleaned:
        cleaned["id"] = parse_record_id(cleaned["id"])

    return model_class.model_validate(cleaned)


def model_to_record(
    model: MercuryModel,
    *,
    exclude_id: bool = True,
    table: str | None = None,
) -> dict:
    """Convert a Pydantic model to a SurrealDB-compatible dict for writing.

    Handles:
    - ID exclusion: SurrealDB auto-generates IDs on create
    - None values: excluded to let SurrealDB defaults apply
    - Enum serialization: StrEnum values → plain strings
    - Datetime preservation: native datetime objects (SurrealDB SCHEMAFULL
      requires Python datetime, not ISO strings)
    - Timestamp exclusion: created_at/updated_at managed by SurrealDB
    - Record links: converts 'table:id' strings to RecordID objects
      for SCHEMAFULL compliance

    Args:
        model: The Pydantic model instance.
        exclude_id: Whether to exclude the 'id' field (True for create, False for update).
        table: The target SurrealDB table name. Required for record link conversion.

    Returns:
        A dict suitable for SurrealDB create/update operations.
    """
    exclude_fields: set[str] = set()
    if exclude_id:
        exclude_fields.add("id")

    # Exclude server-managed timestamp fields on create
    exclude_fields.update({"created_at", "updated_at"})

    # Use mode="python" to preserve native datetime objects (SurrealDB
    # SCHEMAFULL rejects ISO strings for datetime fields).
    # Enums are also preserved as StrEnum instances — we convert them below.
    data = model.model_dump(
        exclude=exclude_fields,
        exclude_none=True,
        mode="python",
    )

    # Convert enum values to plain strings (SurrealDB doesn't understand StrEnum)
    _convert_enums(data)

    # Convert record link strings to RecordID objects if table is known
    if table:
        # Single record link fields
        link_fields = RECORD_LINK_FIELDS.get(table, {})
        for field_name, target_table in link_fields.items():
            if field_name in data and isinstance(data[field_name], str) and data[field_name]:
                data[field_name] = _str_to_record_id(data[field_name], target_table)

        # Array record link fields
        array_link_fields = ARRAY_RECORD_LINK_FIELDS.get(table, {})
        for field_name, target_table in array_link_fields.items():
            if field_name in data and isinstance(data[field_name], list):
                data[field_name] = [
                    _str_to_record_id(v, target_table)
                    for v in data[field_name]
                    if isinstance(v, str) and v
                ]

        # Embedded object record link fields (e.g., booking.items[].service)
        embedded_link_fields = EMBEDDED_RECORD_LINK_FIELDS.get(table, {})
        for array_field, nested_links in embedded_link_fields.items():
            if array_field in data and isinstance(data[array_field], list):
                for item in data[array_field]:
                    if isinstance(item, dict):
                        for nested_field, target_tbl in nested_links.items():
                            if (
                                nested_field in item
                                and isinstance(item[nested_field], str)
                                and item[nested_field]
                            ):
                                item[nested_field] = _str_to_record_id(
                                    item[nested_field], target_tbl
                                )

    return data


def _convert_enums(data: dict) -> None:
    """Recursively convert StrEnum values to plain strings in-place."""
    from enum import Enum

    for key, value in data.items():
        if isinstance(value, Enum):
            data[key] = str(value.value)
        elif isinstance(value, dict):
            _convert_enums(value)
        elif isinstance(value, list):
            for i, item in enumerate(value):
                if isinstance(item, Enum):
                    data[key][i] = str(item.value)
                elif isinstance(item, dict):
                    _convert_enums(item)

