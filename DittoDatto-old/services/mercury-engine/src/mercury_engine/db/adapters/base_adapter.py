"""Generic SurrealDB adapter implementing common CRUD operations.

All domain-specific adapters extend this base to get standard
select/create/update/delete behavior, then add their own query methods.

Uses the record.py utilities for ID mapping between SurrealDB and Pydantic.
"""

from __future__ import annotations

import logging
from typing import TypeVar

from surrealdb import AsyncSurreal

from mercury_core.models.common import MercuryModel
from mercury_core.repositories.base import Repository
from mercury_engine.db.record import (
    make_record_id,
    model_to_record,
    record_to_model,
)

logger = logging.getLogger("mercury-engine.db.adapter")

T = TypeVar("T", bound=MercuryModel)


class SurrealDBAdapter(Repository[T]):
    """Base adapter with generic CRUD via SurrealDB.

    Provides standard implementations of get, list, create, update, delete,
    and count. Domain-specific adapters extend this and add their own
    query methods.

    Args:
        db: An AsyncSurreal connection (already scoped to the correct namespace/database).
        table: The SurrealDB table name (e.g., 'establishment').
        model_class: The Pydantic model class for deserialization.
    """

    def __init__(self, db: AsyncSurreal, table: str, model_class: type[T]) -> None:
        self._db = db
        self._table = table
        self._model_class = model_class

    async def get(self, id: str) -> T | None:
        """Fetch a single record by ID, excluding soft-deleted records."""
        record_id = make_record_id(self._table, id)
        try:
            data = await self._db.select(record_id)
        except Exception:
            logger.debug("Record not found: %s", record_id)
            return None

        if not data:
            return None

        # Handle both single record and list responses
        if isinstance(data, list):
            data = data[0] if data else None
        if not data:
            return None

        model = record_to_model(self._table, data, self._model_class)

        # Check soft-delete
        if hasattr(model, "deleted_at") and model.deleted_at is not None:
            return None

        return model

    async def list(self, **filters: object) -> list[T]:
        """List all non-deleted records, optionally filtered."""
        query = f"SELECT * FROM {self._table} WHERE deleted_at IS NONE"
        bindings: dict[str, object] = {}

        for key, value in filters.items():
            query += f" AND {key} = ${key}"
            bindings[key] = value

        result = await self._db.query(query, bindings)
        return self._parse_query_result(result)

    async def create(self, entity: T) -> T:
        """Create a new record. SurrealDB generates the ID."""
        data = model_to_record(entity, exclude_id=True, table=self._table)
        result = await self._db.create(self._table, data)

        # Handle response format — may be a list with one item
        if isinstance(result, list):
            result = result[0] if result else {}

        return record_to_model(self._table, result, self._model_class)

    async def update(self, id: str, entity: T) -> T:
        """Update an existing record by merging new data."""
        record_id = make_record_id(self._table, id)
        data = model_to_record(entity, exclude_id=True, table=self._table)

        # Use MERGE to update only provided fields (not replace the whole record)
        result = await self._db.merge(record_id, data)

        if isinstance(result, list):
            result = result[0] if result else {}

        return record_to_model(self._table, result, self._model_class)

    async def delete(self, id: str) -> bool:
        """Soft-delete by setting deleted_at to now().

        For tables without soft-delete (e.g., holds), subclasses
        override this with a hard delete.
        """
        record_id = make_record_id(self._table, id)
        query = f"UPDATE {record_id} SET deleted_at = time::now()"
        result = await self._db.query(query)

        # Check if the update affected any records
        return bool(result and self._extract_result_data(result))

    async def count(self, **filters: object) -> int:
        """Count non-deleted records matching filters."""
        query = f"SELECT count() AS total FROM {self._table} WHERE deleted_at IS NONE GROUP ALL"
        bindings: dict[str, object] = {}

        for key, value in filters.items():
            query += f" AND {key} = ${key}"
            bindings[key] = value

        result = await self._db.query(query, bindings)
        data = self._extract_result_data(result)
        if data and isinstance(data, list) and data:
            return int(data[0].get("total", 0))
        return 0

    # ─── Internal helpers ────────────────────────────────────────────────

    def _parse_query_result(self, result: object) -> list[T]:
        """Parse a SurrealDB query result into a list of Pydantic models."""
        data = self._extract_result_data(result)
        if not data or not isinstance(data, list):
            return []
        return [record_to_model(self._table, row, self._model_class) for row in data]

    def _extract_result_data(self, result: object) -> list | None:
        """Extract the data array from a SurrealDB query response.

        SurrealDB query() returns various formats depending on SDK version:
        - List of dicts (direct records)
        - List of response objects with .result attribute
        - Nested response structures
        """
        if not result:
            return None

        if isinstance(result, list):
            # Check if it's a list of response wrappers
            if result and hasattr(result[0], "result"):
                return result[0].result  # type: ignore[union-attr]
            # Direct list of records
            return result

        if hasattr(result, "result"):
            return result.result  # type: ignore[union-attr]

        return None
