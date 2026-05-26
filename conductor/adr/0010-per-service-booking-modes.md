# Per-Service Booking Modes

> **Recorded:** 2026-05-26 (promoted from legacy ADR-0004 Session 2; Zod schema references replaced with Pydantic v2 + SurrealDB)
> **Status:** accepted

## Context

Booking mode configuration originally existed at two levels — Establishment level (`bookingFormType`) AND Service level (`bookingMode`) — creating ambiguity ("who wins when they disagree?") and blocking real business scenarios:

- A **venue** (nightclub) needs ticketed events AND bookable party hall rentals AND VIP table reservations.
- A **restaurant** needs table reservations AND catering service appointments.
- A **salon** needs standard appointments AND occasional ticketed workshops.

One establishment, multiple booking modes across its services. Establishment-level `bookingFormType` forced a single answer at the wrong level.

## Decision

### 1. Booking mode lives exclusively on the Service

`Service.bookingMode: "standard" | "tableReservation" | "ticketSystem"` is the single source of truth. The Establishment does NOT dictate how its services are booked.

### 2. `Establishment.storeType` is purely cosmetic

`storeType: "service" | "restaurant" | "venue"` describes the business **identity**, not its **capabilities**:

| Affects | Does NOT affect |
|---|---|
| Establishment page layout (hero, card style) | Which booking modes are available |
| Datto's personality and default suggestions | Whether the business can create events |
| Search categorization and filter placement | MercuryEngine slot generation logic |
| Default Business Portal dashboard view | Feature access |

A venue can have appointment services. A salon can host ticketed events. The type is a vibe, not a constraint.

### 3. The "none" use case

`bookingFormType: "none"` (display-only listings) was historically used for marketplace-presence-without-bookings. Replaced by: an Establishment with zero active services is inherently non-bookable, or an explicit `Establishment.isBookable: false` flag (derived from `isPublished` + service count).

### 4. `Establishment.reservationConfig` is removed

`reservationConfig` (capacity mode, guest limits, slot intervals) was only relevant when `bookingFormType === "tableReservation"`. Since booking mode is now per-service, this config moves to the Service schema or is derived from service + resource configuration. Detailed design lives in a MercuryEngine track.

## Implementation

Pydantic v2 models in `services/mercury-engine/src/mercury_core/models/` are the canonical schema source post-migration. The frozen Chapter 1 Zod schemas in `packages/shared-types/` remain as reference. SurrealDB schemas (`schemas/*.surql` — currently in `DittoDatto-old/`, migration pending) enforce the assertion: `service.booking_mode IN ['standard', 'tableReservation', 'ticketSystem']`.

## Consequences

- **Flexibility:** Any establishment can offer any combination of booking modes across its services.
- **Simplicity:** One field, one location, one source of truth.
- **Future-proof:** When Datto creates services conversationally (v1.5), it sets `bookingMode` on the service — no establishment-level gate to unlock first.
- **Breaking change:** Any client UI reading establishment-level booking mode updates to read `service.bookingMode`. Manageable since all clients are being Flutter-rebuilt (ADR-0007).

## Considered Options

| Option | Rejected because |
|---|---|
| Keep both with "store = default, service = override" | Implicit inheritance creates confusion and debugging nightmares. |
| Merge `storeType` and `bookingFormType` into one enum | Identity and capability are different concerns. |

---

*Origin: Session 2 Grill. Promoted into canonical conductor/adr/ during /grill foundation 2026-05-26 — Zod schema references replaced with Pydantic v2 + SurrealDB.*
