# Spec: ME ↔ Booking UI Wiring

> **Track:** `me_booking_wiring_20260701`
> **Type:** feature
> **Domain:** booking-integration (cross-cutting: MercuryEngine + mercury_client + booking_ui + marketplace)
> **ADRs:** ADR-0032 (Delegated Trust Auth Bridge)

---

## Overview

Wire the Flutter Marketplace's 5-step booking UI (currently all mocked) to MercuryEngine's live API on Saturn `:8005`. This is the critical vertical slice that connects consumer-facing booking to real availability data, slot holds, and booking confirmation.

The auth bridge uses **Delegated Trust** (ADR-0032): Marketplace sends its existing SurrealDB consumer JWT to ME. ME verifies the token by calling SurrealDB's `authenticate()`, queries `$auth` for identity/role, then proceeds with its own service account for booking operations.

---

## Functional Requirements

### Auth Bridge (ME-side)
- ME's `auth.py` validates SurrealDB consumer JWTs via Delegated Trust verification (not local decode)
- Role mapping: `consumer_auth` → `user` tier, `bp_auth` → `operator` tier
- Optional short-lived LRU cache keyed on JWT `jti` to avoid re-verifying the same token within 60s
- All existing 58 ME tests must remain green

### BookingRepository (mercury_client)
- New `BookingRepository` class in `packages/mercury_client/` with methods:
  - `getAvailability(companySlug, serviceIds, staffId?, date)` → `List<TimeSlot>`
  - `holdSlot(companySlug, serviceId, staffId, startTime)` → `HoldResponse`
  - `confirmBooking(companySlug, holdId, paymentToken?)` → `BookingConfirmation`
  - `getBookings({status?})` → `List<Booking>`
  - `cancelBooking(bookingId, companySlug)` → `CancelResponse`
- Corresponding Dart models for ME's response schemas (TimeSlot, HoldResponse, BookingConfirmation, etc.)
- Passes existing SurrealDB `accessToken` as `Bearer` header

### booking_ui Mock Replacement
- Step 1 (Service Selection): Already uses real data ✅
- Step 2 (Staff Selection): Replace mock staff with real staff from company DB
- Step 3 (Date/Time Selection): Replace mock time slots with real `getAvailability()` response
- Step 4 (Review + Confirm): Wire `holdSlot()` on entry, `confirmBooking()` on submit
- Step 5 (Confirmation): Show real booking receipt

### ME Config Alignment
- ME reads `booking_policy`, `opening_schedule`, `reservation_config` from company DB for availability calculation
- Ensure ME's Pydantic models align with the new schema fields added in BP Establishment Config track

---

## Non-Functional Requirements

- **Performance:** Availability queries < 500ms end-to-end (ME calculation + network)
- **Error handling:** Graceful degradation when ME is unreachable (timeout, snackbar, not a crash)
- **Token expiry:** Handle 401s from ME by refreshing SurrealDB token via `ditto_auth` and retrying

---

## Acceptance Criteria

1. Consumer can complete a full booking flow on the phone against real ME API data
2. Hold → Confirm lifecycle works with MockPaymentGateway
3. Booking appears in `GET /bookings` after confirmation
4. Cancel works and booking status updates
5. Auth works with `consumer_auth` JWT (no second login)
6. ME test suite stays green (58+ tests)
7. mercury_client + booking_ui tests cover new code (>80%)

---

## Edge Cases & Constraints

- **ME unreachable:** Marketplace must show a clear error, not hang. WS timeout pattern from discovery layer applies.
- **Hold expiry mid-checkout:** UI must handle `410 Gone` when confirming an expired hold. Show "slot no longer available" and restart from time selection.
- **Token expiry during booking:** If consumer's 24h SurrealDB JWT expires mid-flow, `ditto_auth` refresh should work transparently. If refresh fails, redirect to login.
- **Company slug mismatch:** ME validates `company_slug` from path against JWT claims. Consumer JWT has no company claim — ME allows `user` tier for any company's public booking endpoints.

---

## Dependencies

- ✅ ME 1.0 Booking Engine (completed, deployed Saturn `:8005`)
- ✅ Booking Flow UI (Phases 1–4, deployed to phone)
- ✅ ditto_auth + consumer_auth (completed)
- ✅ BP Establishment Config (booking_policy, opening_schedule in schema)
- ✅ Discovery Layer (EstablishmentPage + services display)

---

## Out of Scope

- Vipps payment (PaymentGateway swap — v1.3)
- Staff schedule management UI in BP
- "My Bookings" tab in Marketplace (separate track)
- Reservation (table) booking vertical (ME v1.1)
- Ticket booking vertical (ME v1.2)
- Push notifications for booking confirmations
