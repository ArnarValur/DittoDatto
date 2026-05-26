---
title: "ADR-0004: Per-Service Booking Modes"
type: "adr"
status: "accepted"
date: "2026-05-02"
session: 2
domain: "MercuryEngine"
tags:
  - "booking"
  - "service"
  - "booking-mode"
---

# ADR-0004: Per-Service Booking Modes (Remove Store-Level bookingFormType)

## Problem

Booking mode configuration exists at two levels simultaneously:

```typescript
// Store level — what kind of booking does this store do?
Store.bookingFormType: z.enum(["standard", "none", "tableReservation", "ticketSystem"])

// Service level — how is this specific service booked?
Service.bookingMode: z.enum(["standard", "tableReservation", "ticketSystem"])
```

This creates ambiguity ("who wins when they disagree?") and blocks real business scenarios:

- A **venue** (nightclub) needs ticketed events AND bookable party hall rentals AND VIP table reservations
- A **restaurant** needs table reservations AND catering service appointments
- A **salon** needs standard appointments AND occasional ticketed workshops

One store, multiple booking modes across its services. `Store.bookingFormType` forces a single answer at the wrong level.

## Decision

### 1. Remove `Store.bookingFormType`

Booking mode is exclusively a per-service property via `Service.bookingMode`. The store does not dictate how its services are booked.

### 2. `Store.storeType` becomes purely cosmetic

`storeType: "service" | "restaurant" | "venue"` describes the business **identity**, not its **capabilities**:

| Affects | Does NOT affect |
|---------|----------------|
| EstablishmentPage layout (hero section, card style) | Which booking modes are available |
| Datto's personality and default suggestions | Whether the business can create events |
| Search categorization and filter placement | MercuryEngine slot generation logic |
| Default Business Portal dashboard view | Feature access |

A venue can have appointment services. A salon can host ticketed events. The type is a *vibe*, not a *constraint*.

### 3. The `"none"` use case

`bookingFormType: "none"` was used for display-only listings (businesses that want marketplace presence without bookings). This becomes:
- A store with zero active services is inherently non-bookable
- Or: explicit `Store.isBookable: false` flag (already exists via the combination of `isPublished` + no services)

### 4. Remove `Store.reservationConfig`

`reservationConfig` (capacity mode, guest limits, slot intervals for restaurants) was only relevant when `bookingFormType === "tableReservation"`. Since booking mode is now per-service, this config should move to the Service schema or be derived from the service + resource configuration. Detailed design deferred to MercuryEngine Session 3.

## Schema Changes

### Store — remove fields:
```diff
- bookingFormType: z.enum(["standard", "none", "tableReservation", "ticketSystem"])
- reservationConfig: ReservationConfigSchema.optional()
```

### Service — no change needed:
```typescript
// Already correct:
bookingMode: z.enum(["standard", "tableReservation", "ticketSystem"]).default("standard")
```

### Files affected:
- `packages/shared-types/src/store.ts` — remove `bookingFormType` and `reservationConfig`
- `packages/shared-types/src/reservation.ts` — `reservationConfig` migration TBD (Session 3)
- Business Portal pages that read `store.bookingFormType` — update to read `service.bookingMode`
- MercuryEngine — already uses `service.bookingMode` for slot generation (no change expected)

## Consequences

- **Flexibility:** Any establishment can offer any combination of booking modes across its services
- **Simplicity:** One field, one location, one source of truth
- **Future-proof:** When Datto creates services conversationally, it just sets `bookingMode` on the service — no store-level gate to unlock first
- **Breaking change:** Portal UI that reads `store.bookingFormType` needs updating. Manageable since Portal is being rewritten for Flutter.

## Alternatives Considered

- **Keep both with "store = default, service = override"** — rejected: implicit inheritance creates confusion and debugging nightmares
- **Merge `storeType` and `bookingFormType` into one enum** — rejected: identity and capability are different concerns
