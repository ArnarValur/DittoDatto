---
title: "MercuryEngine — Booking Flow"
type: "reference"
status: "current"
date: "2026-05-02"
session: 3
domain: "MercuryEngine"
tags:
  - "booking"
  - "lifecycle"
  - "flow"
---

# MercuryEngine — Booking Flow

> The 5-phase lifecycle of a standard appointment (1:1 booking).

## Flow Diagram

```mermaid
sequenceDiagram
    actor Customer
    participant Flutter as Flutter App
    participant Engine as MercuryEngine
    participant FS as Firestore
    participant CRM as CRM Module

    Note over Customer,CRM: Phase 1 — SEARCH
    Customer->>Flutter: Select service(s), date, (staff)
    Flutter->>Engine: GET /appointments/slots
    Engine->>FS: fetchAvailabilityData()<br/>(7 parallel reads)
    FS-->>Engine: Store + Bookings + Holds<br/>+ Services + Staff + Resources
    Engine->>Engine: buildAvailabilityContext()<br/>(pure: normalize, occupancy maps)
    Engine->>Engine: calculateSlotsFromContext()<br/>(pure: Time Tetris loop)
    Engine-->>Flutter: { availableSlots: ["09:00", "09:15", ...] }
    Flutter-->>Customer: Show available times

    Note over Customer,CRM: Phase 2 — HOLD
    Customer->>Flutter: Tap slot (e.g. 09:00)
    Flutter->>Engine: POST /appointments/holds<br/>{ staffId, slotTime, ... }
    Engine->>FS: Transaction: verify + write hold
    Note right of Engine: resolveHoldAllocation() (pure)<br/>Staff concurrency check<br/>Resource auto-assignment<br/>Composite key: store_date_time_staff
    FS-->>Engine: Hold created (10-min TTL)
    Engine-->>Flutter: { holdId, expiresAt }
    Flutter-->>Customer: "Slot reserved for 10 min"

    Note over Customer,CRM: Phase 3 — PAY
    Customer->>Flutter: Confirm & pay
    Flutter->>Flutter: Vipps / Stripe<br/>(client-side, not engine)
    Flutter-->>Flutter: paymentId received

    Note over Customer,CRM: Phase 4 — CONFIRM
    Flutter->>Engine: POST /appointments/bookings<br/>{ holdId, paymentId }
    Engine->>FS: Transaction: read hold → build receipt → write booking → delete hold
    Note right of Engine: buildBookingReceipt() (pure)<br/>Snapshot Pattern: copies price/title<br/>at booking time for fiscal compliance
    FS-->>Engine: Booking confirmed
    Engine->>CRM: upsertCustomerFromBooking()<br/>(fire-and-forget)
    Engine-->>Flutter: { success, bookingId }
    Flutter-->>Customer: "Booking confirmed! ✅"

    Note over Customer,CRM: Phase 5 — CANCEL (optional)
    Customer->>Flutter: Cancel booking
    Flutter->>Engine: POST /appointments/bookings/:id/cancel
    Engine->>FS: Transaction: verify auth + check policy + update status
    Note right of Engine: checkCancellationPolicy() (pure)<br/>Customer: subject to notice hours<br/>Staff/Admin: bypasses policy
    Engine-->>Flutter: { success }
    Flutter-->>Customer: "Booking cancelled"
```

## Phase Details

### Phase 1: Search (Slot Calculation)

**Endpoint:** `GET /appointments/slots`  
**Auth:** Public  
**Core function:** `calculateSlotsFromContext()` — pure, testable

The Time Tetris algorithm:
1. Fetch all data in parallel (store hours, existing bookings, active holds, services, staff schedules, resources)
2. Build a computed `AvailabilityContext` — normalize staff shifts, build occupancy maps, derive policies
3. Loop from store open → close in `slotInterval` increments:
   - **Notice check** — skip slots too close to "now" (timezone-aware)
   - **Staff check** — is ANY eligible staff member free for this slot?
   - **Resource check** — is a resource available from each required group?
   - If all checks pass → slot is available

### Phase 2: Hold (10-minute Lock)

**Endpoint:** `POST /appointments/holds`  
**Auth:** Firebase Auth  
**Core function:** `resolveHoldAllocation()` — pure, testable

Hold mechanics:
- **Composite key:** `{storeId}_{date}_{slotTime}_{staffId|resourceId|userId}` — provides idempotency AND concurrency differentiation
- **Staff auto-assignment:** If customer didn't pick a specific staff member, engine assigns the first available one
- **Resource auto-assignment:** Best-fit algorithm (priority → smallest capacity)
- **Granular locking:** Transaction writes a tracker to the staff/resource doc, not the store doc — multiplies throughput by number of bookable entities
- **Expired hold overwrite:** If a hold exists but has expired, it's overwritten atomically

### Phase 3: Payment (Client-Side)

Payment is handled entirely by the Flutter client (Vipps/Stripe SDK). The engine doesn't process payments — it only receives the `paymentId` as proof.

### Phase 4: Confirm (Hold → Booking)

**Endpoint:** `POST /appointments/bookings`  
**Auth:** Firebase Auth  
**Core function:** `buildBookingReceipt()` — pure, testable

Confirmation mechanics:
- **Snapshot Pattern:** Copies service `price`, `title`, `duration` at booking time. If the business raises prices later, existing bookings are unaffected (Norwegian fiscal requirement)
- **Atomic transaction:** Read hold → fetch services → build receipt → write booking → delete hold
- **CRM upsert:** After the transaction succeeds, `upsertCustomerFromBooking()` runs fire-and-forget. Failures go to a dead-letter queue (`failed_crm_jobs` collection), never block the booking

### Phase 5: Cancel

**Endpoint:** `POST /appointments/bookings/:bookingId/cancel`  
**Auth:** Firebase Auth (customer or company admin)  
**Core function:** `checkCancellationPolicy()` — pure, testable

Authorization layers:
1. Is the user the customer who made the booking? → Check cancellation policy
2. Is the user a company admin/member? → Always allowed (bypass policy)
3. Is the user a super_admin? → Always allowed

Cancellation policy checks:
- `clientCancelEnabled` — can customers cancel at all?
- `minCancelNoticeHours` — how far in advance must they cancel?

## Hold Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Created: POST /holds
    Created --> Confirmed: POST /bookings<br/>(within 10 min)
    Created --> Expired: TTL elapsed (10 min)
    Created --> Overwritten: New hold on same slot<br/>(if expired)
    Expired --> Cleaned: DELETE /cleanup/holds/expired
    Confirmed --> [*]
    Cleaned --> [*]
    Overwritten --> Created
```

## Booking Status Lifecycle

```mermaid
stateDiagram-v2
    [*] --> confirmed: Hold → Booking
    [*] --> pending: Manual/walk-in entry
    confirmed --> cancelled: Customer or staff cancels
    confirmed --> completed: Service delivered
    confirmed --> no_show: Customer didn't appear
    pending --> confirmed: Staff confirms
    pending --> cancelled: Staff rejects
    cancelled --> [*]
    completed --> [*]
    no_show --> [*]
```

---

*Created: 2026-05-02 — Session 3 Grill*
