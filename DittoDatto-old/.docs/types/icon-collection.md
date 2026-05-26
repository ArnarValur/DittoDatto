---
schema: IconCollectionSchema
domain_term: Icon Collection
firestore_path: iconCollections/{iconCollectionId}
status: active
version: v1.0
related: []
noona_equivalent: N/A
tags: [platform, admin-panel]
---

# Icon Collection

A curated set of icon names for use in the Business Portal and Admin Panel (e.g., service category icons, UI elements). Admin-managed collections with a default set.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `name` | `string` | ✅ | Collection name |
| `description` | `string` | ❌ | Collection description |
| `icons` | `string[]` | ✅ | Array of icon names |
| `isDefault` | `boolean` | ✅ | Whether this is the default collection. Default: `false` |
| `createdAt` | `string (datetime)` | ✅ | Creation timestamp |
| `updatedAt` | `string (datetime)` | ✅ | Last modification |

## Design Notes

- Used by the IconPicker component in the Business Portal for selecting service category icons.
- `isDefault: true` marks the platform-provided collection. Custom collections can be created by admins.
- Uses `z.string().datetime()` instead of `IsoDateSchema` (inconsistency — should eventually align).
