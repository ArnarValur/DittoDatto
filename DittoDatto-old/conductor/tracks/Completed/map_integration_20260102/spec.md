# Map Integration Track — Spec

> **Created:** 2026-01-02 | **Branch:** `mapdata` | **Status:** Planning

---

## Overview

Implement interactive map display for store locations using **Google Maps JavaScript API** (user preference for GCP ecosystem alignment).

**Two key integration points:**
1. **Preview Page (About Us tab)** — Replace static placeholder with interactive map
2. **Business Portal Location Tab** — Add map preview + remove Country field

---

## Current State Analysis

### Schema ✅ Ready
```typescript
// packages/shared-types/src/store.ts (lines 29-35)
gmapCoord: z.object({
  lat: z.number().min(-90).max(90),
  lng: z.number().min(-180).max(180),
}).optional(),
geoHash: z.string().optional(),
country: z.string().min(2).max(255).default("NO"), // Always "NO"
```

### Files to Modify

| File | Change |
|------|--------|
| `packages/ui/components/establishment/AboutSection.vue` | Accept lat/lng props, integrate map component |
| `apps/web/business-portal/app/pages/establishments/[slug]/index.vue` | Remove Country field (L367-369), add map preview to Location tab |
| `apps/web/business-portal/app/pages/establishments/[slug]/preview.vue` | Pass coordinates to AboutSection |
| `apps/web/business-portal/app/pages/preview/[id].vue` | Pass coordinates to AboutSection |

### New Components

| Component | Purpose |
|-----------|---------|
| `packages/ui/components/map/DDStoreMap.vue` | Reusable map component (CSR-only via `<ClientOnly>`) |

---

## Map Provider Decision

> [!IMPORTANT]
> **Recommendation: Google Maps API**
> 
> User preference for GCP ecosystem alignment. Provides Places Autocomplete potential for future address search.

### Alternative Considered
- **Leaflet + Kartverket**: Free, no API key, excellent Norwegian detail. Could revisit if cost becomes an issue.

---

## Dependencies

```bash
# Primary
npm install @googlemaps/js-api-loader

# If Leaflet route chosen instead:
# npm install leaflet @types/leaflet
```

---

## Scope Boundaries

**In Scope:**
- [x] DDStoreMap component with Google Maps
- [x] Integrate into AboutSection
- [x] Map preview in Location tab
- [x] Remove Country input (hardcode "NO")
- [x] Directions button (opens Google Maps)

**Out of Scope (Future):**
- [ ] Address autocomplete/search
- [ ] Geocoding API (convert address → coordinates)
- [ ] Backfill existing stores with coordinates

---

## ⚠️ Legal Compliance Notes (Google Maps ToS)

### Location Privacy (§4.3)
If we collect user locations, we **must**:
1. **Notify users** what location data we collect
2. **Get consent** before caching their location

> **Current Status:** Not collecting user locations yet — only displaying store coordinates.
> **Future:** If we add "near me" features or user location tracking, implement consent flow first.

### Terms of Service Link (§3.2.2)
Public-facing app must state:
> "This application uses Google Maps features. Use is subject to [Google Maps Terms](https://maps.google.com/help/terms_maps/) and [Google Privacy Policy](https://policies.google.com/privacy)."

**TODO:** Add to public-marketplace footer or Terms page.

---

## User Questions

1. **API Key**: Do you have a Google Maps API key, or should I guide you through creating one?
2. **Coordinates Entry**: For now, how should coordinates be entered?
   - Manual lat/lng input fields in Location tab?
   - Or defer coordinate entry to future geocoding feature?
