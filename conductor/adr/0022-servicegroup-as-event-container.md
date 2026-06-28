# ServiceGroup as Event Container, Services as Ticket Tiers

> **Recorded:** 2026-06-28 17:30
> **Status:** accepted

The third booking domain (ticketSystem) reuses existing entity infrastructure rather than introducing a dedicated `event` table. A **ServiceGroup** serves as the Event container — holding event metadata (date, time, type, logo, gallery, description, recurrence rule). Each child **Service** within that group represents a ticket tier (e.g., VIP, General Admission, Standing), each with its own `booking_mode: ticketSystem`, capacity, pricing, and `over_capacity_policy`.

This model applies universally: a complex venue concert has one ServiceGroup (event) with multiple Services (tiers), while a simple salon workshop has one ServiceGroup (event) with one Service (single ticket type). Total event capacity is the sum of child Service capacities.

Recurring events use RFC 5545 `rrule` on the ServiceGroup. Platform auto-creates next instances; company user confirms/adjusts. Future: Datto AI agent automates recurrence.

## Considered Options

- **Dedicated `event` table** — separate entity with its own CRUD. Cleaner separation, but duplicates ServiceGroup's grouping semantics and requires a new relationship layer between events, services, and bookings.
- **Service = Event** (flat model) — a single Service with `bookingMode: ticketSystem` IS the event. Simpler, but no tier support without bolting on sub-entities. Cannot represent VIP vs General vs Standing under one event.
- **ServiceGroup = Event, Services = Ticket tiers** (chosen) — reuses existing infrastructure, naturally supports tiers via child Services, mirrors Noona's `tiers[]` model, and keeps the entity graph shallow.

## Consequences

- ServiceGroup schema gains event-specific fields (date, type, logo, gallery, rrule, parent_event). These are optional — non-event ServiceGroups ignore them.
- The `booking` table remains the universal booking container. A `ticketSystem` booking is a booking row associated with a `ticketSystem`-mode Service.
- `attendee_count` on bookings enables multi-ticket purchases (e.g., "2 VIP tickets").
- Per-tier `over_capacity_policy` allows flexible capacity management (VIP = `reject`, Standing = `allow`).
- MercuryEngine's Time Tetris calculator will need a capacity-based slot mode (count-based rather than time-based) for `ticketSystem` services.
- BP event creation UX extends the ServiceGroup form with event metadata fields — wireframes TBD in track spec.
