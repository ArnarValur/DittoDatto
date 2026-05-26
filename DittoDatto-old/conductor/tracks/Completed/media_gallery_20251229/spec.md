# Specification: Media Gallery Service (MVP)

> **Source:** Adapted from [.docs/media-gallery/spec.md](file:///x:/DittoDatto.no/.docs/media-gallery/spec.md)

## Overview

A centralized service for managing media assets (images, logos, portraits) for the DittoDatto platform. This track focuses on:

1. **Admin Panel:** Media Manager page with company filtering (similar to Services page)
2. **Business Portal:** Upload UI for company users (store covers, logos, staff photos)
3. **Foundation:** Firebase Storage structure and Firestore `media` collection

## User Personas

| Persona | Capabilities |
|---------|--------------|
| **Super Admin** | Full access to all media, filter by company |
| **Company Owner** | Upload/manage brand assets (logos) |
| **Store Manager** | Upload store gallery images, staff portraits |

## Data Model

**Collection:** `media`

```typescript
type MediaType = "logo" | "store_gallery" | "staff_portrait" | "cover" | "general";

interface MediaItem {
  id: string;
  companyId: string;
  storeId?: string;
  uploaderId: string;
  
  url: string;           // Firebase Storage Download URL
  path: string;          // Full Storage path (for deletion)
  filename: string;
  mimeType: string;
  size: number;
  width?: number;
  height?: number;
  
  type: MediaType;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
```

## Storage Hierarchy

```
companies/{companyId}/
├── logos/{filename}
├── covers/{filename}
├── stores/{storeId}/
│   └── gallery/{filename}
└── staff/{staffId}/
    └── portraits/{filename}
```

## Validation

- **Max File Size:** 5MB
- **Allowed Types:** `image/jpeg`, `image/png`, `image/webp`, `image/svg+xml`

## Security

| Layer | Read | Write |
|-------|------|-------|
| **Storage** | Public (MVP) | Auth user with matching `companyId` claim or `super_admin` |
| **Firestore** | Auth user with `companyId` access | Auth user with `companyId` or `super_admin` |

## MVP Scope (This Track)

### In Scope ✅
- [ ] Zod schema for `MediaItem` in `shared-types`
- [ ] Storage rules for company-scoped uploads
- [ ] `useMediaUpload` composable (upload + Firestore doc creation)
- [ ] Admin Panel: Media Manager page with company filter
- [ ] Business Portal: Basic upload UI (functional, not polished)

### Out of Scope ❌ (Post-MVP)
- Cloud Functions for image processing (thumbnails, placeholders)
- Batch upload
- Signed URLs for private assets
- `<NuxtImg>` optimization integration
