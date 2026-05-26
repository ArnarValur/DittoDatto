# Map Integration Track — Task List

> **Track:** map_integration_20260102 | **Branch:** `mapdata` | **Status:** ✅ COMPLETE

---

## Phase 1: Setup & Component

- [x] Install `@googlemaps/js-api-loader` dependency
- [x] Create `StoreMap.vue` component in `packages/ui/components/map/` (auto-imports as DDMapStoreMap)
- [x] Configure Google Maps API key in nuxt.config.ts runtimeConfig
- [x] Test component renders with coordinates

---

## Phase 2: Business Portal Integration

- [x] Remove Country field from Location tab (hardcoded to 'NO')
- [x] Add gmapCoord (lat/lng) to form state
- [x] Add "Find on Map" geocoding button using Maps JavaScript API Geocoder
- [x] Add map preview to Location tab
- [x] Update save logic to persist `gmapCoord`

---

## Phase 3: Preview Page Integration

- [x] Modify `AboutSection.vue` to accept lat/lng props
- [x] Integrate `DDMapStoreMap` with `<ClientOnly>` wrapper
- [x] Update `preview.vue` to pass coordinates
- [x] Update `[id].vue` to pass coordinates

---

## Phase 4: Verification

- [x] Manual test: Location tab shows map preview ✅
- [x] Manual test: Preview page shows interactive map ✅
- [x] Manual test: Directions button works ✅
- [ ] Manual test: Graceful fallback when no coordinates ✅

---

## Notes

- **GCP Setup Required:** API key needs HTTP referrer restrictions for each localhost port (e.g., `http://localhost:3001/*`)
- **Propagation Delay:** GCP restriction changes take up to 5 minutes to apply
- Uses `@googlemaps/js-api-loader` v2.x functional API (`setOptions()` + `importLibrary()`)
- Geocoding uses Maps JavaScript API `Geocoder` class (not REST API) for better key management
