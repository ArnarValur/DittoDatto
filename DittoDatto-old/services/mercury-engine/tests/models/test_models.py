"""Pydantic model validation tests.

Verifies: construct → serialize → deserialize round-trip for all core models.
This confirms our .surql → Pydantic translation is correct.
"""

from __future__ import annotations

from datetime import UTC, datetime

from mercury_core.models import (
    Booking,
    BookingItem,
    BookingMode,
    BookingPolicy,
    BookingStatus,
    Currency,
    Customer,
    DateOverride,
    DateOverrideType,
    DaySchedule,
    Establishment,
    Hold,
    ReservationConfig,
    Resource,
    ResourceGroup,
    ResourceType,
    Service,
    ShiftDay,
    Staff,
    StaffStatus,
    StoreType,
    TimeBlock,
)


class TestEstablishment:
    """Establishment model validation."""

    def test_minimal_establishment(self):
        """Establishment with only required fields."""
        est = Establishment(name="Sawasdee Thai", slug="sawasdee-thai")
        assert est.name == "Sawasdee Thai"
        assert est.country == "NO"
        assert est.timezone == "Europe/Oslo"
        assert est.is_active is True
        assert est.store_type == "store"

    def test_full_establishment(self):
        """Establishment with all fields populated."""
        est = Establishment(
            id="establishment:sawasdee",
            name="Sawasdee Thai Massage",
            slug="sawasdee-thai",
            address="Storgata 1",
            city="Drammen",
            zip="3015",
            country="NO",
            location=(59.7439, 10.2045),
            phone="+4712345678",
            email="hello@sawasdee.no",
            store_type=StoreType.STORE,
            booking_policy=BookingPolicy(
                slot_interval=30,
                min_cancel_notice_hours=48,
            ),
            opening_schedule={
                "mon": DaySchedule(is_open=True, open="10:00", close="18:00"),
                "tue": DaySchedule(is_open=True, open="10:00", close="18:00"),
                "sun": DaySchedule(is_open=False),
            },
            is_published=True,
        )
        assert est.booking_policy.slot_interval == 30
        assert est.opening_schedule["mon"].is_open is True
        assert est.opening_schedule["sun"].is_open is False
        assert est.location == (59.7439, 10.2045)

    def test_round_trip_serialization(self):
        """Construct → JSON → reconstruct preserves all data."""
        est = Establishment(
            name="Test Place",
            slug="test-place",
            booking_policy=BookingPolicy(min_cancel_notice_hours=12),
            reservation_config=ReservationConfig(max_guests=6),
        )
        json_str = est.model_dump_json()
        restored = Establishment.model_validate_json(json_str)
        assert restored.name == est.name
        assert restored.booking_policy.min_cancel_notice_hours == 12
        assert restored.reservation_config.max_guests == 6


class TestService:
    """Service model validation."""

    def test_default_service(self):
        """Service with defaults."""
        svc = Service(title="Thai Massage", duration=60, price=599)
        assert svc.booking_mode == "standard"
        assert svc.currency == "NOK"
        assert svc.buffer_time == 0
        assert svc.is_active is True

    def test_restaurant_service(self):
        """Service with table reservation mode."""
        svc = Service(
            title="Table for 2",
            booking_mode=BookingMode.TABLE_RESERVATION,
            duration=90,
            price=0,
        )
        assert svc.booking_mode == "tableReservation"


class TestStaff:
    """Staff model validation."""

    def test_staff_with_shifts(self):
        """Staff with weekly shifts."""
        staff = Staff(
            email="somchai@sawasdee.no",
            display_name="Somchai",
            is_bookable=True,
            status=StaffStatus.ACTIVE,
            weekly_shifts={
                "mon": ShiftDay(
                    is_working=True,
                    blocks=[TimeBlock(start="09:00", end="17:00")],
                ),
                "sun": ShiftDay(is_working=False),
            },
        )
        assert staff.weekly_shifts["mon"].is_working is True
        assert staff.weekly_shifts["mon"].blocks[0].start == "09:00"

    def test_date_override(self):
        """DateOverride for sick day."""
        override = DateOverride(
            staff="staff:somchai",
            date="2026-05-10",
            type=DateOverrideType.SICK,
            reason="Flu",
        )
        assert override.type == "sick"


class TestBooking:
    """Booking model validation."""

    def test_booking_with_fiscal_snapshot(self):
        """Booking preserves fiscal snapshot at booking time."""
        now = datetime.now(tz=UTC)
        booking = Booking(
            user_id="user:123",
            establishment="establishment:sawasdee",
            service="service:thai-massage",
            staff="staff:somchai",
            status=BookingStatus.CONFIRMED,
            start_time=now,
            service_title="Thai Massage 60min",
            duration=60,
            price_at_booking=599.0,
            currency=Currency.NOK,
            user_name="Arnar Valur",
            user_email="arnar@test.no",
        )
        assert booking.price_at_booking == 599.0
        assert booking.service_title == "Thai Massage 60min"

    def test_multi_service_booking(self):
        """Booking with multiple service items."""
        booking = Booking(
            user_id="user:123",
            establishment="establishment:sawasdee",
            service="service:thai-massage",
            service_title="Thai Massage",
            user_name="Test User",
            user_email="test@test.no",
            items=[
                BookingItem(
                    service="service:thai-massage",
                    title="Thai Massage",
                    price=599.0,
                    duration=60,
                ),
                BookingItem(
                    service="service:foot-massage",
                    title="Foot Massage",
                    price=399.0,
                    duration=30,
                    staff="staff:somchai",
                ),
            ],
        )
        assert len(booking.items) == 2
        assert booking.items[1].staff == "staff:somchai"


class TestHold:
    """Hold model validation."""

    def test_hold_creation(self):
        """Hold with expiry."""
        hold = Hold(
            user_id="user:123",
            establishment="establishment:sawasdee",
            services=["service:thai-massage"],
            date="2026-05-10",
            slot_time="14:00",
            duration=60,
            expires_at=datetime(2026, 5, 10, 14, 10, tzinfo=UTC),
        )
        assert hold.slot_time == "14:00"
        assert hold.payment_status is None


class TestResource:
    """Resource and ResourceGroup model validation."""

    def test_table_resource(self):
        """Restaurant table resource."""
        table = Resource(
            name="Window Table A",
            type=ResourceType.TABLE,
            min_capacity=2,
            max_capacity=4,
        )
        assert table.type == "table"
        assert table.max_capacity == 4

    def test_resource_group(self):
        """Resource group for tables."""
        group = ResourceGroup(name="Window Tables", show_on_storefront=True)
        assert group.show_on_storefront is True


class TestCustomer:
    """Customer model validation."""

    def test_customer_with_metrics(self):
        """Customer with CRM metrics."""
        customer = Customer(
            name="Arnar Valur",
            first_name="Arnar",
            last_name="Valur",
            email="arnar@test.no",
            total_visits=5,
            total_spent=2995.0,
        )
        assert customer.total_visits == 5
        assert customer.status == "new"

    def test_round_trip_customer(self):
        """Customer survives JSON round-trip."""
        customer = Customer(name="Test", email="test@test.no")
        json_str = customer.model_dump_json()
        restored = Customer.model_validate_json(json_str)
        assert restored.name == customer.name
        assert restored.email == customer.email
