---
schema: CategorySchema
domain_term: Category
firestore_path: categories/{categoryId}
status: active
version: v1.0
related: [store, search-event]
noona_equivalent: Company Types + Categories
tags: [core, public-marketplace]
---

# Category

A service category for marketplace filtering and discovery — "Hair Salon", "Restaurant", "Massage", "Auto Repair". Categories are platform-wide (not per-company). Stores reference a category via the denormalized `Store.category` field.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `name` | `string` | ✅ | Display name |
| `slug` | `string` | ✅ | Kebab-case URL slug |
| `description` | `string` | ❌ | Category description |
| `icon` | `string` | ❌ | Lucide icon name |
| `count` | `number (int)` | ✅ | Number of stores in this category. Denormalized, updated by trigger. Default: `0` |
| `createdAt` | `Date` | ✅ | Creation timestamp |
| `updatedAt` | `Date` | ✅ | Last modification |

## Design Notes

- Categories live at Store level, not Company level. A company operating a salon and a barbershop has two stores in different categories.
- `count` is denormalized for the marketplace home screen: "Hair Salons (24)", "Restaurants (18)". Updated by Firestore trigger when stores are created/deleted.
- Categories are admin-managed — businesses can't create custom categories.
- `SearchEvent.selectedResult.type === "category"` tracks when users click on a category from search results.
