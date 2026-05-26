---
schema: CustomerSchema
domain_term: Customer
firestore_path: companies/{companyId}/customers/{customerId}
status: active
version: v1.0
related: [company, store, booking, staff-member, user]
noona_equivalent: Customer
tags: [core, business-portal, crm]
---

# Customer

A client of a specific business (Company). Represents the business's view of a person who has booked or been manually added. A Customer may optionally be linked to a registered platform User via `userId`.

> **Customer ≠ User.** A Customer exists within a Company's CRM. A User exists at the platform level. A walk-in customer who calls to book might have a Customer record but no User account.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `companyId` | `string` | ✅ | Parent company |
| `storeIds` | `string[]` | ✅ | Stores this customer has visited. For multi-store filtering. Default: `[]` |
| `userId` | `string` | ❌ | Link to registered platform User (if they have an account) |
| `name` | `string` | ✅ | Full name |
| `firstName` | `string` | ❌ | First name (parsed) |
| `lastName` | `string` | ❌ | Last name (parsed) |
| `email` | `string (email)` | ❌ | Email (or empty string) |
| `phone` | `string` | ❌ | Phone number |
| `phoneCountryCode` | `string` | ❌ | Phone country code |
| `notes` | `string` | ❌ | Staff notes about this customer |
| `status` | `enum: new, active, inactive` | ✅ | Lifecycle status. Default: `"new"` |
| `staffIds` | `string[]` | ✅ | Staff members who have served this customer. Default: `[]` |
| `channel` | `enum: app, web, portal, import` | ✅ | How this customer was acquired. Default: `"app"` |
| `lastBookingId` | `string` | ❌ | Most recent booking ID |
| `totalVisits` | `number` | ✅ | Cumulative booking count. Default: `0` |
| `totalSpent` | `number` | ✅ | Cumulative spend (default currency). Default: `0` |
| `firstVisitAt` | `Date` | ❌ | First booking timestamp |
| `lastVisitAt` | `Date` | ❌ | Most recent booking timestamp |
| `createdAt` | `Date` | ✅ | Record creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification timestamp |

## Relationships

- A **Customer** belongs to exactly one **Company**
- A **Customer** may be linked to a **User** (via `userId`)
- A **Customer** has been served by specific **Staff Members** (via `staffIds`)
- A **Customer** has visited specific **Stores** (via `storeIds`)
- A **Customer** has **Bookings** (referenced via `lastBookingId`, queried via `userId` or `customerId`)

## Design Notes

- **Status lifecycle:** `new` → `active` (has visited within 90 days) → `inactive` (no visit in 90+ days). Status transitions are computed, not manually set.
- **Metrics** (`totalVisits`, `totalSpent`, `firstVisitAt`, `lastVisitAt`) are incremented by MercuryEngine on booking completion. Never written by clients.
- **`channel`** tracks acquisition source for CRM analytics. `"import"` is for bulk CSV imports.
- **`storeIds`** enables multi-store filtering in the Business Portal: "Show me customers who visited Store A but not Store B."
- Inspired by Noona HQ's customer model: `event_count` → `totalVisits`, `previous_event` → `lastBookingId`, `employee_ids` → `staffIds`.
