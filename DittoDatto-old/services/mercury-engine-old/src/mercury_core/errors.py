"""Domain errors for MercuryEngine.

Replaces: packages/mercury-engine/src/core/shared/errors.ts (HttpsError)

These errors carry HTTP status semantics but live in the domain layer.
The FastAPI error handler maps them to HTTP responses.
"""

from __future__ import annotations


class MercuryError(Exception):
    """Base error for all MercuryEngine domain errors.

    Attributes:
        code: Machine-readable error code (e.g., 'not-found', 'already-exists')
        message: Human-readable error description
        status_code: HTTP status code for API responses
        details: Optional structured error details
    """

    def __init__(
        self,
        code: str,
        message: str,
        status_code: int = 400,
        details: dict | None = None,
    ):
        super().__init__(message)
        self.code = code
        self.message = message
        self.status_code = status_code
        self.details = details or {}


class NotFoundError(MercuryError):
    """Resource not found (HTTP 404)."""

    def __init__(self, resource: str, resource_id: str = ""):
        detail = f"{resource} '{resource_id}' not found" if resource_id else f"{resource} not found"
        super().__init__(code="not-found", message=detail, status_code=404)


class ConflictError(MercuryError):
    """Resource conflict — e.g., slot already held (HTTP 409)."""

    def __init__(self, message: str = "Resource conflict"):
        super().__init__(code="conflict", message=message, status_code=409)


class ValidationError(MercuryError):
    """Domain validation failed (HTTP 422)."""

    def __init__(self, message: str, details: dict | None = None):
        super().__init__(
            code="validation-failed", message=message, status_code=422, details=details
        )


class UnauthorizedError(MercuryError):
    """Authentication required (HTTP 401)."""

    def __init__(self, message: str = "Authentication required"):
        super().__init__(code="unauthorized", message=message, status_code=401)


class ForbiddenError(MercuryError):
    """Insufficient permissions (HTTP 403)."""

    def __init__(self, message: str = "Insufficient permissions"):
        super().__init__(code="forbidden", message=message, status_code=403)


class SlotUnavailableError(MercuryError):
    """Requested time slot is not available (HTTP 409).

    Booking-domain specific — used by hold allocation and booking creation.
    """

    def __init__(self, message: str = "Requested slot is not available"):
        super().__init__(code="slot-unavailable", message=message, status_code=409)


class PolicyViolationError(MercuryError):
    """Booking policy violated — e.g., cancellation deadline passed (HTTP 422).

    Carries the policy details so the client can display the right message.
    """

    def __init__(self, message: str, details: dict | None = None):
        super().__init__(
            code="policy-violation", message=message, status_code=422, details=details
        )
