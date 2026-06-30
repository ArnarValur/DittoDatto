## Phase 1 — Package + Models + BP Publish Sync

- [x] Task: Create `packages/discovery_service/` package scaffold
    - [x] `pubspec.yaml` with dependencies on `surrealdb`, `flutter`
    - [x] `lib/discovery_service.dart` barrel export
    - [x] `lib/src/` directory structure (models/, repositories/, services/)
- [x] Task: Build Dart models
    - [x] `EstablishmentListing` — matches `establishment_listing` schema fields
    - [x] `DiscoveryCategory` — matches `category` schema fields
    - [x] `DiscoveryArea` — matches `area` schema fields with parent-child support
- [x] Task: Build `DiscoveryRepository` (read-side)
    - [x] `fetchListings({category?, city?, query?})` — SELECT from `establishment_listing`
    - [x] `searchListings(query)` — BM25 full-text search on name + about
    - [x] `fetchCategories()` — SELECT from `category`
    - [x] `fetchAreas({parent?})` — SELECT from `area` with optional parent filter
    - [x] DB connection management (service user on `companies/discovery`)
- [x] Task: Build `ListingSyncService` (write-side)
    - [x] `syncListing(EstablishmentData, companySlug)` — UPSERT `establishment_listing`
    - [x] `deactivateListing(companySlug, establishmentSlug)` — SET `is_active=false`
    - [x] Build denormalization logic (Establishment → EstablishmentListing projection)
    - [x] Create `categorized_as` graph edge on sync
- [x] Task: Upgrade `bp_portal` on discovery DB
    - [x] Change from VIEWER to EDITOR for `establishment_listing` table
    - [x] Update `test-db-seed.sh` with new permissions
- [x] Task: Wire PublishSync into BP
    - [x] Hook into `is_published` toggle in establishment edit view
    - [x] On publish: call `ListingSyncService.syncListing()`
    - [x] On unpublish: call `ListingSyncService.deactivateListing()`
    - [x] On any establishment update when `is_published=true`: re-sync
- [x] Task: Write tests for Phase 1
    - [x] Model serialization/deserialization tests (9 + 3 AggregateRating)
    - [x] DiscoveryCategory + DiscoveryArea model tests (12 tests)
    - [x] ListingSyncService projection logic tests (5 tests)
    - [ ] BP integration test: publish → verify listing in discovery (deferred to Phase 5 E2E)

## Phase 2 — Marketplace Home Screen + DittoBar Search

- [ ] Task: Build `EstablishmentListingCard` widget
    - [ ] Cover image (or logo fallback, or placeholder)
    - [ ] Name, category chip, rating stars (average + count)
    - [ ] City/address subtitle
    - [ ] Tap callback → navigate to establishment detail
- [ ] Task: Build `HomeScreen` (replace placeholder)
    - [ ] DittoBar search field at top (text input with search icon)
    - [ ] Horizontal scrolling category chip row (from `fetchCategories()`)
    - [ ] Vertical list of EstablishmentListingCards (from `fetchListings()`)
    - [ ] Empty state: "Ingen virksomheter funnet" with illustration
    - [ ] Loading skeleton shimmer
- [ ] Task: Wire DittoBar search
    - [ ] Debounced text input → `searchListings(query)` via BM25
    - [ ] Results replace the listing list
    - [ ] Clear button resets to default listings
- [ ] Task: Wire category filtering
    - [ ] Tap category chip → `fetchListings(category: slug)`
    - [ ] Active chip visual state
    - [ ] "Alle" chip to clear filter
- [ ] Task: Connect Marketplace to discovery DB
    - [ ] Riverpod providers for listings, categories, search
    - [ ] DB connection via anonymous/service user on `companies/discovery`
- [ ] Task: Write tests for Phase 2
    - [ ] EstablishmentListingCard renders correctly
    - [ ] HomeScreen shows listings from provider
    - [ ] Search filters results
    - [ ] Category chip selection updates listings
    - [ ] Empty state displayed when no results

