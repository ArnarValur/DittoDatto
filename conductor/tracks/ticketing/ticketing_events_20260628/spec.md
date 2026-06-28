# Spec: Ticketing & Events — Event System + Ticket Booking Mode

> **Track:** `ticketing_events_20260628`
> **Type:** feature
> **Domain:** ticketing
> **Created:** 2026-06-28
> **Grilled in:** Ticketing & Events Domain Grill session (2026-06-28 17:30)

---

## Overview

Build the third booking domain: Events + Ticketing. Events are a general-purpose occurrence system (public/private) for any establishment. Ticketing layers capacity-managed ticket sales on top of events. The model reuses existing infrastructure: **ServiceGroup = Event container, Services = Ticket tiers** (ADR-0022). Two independent feature flags gate capabilities (ADR-0023).

**Use cases:**
- Venue with recurring concerts (monthly/weekly) — each concert is a ServiceGroup with ticket tiers (VIP, GA, Standing)
- Salon hosting a one-off ticketed workshop — one ServiceGroup + one Service
- Company posting a public opening event — visibility-only, no tickets (just `event_system`)
- Internal staff event — private, not consumer-visible

**Surfaces touched:**
- `schemas/company-blueprint.surql` — Event metadata fields on `service_group`, capacity fields on `service`
- `schemas/platform.surql` — Feature flag dependency enforcement
- `packages/establishment_ui/` — Event display widgets, ticket card styling
- `apps/business-portal/` — Event creation/management, ticket tier CRUD, recurring event setup
- `apps/marketplace/` — Event section on EstablishmentPage, ticket purchase flow (basic)

**Depends on:**
- `services_section_20260628` track (Phase 1–2 minimum) — Service + ServiceGroup models, BP CRUD patterns

---

## Functional Requirements

### Schema Extensions

**service_group (event metadata — all optional, ignored by non-event groups):**
- `is_event` — `TYPE bool DEFAULT false` — distinguishes event ServiceGroups from regular groupings
- `event_type` — `TYPE option<string> ASSERT $value IN ['public', 'private']` — consumer-visible vs staff-only
- `event_date` — `TYPE option<datetime>` — when the event occurs
- `event_end_date` — `TYPE option<datetime>` — optional end time
- `event_logo` — `TYPE option<string>` — event-specific branding (media URL)
- `event_gallery` — `TYPE option<array<string>>` — event photos
- `event_description` — `TYPE option<string>` — rich event description
- `rrule` — `TYPE option<string>` — RFC 5545 recurrence rule for recurring events
- `parent_event` — `TYPE option<record<service_group>>` — link to parent recurring event ServiceGroup

**service (ticket-mode fields — used when `booking_mode = 'ticketSystem'`):**
- `capacity` — `TYPE option<int>` — max tickets for this tier (null = unlimited for standard services)
- `remaining_capacity` — computed or cached count of available tickets

**Feature flag dependency (application-level enforcement):**
- `ticket_system: true` → auto-enable `event_system: true`
- `event_system: false` → auto-disable `ticket_system: false`

### BP Event Management

- Event creation flow: new ServiceGroup with `is_event=true` → set event metadata (name, date, time, type, description, logo, gallery)
- Ticket tier CRUD: add Services under the event ServiceGroup with `booking_mode: ticketSystem`, capacity, price
- Recurring event setup: set `rrule` on an event ServiceGroup → platform generates next instance preview
- Event list view: filter ServiceGroups where `is_event=true`, show date, type badge, capacity summary

### Marketplace Event Display

- **Events section** on EstablishmentPage — shows upcoming public events for the establishment
- **Event card** — date, name, description, logo, ticket availability summary
- **Ticket tiers** — display within event (tier name, price, remaining capacity)
- **Ticket purchase** — basic flow: select tier → select attendee_count → Hold → Booking (uses existing MercuryEngine Hold pattern)
- Replace placeholder `EstablishmentEventsSection` ("Arrangementer kommer snart") with real event data
- Only visible when establishment has events AND company has `event_system` enabled

### Recurring Event Auto-Creation

- Platform reads `rrule` on event ServiceGroup → generates next occurrence as a new ServiceGroup
- Copies event metadata (name pattern, tiers, default pricing) from parent
- Links via `parent_event` field
- Notifies company user to confirm/adjust (notification mechanism TBD — could be BP dashboard banner for v1)

---

## Non-Functional Requirements

- Schema changes must be backward-compatible (all new fields optional with defaults)
- Widget tests for event display components
- Integration tests for event CRUD against real SurrealDB
- Package tests for model serialization (event metadata round-trip)
- Feature flag enforcement tested in both BP and Marketplace

---

## Acceptance Criteria

1. ✅ Company with `event_system: true` can create an Event (public) in BP → event appears on Marketplace EstablishmentPage
2. ✅ Company with `event_system: true, ticket_system: false` → can create display-only events (no ticket tiers)
3. ✅ Company with both flags → can create event + ticket tiers (VIP 50 seats / GA 200 seats)
4. ✅ Consumer sees events section on EstablishmentPage with upcoming events, date, description
5. ✅ Consumer sees ticket tiers within event (name, price, remaining)
6. ✅ Consumer can select tier + attendee count → creates Hold → Booking
7. ✅ Recurring event with `rrule` → platform auto-creates next instance
8. ✅ Private events (`event_type: 'private'`) not visible on Marketplace
9. ✅ All tests green (widget + integration + package)

---

## Edge Cases & Constraints

- Event with zero ticket tiers → display-only (no "Book" action)
- All tiers sold out → show "Utsolgt" badge, disable purchase
- Single-tier event → don't show tier selector, just "Kjøp billett" button
- `attendee_count > remaining_capacity` → reject with clear error
- Past events → show in "Tidligere arrangementer" section (collapsed), not in upcoming
- Schema gate: all Dart model fields MUST match `company-blueprint.surql` exactly
- Feature flag invalid combo (`event_system: false, ticket_system: true`) → enforce at UI + API level

---

## Dependencies

- **ADR-0022** — ServiceGroup = Event container, Services = Ticket tiers
- **ADR-0023** — Independent feature flags with directional dependency
- **`services_section_20260628` track** — Service + ServiceGroup models in `establishment_ui`, BP CRUD patterns
- `packages/establishment_ui/` — existing EstablishmentPage + EstablishmentData model
- `schemas/company-blueprint.surql` — existing service_group + service table definitions
- `schemas/platform.surql` — existing enabled_features fields
- MercuryEngine Hold→Booking lifecycle (existing, but needs capacity-based slot mode — future track)

---

## Out of Scope

- **Seat maps / assigned seating** — general admission only for v1 (Ticketmaster seat-map pattern researched, parked)
- **Payment integration** — Vipps/Stripe for ticket purchases (separate track)
- **Ticket QR codes / check-in flow** — future feature (Noona has this, parked)
- **Event discovery in DittoBar** — how events surface in search (needs Discovery track)
- **MercuryEngine capacity slot calculator** — Time Tetris needs a count-based mode for ticketSystem (separate track, 🔴 Critical)
- **Datto automation** — AI-powered recurring event management (Layer 2, future)
- **Notification system** — company user notifications for recurring event auto-creation (v1 uses BP dashboard banner)
- **Event analytics** — attendance, revenue, popularity (future)
