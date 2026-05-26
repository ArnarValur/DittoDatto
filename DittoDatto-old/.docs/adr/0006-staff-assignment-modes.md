---
title: "ADR-0006: Staff Assignment Modes"
type: "adr"
status: "accepted"
date: "2026-05-02"
session: 2
domain: "MercuryEngine"
tags:
  - "staff"
  - "assignment"
  - "booking"
---

# ADR-0006: Staff Assignment Modes and Empty assignedStaff Semantics

## Problem 1: Empty `assignedStaff` is ambiguous

`Service.assignedStaff` defaults to `[]`. The engine has no way to distinguish:

- "Nobody is assigned yet" (service is incomplete/not bookable)
- "Anyone can do it" (implicit all-staff assignment)

**Decision:** Empty `assignedStaff` = **not bookable**. MercuryEngine returns zero slots. Staff must be explicitly assigned to a service for it to appear in the booking flow.

## Problem 2: Staff selection has three implicit modes

Three distinct assignment patterns exist but aren't formalized:

1. Customer picks a specific staff member (tapping a portrait)
2. Engine auto-assigns the best available staff
3. Manager manually assigns after the booking is created

Without an explicit mode, the engine has to guess intent from context.

## Decision

Add `staffAssignmentMode` to `ServiceSchema`:

```typescript
staffAssignmentMode: z.enum([
  "customer_choice",   // Customer picks from displayed staff
  "any_available",     // Engine auto-assigns from assignedStaff[]
  "manual",            // Manager assigns post-booking (status: pending)
]).default("any_available")
```

### Mode behaviors

#### `customer_choice`

- EstablishmentPage shows staff portraits for this service
- Customer selects a staff member before choosing a time slot
- Engine shows only the selected staff member's available slots
- Typical for: salons with named stylists, clinics with specific doctors

#### `any_available`

- Customer sees available time slots without staff selection
- Engine auto-assigns from `assignedStaff[]` based on availability
- v1.0: first-available / round-robin
- v1.5: Datto applies intelligent scoring (workload, customer history, skills)
- Typical for: barbershops with interchangeable barbers, cleaning services

#### `manual`

- Customer books a time slot, no staff assigned
- Booking created with `status: "pending"`
- Manager assigns staff via Business Portal (or Datto suggests)
- Customer notified when staff is assigned, status → `"confirmed"`
- Typical for: large teams where manager controls the board

### Datto integration (v1.5)

Datto enhances `any_available` mode with intelligent scoring. No new mode needed — Datto's intelligence is applied at runtime, not stored in the schema:

| Factor | Weight | Example |
|--------|--------|---------|
| Customer history | High | "Last 3 visits were with Sofia" → prefer Sofia |
| Staff workload | Medium | "Erik has 2 bookings, Sofia has 6" → prefer Erik |
| Staff skills/seniority | Low | "Senior stylists for complex services" |
| Staff preference | Low | "Erik prefers morning shifts" |
| Business owner config | High | Owner can set per-staff priority/preference via Datto |

The scoring logic lives in MercuryEngine (or a Datto plugin), not in the schema.

### Relationship to `StaffMember.showOnStorefront`

| `showOnStorefront` | Typical `staffAssignmentMode` | Result |
|---|---|---|
| `true` | `customer_choice` | Portraits visible, customer picks |
| `true` | `any_available` | Portraits visible (branding), but engine picks |
| `false` | `any_available` | No portraits, engine picks |
| `false` | `manual` | No portraits, manager assigns |

These are independent fields — visible staff ≠ customer-pickable staff.

## Schema Changes

### Service — add field

```typescript
staffAssignmentMode: z.enum(["customer_choice", "any_available", "manual"])
  .default("any_available")
```

### MercuryEngine — implement

- `getSlots`: respect `staffAssignmentMode` when calculating available slots
- `createHold`: auto-assign staff for `any_available`, leave empty for `manual`
- `createBooking`: set `status: "pending"` for `manual` mode when no staff assigned

### Files affected

- `packages/shared-types/src/service.ts` — add `staffAssignmentMode`
- `packages/mercury-engine/` — slot generation and hold creation logic
- `.docs/types/service.md` — update field table

## Consequences

- **Explicit over implicit:** No guessing about assignment intent
- **Three clean paths:** customer picks, engine picks, manager picks
- **Datto-ready:** Intelligent assignment is a runtime enhancement to `any_available`, not a schema addition
- **No breaking change:** New field with sensible default (`any_available`)
