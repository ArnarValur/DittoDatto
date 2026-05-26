# 🔴 MercuryEngine — Booking Engine Safety Manual

> **Caution Level: 🔴 CRITICAL**
> This engine handles real money, real time slots, and real customer trust.
> A bug here = failed bookings, lost revenue, angry customers.

---

## Architecture Overview

```
Frontend (useBooking.ts composable)
  → mercury_getSlots      → calculateSlots()  → data.ts (parallel fetch)
  → mercury_createHold    → createHold()       → Firestore atomic create
  → mercury_createBooking → createBookingFromHold() → Firestore transaction
```

### Key Files

| File                                      | Purpose                                               | Risk Level  |
| ----------------------------------------- | ----------------------------------------------------- | ----------- |
| `src/MercuryEngine/booking.ts`            | Hold → Booking conversion (the receipt)               | 🔴 Critical |
| `src/MercuryEngine/hold.ts`               | Atomic slot locking with 10-min TTL                   | 🔴 Critical |
| `src/MercuryEngine/calculator.ts`         | Time Tetris — available slot calculation              | 🔴 Critical |
| `src/MercuryEngine/data.ts`               | Parallel data fetching for availability               | 🟡 High     |
| `src/MercuryEngine/staff-availability.ts` | Staff schedule filtering                              | 🟡 High     |
| `src/MercuryEngine/index.ts`              | Cloud Function wrappers (validation + error handling) | 🟡 High     |

### Tests

| File                                          | Coverage                                |
| --------------------------------------------- | --------------------------------------- |
| `src/MercuryEngine/__tests__/booking.test.ts` | `createBookingFromHold` — notes, errors |

---

## Invariants (NEVER Break These)

### 1. No `undefined` values in Firestore writes

Firestore rejects `undefined`. Always use conditional spread for optional fields:

```typescript
// ✅ CORRECT
...(value ? { field: value } : {}),

// ❌ WRONG — will crash Firestore
field: value || undefined,
```

### 2. Holds must expire

Every hold has a 10-minute TTL via `expiresAt`. Both the slot calculator and the hold creator must respect this:

- `data.ts` filters expired holds from occupied slots
- `hold.ts` overwrites expired holds on conflict

### 3. Booking creation is atomic

`createBookingFromHold` runs in a Firestore transaction:

- Read hold → Read service → Create booking → Delete hold
- If anything fails, nothing is written (transaction rollback)
- **Side effect:** A failed booking leaves the hold intact until it expires

### 4. Hold ID is a composite key

Format: `{storeId}_{date}_{slotTime}` — one hold per slot per store, regardless of service.

### 5. Slot calculator includes active holds as occupied

Both confirmed bookings AND active (non-expired) holds block timeslots.

---

## Before You Change Anything

### Mandatory Checklist

- [ ] Read this document
- [ ] Understand which invariant your change touches
- [ ] Write or update tests BEFORE deploying
- [ ] Run `npm test` in `packages/functions` — all tests must pass
- [ ] Deploy is gated: `firebase.json` runs tests in `predeploy`

### Testing Commands

```bash
cd packages/functions
npm test            # Run all tests once
npm run test:watch  # Watch mode during development
```

### Deploy Process

```bash
# Tests run automatically before deploy (predeploy hook in firebase.json)
firebase deploy --only functions

# Or deploy specific functions:
firebase deploy --only functions:mercury_createBooking,functions:mercury_createHold,functions:mercury_getSlots
```

---

## Known Gotchas

| Gotcha                            | Details                                                                                                                                                                       |
| --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Firestore + undefined**         | `undefined` is not a valid Firestore value. Use `null` or omit the field.                                                                                                     |
| **Hold orphans**                  | If `createBookingFromHold` fails, the hold persists until TTL expires. The system now handles this gracefully (expired hold overwrite + filtered availability), but be aware. |
| **Hold key is store-scoped**      | `{storeId}_{date}_{slotTime}` means two different services at the same time/store share the hold. This is by design for MVP (one booking per slot per store).                 |
| **Transaction read-before-write** | Firestore transactions require all reads before writes. Don't add writes between reads in `createBookingFromHold`.                                                            |
| **Region**                        | All functions MUST deploy to `europe-west1`. Firestore triggers need explicit `region` param.                                                                                 |

---

## Post-Incident Log

| Date       | Bug                                       | Root Cause                                                                      | Fix                                                                    |
| ---------- | ----------------------------------------- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| 2026-03-13 | Services with resources allow "double-booking" | `hold.ts` collision logic: when `hasBookableStaff=false` + `hasResourceRequirements=true`, global store-level check was skipped — each booking got a different resource | Not a bug: resource concurrency is correct (2 halls = 2 concurrent bookings). Fixed `data.ts` query format mismatch (`Z` suffix). Added resource-aware BookingOverview columns. |
| 2026-02-19 | Bookings without notes fail with 500      | `notes: undefined` crashes Firestore `transaction.set()`                        | Conditional spread in `booking.ts:126`                                 |
| 2026-02-19 | Expired holds permanently block timeslots | `data.ts` never checked `expiresAt`; `hold.ts` never checked expiry on conflict | Added expiry filter in `data.ts` + expired hold overwrite in `hold.ts` |

---

_Last updated: 2026-03-13 by Commander Hermes_
