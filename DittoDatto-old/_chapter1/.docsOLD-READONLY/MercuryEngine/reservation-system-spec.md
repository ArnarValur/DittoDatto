# Reservation System — Requirements Spec

## Context

The reservation system handles capacity-based bookings (restaurants, group experiences). A customer selects a **Service** (e.g. "Dinner Experience"), picks a date/time/party-size, and the engine assigns a table.

### Current Data Model

```
Service (bookingMode: "tableReservation")
  └── requiredResourceGroupIds: ["group-A", "group-B"]  ← EXISTS but unused

ResourceGroup (e.g. "Upper Floor Parlor")
  └── Resources: Table 1 (2-4), Table 2 (2-4), ...

Experience (reservation-specific)
  └── NO resource group linkage ← THE GAP
```

---

## Current Bugs

| # | Bug | Root Cause |
|---|-----|------------|
| 1 | **Cross-group leak** — Dinner Experience fills Upper Floor, then spills into Main Dining Hall | `findBestTable()` queries ALL `type:"table"` resources for the store. No scoping by service → resource group |
| 2 | **Infinite bookings on same slot** — overflow lands in "Ikke tildelt" with overlapping cards | Pre-existing unassigned reservations (created before engine fix). Also: cards in "Ikke tildelt" stack on top of each other (CSS) |
| 3 | **Slideover empties on Cancel/Apply** | `ReservationSlideover.vue` — likely `v-if="reservation"` losing reference after `updateReservation` triggers reactivity flush |
| 4 | **Profile shows 0 reservations** | Firestore `collectionGroup` index for `reservations` where `customerId` doesn't exist yet |
| 5 | **Public booking fails with 409** | Engine correctly rejects when tables full — but the error message/UX could be clearer |

---

## Requirements

### R1: Service → Resource Group Scoping

> **When a reservation is created for a service, only tables within that service's `requiredResourceGroupIds` should be considered.**

**Data flow:**
1. Public marketplace sends `serviceId` with reservation request
2. Engine loads the Service document → reads `requiredResourceGroupIds`
3. `findBestTable()` filters resources to only those whose `resourceGroupId` is in the list
4. If no `requiredResourceGroupIds` → fall back to ALL tables (backward compat)

> [!IMPORTANT]
> This means the `Experience` schema can be deprecated for table reservation — `Service` already has everything needed (title, duration, `bookingMode`, `requiredResourceGroupIds`). The operating window (start/end time) would need to be added to Service or derived from store hours.

**Open question:** Do we keep `Experience` as a separate entity, or unify everything under `Service`? Experiences currently have `operatingWindow` (start/end time) that Services don't.

### R2: Reject When Group Is Full

> **If all tables in the scoped resource group are occupied for the requested time, reject the reservation. Never leak into other groups.**

- Return `409` with clear message: "No tables available for [Service Name] at this time"
- Public marketplace should show this as a user-friendly error and suggest trying another time

### R3: No Unassigned Reservations (Table Mode)

> **In table mode, every confirmed reservation MUST have a `tableId`. "Ikke tildelt" should only appear in pool mode.**

- Engine guarantees: if tables exist for the service → must assign one or reject
- Portal: hide "Ikke tildelt" row when store is in table mode (has table resources)

### R4: Portal Slideover Stability

> **Cancel/Apply buttons must not empty the panel. Panel should remain open with current reservation data until explicitly closed.**

- Root cause: likely reactive reference being replaced. Need to use `toRaw()` or stable ID-based lookup
- After save: show success toast, keep panel open with updated data

### R5: Card Overlap in Timeline

> **Multiple reservation cards on the same table/slot must not overlap visually.**

- CSS fix: cards should stack vertically or use a stacking layout within the cell
- If multiple reservations somehow land on the same table (shouldn't happen after R1-R3), show a warning badge

### R6: Profile Reservations

> **User profile must show both bookings AND reservations.**

- Requires Firestore composite index on `collectionGroup('reservations')` for `customerId`
- **Action:** Create the index via Firebase Console or `firestore.indexes.json`

---

## Architecture Decision: Experience vs Service

Currently there are two parallel concepts:

| | Service | Experience |
|---|---------|------------|
| Has resource group linkage | ✅ `requiredResourceGroupIds` | ❌ |
| Has operating window | ❌ | ✅ `operatingWindow` |
| Has booking mode | ✅ `bookingMode` | ❌ |
| Has duration | ✅ | ✅ (optional override) |
| Used by public marketplace | ✅ (standard booking) | ✅ (reservation slots) |

**Recommendation:** Add `operatingWindow` to Service (optional, for `tableReservation` mode) and use Service as the single entity for both booking modes. This eliminates the Experience → Service mapping gap entirely.

**Or:** Add `requiredResourceGroupIds` to Experience. Simpler short-term fix, but adds to technical debt.

---

## Implementation Priority

1. **R1** — Service → resource group scoping (blocks everything)
2. **R2** — Reject when full (depends on R1)
3. **R3** — No unassigned in table mode (depends on R1)
4. **R4** — Slideover fix (independent)
5. **R5** — Card overlap CSS (independent)
6. **R6** — Profile index (independent, quick)
