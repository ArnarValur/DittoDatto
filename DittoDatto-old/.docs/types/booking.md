---
schema: BookingSchema
domain_term: Booking
firestore_path: companies/{companyId}/bookings/{bookingId}
status: active
version: v1.0
related: [store, service, user, staff-member, hold, resource, customer]
noona_equivalent: Event
tags: [core, public-marketplace, business-portal, booking-spine]
---

# Booking

A confirmed appointment between a customer and an establishment. Created when a Hold is confirmed. Contains fiscal snapshots of price, service title, and user info at time of booking — immutable for legal compliance.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `userId` | `string` | ✅ | Customer's platform User ID |
| `companyId` | `string` | ✅ | Company this booking belongs to |
| `storeId` | `string` | ✅ | Store (Establishment) where the service is performed |
| `serviceId` | `string` | ✅ | Primary service booked |
| `staffId` | `string` | ❌ | Staff assignment. |
| `resourceId` | `string` | ❌ | Assigned resource (table, room, station) |
| `addonResourceIds` | `string[]` | ✅ | Add-on resources (e.g., Beer Keg, Bartender). Default: `[]` |
| `status` | `enum` | ✅ | `confirmed`, `completed`, `cancelled`, `no-show`, `pending` |
| `startTime` | `Date` | ✅ | Appointment start (ISO 8601) |
| `endTime` | `Date` | ✅ | Appointment end (ISO 8601) |
| `createdAt` | `Date` | ✅ | When the booking was created |
| `updatedAt` | `Date` | ❌ | Last modification |

### Fiscal Snapshot (Immutable at booking time)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `serviceTitle` | `string` | ✅ | Service name at time of booking |
| `duration` | `number (int)` | ✅ | Duration in minutes |
| `priceAtTimeOfBooking` | `number` | ✅ | Price at time of booking |
| `currency` | `enum: NOK, USD` | ✅ | Currency |
| `userName` | `string` | ✅ | Customer name (retained if account deleted) |
| `userEmail` | `string (email)` | ✅ | Customer email (retained if account deleted) |
| `userPhone` | `string` | ❌ | Customer phone |

### Multi-Service Items

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `items` | `array` | ✅ | Array of `{ serviceId, title, price, duration, staffId }` |

> ⚠️ **Cleanup (ADR-0003 session):** Current schema includes per-item `storeId` and `companyId` — these are redundant (always same as top-level). Remove them. A multi-service booking is always at the same establishment. Cross-store booking is not supported.

### Metadata

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `channel` | `enum: app, web, voice_agent, portal, phone` | ✅ | Booking source. Default: `"app"` |
| `attendeeCount` | `number (int)` | ✅ | Number of guests. Default: `1` |
| `notes` | `string` | ❌ | Customer notes |
| `cancellationReason` | `string` | ❌ | Reason for cancellation |
| `paymentId` | `string` | ❌ | Payment reference (Vipps/Stripe, future) |

## Status Lifecycle

```
pending → confirmed → completed
                   ↘ cancelled
                   ↘ no-show
```

- **pending:** Awaiting manual confirmation (if `overCapacityPolicy === "request"`)
- **confirmed:** Active booking
- **completed:** Service was performed
- **cancelled:** Cancelled by customer or staff (subject to booking policy)
- **no-show:** Customer didn't show up

## Relationships

- A **Booking** belongs to one **User** (the customer)
- A **Booking** belongs to one **Store** and one **Company**
- A **Booking** references one primary **Service** (plus additional services in `items[]`)
- A **Booking** may be assigned to a **Staff Member** (via `staffId`)
- A **Booking** may lock a **Resource** (via `resourceId`) and add-on resources
- A **Booking** is created from a confirmed **Hold**
- A **Booking** updates a **Customer** record (metrics: `totalVisits`, `totalSpent`, `lastVisitAt`)

## Design Notes

- **Fiscal snapshots** (`priceAtTimeOfBooking`, `serviceTitle`, `userName`, `userEmail`) are captured at booking creation and never updated. This is a legal requirement — price changes or account deletions must not affect historical records.
- **`items[]`** supports multi-service bookings: "Haircut + Beard Trim + Hot Towel". Each item has its own price and staff assignment.
- **`channel`** tracks booking origin for analytics. `"voice_agent"` is pre-wired for Ditto/Datto agentic bookings.
- **`attendeeCount`** is used for restaurant table logic: "Table for 4" → engine finds a table with `capacity >= 4`.
- **`paymentId`** is the bridge to Vipps/Stripe integration (v1.3). Currently always empty.

## Noona Comparison

- Noona calls bookings `Events` (very confusing — they also have actual events). DittoDatto uses the clearer term **Booking**.
- Noona tracks `check_in_at` and `check_in_origin` on bookings; DittoDatto tracks this on Reservations instead (separate schema for restaurants).
- Noona has `outstanding_no_show_fee` on the booking; DittoDatto defers no-show fee tracking to Payments integration.
- Both snapshot fiscal data at booking time.
