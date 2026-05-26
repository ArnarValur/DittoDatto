---
schema: ExperienceSchema
domain_term: Experience
firestore_path: companies/{companyId}/stores/{storeId}/experiences/{experienceId}
status: active
version: v1.0
related: [store, reservation]
noona_equivalent: N/A (DittoDatto original)
tags: [restaurant-vertical, v1.2]
---

# Experience

A named dining time window at a restaurant — Lunch, Dinner, Brunch, Happy Hour. Defines when specific dining experiences are available and what operating hours apply. Customers select an Experience when making a Reservation.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `storeId` | `string` | ✅ | Parent restaurant store |
| `companyId` | `string` | ✅ | Parent company |
| `name` | `string` | ✅ | Experience name: "Dinner", "Lunch", "Brunch" |
| `description` | `string` | ❌ | What makes this experience special |
| `image` | `string (url)` | ❌ | Cover image |
| `operatingWindow` | `{ startTime, endTime }` | ✅ | Time window: `"17:30"` – `"22:00"` |
| `duration` | `number (int)` | ❌ | Override default reservation duration (minutes) |
| `daysAvailable` | `number[]` | ✅ | Days of week (0=Sun–6=Sat). Default: all days |
| `isActive` | `boolean` | ✅ | Whether this experience is bookable. Default: `true` |
| `order` | `number (int)` | ✅ | Display order. Default: `0` |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification |

## Relationships

- An **Experience** belongs to exactly one **Store** (restaurant)
- **Reservations** may reference an **Experience** (via `experienceId`)
- The operating window constrains when reservations can be placed

## Design Notes

- A DittoDatto original — Noona doesn't have this concept. It provides structure for restaurants that want to differentiate their dining periods (different menus, pricing, or atmospheres).
- `daysAvailable` allows "Brunch only on weekends" or "Happy Hour Mon–Fri" without duplicating configuration.
- `duration` override lets "Quick Lunch" be 60 minutes while "Dinner" is 120 minutes, independent of the store's `defaultDuration`.
