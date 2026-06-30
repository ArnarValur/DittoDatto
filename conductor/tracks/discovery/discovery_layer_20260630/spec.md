# Discovery Layer — Specification

## Overview

The Marketplace app currently has a placeholder Home tab ("Utforsk tjenester — DittoBar og oppdagelse kommer snart") and a hardcoded debug pipe that reads a single company DB. The Discovery Layer replaces this with:

1. A **publish pipeline** — when a business owner publishes an establishment in the Business Portal, a denormalized `establishment_listing` is written to `companies/discovery` (ADR-0024).
2. A **shared Dart package** (`packages/discovery_service/`) containing all discovery read/write logic (ADR-0026).
3. A **real Home screen** — search bar (DittoBar with BM25 full-text search), category chips, and EstablishmentListingCards.
4. **Two-phase load** — listings from discovery for browsing, full detail from company DBs via `marketplace_reader` service user (ADR-0025).
5. **Area auto-detection** — Kartverket geocoding data used to auto-classify establishments into geographic areas (Drammen → Bragernes/Konnerud/Fjell/etc.).

## Functional Requirements

### BP Publish Sync (Phase 1)
- When `is_published` flips to `true` in BP, `ListingSyncService` writes/updates an `establishment_listing` in `companies/discovery`.
- When `is_published` flips to `false`, the listing is marked `is_active=false` in discovery (soft removal).
- `bp_portal` on discovery DB upgraded from VIEWER to EDITOR for the `establishment_listing` table.
- Listing projection: name, slug, about, address fields, location (geo), logo, cover, store_type, category, category_ref.

### Discovery Service Package (Phase 1)
- `packages/discovery_service/` with barrel export.
- `DiscoveryRepository` — reads listings, categories, areas from `companies/discovery`.
- `ListingSyncService` — writes/updates `establishment_listing` on publish.
- Dart models: `EstablishmentListing`, `DiscoveryCategory`, `DiscoveryArea`.
- Anonymous read access: Marketplace connects to discovery DB via a read-only service user (or unauthenticated if PERMISSIONS allow SELECT).

### Home Screen (Phase 2)
- Replace placeholder with: DittoBar search field at top, horizontal category chip row, vertical list of EstablishmentListingCards.
- DittoBar uses SurrealQL BM25 full-text search on `name` and `about` fields (Norwegian snowball stemmer already indexed).
- Category chip tap filters listings by category.
- EstablishmentListingCard: cover/logo, name, category chip, rating stars, city/address.
- Tap card → navigate to EstablishmentPage.

### Area Auto-Detection (Phase 3)
- When PublishSync runs, use the establishment's geocoded coordinates to determine the area (bydel/kommune).
- Create `located_in` graph edge linking listing → area.
- Seed initial area hierarchy: Viken → Drammen → bydeler (Bragernes, Strømsø, Konnerud, Fjell, Gulskogen, etc.) with approximate boundary polygons from Kartverket.
- Home screen gains area filter (optional).

### Two-Phase Detail Load (Phase 4)
- Define `marketplace_reader` service user in `company-blueprint.surql` (VIEWER: SELECT on `establishment`, `service`, `service_group` WHERE `is_active=true`).
- Password via `--dart-define=MARKETPLACE_READER_PASS=xxx`.
- Replace `EstablishmentDebugService` with `DiscoveryRepository.fetchDetail(companySlug, establishmentSlug)` → connects to `company_{slug}` DB.
- Remove debug pipe entirely.

## Non-Functional Requirements

- **Performance:** Home screen must load listings in <500ms on 4G.
- **Privacy:** Anonymous browsing per ADR-0020. No PII in discovery queries. SearchEvent logging deferred (separate DittoBar Intelligence grill).
- **Consistency:** PublishSync is immediate (not eventually consistent). Listing appears in discovery within the same user session as the publish action.

## Acceptance Criteria

1. Business owner publishes in BP → listing appears on Marketplace Home screen.
2. Business owner unpublishes → listing disappears from Home screen.
3. DittoBar search returns relevant results via BM25 (Norwegian text).
4. Category chip filters listings correctly.
5. Tapping a listing card opens EstablishmentPage with full data (services, staff, gallery).
6. Area auto-detected from geocoded address.
7. Debug pipe (`EstablishmentDebugService`) fully replaced and deleted.
8. Deploy to phone — full flow verified on Galaxy S21.

## Edge Cases & Constraints

- **Company with no published establishments:** No listing synced. Home screen shows empty state.
- **Establishment with no services:** Listing synced (it's a valid business), but services section on detail page is empty.
- **Stale listing:** If business owner updates establishment without re-publishing, listing may be stale. PublishSync should run on any establishment update when `is_published=true`, not just on the toggle.
- **Blueprint migration:** Existing company DBs (House of the North) need `marketplace_reader` added via schema migration.

## Dependencies

- `establishment_ui` package (✅ built — EstablishmentPage, EstablishmentData)
- `ditto_auth` package (✅ built — DB connection management)
- `ditto_design` package (✅ built — theme tokens, layout)
- Kartverket geocoding integration (✅ built — `packages/establishment_ui/`)
- Admin Panel category management (✅ built — categories already in `companies/discovery`)
- ADR-0024, ADR-0025, ADR-0026 (✅ recorded)

## Out of Scope

- SearchEvent / Zero-Result Signal logging (separate DittoBar Intelligence grill)
- Vector search / semantic search via embeddings
- Rating/review system
- Favorites count aggregation on listings
- Map view / multi-pin discovery
- Self-service business signup
- Push notifications on new listings
- Restaurant reservation flow (separate booking mode)
