---
schema: UserFavoriteSchema
domain_term: User Favorite
firestore_path: users/{userId}/favorites/{favoriteId}
status: active
version: v1.0
related: [user, store]
noona_equivalent: N/A
tags: [public-marketplace, v1.1]
---

# User Favorite

A user's "hearted" establishment. Stored as a sub-collection on the User document. Primarily used for the favorites list (v1.1) and as a targeting mechanism for Broadcast notifications.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Document ID (= store ID for `type: "store"`) |
| `type` | `enum: store, person` | ✅ | What was favorited |
| `addedAt` | `Date` | ✅ | When the user favorited this |

## Relationships

- A **User Favorite** belongs to a **User** (sub-collection)
- `type: "store"` → references a **Store** (Establishment)
- `type: "person"` → references a legacy **Person** (staff)
- Favorited stores receive **Broadcast** notifications from the business

## Design Notes

- **Primary use case:** Users heart establishments they love. The favorites list shows these on the Profile tab (v1.1).
- **`type: "person"`** — the ability to favorite individual staff members exists in the schema. Open question: do we surface this in the Flutter app, or is favoriting establishments sufficient for v1.1? A user might want to follow "their" stylist across store changes. Defer decision to v1.1 scope.
- **`favoritesCount`** on Store is incremented/decremented by a Firestore trigger when favorites are added/removed. Enables "❤️ 42" on the EstablishmentPage.
- In Flutter domain code, `type: "store"` maps to `"establishment"` — the repo layer handles the translation.
