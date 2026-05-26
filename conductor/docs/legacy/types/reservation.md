---
schema: ReservationSchema
domain_term: Reservation
firestore_path: companies/{companyId}/stores/{storeId}/reservations/{reservationId}
status: active
version: v1.0
related: [store, experience, resource, customer]
noona_equivalent: Event (restaurant context)
tags: [restaurant-vertical, business-portal, v1.2]
---

# Reservation

A table reservation at a restaurant-type Establishment. Separate from Booking because restaurants have distinct needs: guest counts, table assignment, seating status, and dining experiences. Part of v1.2 (Restaurant Vertical).

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `storeId` | `string` | ✅ | Restaurant store |
| `companyId` | `string` | ✅ | Parent company |
| `experienceId` | `string` | ❌ | Which dining experience (Dinner, Lunch, Brunch) |
| `customerId` | `string` | ❌ | Linked CRM customer (if registered) |
| `customerName` | `string` | ✅ | Guest name |
| `customerEmail` | `string (email)` | ❌ | Guest email |
| `customerPhone` | `string` | ✅ | Guest phone (required for confirmation) |
| `guestCount` | `number (int)` | ✅ | Party size |
| `date` | `Date` | ✅ | Reservation date |
| `time` | `string` | ✅ | Time slot `"HH:MM"` |
| `duration` | `number (int)` | ✅ | Expected duration in minutes |
| `tableId` | `string` | ❌ | Assigned table resource (if table management is used) |
| `status` | `enum` | ✅ | Lifecycle status. Default: `"confirmed"` |
| `notes` | `string` | ❌ | Guest special requests ("window seat", "birthday") |
| `internalNotes` | `string` | ❌ | Staff-only notes |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification |
| `confirmedAt` | `Date` | ❌ | When reservation was confirmed |
| `cancelledAt` | `Date` | ❌ | When reservation was cancelled |
| `cancelReason` | `string` | ❌ | Cancellation reason |

## Status Lifecycle

```
pending → confirmed → seated → completed
                   ↘ cancelled
                   ↘ no_show
```

- **pending:** Awaiting confirmation (if `autoConfirm === false`)
- **confirmed:** Reservation accepted
- **seated:** Party has arrived and been seated (check-in)
- **completed:** Dining finished
- **cancelled:** Cancelled by guest or restaurant
- **no_show:** Guest didn't arrive

## Relationships

- A **Reservation** belongs to one **Store** (restaurant)
- A **Reservation** may reference an **Experience** (dining window)
- A **Reservation** may be assigned a **Resource** (table) via `tableId`
- A **Reservation** may be linked to a **Customer** (CRM)

## Design Notes

- Separate from Booking intentionally. Restaurants need: `seated` status, `guestCount`, `tableId`, `internalNotes`, `experiences`. These don't map cleanly to the appointment-based Booking schema.
- `customerPhone` is required (not optional like in Booking) because restaurants need phone for same-day confirmation calls.
- Consider adding `checkInAt` and `checkInBy` fields (from Noona insights) for host tracking at the door.
- `tableId` references a Resource of type `"table"` from the store's resource management system.

## Noona Comparison

- Noona uses the same `Event` schema for both appointments and reservations. DittoDatto deliberately separates them for clarity and to avoid forcing restaurant-specific fields onto appointment bookings.
- Noona tracks `check_in_at` natively on their Event — recommended addition for DittoDatto Reservations.
