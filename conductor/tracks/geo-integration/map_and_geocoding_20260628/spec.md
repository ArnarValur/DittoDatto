# Spec: Map & Geocoding Integration

## Overview

Integrate a shared map widget and address geocoding across the DittoDatto platform. Uses free, keyless services: **flutter_map** (OpenStreetMap tiles), **Kartverket** (Norwegian address autocomplete), and **Nominatim** (forward geocoding). All logic lives in the shared `establishment_ui` package for cross-app reuse.

### Problem

Establishments and Companies need real-world coordinates for discovery (map pins) and address management (auto-fill). Google Maps requires API keys and billing; Kartverket + OSM are free and Norway-native.

### PRD Anchor

Supports the **Public Marketplace** vision of map-based discovery with pins for local establishments. Also aligns with **Business Portal** establishment management and **Admin Panel** company administration.

---

## Functional Requirements

1. **Kartverket Address Autocomplete** — Type ≥ 3 chars in an address field → query `ws.geonorge.no/adresser/v1/sok` → show real Norwegian addresses in a dropdown → select one → auto-fill street, city, postal code.
2. **Nominatim Forward Geocoding** — Convert a full address string into lat/lng coordinates via OSM Nominatim. Used as fallback when Kartverket doesn't provide coordinates directly.
3. **flutter_map Map Widget** — Display an interactive OpenStreetMap with a marker pin at the establishment/company location. Used in both read-only (EstablishmentPage) and edit (BP edit form) contexts.
4. **GeoJSON Persistence** — Store coordinates as `geometry<point>` in SurrealDB (`{ type: "Point", coordinates: [lng, lat] }`). Round-trip parse/serialize in Dart models.
5. **Cross-App Reuse** — Services (`KartverketService`, `NominatimService`) and models (`NorwegianAddress`) exported from `establishment_ui` barrel file. Consumed by Admin Panel, BP, and future Marketplace.

---

## Non-Functional Requirements

- **Zero API keys** — All three services (OSM tiles, Kartverket, Nominatim) are free and require no authentication.
- **Debounced requests** — 300ms debounce on Kartverket autocomplete to avoid API flooding.
- **OSM tile policy** — `userAgentPackageName` set in `TileLayer` per OSM usage policy.
- **Nominatim rate limit** — Max 1 req/sec per OSM Nominatim policy. Current usage is well under this.

---

## Acceptance Criteria

- [x] Kartverket autocomplete works in Admin Panel company dialog (address → city + postal auto-fill)
- [x] Kartverket autocomplete works in BP establishment edit form
- [x] flutter_map renders with OSM tiles and a pin in BP Lokasjon section
- [x] EstablishmentPage (shared) shows read-only map section when coordinates exist
- [x] GeoJSON round-trip: save lat/lng → SurrealDB `geometry<point>` → reload → same values
- [x] `dart analyze` clean across establishment_ui, admin, and business-portal
- [x] All integration tests pass (50 admin, 63 BP)
- [x] Both apps deployed to Saturn and verified
- [ ] **Future:** Marketplace landing page with multi-pin discovery map
- [ ] **Future:** Swedish address support (Lantmäteriet or Nominatim fallback)

---

## Edge Cases & Constraints

- **Norway-only autocomplete** — Kartverket covers Norwegian addresses exclusively. A TODO comment documents future Sweden exploration via Lantmäteriet or Nominatim fallback.
- **Missing coordinates** — If Kartverket returns an address without lat/lng, Nominatim geocoding is used as fallback. If both fail, the map shows a "Skriv en adresse" placeholder.
- **GeoJSON coordinate order** — GeoJSON is `[longitude, latitude]`, not `[lat, lng]`. The model handles the swap explicitly.
- **Nullable geometry** — `location` field is `option<geometry<point>>` in the schema. Null/absent coordinates are valid (new establishments won't have them yet).

---

## Dependencies

- `flutter_map: ^8.1.1` — Map widget
- `latlong2: ^0.9.1` — Coordinate types (LatLng)
- `http: ^1.2.2` — HTTP client for Kartverket + Nominatim APIs
- `establishment_ui` shared package — hosts all geo services and widgets

---

## Out of Scope

- Google Maps integration (replaced by OSM)
- Draggable pin / manual coordinate adjustment
- Reverse geocoding (coordinates → address)
- Swedish address autocomplete (documented as future TODO)
- Marketplace multi-pin discovery map (future phase)
