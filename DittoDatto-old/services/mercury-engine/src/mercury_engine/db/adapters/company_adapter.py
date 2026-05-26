"""SurrealDB adapter for company table (titan/platform).

Implements CompanyRepository with slug-based lookup.
Companies use soft-delete (deleted_at) per the standard pattern.
"""

from __future__ import annotations

from surrealdb import AsyncSurreal

from mercury_core.models.company import Company
from mercury_core.repositories.companies import CompanyRepository
from mercury_engine.db.adapters.base_adapter import SurrealDBAdapter
from mercury_engine.db.record import record_to_model


class SurrealCompanyRepo(SurrealDBAdapter[Company], CompanyRepository):
    """SurrealDB adapter for the company table in titan/platform.

    Companies are the top-level registry entries. Each company
    maps to a titan/company_{slug} database.
    """

    def __init__(self, db: AsyncSurreal) -> None:
        super().__init__(db, "company", Company)

    async def get_by_slug(self, slug: str) -> Company | None:
        """Find a company by its URL slug."""
        result = await self._db.query(
            "SELECT * FROM company WHERE slug = $slug AND deleted_at IS NONE LIMIT 1",
            {"slug": slug},
        )
        data = self._extract_result_data(result)
        if data and isinstance(data, list) and data:
            return record_to_model(self._table, data[0], Company)
        return None
