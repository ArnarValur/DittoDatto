"""Category model for platform-wide service taxonomy.

Stored in titan/discovery.category.
Admin-managed. Used for discovery filtering and DittoBar search.

Schema source: schemas/discovery.surql §1 (category table)
"""

from __future__ import annotations

from mercury_core.models.common import MercuryModel, TimestampMixin


class Category(MercuryModel, TimestampMixin):
    """Platform-wide service category (taxonomy).

    Categories classify establishments for discovery.
    Managed by platform admins, not company operators.

    Attributes:
        name: Display name (e.g., "Hair Salon", "Thai Massage").
        slug: URL-safe identifier (unique index in SurrealDB).
        description: Optional long description.
        icon: Optional icon identifier (e.g., Material icon name).
        count: Number of establishments in this category (synced).
    """

    id: str | None = None
    name: str
    slug: str
    description: str | None = None
    icon: str | None = None
    count: int = 0
