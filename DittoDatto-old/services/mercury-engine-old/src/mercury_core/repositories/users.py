"""Repository interface for user persistence.

Users live in enceladus/users (GDPR-isolated).
This ABC adds user-specific queries beyond the standard CRUD.
"""

from __future__ import annotations

from abc import abstractmethod

from mercury_core.models.user import User
from mercury_core.repositories.base import Repository


class UserRepository(Repository[User]):
    """User persistence contract.

    Extends base Repository with identity-lookup queries
    needed by the auth pipeline.
    """

    @abstractmethod
    async def get_by_vipps_sub(self, vipps_sub: str) -> User | None:
        """Find a user by their Vipps subject ID.

        Used during Vipps OIDC login to check if the user already exists.
        """

    @abstractmethod
    async def get_by_email(self, email: str) -> User | None:
        """Find a user by email address.

        Used by dev-login endpoint for credential lookup.
        """

    @abstractmethod
    async def upsert(self, user: User) -> User:
        """Create or update a user record.

        Used during Vipps login: if vipps_sub exists, update profile;
        otherwise create new record.
        """
