# 🪑 Resources & Table Reservation — Design Report

**Created:** 2026-03-03
**Author:** Commander Hermes + Captain Arnar
**Status:** Phase 1 prep complete, ready for implementation

---

## Context

DittoDatto's booking engine supports three booking types:

1. **Service bookings** — appointments (massage, haircut, etc.) ✅ Live
2. **Table reservations** — restaurant tables, capacity-based ⬅️ This report
3. **Event bookings** — ticketed events (future — possibly April)

The Resource system underpins both table reservations AND event space add-ons.

---

## The Insight

Resources are the unifying concept across multiple use cases:

| Use Case                | Resource Type | Examples                                                     |
| ----------------------- | ------------- | ------------------------------------------------------------ |
| Restaurant tables       | `table`       | Table 1 (2–4 guests), Table 5 (6 pax)                        |
| Massage/treatment rooms | `room`        | Room 1, VIP Suite                                            |
| Hair stations           | `station`     | Chair 1, Chair 2                                             |
| Event space rental      | `room`        | Red Hall, Blue Room                                          |
| Event add-ons           | `addon`       | Beer Keg (1500kr), Bartender (2500kr), Laser Lights (9990kr) |
| Equipment rental        | `equipment`   | Projector, Sound System                                      |

### Add-on Resources (💡 Key Feature)

Add-on resources (`type: "addon"`) have a **price** and can be attached to bookings.
This enables "Party Hall 1 rental + Beer Keg + Bartender" as a single booking with aggregated pricing.

---

## What Already Exists

These schemas were designed ahead of time and are ready for wiring:

### `resource.ts` (shared-types) — ✅ Updated this session

- `ResourceSchema` — type, capacity, price, imageUrl, priority, allowOverlapping, bookingInterval
- `ResourceGroupSchema` — logical groupings ("Main dining", "Outside", "Massage rooms")
- `ResourceTypeSchema` — `room | table | station | equipment | addon`
- `ResourcePrioritySchema` — `low | normal | high` (for auto-assignment preference)
- Input schemas: `CreateResourceSchema`, `CreateResourceGroupSchema`

### `reservation.ts` (shared-types) — ✅ Pre-existing

- `ReservationSchema` — `guestCount`, `tableId`, `status` (with `seated` state!), customer info
- `ReservationConfigSchema` — `maxGuestsPerReservation`, `largePartyHandling`, `capacityMode`, `autoConfirm`
- `ExperienceSchema` — meal periods ("Lunch", "Dinner") with `operatingWindow` time ranges
- `CapacityMode` — `pool | tables | hybrid`

### `booking.ts` (shared-types) — ✅ Updated this session

- Added `resourceId` — which resource was assigned (table, room)
- Added `addonResourceIds[]` — add-on resources attached to booking
- Expanded `channel` — `app | web | voice_agent | portal | phone` (walk-in/phone support)
- Already had `attendeeCount` — "Table for 4" logic

### `hold.ts` (shared-types) — ✅ Updated this session

- Added `resourceId` — resource locked during hold

### `service.ts` (shared-types) — ✅ Pre-existing

- `requiredResourceGroupIds[]` — links services to required resource groups

---

## Implementation Phases

### Phase 1: Foundation (Schema + CRUD) — ~3h ✅ PREPPED

- [x] Schema enhancements (resourceId, price, addon type, priority, overlapping)
- [x] Cloud Functions: `resources/index.ts` with full CRUD (6 functions)
- [x] Composables: `useResources.ts` + `useResourceGroups.ts`
- [x] Functions registered in `src/index.ts`
- [ ] **Next session:** Deploy + verify, add Firestore rules

### Phase 2: Portal Resource Management UI — ~4h

- [ ] Settings → Resources page (CRUD)
- [ ] Resource group collapsible sections
- [ ] Resource cards with capacity, price, type badges
- [ ] Service → Resource group linking in ServiceFormSlideover

### Phase 3: MercuryEngine Resource Wiring — ~3h

- [ ] `getSlots`: Check resource availability
- [ ] `createHold`: Lock resource
- [ ] `createBooking`: Assign resourceId
- [ ] Resource conflict detection

### Phase 4: Table Reservation View — ~4h

- [ ] Fork BookingOverview → TableReservationOverview
- [ ] Tables as rows (grouped by ResourceGroup/area)
- [ ] Guest count on blocks
- [ ] Meal period filters (Lunch/Dinner via Experience schema)
- [ ] Walk-in quick-create
- [ ] Right sidebar: upcoming reservations timeline

### Phase 5: Event Add-ons — ~2h

- [ ] Add-on resource selection in booking flow
- [ ] Price aggregation (service + add-ons)
- [ ] Booking detail shows attached add-ons

---

## Noona Reference Analysis

The Noona table reservation screenshot reveals these patterns:

| Pattern                   | Noona                                          | DittoDatto Adaptation                               |
| ------------------------- | ---------------------------------------------- | --------------------------------------------------- |
| Table × time grid         | Horizontal time axis, vertical table rows      | Fork our vertical-time BookingOverview              |
| Area grouping             | "Main dining (8)", "Outside (4)" — collapsible | `ResourceGroup` with collapse toggle                |
| Seat count                | Per-row indicator                              | `Resource.minCapacity / maxCapacity`                |
| Guest count on blocks     | 🪑 2, 🪑 4 icons                               | `Reservation.guestCount` or `Booking.attendeeCount` |
| Walk-in support           | Distinct green color                           | `channel: "portal"` + visual style                  |
| Meal period filters       | "All day / Lunch / Dinner" tabs                | `Experience` schema with `operatingWindow`          |
| Priority booking          | `priority: "normal"` per resource              | `ResourcePrioritySchema` for auto-assignment        |
| Sidebar timeline          | Upcoming list grouped by time                  | Optional panel component                            |
| Overlapping bookings      | `allow_overlapping_bookings` flag              | `Resource.allowOverlapping`                         |
| Resource booking interval | Per-resource override                          | `Resource.bookingInterval`                          |

---

## Competitive Edge

> **Noona** = salon/spa focused, added restaurant features later
> **DittoDatto** = marketplace discovery + booking in one platform

Our advantage: A business on DittoDatto gets discovered AND booked from the same platform.
The resource system makes us equally capable for salons, restaurants, event spaces, AND rental businesses.

---

## Files Modified This Session (Forework)

| File                                               | What                                                                                                   |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `shared-types/src/resource.ts`                     | Added `addon` type, `price`, `currency`, `imageUrl`, `allowOverlapping`, `bookingInterval`, `priority` |
| `shared-types/src/booking.ts`                      | Added `resourceId`, `addonResourceIds[]`, expanded `channel` enum                                      |
| `shared-types/src/hold.ts`                         | Added `resourceId`                                                                                     |
| `functions/src/resources/index.ts`                 | **NEW** — Full CRUD for Resources + ResourceGroups (6 Cloud Functions)                                 |
| `functions/src/index.ts`                           | Registered resource functions                                                                          |
| `business-portal/composables/useResources.ts`      | **NEW** — Reactive Firestore collection with filtering helpers                                         |
| `business-portal/composables/useResourceGroups.ts` | **NEW** — Reactive Firestore collection for groups                                                     |

---

_Next session: Deploy resource functions + build Settings → Resources UI_
