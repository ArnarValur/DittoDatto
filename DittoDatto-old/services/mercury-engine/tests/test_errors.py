"""Tests for mercury_core.errors — V2 error hierarchy.

Rewritten (not ported) from V1 error-handler.test.ts.
V1 tested HttpsError (Firebase-style codes). V2 has a richer hierarchy
with domain-specific error types.
"""


from mercury_core.errors import (
    ConflictError,
    ForbiddenError,
    MercuryError,
    NotFoundError,
    PolicyViolationError,
    SlotUnavailableError,
    UnauthorizedError,
    ValidationError,
)


class TestMercuryErrorBase:
    def test_is_instance_of_exception(self):
        err = MercuryError(code="test", message="test error")
        assert isinstance(err, Exception)

    def test_carries_code_and_status(self):
        err = MercuryError(code="custom", message="oops", status_code=500)
        assert err.code == "custom"
        assert err.message == "oops"
        assert err.status_code == 500

    def test_defaults_to_400(self):
        err = MercuryError(code="bad", message="bad request")
        assert err.status_code == 400


class TestErrorSubclasses:
    def test_not_found_maps_to_404(self):
        err = NotFoundError("Service", "svc-123")
        assert err.status_code == 404
        assert err.code == "not-found"
        assert "svc-123" in err.message

    def test_conflict_maps_to_409(self):
        err = ConflictError("Already booked")
        assert err.status_code == 409
        assert err.code == "conflict"

    def test_validation_maps_to_422(self):
        err = ValidationError("Invalid phone format", details={"field": "phone"})
        assert err.status_code == 422
        assert err.code == "validation-failed"
        assert err.details["field"] == "phone"

    def test_unauthorized_maps_to_401(self):
        err = UnauthorizedError()
        assert err.status_code == 401
        assert err.code == "unauthorized"

    def test_forbidden_maps_to_403(self):
        err = ForbiddenError("Not your store")
        assert err.status_code == 403
        assert err.code == "forbidden"

    def test_slot_unavailable_maps_to_409(self):
        err = SlotUnavailableError("Slot taken")
        assert err.status_code == 409
        assert err.code == "slot-unavailable"

    def test_policy_violation_maps_to_422(self):
        err = PolicyViolationError("Too late to cancel", details={"hours": 24})
        assert err.status_code == 422
        assert err.code == "policy-violation"
        assert err.details["hours"] == 24

    def test_all_errors_are_mercury_error(self):
        errors = [
            NotFoundError("x"),
            ConflictError(),
            ValidationError("x"),
            UnauthorizedError(),
            ForbiddenError(),
            SlotUnavailableError(),
            PolicyViolationError("x"),
        ]
        for err in errors:
            assert isinstance(err, MercuryError)
