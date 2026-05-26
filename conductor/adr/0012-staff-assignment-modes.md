# Staff Assignment Modes

> **Recorded:** 2026-05-26 (promoted from legacy ADR-0006 Session 2; Zod schema references replaced with Pydantic v2)
> **Status:** accepted

## Context

### Problem 1: Empty `assignedStaff` is ambiguous

`Service.assignedStaff` defaults to `[]`. The engine has no way to distinguish:
- "Nobody is assigned yet" (service is incomplete/not bookable).
- "Anyone can do it" (implicit all-staff assignment).

### Problem 2: Staff selection has three implicit modes

Three distinct assignment patterns exist but aren't formalized:
1. Customer picks a specific staff member (tapping a portrait).
2. Engine auto-assigns the best available staff.
3. Manager manually assigns after the booking is created.

Without an explicit mode, the engine guesses intent from context.

## Decision

### 1. Empty `assignedStaff` = not bookable

MercuryEngine returns zero slots for a service with no assigned staff. Staff must be explicitly assigned for the service to appear in the booking flow.

### 2. `Service.staffAssignmentMode` formalizes the three modes

```python
staff_assignment_mode: Literal["customer_choice", "any_available", "manual"] = "any_available"
```

### Mode behaviors

**`customer_choice`** — Customer picks from displayed staff
- Establishment page shows staff portraits for this service.
- Customer selects a staff member before choosing a time slot.
- Engine shows only the selected staff member's available slots.
- Typical: salons with named stylists, clinics with specific doctors.

**`any_available`** — Engine auto-assigns
- Customer sees available time slots without staff selection.
- Engine auto-assigns from `assignedStaff[]` based on availability.
- v1.0: first-available / round-robin.
- v1.5: Datto applies intelligent scoring (workload, customer history, skills).
- Typical: barbershops with interchangeable barbers, cleaning services.

**`manual`** — Manager assigns post-booking
- Customer books a time slot; no staff assigned.
- Booking created with `status: "pending"`.
- Manager assigns staff via Business Portal (or Datto suggests).
- Customer notified when staff is assigned; status → `"confirmed"`.
- Typical: large teams where manager controls the board.

### Datto integration (v1.5)

Datto enhances `any_available` mode with intelligent scoring. No new mode needed — Datto's intelligence is applied at runtime, not stored in the schema:

| Factor | Weight | Example |
|---|---|---|
| Customer history | High | "Last 3 visits were with Sofia" → prefer Sofia |
| Staff workload | Medium | "Erik has 2 bookings, Sofia has 6" → prefer Erik |
| Staff skills/seniority | Low | "Senior stylists for complex services" |
| Staff preference | Low | "Erik prefers morning shifts" |
| Business owner config | High | Owner can set per-staff priority/preference via Datto |

Scoring logic lives in MercuryEngine (or a Datto plugin), not in the schema.

### Relationship to `StaffMember.showOnStorefront`

| `showOnStorefront` | Typical `staffAssignmentMode` | Result |
|---|---|---|
| `true` | `customer_choice` | Portraits visible, customer picks |
| `true` | `any_available` | Portraits visible (branding), engine picks |
| `false` | `any_available` | No portraits, engine picks |
| `false` | `manual` | No portraits, manager assigns |

These are independent fields — visible staff ≠ customer-pickable staff.

## Implementation

Pydantic v2 models in `services/mercury-engine/src/mercury_core/models/service.py` define `staff_assignment_mode`. MercuryEngine:
- `getSlots`: respects `staffAssignmentMode` when calculating available slots.
- `createHold`: auto-assigns staff for `any_available`, leaves empty for `manual`.
- `createBooking`: sets `status: "pending"` for `manual` mode when no staff assigned.

## Consequences

- **Explicit over implicit:** No guessing about assignment intent.
- **Three clean paths:** customer picks, engine picks, manager picks.
- **Datto-ready:** Intelligent assignment is a runtime enhancement to `any_available`, not a schema addition.
- **No breaking change:** New field with sensible default (`any_available`).

---

*Origin: Session 2 Grill. Promoted into canonical conductor/adr/ during /grill foundation 2026-05-26 — Zod references replaced with Pydantic v2.*
