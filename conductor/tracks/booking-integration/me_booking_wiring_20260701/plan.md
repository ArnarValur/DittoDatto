# Plan: ME ↔ Booking UI Wiring

> **Workflow:** Strict TDD (parent) + Strict Python TDD (ME child)
> **Track:** `me_booking_wiring_20260701`

---

## Phase 1: Auth Bridge — Delegated Trust Verification (ME-side)

> 🔴 Critical domain. Strict Python TDD applies.

- [ ] Task: Implement Delegated Trust token verification in ME
    - [ ] Write failing tests: `test_delegated_auth.py` — verify consumer JWT acceptance, role mapping (consumer_auth→user, bp_auth→operator), rejection of invalid/expired tokens
    - [ ] Implement `verify_surrealdb_token()` in `auth.py` — open verify-only SDB connection, call `authenticate()`, query `$auth` for identity/role
    - [ ] Implement role mapping: `ac` claim → ME role tier
    - [ ] Add optional LRU cache (60s TTL, keyed on `jti`)
    - [ ] Ensure all 58 existing tests remain green
    - [ ] Ruff format + lint clean

- [ ] Task: ME config alignment — read booking_policy + opening_schedule
    - [ ] Write failing tests: verify ME can parse `booking_policy`, `opening_schedule`, `reservation_config` from company DB
    - [ ] Align Pydantic models with new schema fields (from BP Establishment Config track)
    - [ ] Verify against Saturn staging data

---

## Phase 2: BookingRepository in mercury_client (Dart-side)

> 🔴 Critical domain (shared package). Parent TDD applies.

- [ ] Task: Dart models for ME API responses
    - [ ] Write tests for model serialization (TimeSlot, HoldResponse, BookingConfirmation, BookingListItem, CancelResponse)
    - [ ] Implement models with `fromJson` / `toJson`

- [ ] Task: BookingRepository HTTP client
    - [ ] Write tests: getAvailability, holdSlot, confirmBooking, getBookings, cancelBooking — mock HTTP responses
    - [ ] Implement BookingRepository using MercuryApi HTTP client
    - [ ] Wire Bearer token passthrough (existing SurrealDB accessToken)

- [ ] Task: Riverpod providers for booking data
    - [ ] Write provider tests
    - [ ] Create `bookingRepositoryProvider`, `availabilityProvider`, `activeHoldProvider`

---

## Phase 3: booking_ui Mock Replacement

> Parent TDD applies. booking_ui is a shared package.

- [ ] Task: Wire Step 2 (Staff Selection) to real data
    - [ ] Write tests: staff list from company DB
    - [ ] Replace mock staff with real staff fetched via mercury_client

- [ ] Task: Wire Step 3 (Date/Time Selection) to ME availability
    - [ ] Write tests: availability slots from ME API
    - [ ] Replace mock time slots with getAvailability() call
    - [ ] Handle loading / error / empty states

- [ ] Task: Wire Step 4 (Review + Confirm) to ME hold/confirm
    - [ ] Write tests: hold on entry, confirm on submit
    - [ ] Call holdSlot() when entering review step
    - [ ] Show hold countdown timer (TTL from HoldResponse)
    - [ ] Call confirmBooking() on payment confirmation
    - [ ] Handle hold expiry (410 → redirect to time selection)

- [ ] Task: Wire Step 5 (Confirmation) to real booking receipt
    - [ ] Write tests: receipt display from BookingConfirmation data
    - [ ] Replace placeholder with real booking data

---

## Phase 4: Marketplace Integration + Error Handling

- [ ] Task: Token passthrough from ditto_auth → MercuryApi
    - [ ] Wire consumer's SurrealDB accessToken into BookingRepository
    - [ ] Handle 401 (token expired) → refresh via ditto_auth → retry
    - [ ] Handle ME unreachable → timeout + snackbar (not crash)

- [ ] Task: Booking flow E2E on phone
    - [ ] Deploy ME + updated Marketplace to Saturn/phone
    - [ ] Walk through: select service → select staff → select time → review → confirm
    - [ ] Verify booking in GET /bookings
    - [ ] Test cancel flow

---

## Phase 5: Verification + Deploy

- [ ] Task: Full test suite verification
    - [ ] ME: all tests green (58+ existing + new auth tests)
    - [ ] mercury_client: all tests green
    - [ ] booking_ui: all tests green (18 existing + new)
    - [ ] Marketplace: widget tests green
    - [ ] Coverage gate: >80% on new code

- [ ] Task: Deploy + E2E verification
    - [ ] Deploy ME container update to Saturn
    - [ ] Deploy Marketplace to phone
    - [ ] User E2E walkthrough: real booking against real establishment
    - [ ] Verify booking data in SurrealDB (read-only CLI query)