## Phase 3 — Area Hierarchy + Geo Filtering

- [ ] Task: Seed initial Drammen area hierarchy
    - [ ] Research Kartverket API for bydel boundaries (GeoJSON polygons)
    - [ ] Create Admin Panel Areas management screen (CRUD for areas)
    - [ ] Seed: Viken (fylke) → Drammen (kommune) → bydeler
- [ ] Task: Auto-detect area on PublishSync
    - [ ] On sync, use establishment coordinates to determine area
    - [ ] Point-in-polygon check against area boundaries
    - [ ] Create `located_in` graph edge (listing → area)
    - [ ] Fallback: use city name matching if no polygon match
- [ ] Task: Area filter on Home screen
    - [ ] Area dropdown or chip row (below categories or integrated)
    - [ ] Filter listings by `located_in` relationship
- [ ] Task: Write tests for Phase 3
    - [ ] Area model tests
    - [ ] Point-in-polygon detection tests
    - [ ] Area filter on home screen tests

## Phase 4 — Two-Phase Detail Load (Replace Debug Pipe)

- [ ] Task: Define `marketplace_reader` in blueprint
    - [ ] Add DEFINE USER in `company-blueprint.surql` (VIEWER, SELECT only)
    - [ ] Permissions: `establishment WHERE is_published=true`, `service WHERE is_active=true AND deleted_at IS NONE`, `service_group WHERE deleted_at IS NONE`
    - [ ] Password via `MARKETPLACE_READER_PASS` dart-define
- [ ] Task: Build detail fetch in `DiscoveryRepository`
    - [ ] `fetchEstablishmentDetail(companySlug, establishmentSlug)` → connects to `company_{slug}` DB
    - [ ] Returns full `EstablishmentData` (services, service groups, establishment info)
    - [ ] On-demand DB connection (connect, query, disconnect)
- [ ] Task: Wire detail load into Marketplace
    - [ ] Listing card tap → fetch detail → navigate to EstablishmentPage
    - [ ] Loading state during detail fetch
    - [ ] Error handling (company DB unreachable, establishment not found)
- [ ] Task: Remove debug pipe
    - [ ] Delete `EstablishmentDebugService`
    - [ ] Delete `establishment_providers.dart` (replace with discovery providers)
    - [ ] Remove "Establishment Test" button from home screen
    - [ ] Update `/booking` route to receive data from discovery flow
- [ ] Task: Apply `marketplace_reader` to existing company DBs
    - [ ] Migration script for House of the North (`company_dittodatto-as`)
    - [ ] Update `test-db-seed.sh`
- [ ] Task: Write tests for Phase 4
    - [ ] Detail fetch returns full EstablishmentData
    - [ ] Detail load → EstablishmentPage renders correctly
    - [ ] Error states (DB down, establishment not found)
    - [ ] Debug pipe fully removed (no references)

## Phase 5 — Verification + Deploy

- [ ] Task: End-to-end verification
    - [ ] Admin creates Company A → provisions DB
    - [ ] Business owner logs into BP → creates establishment → publishes
    - [ ] Listing appears on Marketplace Home screen
    - [ ] DittoBar search finds it
    - [ ] Tap → full EstablishmentPage with services
    - [ ] Book button → booking flow works
    - [ ] Unpublish → listing disappears
- [ ] Task: Multi-tenant verification
    - [ ] Create second company (hair salon) via Admin
    - [ ] Create third company (restaurant) via Admin
    - [ ] All three appear on Home screen with correct categories
- [ ] Task: Visual polish
    - [ ] Home screen matches design system (Moody Blue, Plus Jakarta Sans)
    - [ ] Smooth transitions, skeleton loading
    - [ ] Norwegian labels verified
- [ ] Task: Deploy
    - [ ] Deploy BP to Saturn (publish sync)
    - [ ] Deploy Marketplace to phone (home screen)
    - [ ] E2E walkthrough on Galaxy S21
