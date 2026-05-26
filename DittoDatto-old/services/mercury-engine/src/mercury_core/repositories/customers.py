"""Customer repository interface.

Source: schemas/company-blueprint.surql §1.5
Domain model: mercury_core/models/customer.py

Customers are cross-DB projections from enceladus/users.
Direction: enceladus → company_X. Never reverse. (Session 9 contract)
"""

from __future__ import annotations

from abc import abstractmethod

from mercury_core.models import Customer

from .base import Repository


class CustomerRepository(Repository[Customer]):
    """Repository for customer aggregate root.

    Customer records in the company database are projections of user data
    from enceladus/users. MercuryEngine mediates the sync.
    """

    @abstractmethod
    async def get_by_email(self, email: str) -> Customer | None:
        """Find a customer by email address.

        Email is indexed in the schema.
        Returns None if not found or soft-deleted.
        """

    @abstractmethod
    async def get_by_user_id(self, user_id: str) -> Customer | None:
        """Find a customer by their cross-DB user reference.

        user_id is a string reference to enceladus/users (cross-namespace).
        Returns None if not found or soft-deleted.
        """

    @abstractmethod
    async def list_by_establishment(self, establishment_id: str) -> list[Customer]:
        """List customers associated with an establishment.

        Checks customer.store_ids array for the establishment record link.
        """
