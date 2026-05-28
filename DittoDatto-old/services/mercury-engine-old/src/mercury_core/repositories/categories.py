"""Repository interface for category persistence.

Categories live in titan/discovery (platform-wide taxonomy).
This ABC extends the base Repository with slug-based lookup.
"""

from __future__ import annotations

from abc import abstractmethod

from mercury_core.models.category import Category
from mercury_core.repositories.base import Repository


class CategoryRepository(Repository[Category]):
    """Category persistence contract (titan/discovery).

    Extends base CRUD with slug-based lookup needed for
    unique constraint validation.
    """

    @abstractmethod
    async def get_by_slug(self, slug: str) -> Category | None:
        """Find a category by its URL slug.

        Used for duplicate detection during create/update.
        """
