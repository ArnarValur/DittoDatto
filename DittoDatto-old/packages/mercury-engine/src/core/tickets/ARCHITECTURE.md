# Ticketing Domain — Architecture Notes

> Collected from Architect feedback sessions (2026-03-14).
> To be actioned when ticketing development begins (April 2026).

---

## 1. Result/Either Pattern for Pure Functions

**Source:** Architect Feedback #4 — Error handling strategy

**Problem:** Pure domain functions (`resolveHoldAllocation`, `calculateSlotsFromContext`) currently `throw HttpsError` for expected business outcomes like "slot unavailable". This is an anti-pattern:
- Exceptions should be exceptional — a taken slot is a normal state machine path
- Function signatures lie — they claim to return `HoldAllocation` but have hidden exit paths
- HTTP concerns leak into domain logic — pure functions shouldn't know about HTTP status codes

**Solution — Hybrid 3-Layer Error Model:**

```
┌─────────────────────────────────────────────────┐
│  Pure Functions (Functional Core)               │
│  return Result<T> — no throwing, no HTTP        │
│  e.g. { success: false, error: 'SLOT_TAKEN' }  │
├─────────────────────────────────────────────────┤
│  Orchestrators (Application Services)           │
│  Unwrap Result → throw HttpsError on failure    │
│  e.g. createHold checks result, throws if bad   │
├─────────────────────────────────────────────────┤
│  Transport Layer (Hono routes + onError)         │
│  Global error handler catches HttpsError         │
│  Maps to HTTP response codes                    │
└─────────────────────────────────────────────────┘
```

**Implementation sketch:**

```typescript
// src/core/shared/result.ts
type DomainResult<T> =
  | { success: true; data: T }
  | { success: false; error: DomainErrorCode; message: string }

type DomainErrorCode =
  | 'SLOT_UNAVAILABLE'
  | 'STAFF_BUSY'
  | 'RESOURCE_EXHAUSTED'
  | 'POLICY_VIOLATION'
  | 'CANCEL_DEADLINE_PASSED'
  | 'CANCEL_DISABLED'

// Pure function returns Result instead of throwing
function resolveHoldAllocation(ctx, ...): DomainResult<HoldAllocation> {
  if (noStaffAvailable) {
    return { success: false, error: 'STAFF_BUSY', message: '...' }
  }
  return { success: true, data: { holdId, finalPersonId, ... } }
}

// Orchestrator unwraps and throws for HTTP layer
const result = resolveHoldAllocation(ctx, ...)
if (!result.success) {
  throw new HttpsError('failed-precondition', result.message)
}
```

**Why this matters for ticketing:** A Pub/Sub queue consumer processing ticket holds can't meaningfully catch `HttpsError`. It needs the `DomainResult` discriminant to decide: retry? dead-letter? acknowledge?

---

## 2. Domain Error Classes (replaces HttpsError in pure functions)

**Source:** Architect Feedback #2 — Pure function boundary

**Current state:** Pure functions throw `HttpsError` (HTTP-specific). This works for HTTP-only consumers but breaks for background workers.

**When to refactor:** When the first non-HTTP consumer exists (queue worker, CLI tool, scheduled job).

**Scope:** Only pure functions need to change. Orchestrators and routes stay the same.

---

## 3. Queue-Based Serialization for Flash Sales

**Source:** Architect Feedback #1 — Contention analysis

**Problem:** Even with granular locks (staff-level, table-level), flash-sale ticket scenarios (1000 users, 50 tickets, 10 seconds) will overwhelm Firestore OCC retries.

**Solution:** Pub/Sub queue + saga pattern:
1. User requests ticket → message published to queue
2. Single consumer processes sequentially → no OCC contention
3. Result written to Firestore → client polls or gets push notification

**When to build:** When ticketing domain is designed. Not needed for appointments or reservations (low contention by nature).

---

## 4. Transaction Reads — What Stays, What Can Move

**Source:** Architect Feedback #3 — Transaction boundary analysis

**Core reads (MUST stay inside transaction):**
- `holdRef` — prevents double-booking race condition
- `bookingRef` — idempotency check

**Ancillary reads (CAN move outside if needed):**
- Service snapshots — static data, rarely changes during booking
- User profile — name/email for receipt
- Store details — store name for notifications

**When to optimize:** Only if transaction timeouts become an issue at scale. Current approach guarantees perfect snapshot consistency.

---

## 5. Query-Driven Data Modeling — Top-Level vs. Subcollections

**Source:** Architect Feedback #5 — Collection hierarchy

**Current structure:**
- `/holds/{holdId}` — top-level (ephemeral, 10-min TTL)
- `/bookings/{bookingId}` — top-level (payment-keyed idempotency)
- `/companies/{id}/reservations/` — subcollection (tenant-scoped)

**Why this asymmetry is correct (NoSQL query-driven modeling):**
- **Holds top-level:** Optimized for global TTL cleanup — one simple `where('expiresAt', '<=', now)` query. Subcollections would require Collection Group Queries with composite indexes.
- **Reservations subcollection:** Optimized for multi-tenant isolation — natural security rules, no cross-tenant leakage.

**⚠️ Required: Composite Index on `holds` collection:**
The availability query in `data.ts` uses `where('storeId', '==', ...)` + `where('date', '==', ...)` on the global `holds` collection. Ensure a Firestore composite index exists for `(storeId ASC, date ASC)` — without it, query performance degrades as the collection grows.

**For ticketing:** Tickets will likely follow the reservation pattern — `/companies/{id}/tickets/` — since they're long-lived, tenant-specific, and queried per-event. Ticket *holds* (temporary seat locks) should stay top-level like booking holds.
