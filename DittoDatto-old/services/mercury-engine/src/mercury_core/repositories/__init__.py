"""Repository interfaces for MercuryEngine domain persistence.

These ABCs define the contract that any persistence adapter must fulfill.
No I/O, no database dependency — pure domain interfaces.

Concrete implementations live in mercury_engine/db/adapters/.
"""

from .base import Repository
from .bookings import BookingRepository
from .categories import CategoryRepository
from .companies import CompanyRepository
from .customers import CustomerRepository
from .establishments import EstablishmentRepository
from .holds import HoldRepository
from .resources import ResourceGroupRepository, ResourceRepository
from .services import ServiceGroupRepository, ServiceRepository
from .staff import DateOverrideRepository, StaffRepository
from .users import UserRepository

__all__ = [
    "Repository",
    "EstablishmentRepository",
    "ServiceRepository",
    "ServiceGroupRepository",
    "StaffRepository",
    "DateOverrideRepository",
    "BookingRepository",
    "HoldRepository",
    "ResourceRepository",
    "ResourceGroupRepository",
    "CustomerRepository",
    "UserRepository",
    "CategoryRepository",
    "CompanyRepository",
]
