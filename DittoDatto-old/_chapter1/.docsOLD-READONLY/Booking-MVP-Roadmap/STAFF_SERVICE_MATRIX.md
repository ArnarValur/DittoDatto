# 🧠 Booking Engine — Staff-Service Decision Matrix

> **MercuryEngine architecture reference for how staff, services, and availability interact.**
> Last updated: 2026-03-10

---

## The 4 Store Modes

| # | Store Setup | Example | Slot Logic |
|---|---|---|---|
| 1 | **No staff** | Solo nail artist, car wash kiosk | Store-hours only. Global concurrency (1 booking at a time). |
| 2 | **1 staff** | Solo barber with a booking page | That person's shift schedule. 1 slot at a time for them. |
| 3 | **Many staff, all services** | Thai massage salon — everyone does everything | Union of all staff shifts. Slot available if **any** staff is free. |
| 4 | **Many staff, assigned services** | Hair salon — "Senior Cut" only by Pim | Filter by `service.assignedStaff[]`. Only eligible staff count. |

---

## Staff-Service Candidate Resolution

When a customer selects services and optionally a staff member, the engine resolves **who is eligible**:

```
service.assignedStaff   │ staffId (user chose)  │ Candidates
════════════════════════╪═══════════════════════╪══════════════════
[]  (anyone can do it)  │ undefined ("anyone")  │ ALL bookable staff
[]  (anyone can do it)  │ "staff_123"           │ Just staff_123
["A", "B"]              │ undefined ("anyone")  │ Just A and B
["A", "B"]              │ "staff_A"             │ Just A
["A", "B"]              │ "staff_C"             │ ERROR — C can't do this service
```

### Multi-Service Rule

When booking multiple services at once, the eligible staff is the **intersection**:

```
Service "Hands"   → assignedStaff: []         → eligible: ALL
Service "Head"    → assignedStaff: ["A","B"]  → eligible: A, B
─────────────────────────────────────────────────────────────────
Combined booking  → intersection: A, B
```

If one service says "anyone" (`[]`) and another restricts to specific staff, the restricted list wins.

---

## Data Flow

```
                        ┌─────────────────────┐
                        │   Customer Request   │
                        │  services[], staffId │
                        └─────────┬───────────┘
                                  │
                    ┌─────────────▼──────────────┐
                    │   fetchAvailabilityData()   │
                    │  → ALL bookable staff       │
                    │  → bookings, holds          │
                    │  → services, resources      │
                    └─────────────┬──────────────┘
                                  │
                    ┌─────────────▼──────────────┐
                    │   Staff Candidate Filter    │
                    │                             │
                    │  1. service.assignedStaff   │
                    │     → restrict candidates   │
                    │                             │
                    │  2. staffId from user        │
                    │     → further restrict       │
                    │                             │
                    │  3. Normalize weeklyShifts   │
                    │     → fallback to store hrs  │
                    └─────────────┬──────────────┘
                                  │
                    ┌─────────────▼──────────────┐
                    │   Time Tetris Loop          │
                    │   (every slotInterval min)  │
                    │                             │
                    │  For each candidate:        │
                    │  ├ Shift check (schedule)    │
                    │  ├ Occupancy check (clashes) │
                    │  └ Resource check (tables)   │
                    │                             │
                    │  → ANY free? → slot ✅       │
                    └─────────────┬──────────────┘
                                  │
                        ┌─────────▼───────────┐
                        │  Available Slots[]   │
                        └─────────────────────┘
```

---

## Key Schema Fields

| Field | Location | Purpose |
|---|---|---|
| `service.assignedStaff[]` | `ServiceSchema` | Which staff can perform this service. Empty = all. |
| `service.personId` | `ServiceSchema` | **Legacy.** Single staff. Being replaced by `assignedStaff`. |
| `staff.isBookable` | `StaffMemberSchema` | Whether customers can book with this person. |
| `staff.showOnStorefront` | `StaffMemberSchema` | Whether this person appears on the public page. |
| `staff.weeklyShifts` | `StaffMemberSchema` | Shift blocks per day. Optional — engine falls back to store hours. |
| `staff.storeIds[]` | `StaffMemberSchema` | Which stores this staff member works at. |

---

## Edge Cases & Rules

1. **`assignedStaff: []`** = universal service. All bookable staff are eligible.
2. **No bookable staff at store** = Mode 1 (store-level). No staff filtering at all.
3. **Staff without `weeklyShifts`** = Engine falls back to store opening hours (defensive).
4. **User picks specific staff** = Only that person is considered. If they can't do the service → error.
5. **Multi-service booking** = Staff must be eligible for ALL selected services.
6. **Resource requirements** = Checked independently of staff (AND logic: staff OK AND resource OK).

---

## Noona HQ Comparison

| Concept | Noona | DittoDatto |
|---|---|---|
| Staff | `employee` | `StaffMember` |
| Service | `event_type` | `Service` |
| Staff-Service link | `employee.event_type_ids` | `service.assignedStaff[]` (inverted) |
| Slot interval | `override_booking_interval` (default 15) | `bookingPolicy.slotInterval` (default 15) |
| "Anyone" | `employee_id` param optional | `staffId` param optional |
| Resources | `resource_id` | `service.requiredResourceGroupIds[]` |

> Note: Noona links from employee→services (employee knows what they can do).
> DittoDatto links from service→employees (service knows who can do it).
> Both approaches work. Ours is simpler for the business admin UX ("who does this service?").
