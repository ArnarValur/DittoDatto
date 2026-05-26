---
title: "MercuryEngine — Standard Bookings (1:1)"
type: "reference"
status: "current"
date: "2026-05-02"
session: 3
domain: "MercuryEngine"
tags:
  - "booking"
  - "vertical"
  - "1-to-1"
  - "standard"
---

# MercuryEngine — Standard Bookings (1:1)

> One customer, one staff member, one time slot.  
> Salons, clinics, garages, massage, consulting — the bread and butter.

## Pattern

```
Customer ──[1:1]──► Staff Member ──[at]──► Time Slot
                        │
                   [optionally]
                        │
                        ▼
                    Resource
              (room, chair, station)
```

## Route Prefix

`/appointments/*`

## Core Module

`core/bookings/` — [calculator.ts](file:///media/addinator/Mercury/Projects/DittoDatto/packages/mercury-engine/src/core/bookings/calculator.ts), [hold.ts](file:///media/addinator/Mercury/Projects/DittoDatto/packages/mercury-engine/src/core/bookings/hold.ts), [booking.ts](file:///media/addinator/Mercury/Projects/DittoDatto/packages/mercury-engine/src/core/bookings/booking.ts)

## Status: ✅ Production

156 tests, <1s. Fully normalized (`staffId`).

## Lifecycle

See [Booking Flow](./booking-flow.md) for the full 5-phase sequence diagram.

```
Search → Hold (10-min TTL) → Pay (client) → Confirm → Cancel (optional)
```

## Data Model

| Entity | Schema | Collection Path |
|--------|--------|----------------|
| Hold | `HoldSchema` | `companies/{cid}/holds/{hid}` |
| Booking | `BookingSchema` | `bookings/{bid}` |
| Service | `ServiceSchema` | `companies/{cid}/stores/{sid}/services/{svcId}` |
| Staff | `StaffMemberSchema` | `companies/{cid}/staff/{staffId}` |
| Resource | `ResourceSchema` | `companies/{cid}/stores/{sid}/resources/{rid}` |

## Key Behaviors

### Staff Assignment Modes (ADR-0006)

| Mode | Behavior |
|------|----------|
| `customer_choice` | Customer picks staff in the UI |
| `any_available` | Engine auto-assigns first free staff member |
| `manual` | Staff-only booking (not shown in marketplace) |

### Concurrency

Three levels, auto-detected:

1. **Staff-aware** — slot available if ANY eligible staff is free
2. **Resource-aware** — additive check: staff free AND resource available
3. **Store-level** — fallback when no staff/resources configured: one booking at a time

### Composite Hold Key

```
{storeId}_{date}_{slotTime}_{staffId|resourceId|userId}
```

Provides both idempotency (same user can't double-hold) and concurrency (Alice's hold doesn't lock Bob's staff).

### Snapshot Pattern

At booking time, the engine copies:
- Service `title`, `price`, `duration`
- User `name`, `email`, `phone`

Into the booking document. Price changes never affect historical bookings (Norwegian fiscal compliance).

## API Reference

See [API Contract](./api-contract.md#appointments--standard-11-booking) for full endpoint documentation.

| Method | Endpoint | Auth | Purpose |
|--------|----------|------|---------|
| `GET` | `/appointments/slots` | Public | Search available slots |
| `POST` | `/appointments/holds` | Firebase | Create 10-min hold |
| `POST` | `/appointments/bookings` | Firebase | Confirm hold → booking |
| `POST` | `/appointments/bookings/:id/cancel` | Firebase | Cancel booking |

## Test Coverage

| Test File | Focus |
|-----------|-------|
| `calculator-slots.test.ts` | Slot generation, intervals, closed days |
| `hold-allocation.test.ts` | Composite keys, staff assignment, concurrency |
| `booking-receipt.test.ts` | Snapshot pattern, receipt builder |
| `availability-context.test.ts` | Context builder, occupancy maps |
| `api-contracts.test.ts` | HTTP shape validation |

---

*Created: 2026-05-02 — Session 3 Grill*
