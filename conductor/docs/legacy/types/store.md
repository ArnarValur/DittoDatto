---
schema: StoreSchema
domain_term: Establishment
firestore_path: companies/{companyId}/stores/{storeId}
status: active
version: v1.0
related: [company, service, service-group, booking, staff-member, resource, reservation, hold, schedule, booking-policy]
noona_equivalent: Company (location-level)
tags: [core, public-marketplace, business-portal]
---

# Store (Establishment)

A physical business location registered on the platform — salons, restaurants, garages, clinics, etc. The user-facing domain term is **Establishment**; `store` is retained as the Firestore collection name. The repository layer maps between them.

> **Naming convention:** In Flutter code, use `Establishment` and `establishmentId`. In Zod schemas and Firestore, `store` and `storeId` remain. This is deliberate — the persistence layer shouldn't leak into domain language.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `companyId` | `string` | ✅ | Parent company |
| `name` | `string` | ✅ | Establishment name |
| `slug` | `string` | ✅ | URL-safe slug |
| `address` | `string` | ✅ | Street address |
| `city` | `string` | ✅ | City |
| `zip` | `string` | ✅ | Postal code |
| `country` | `string` | ✅ | ISO country code. Default: `"NO"` |
| `gmapCoord` | `{ lat, lng }` | ❌ | Google Maps coordinates |
| `geoHash` | `string` | ❌ | Geohash for proximity queries |
| `phone` | `string` | ❌ | Contact phone (overrides company) |
| `email` | `string (email)` | ❌ | Contact email (overrides company) |
| `website` | `string (url)` | ❌ | Website (overrides company) |
| `slinks` | `object` | ❌ | Social links: `fb`, `ig`, `x` |
| `about` | `string` | ❌ | Description / about text |
| `images` | `object` | ✅ | `logo`, `cover` (optional strings), `gallery` (string array) |
| `coverLayoutMode` | `enum: showcase, spotlight, bento` | ✅ | Cover image layout. Default: `"bento"` |
| `openingSchedule` | `OpeningSchedule` | ✅ | Weekly opening hours (mon–sun) |
| `timezone` | `string` | ✅ | IANA timezone. Default: `"Europe/Oslo"` |
| `bookingPolicy` | `BookingPolicy` | ❌ | Booking/cancel/reschedule rules. Embedded object. |
| `storeType` | `enum: service, restaurant, venue` | ✅ | Business vertical — maps to primary booking mode. Default: `"service"` |
| `resourcesEnabled` | `boolean` | ✅ | Whether resource management is active. Default: `false` |
| ~~`bookingFormType`~~ | ~~`enum`~~ | ❌ | **⚠️ REMOVE (ADR-0004).** Booking mode lives on Service, not Store. See [ADR-0004](../adr/0004-per-service-booking-modes.md). |
| ~~`reservationConfig`~~ | ~~`object`~~ | ❌ | **⚠️ REMOVE (ADR-0004).** Config moves to Service or Resource. Design in Session 3. |
| `isPublished` | `boolean` | ✅ | Whether visible on Public Marketplace |
| `isActive` | `boolean` | ✅ | Soft-delete flag. Default: `true` |
| `category` | `string` | ❌ | Denormalized category slug for marketplace filtering |
| `aggregateRating` | `{ average, count }` | ❌ | Denormalized rating |
| `favoritesCount` | `number` | ✅ | Denormalized favorite count (updated by trigger). Default: `0` |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification timestamp |

## Relationships

- A **Store** belongs to exactly one **Company**
- A **Store** has many **Services** (sub-collection)
- A **Store** has many **Service Groups** (sub-collection)
- A **Store** has many **Resources** and **Resource Groups** (sub-collections)
- A **Store** has many **Reservations** (sub-collection, for restaurants)
- A **Store** has many **Experiences** (sub-collection, dining time windows)
- **Staff Members** are assigned to stores via `storeIds` on StaffMember
- **Bookings** reference a store via `storeId`
- **Holds** reference a store via `storeId`
- The **Public Marketplace** displays published stores as **EstablishmentPages**

## Design Notes

- `coverLayoutMode` controls the EstablishmentPage hero section: `bento` (2×2 grid), `showcase` (gallery scroll), `spotlight` (full-width single).
- ~~`bookingFormType`~~ — **REMOVED (ADR-0004).** Booking mode is per-service via `Service.bookingMode`. A store can have services with different booking modes simultaneously.
- `storeType` is **cosmetic only** (ADR-0004): affects UI presentation, Datto personality, and search categorization — NOT which booking modes are available.
- `favoritesCount` and `aggregateRating` are denormalized for cheap marketplace reads. Updated by Firestore triggers — never written by clients directly.
- `storeType` is the technical enum; the user-facing category is the `category` field (maps to `CategorySchema`).
- `geoHash` enables Firestore geo-queries for "near me" functionality on the map.

## Noona Comparison

- Noona conflates company and location into one entity. DittoDatto splits them: Company → Store is 1:many.
- Noona uses `company.profile` for booking policy; DittoDatto embeds `bookingPolicy` directly on Store.
- `coverLayoutMode` is a DittoDatto original — Noona has no equivalent (they use a fixed layout).
- Noona deprecated `space` in favor of `resources`; DittoDatto never had `space` — went straight to unified Resource.
