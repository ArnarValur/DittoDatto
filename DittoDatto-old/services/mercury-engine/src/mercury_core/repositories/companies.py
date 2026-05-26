"""Repository interface for platform company persistence.

Companies live in titan/platform (company registry).
This ABC extends the base Repository with slug-based lookup.
"""

from __future__ import annotations

from abc import abstractmethod

from mercury_core.models.company import Company
from mercury_core.repositories.base import Repository


class CompanyRepository(Repository[Company]):
    """Platform company registry contract (titan/platform).

    Extends base CRUD with slug-based lookup needed for
    unique constraint validation and company resolution.
    """

    @abstractmethod
    async def get_by_slug(self, slug: str) -> Company | None:
        """Find a company by its URL slug.

        Used for duplicate detection and company resolution by slug.
        """
