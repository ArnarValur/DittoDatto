# Plan: ME ↔ Booking UI Wiring

> **Workflow:** Strict TDD (parent) + Strict Python TDD (ME child)
> **Track:** `me_booking_wiring_20260701`

---

## Phase 1: Auth Bridge — Delegated Trust Verification (ME-side)

> 🔴 Critical domain. Strict Python TDD applies.

- [x] Task: Implement Delegated Trust token verification in ME
    - [x] Write failing tests: `test_delegated_auth.py` — verify consumer JWT acceptance, role mapping (consumer_auth→user, bp_auth→operator), rejection of invalid/expired tokens
    - [x] Implement `verify_surrealdb_token()` in `auth.py` — open verify-only SDB connection, call `authenticate()`, query `$auth` for identity/role
    - [x] Implement role mapping: `ac` claim → ME role tier
    - [x] Add optional LRU cache (60s TTL, keyed on `jti`) — deferred, profile first
    - [x] Ensure all 58 existing tests remain green — 66/66 green
    - [x] Ruff format + lint clean

- [ ] Task: ME config alignment — read booking_policy + opening_schedule
    - [ ] Write failing tests: verify ME can parse `booking_policy`, `opening_schedule`, `reservation_config` from company DB
    - [ ] Align Pydantic models with new schema fields (from BP Establishment Config track)
    - [ ] Verify against Saturn staging data

---

## Phase 2: BookingRepository in mercury_client (Dart-side)

> 🔴 Critical domain (shared package). Parent TDD applies.

- [x] Task: Dart models for ME API responses
    - [x] Write tests for model serialization (TimeSlot, HoldResponse, BookingConfirmation, BookingListItem, CancelResponse)
    - [x] Implement models with `fromJson` / `toJson`

- [x] Task: BookingRepository HTTP client
    - [x] Write tests: getAvailability, holdSlot, confirmBooking, getBookings, cancelBooking — mock HTTP responses
    - [x] Implement BookingRepository using MercuryApi HTTP client
    - [x] Wire Bearer token passthrough (existing SurrealDB accessToken)

- [x] Task: Riverpod providers for booking data
    - [x] Analysis: providers not needed — callback injection pattern used instead
    - [x] BookingScreen wired directly with BookingRepository + consumer JWT

---

## Phase 3: booking_ui Mock Replacement

> Parent TDD applies. booking_ui is a shared package.

- [x] Task: Wire Step 2 (Staff Selection) to real data
    - [x] StaffSelectionStep accepts optional staffList param
    - [ ] Fetch real staff list from company DB (staff CRUD needed first)

- [x] Task: Wire Step 3 (Date/Time Selection) to ME availability
    - [x] DateTimeSelectionStep accepts async onFetchSlots callback
    - [x] BookingScreen passes real _fetchSlots using BookingRepository
    - [x] Loading indicator during async fetch
    - [x] Error handling with user-facing message
    - [x] Slot caching per date

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

- [x] Task: Token passthrough from ditto_auth → MercuryApi
    - [x] DittoAuth.getConsumerToken() exposed for ME API use
    - [x] BookingScreen reads consumer JWT and sets MercuryApi.accessToken
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
