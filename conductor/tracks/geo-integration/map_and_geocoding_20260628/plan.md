# Plan: Map & Geocoding Integration

## Phase 1 — Data Layer ✅

- [x] Add `flutter_map`, `latlong2`, `http` to `establishment_ui/pubspec.yaml`
- [x] Add `latitude`/`longitude` fields to `EstablishmentData`
- [x] Run `flutter pub get`

## Phase 2 — Geocoding Services ✅

- [x] Create `NorwegianAddress` model (`establishment_ui/lib/src/models/`)
- [x] Create `KartverketService` — address autocomplete via `ws.geonorge.no`
- [x] Create `NominatimService` — forward geocoding via OSM Nominatim

## Phase 3 — Map Section Widget ✅

- [x] Create `EstablishmentMapSection` (read-only map sliver for EstablishmentPage)
- [x] Wire into `EstablishmentPage` after contact section
- [x] Export new files from barrel file
- [x] Add 'Kart' shortcut chip (only when location exists)

## Phase 4 — BP Edit Form Integration ✅

- [x] Add `latitude`/`longitude` to BP `Establishment` model
- [x] Parse GeoJSON `geometry<point>` in `fromJson`
- [x] Serialize GeoJSON point in `toJson`
- [x] Replace "Kartvisning kommer snart" placeholder with live map + autocomplete
- [x] Wire lat/lng state through edit view lifecycle
- [x] Add `flutter_map`/`latlong2` to BP pubspec

## Phase 5 — Admin Panel Integration ✅

- [x] Add `establishment_ui` dependency to admin pubspec
- [x] Create `_KartverketAddressField` widget in companies screen
- [x] Replace plain address TextField with Kartverket autocomplete
- [x] Verify auto-fill of city + postal code on selection
- [x] Fix deploy script path (`apps/admin-panel` → `apps/admin`)

## Phase 6 — Verification ✅

- [x] `dart analyze` — establishment_ui: 0 issues
- [x] `dart analyze` — business-portal: 0 errors
- [x] `dart analyze` — admin: 0 errors
- [x] Integration tests: 50/50 admin, 63/63 BP
- [x] Deploy admin to Saturn — hash verified, smoke test passed
- [x] Deploy BP to Saturn — hash verified, smoke test passed
- [x] Live test: Kartverket autocomplete + save round-trip confirmed

## Phase 7 — Marketplace Discovery Map (Future)

- [ ] Query establishments with `location != NONE` from discovery DB
- [ ] Multi-pin `MarkerLayer` on Marketplace landing page
- [ ] Tap pin → navigate to EstablishmentPage
- [ ] Cluster markers for dense areas

## Phase 8 — Sweden Support (Future)

- [ ] Evaluate Lantmäteriet API (requires registration + API key)
- [ ] Alternatively: Nominatim fallback for non-NO countries
- [ ] Country detection to switch autocomplete provider
