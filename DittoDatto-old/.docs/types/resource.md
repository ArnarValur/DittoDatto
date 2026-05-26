---
schema: ResourceSchema, ResourceGroupSchema
domain_term: Resource / Resource Group
firestore_path: companies/{companyId}/stores/{storeId}/resources/{resourceId}, .../resourceGroups/{groupId}
status: active
version: v1.0
related: [store, service, booking, hold, reservation]
noona_equivalent: Resource / Resource Group
tags: [core, business-portal]
---

# Resource System

Physical assets required to perform services: rooms, tables, stations, equipment, add-ons. A unified model that replaced the deprecated `space` concept. Resources are organized into Resource Groups — when a Service requires a resource, it references a group, and MercuryEngine picks any available resource from that group.

## Resource Group

Logical grouping of interchangeable resources.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `storeId` | `string` | ✅ | Parent store |
| `companyId` | `string` | ✅ | Parent company |
| `name` | `string` | ✅ | Group name: "Massage Rooms", "Window Tables" |
| `description` | `string` | ❌ | Group description |
| `sortOrder` | `number (int)` | ✅ | Display order. Default: `0` |
| `showOnStorefront` | `boolean` | ✅ | Whether browsable on public EstablishmentPage. Default: `false` |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification |

## Resource

A single physical asset.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `storeId` | `string` | ✅ | Parent store |
| `companyId` | `string` | ✅ | Parent company |
| `resourceGroupId` | `string` | ❌ | Parent group (ungrouped if empty) |
| `name` | `string` | ✅ | Resource name: "Massage Room 1", "Table 5" |
| `description` | `string` | ❌ | Resource description |
| `type` | `enum: room, table, station, equipment, addon` | ✅ | Resource type |
| `minCapacity` | `number (int)` | ✅ | Min guests served. Default: `1` |
| `maxCapacity` | `number (int)` | ✅ | Max guests served. Default: `1` |
| `price` | `number` | ❌ | Price for add-on resources ("Beer Keg 1500 kr") |
| `currency` | `string (3 char)` | ✅ | Currency code. Default: `"NOK"` |
| `imageUrl` | `string (url)` | ❌ | Resource photo |
| `isBookable` | `boolean` | ✅ | Whether available for booking. Default: `true` |
| `allowOverlapping` | `boolean` | ✅ | Allow multiple bookings at same time. Default: `false` |
| `bookingInterval` | `number (int)` | ❌ | Override store-level slot interval (minutes) |
| `priority` | `enum: low, normal, high` | ✅ | Auto-assignment preference. Default: `"normal"` |
| `sortOrder` | `number (int)` | ✅ | Display order. Default: `0` |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification |

## Resource Types

| Type | Description | Example |
|------|-------------|---------|
| `room` | Enclosed space for private services | Massage room, treatment room |
| `table` | Restaurant seating | Table 5, Bar seating |
| `station` | Open workstation | Hair station, nail station |
| `equipment` | Specific tool or machine | Laser machine, projector |
| `addon` | Bookable extra with price | Beer keg, DJ equipment |

## Relationships

- A **Resource Group** belongs to one **Store**
- A **Resource** belongs to one **Store** and optionally one **Resource Group**
- **Services** require resources via `requiredResourceGroupIds` (references groups, not individual resources)
- **Bookings** lock a resource via `resourceId` (individual assignment)
- **Holds** lock a resource via `resourceId`
- **Reservations** may reference a table resource via `tableId`
- **MercuryEngine** checks: `staff available AND resource available → slot is bookable`

## Design Notes

- **Group-based assignment:** Services reference Resource *Groups*, not individual Resources. The engine picks the best available resource from the group. This avoids customers having to choose "Room 1 vs Room 2" — they just book "a massage room."
- **`priority`** controls auto-assignment preference: high-priority resources are assigned first (e.g., the premium massage room).
- **`allowOverlapping: true`** is for shared resources like a conference room that can host multiple small meetings simultaneously.
- **`addon` type** with `price` enables "add a beer keg to your birthday party" upselling.
- **`minCapacity` / `maxCapacity`** enables table reservation logic: "Find a table that seats 4 guests" → engine finds resources where `minCapacity <= 4 <= maxCapacity`.

## Noona Comparison

- Noona deprecated their `space` property on Events in favor of a unified `resources` array. DittoDatto went straight to unified Resources — correct architectural choice validated by Noona's own migration.
- Noona's Resource Groups are very similar. Key difference: DittoDatto adds `addon` type with pricing for upsell resources.
