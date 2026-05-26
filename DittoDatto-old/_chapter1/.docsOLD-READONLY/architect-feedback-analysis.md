# System Architect Feedback — Distilled Analysis

Feedback received from an architect with C4/System Design context, reviewed against actual codebase state as of 2026-03-13.

---

## ✅ Already Strong (Architect Confirmed)

| Area | What they praised | Our status |
|------|-------------------|------------|
| Concurrency control | Composite hold key + `_lastReservationTracker` phantom read fix | ✅ Solid |
| Separation of concerns | CRM upsert is fire-and-forget, never blocks booking | ✅ Correct |
| Pure functions | `staff-availability.ts` has zero Firestore deps | ✅ Testable |
| Parallel data fetching | `Promise.all` in `data.ts` | ✅ Good perf |

---

## 🔴 Actionable Now (High Impact, Low Effort)

### 1. CRM Upsert Race Condition

**Risk:** Two parallel bookings for a new user → two customer docs created.
**Fix:** Use `userId` as the Firestore document ID for customers instead of `customersRef.doc()`.

> [!TIP]
> This is a one-line fix in `customer.ts`: `const newCustomerRef = customersRef.doc(userId)` instead of `customersRef.doc()`. Concurrent writes merge into the same document.

### 2. Firestore TTL for Holds

**Risk:** `holds` collection grows unbounded; expired holds filtered in-memory.
**Fix:** Enable Firestore TTL policy on the `expiresAt` field → Google auto-deletes expired holds.

> [!NOTE]
> This is a Firebase Console config change, not code. Go to Firestore → TTL Policies → Add policy on `holds` collection, field `expiresAt`.

### 3. CRM Dead Letter Queue

**Risk:** If CRM upsert fails, customer data is silently lost.
**Fix:** On `catch`, write failed payload to `failed_crm_jobs` collection for retry.

---

## 🟡 Actionable Later (Good Architecture, Not Blocking)

### 4. Timezone: Store UTC Alongside Local

**Current:** Timezone-naive strings (`"2026-03-13T14:00:00"`).
**Risk:** DST transitions, store timezone changes.
**Architect says:** Store UTC epoch + timezone string. Use `date-fns-tz` or `Luxon`.
**Our take:** Norway has one timezone. This is correct but non-urgent. We already use `Intl.DateTimeFormat` with store timezone awareness in `time.ts`. Flag for future hardening.

### 5. Availability Caching

**Current:** Full bookings+holds query per availability check.
**Architect says:** Cache daily availability in Redis or an aggregate Firestore doc.
**Our take:** Scale concern. DittoDatto stores won't hit hundreds of bookings/day yet. Worth designing when we hit performance walls.

### 6. `allowOverlapping` → `maxConcurrentUses`

**Current:** Boolean — infinite concurrent bookings if `true`.
**Architect says:** Change to `maxConcurrentUses: number`.
**Our take:** Agreed, but `allowOverlapping` is currently only wired for rooms/stations (not tables). Can refactor when we implement shared-resource booking.

---

## 💡 Future Considerations (Noted, Not Now)

| Item | Architect suggestion | Notes |
|------|---------------------|-------|
| **Yield management** | Restrict small parties from big tables at peak hours | MVP is fine with greedy best-fit. Config toggle later |
| **Combinable tables** | Push 2 tables together for party of 8 | Knapsack problem. Use `maxPartySize` + "Call restaurant" for now |
| **Add-on resources** | High Chair, Projector — blocking vs non-blocking | `addonResourceIds` exists but is `[]`. Design when needed |
| **Waitlist** | "Join waitlist" button when group is full, Eventarc trigger on cancel | Arnar's vision aligns. Implement after service→group scoping |
| **Rebooking** | Atomic cancel+hold in single transaction | TODO exists in `index.ts`. Priority 3 in pulse |

---

## Action Priority

| # | Item | Effort | Impact |
|---|------|--------|--------|
| 1 | CRM deterministic ID | 5 min | Prevents duplicate customers |
| 2 | Firestore TTL for holds | 5 min (console) | Prevents DB bloat |
| 3 | CRM dead letter queue | 30 min | Prevents silent data loss |
| 4 | `allowOverlapping` → `maxConcurrentUses` | 1 hr | Future-proofs shared resources |
| 5 | UTC time storage | 2 hr | DST safety (non-urgent for Norway) |
