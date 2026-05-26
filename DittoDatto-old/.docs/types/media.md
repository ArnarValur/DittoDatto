---
schema: MediaItemSchema
domain_term: Media Item
firestore_path: companies/{companyId}/media/{mediaId}
status: active
version: v1.0
related: [company, store]
noona_equivalent: N/A (Noona uses direct URL references)
tags: [core, business-portal]
---

# Media Item

A managed media asset stored in Firebase Storage with metadata in Firestore. Supports images for logos, covers, galleries, staff portraits, and menu items. Tag-based categorization with company-configurable tags.

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Firestore document ID |
| `companyId` | `string` | ✅ | Owning company |
| `storeId` | `string` | ❌ | Associated store (optional for company-level assets) |
| `uploaderId` | `string` | ✅ | Who uploaded this |
| `url` | `string (url)` | ✅ | Firebase Storage download URL |
| `path` | `string` | ✅ | Full Storage path (for deletion) |
| `filename` | `string` | ✅ | Original filename |
| `mimeType` | `enum` | ✅ | `image/jpeg`, `image/png`, `image/webp`, `image/svg+xml`, `image/heic`, `image/heif` |
| `size` | `number (int)` | ✅ | File size in bytes (max 10MB) |
| `width` | `number (int)` | ❌ | Image width (extracted after upload) |
| `height` | `number (int)` | ❌ | Image height (extracted after upload) |
| `name` | `string` | ❌ | User-friendly display name |
| `tags` | `string[]` | ✅ | Categorization tags: `["logo", "cover", "staff"]`. Default: `[]` |
| `type` | `MediaType` | ❌ | **Deprecated.** Use `tags` instead. |
| `createdAt` | `Timestamp` | ✅ | Upload timestamp |
| `updatedAt` | `Timestamp` | ✅ | Last modification |

## Allowed MIME Types

`image/jpeg`, `image/png`, `image/webp`, `image/svg+xml`, `image/heic`, `image/heif`

## Default Tags

`logo`, `cover`, `staff`, `store`, `menu`, `misc` — configurable per company via `Company.mediaConfig.defaultTags`.

## Design Notes

- `tags` replaced the deprecated `type` enum for flexibility. A single image can be tagged as both `"cover"` and `"staff"` if needed.
- 10MB max file size. No video support yet — images only.
- `path` is the Firebase Storage path, not a URL. Used for deletion when the media item is removed.
- Companies can customize available tags via `Company.mediaConfig.defaultTags`.
