# MercuryEngine — Convergence Roadmap

> **Created:** 2026-06-29
> **Context:** Services, Booking UI, and BP Bookings are converging. This doc captures the architectural direction and sequencing decisions.

## The Convergence Map

```
                    ┌──────────────────────┐
                    │    MercuryEngine      │
                    │  (Booking API/Core)   │
                    └──────┬───────┬────────┘
                           │       │
              ┌────────────┘       └────────────┐
              ▼                                 ▼
   ┌──────────────────────┐          ┌──────────────────────┐
   │   Marketplace App    │          │   Business Portal    │
   │  (Customer-facing)   │          │  (Business-facing)   │
   └──────────┬───────────┘          └──────────┬───────────┘
              │                                 │
     ┌────────┴────────┐               ┌────────┴────────┐
     │ EstablishmentPage│               │  Services Tab   │
     │ "Bestill Time"   │               │  Bookings Tab   │
     │  → Booking Flow  │               │  (incoming)     │
     └──────────────────┘               └─────────────────┘
```

## Critical Path

**MercuryEngine is the foundation.** Both Marketplace booking flow and BP Bookings tab consume it. Without a working engine, those UIs have nowhere to send data.

## Sequencing (decided 2026-06-29)

### Step 1 — Booking UX Design (grill, no code)
- What happens when "Bestill Time" is tapped?
- Landing page: curated services vs full list?
- How do the 3 booking modes shape the flow differently?
- **Output:** UX spec that defines both the engine API contract and the UI

### Step 2 — MercuryEngine Audit + Grill
- Cold for 30+ days. Schema drift identified (rescheduled_from/to missing).
- Bring up to speed with current schema (services, groups, booking modes)
- Define the API contract: what does the engine accept, what does it return?
- **This unblocks everything downstream**

### Step 3 — Build Outward from the Engine
- **Marketplace Booking UI** — consumes MercuryEngine (customer creates bookings)
- **BP Bookings Tab** — consumes MercuryEngine (business sees incoming bookings)
- These can be parallelized — same API, different sides

### Step 4 — Independent / Anytime
- BP Services UX tweaks (low risk, standalone)

## Booking Modes — Progressive Rollout

Use **House of the North** as the demo establishment for all three modes:

1. **Standard booking** — first. Get the basic flow working (select service → pick slot → confirm)
2. **Table reservation** — second. Create a reservation group on House of the North. Test the reservation variant
3. **Ticket system** — third. Leverages the ServiceGroup-as-Event model (ADR-0022)

Each mode builds on the previous. Standard is the foundation, reservation adds time-slot semantics, ticketing adds capacity management.

## Open Design Questions (for Booking UX grill)

- **EstablishmentPage service display:** Show all services on landing, or only "featured"? Currently dumps everything. The "Bestill Time" button could open a sheet/page with the full service catalog + booking flow.
- **Booking flow steps:** Service selection → Staff preference → Time slot → Confirmation? Or simpler?
- **MultiSelect interaction:** When a group has `multiSelect: true`, user picks multiple services. Summary bar? Total price/duration?
- **Soft-delete temporal cleanup:** Services with `deleted_at` set — auto-purge after X days? Need "is it safe to delete" logic (check booking references). Stickered for later.

## Related References

- **Services track:** `conductor/tracks/services/services_section_20260628/`
- **Ticketing track:** `conductor/tracks/ticketing/ticketing_events_20260628/`
- **MercuryEngine audit (from recon):** `conductor/docs/recon_report.md` — schema drift, test coverage, relay gaps
- **ADR-0022:** ServiceGroup as Event Container
- **ADR-0023:** Independent Feature Flags (event_system / ticket_system)
- **Legacy Nuxt booking flow:** ServiceFormSlideover (596 lines), DDBookingSummary, hold→confirm pattern
