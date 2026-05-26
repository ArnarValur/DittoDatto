# Specification: Store Preview Page - Structure, Layout Modes & Publishing

## Overview

This track defines the **public-facing Store Page** structure, introduces **3 owner-selectable cover image layout modes**, and establishes the **Publish/Visibility flow** that makes stores publicly accessible.

## Visual References

### Layout Modes Concept
![Cover Layout Modes Mockup](file:///C:/Users/arnar/.gemini/antigravity/brain/316999ff-f100-46b1-99d5-9942f32634f8/uploaded_image_1767143055967.png)

### Store Edit - Media Tab Location
![Media Tab Location](file:///C:/Users/arnar/.gemini/antigravity/brain/316999ff-f100-46b1-99d5-9942f32634f8/uploaded_image_1767143561018.png)

---

## Part 1: Cover Layout Modes (Corrected)

The owner can choose how their store's hero/gallery section is displayed. Three modes are available:

### Mode A: "Showcase" (3/4 + 1/4 Vertical Scroll)
```
┌─────────────────────────┬───────┐
│                         │ img 1 │
│                         ├───────┤
│     COVER IMAGE         │ img 2 │  ← Vertical scroll if >2 images
│        (3/4)            ├───────┤
│                         │ img 3 │
│                         ├───────┤
│                         │  ...  │
└─────────────────────────┴───────┘
```
- **Left**: Large cover image (75% width)
- **Right**: Vertical scrollable gallery strip (25% width)
- Best for: Restaurants, hotels with many photos to showcase

### Mode B: "Spotlight" (4/4 Full Cover)
```
┌─────────────────────────────────┐
│                                 │
│         COVER IMAGE             │
│           (4/4)                 │
│                                 │
└─────────────────────────────────┘
```
- **Single panoramic cover image** spanning full width
- Gallery accessible via "View Gallery" button overlay
- Best for: Service businesses, clinics, minimalist brands

### Mode C: "Bento Grid" (2/4 + 2x2 Quad) — Current Default
```
┌─────────────────┬───────┬───────┐
│                 │ img 1 │ img 2 │
│   COVER IMAGE   ├───────┼───────┤
│      (2/4)      │ img 3 │ img 4 │
└─────────────────┴───────┴───────┘
```
- **Left**: Cover image (50% width)
- **Right**: 2x2 grid of gallery images (50% width, each ~25%)
- Current implementation in `EstablishmentImageGallery.vue`
- Best for: Balanced visual with variety

---

## Part 2: Schema Changes

### Store Schema Extension

```typescript
// In packages/shared-types/src/store.ts

// New coverLayoutMode enum
coverLayoutMode: z.enum(['showcase', 'spotlight', 'bento']).default('bento'),

// Existing images structure (already defined)
images: z.object({
  logo: z.url().optional(),
  cover: z.url().optional(),
  gallery: z.array(z.url()).default([]),
}).default({ gallery: [] }),
```

---

## Part 3: New "Media" Tab in Store Edit

### Location
Add after "Settings" tab in store edit page:
`General | Location | Contact | Hours | Settings | 📷 Media`

### Media Tab Contents
1. **Layout Mode Selector** - Visual radio buttons showing the 3 layouts
2. **Cover Image Picker** - Uses `MediaPickerButton` component
3. **Gallery Images** - Multi-select picker or drag-drop grid
4. **Logo Picker** - Small logo image for info bar

### Component Path
- `apps/web/business-portal/app/pages/stores/[slug]/index.vue` → Add "Media" tab
- OR create `apps/web/business-portal/app/pages/stores/[slug]/media.vue`

---

## Part 4: Publishing Flow

### Current State
- `isPublished: boolean` exists on Store schema
- No UI to toggle it in Business Portal
- No public-marketplace frontend exists yet

### Target State

1. **Business Portal**: Add "Publish" toggle in Settings tab (or dedicated "Visibility" section)
2. **Visibility States**:
   - `isPublished: false` → Only visible in Business Portal preview
   - `isPublished: true` → Visible on Public Marketplace
3. **Pre-publish Checklist** (soft warnings):
   - ⚠️ No cover image selected
   - ⚠️ Missing address
   - ⚠️ No services configured
   
### Public Marketplace Integration (Post-It Note)

> **📌 FUTURE**: Public Marketplace (`apps/web/public-marketplace`) is empty.
> This track focuses on the Preview Page structure in Business Portal.
> The same components will be reused when marketplace is built.

---

## Part 5: Component Architecture

### Shared Components (packages/ui)
- `EstablishmentImageGallery.vue` - Refactor to accept `layoutMode` prop
  - Implement `showcase`, `spotlight`, `bento` variants
  
### New Components Needed
- `LayoutModeSelector.vue` - Visual picker for the 3 modes
- `GalleryEditor.vue` - Multi-image picker with reorder (optional, can reuse MediaGrid)

### Business Portal Specific
- Store edit page → Add "Media" tab
- Preview page → Pass `layoutMode` from store data

---

## Part 6: Implementation Difficulty Assessment

| Task | Complexity | Notes |
|------|-----------|-------|
| Schema addition | 🟢 Easy | Single enum field |
| Media Tab UI | 🟢 Easy | New tab with existing pickers |
| Layout Mode Selector | 🟡 Medium | Visual radio buttons with previews |
| "Bento" mode | 🟢 Done | Already implemented |
| "Spotlight" mode | 🟢 Easy | Simplify current component |
| "Showcase" mode | 🟡 Medium | Vertical scroll container, responsive |
| Publish toggle | 🟢 Easy | Boolean field update |
| Mobile responsiveness | 🟡 Medium | All 3 modes need mobile variants |

**Overall: Medium complexity, ~4-6 hours estimated**

---

## Scope Boundary

### In Scope ✅
- Schema update for `coverLayoutMode`
- `EstablishmentImageGallery.vue` refactor to support 3 modes
- New "Media" tab in store edit
- Business Portal: Publish toggle UI
- Preview page reflects selected mode

### Out of Scope ❌ (Future)
- Public Marketplace pages (empty currently)
- SEO/meta tags for public pages
- Gallery lightbox/fullscreen viewer
- Drag-drop image reordering
