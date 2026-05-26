---
schema: ServiceGroupSchema
domain_term: Service Group
firestore_path: companies/{companyId}/stores/{storeId}/serviceGroups/{groupId}
status: active
version: v1.0
related: [store, service, staff-member]
noona_equivalent: Event Type Category
tags: [core, business-portal, public-marketplace]
---

# Service Group

An organizational container for related services within a store. Purely for display and selection — carries no configuration defaults. Duration, buffer, capacity, and availability belong on the Service or Resource exclusively.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `storeId` | `string` | ✅ | Parent store |
| `name` | `string` | ✅ | Group name (e.g., "Hair Services", "Nail Services") |
| `description` | `string` | ❌ | Group description |
| `staffIds` | `string[]` | ❌ | Staff assigned to this group |
| `sortOrder` | `number (int)` | ✅ | Display order. Default: `0` |
| `showOnBookingPanel` | `boolean` | ✅ | Whether visible on public booking UI. Default: `true` |
| `multiSelect` | `boolean` | ✅ | Whether customers can pick multiple services from this group in one booking. Default: `false` |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification timestamp |

## Relationships

- A **Service Group** belongs to exactly one **Store**
- A **Service Group** contains zero or more **Services** (via `Service.groupId`)
- A **Service Group** may have assigned **Staff Members** (via `staffIds`)

## Design Notes

- **Organizational only.** This was a deliberate design decision (2026-03-03, Noona analysis): groups should never be a config layer. Putting duration or buffer on a group creates inheritance headaches and implicit overrides.
- **`multiSelect: true`** enables the "pick multiple" UX for compound bookings: "Haircut + Beard Trim + Hot Towel" from the same group.
- **`showOnBookingPanel: false`** hides internal groups (e.g., "Staff-only services") from the public EstablishmentPage.

## Noona Comparison

- Noona has three levels of grouping: `Event Type Category Group` → `Event Type Category` → `Event Type`. DittoDatto intentionally simplifies to **Service Group** → **Service** (two levels). Less nesting = less confusion.
