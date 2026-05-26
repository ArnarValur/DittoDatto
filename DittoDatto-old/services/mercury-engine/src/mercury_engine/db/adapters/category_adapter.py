"""SurrealDB adapter for category table (titan/discovery).

Implements CategoryRepository with slug-based lookup.
Categories don't use soft-delete — they are hard-deleted.
"""

from __future__ import annotations

from surrealdb import AsyncSurreal

from mercury_core.models.category import Category
from mercury_core.repositories.categories import CategoryRepository
from mercury_engine.db.adapters.base_adapter import SurrealDBAdapter
from mercury_engine.db.record import record_to_model


class SurrealCategoryRepo(SurrealDBAdapter[Category], CategoryRepository):
    """SurrealDB adapter for the category table in titan/discovery.

    Categories are platform-wide and admin-managed.
    No soft-delete — categories are hard-deleted when removed.
    """

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "category", Category)

    async def get_by_slug(self, slug: str) -> Category | None:
        """Find a category by its URL slug."""
        result = await self._db.query(
            "SELECT * FROM category WHERE slug = $slug LIMIT 1",
            {"slug": slug},
        )
        data = self._extract_result_data(result)
        if data and isinstance(data, list) and data:
            return record_to_model(self._table, data[0], Category)
        return None

    async def list(self, **filters: object) -> list[Category]:
        """List all categories (no soft-delete filter needed)."""
        query = "SELECT * FROM category"
        bindings: dict[str, object] = {}

        first_filter = True
        for key, value in filters.items():
            connector = " WHERE " if first_filter else " AND "
            query += f"{connector}{key} = ${key}"
            bindings[key] = value
            first_filter = False

        query += " ORDER BY name ASC"
        result = await self._db.query(query, bindings)
        return self._parse_query_result(result)

    async def delete(self, id: str) -> bool:
        """Hard-delete a category (no soft-delete for taxonomy)."""
        from mercury_engine.db.record import make_record_id

        record_id = make_record_id(self._table, id)
        result = await self._db.delete(record_id)
        return result is not None

    async def count(self, **filters: object) -> int:
        """Count all categories (no soft-delete filter)."""
        query = "SELECT count() AS total FROM category GROUP ALL"
        result = await self._db.query(query)
        data = self._extract_result_data(result)
        if data and isinstance(data, list) and data:
            return int(data[0].get("total", 0))
        return 0
