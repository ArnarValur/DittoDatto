---
schema: ServiceSchema
domain_term: Service
firestore_path: companies/{companyId}/stores/{storeId}/services/{serviceId}
status: active
version: v1.0
related: [store, service-group, booking, staff-member, resource, hold]
noona_equivalent: Event Type
tags: [core, public-marketplace, business-portal, booking-spine]
---

# Service

A bookable offering provided by an Establishment — haircuts, massages, consultations, table reservations, event tickets. The core unit of the booking spine.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `storeId` | `string` | ✅ | Parent store |
| `groupId` | `string` | ❌ | Parent Service Group (for organizational grouping) |
| `staffId` | `string` | ❌ | **Legacy.** Single staff assignment. Use `assignedStaff[]`. |
| `assignedStaff` | `string[]` | ✅ | Staff UIDs who can perform this service. **Empty = not bookable** (ADR-0006). Default: `[]` |
| `staffAssignmentMode` | `enum: customer_choice, any_available, manual` | ✅ | How staff is selected for this service (ADR-0006). Default: `"any_available"` |
| `requiredResourceGroupIds` | `string[]` | ✅ | Resource groups needed. Empty = no resource required. Default: `[]` |
| `title` | `string` | ✅ | Service name |
| `description` | `string` | ❌ | Service description |
| `bookingMode` | `enum: standard, tableReservation, ticketSystem` | ✅ | How customers book. Default: `"standard"` |
| `coverImage` | `string` | ❌ | Cover image URL |
| `gallery` | `string[]` | ❌ | Gallery image URLs |
| `serviceType` | `string[]` | ✅ | Category tags (e.g., `["haircut", "styling"]`) |
| `subcategory` | `string` | ❌ | Sub-category |
| `keywords` | `string[]` | ✅ | AI-generated search keywords |
| `aiDescription` | `string` | ❌ | AI-generated description for search/matching |
| `_embedding` | `number[]` | ❌ | Vector embedding for semantic search |
| `duration` | `number (int)` | ✅ | Duration in minutes |
| `price` | `number` | ✅ | Price (non-negative) |
| `bufferTime` | `number (int)` | ✅ | Buffer between consecutive bookings (minutes). Default: `0` |
| `currency` | `enum: NOK, USD` | ✅ | Currency. Default: `"NOK"` |
| `overCapacityPolicy` | `enum: reject, request, allow` | ✅ | What happens when capacity is exceeded. Default: `"reject"` |
| `minBookingNoticeMinutes` | `number (int)` | ✅ | Minimum advance notice to book. Default: `0` |
| `slotInterval` | `number (int)` | ✅ | Slot generation interval in minutes. Default: `15` |
| `isActive` | `boolean` | ✅ | Whether this service is bookable. Default: `true` |

## Booking Modes

| Mode | Description | Example |
|------|-------------|---------|
| `standard` | 1:1 time-based appointments | Haircut, massage |
| `tableReservation` | Capacity-based group bookings | Restaurant table |
| `ticketSystem` | Inventory-based event tickets | Concert, workshop |

## Relationships

- A **Service** belongs to exactly one **Store**
- A **Service** may belong to a **Service Group** (via `groupId`)
- A **Service** can be performed by multiple **Staff Members** (via `assignedStaff`)
- A **Service** may require **Resources** from specific **Resource Groups** (via `requiredResourceGroupIds`)
- **Bookings** reference the booked service via `serviceId`
- **Holds** reference the held service via `serviceId` / `serviceIds`
- **MercuryEngine** uses `duration`, `bufferTime`, `assignedStaff`, and `requiredResourceGroupIds` for slot calculation

## Design Notes

- **Dual availability check:** MercuryEngine calculates slots as `staff available AND resource available → slot is bookable`. If `requiredResourceGroupIds` is empty, only staff availability matters.
- **Empty `assignedStaff` = not bookable** (ADR-0006). MercuryEngine returns zero slots. Staff must be explicitly assigned.
- **`staffAssignmentMode`** (ADR-0006): `customer_choice` (customer picks), `any_available` (engine auto-assigns), `manual` (manager assigns post-booking). Datto enhances `any_available` with intelligent scoring in v1.5.
- **`overCapacityPolicy: "request"`** enables "Request to Book" flows — the booking goes to `pending_approval` status and the business manually confirms.
- **`_embedding`** is for future vector search via Saturn/Qdrant. Not populated in v1.0.
- **`keywords`** should always be populated — they feed DittoBar search and future AI matching.
- **`slotInterval`** can differ per service: a quick 15-min nail job might use 15-min intervals, while a 2-hour spa treatment might use 30-min intervals.

## Noona Comparison

- Noona calls this `Event Type` (confusing name — "event" in Noona means "booking", not "concert"). DittoDatto uses the clearer term **Service**.
- Noona groups event types into `Event Type Categories` and `Event Type Category Groups` — three levels of nesting. DittoDatto simplifies to **Service Group** → **Service** (two levels).
- Noona has `overbookable` enum; DittoDatto uses `overCapacityPolicy` with three explicit options.
- `_embedding` and `aiDescription` are DittoDatto originals — preparing for agentic search.
