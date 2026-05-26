"""SurrealDB concrete repository adapters.

These implement the repository ABCs from mercury_core.repositories
using SurrealDB queries via the AsyncSurreal client.
"""

from .base_adapter import SurrealDBAdapter
from .booking_adapter import SurrealBookingRepo
from .category_adapter import SurrealCategoryRepo
from .company_adapter import SurrealCompanyRepo
from .customer_adapter import SurrealCustomerRepo
from .establishment_adapter import SurrealEstablishmentRepo
from .hold_adapter import SurrealHoldRepo
from .resource_adapter import SurrealResourceGroupRepo, SurrealResourceRepo
from .service_adapter import SurrealServiceGroupRepo, SurrealServiceRepo
from .staff_adapter import SurrealDateOverrideRepo, SurrealStaffRepo
from .user_adapter import SurrealUserRepo

__all__ = [
    "SurrealDBAdapter",
    "SurrealEstablishmentRepo",
    "SurrealServiceRepo",
    "SurrealServiceGroupRepo",
    "SurrealStaffRepo",
    "SurrealDateOverrideRepo",
    "SurrealBookingRepo",
    "SurrealHoldRepo",
    "SurrealResourceRepo",
    "SurrealResourceGroupRepo",
    "SurrealCustomerRepo",
    "SurrealUserRepo",
    "SurrealCategoryRepo",
    "SurrealCompanyRepo",
]
