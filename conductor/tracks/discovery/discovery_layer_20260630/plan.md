## Phase 1 — Package + Models + BP Publish Sync

- [ ] Task: Create `packages/discovery_service/` package scaffold
    - [ ] `pubspec.yaml` with dependencies on `ditto_auth`, `establishment_ui`, `flutter`
    - [ ] `lib/discovery_service.dart` barrel export
    - [ ] `lib/src/` directory structure (models/, repositories/, services/)
- [ ] Task: Build Dart models
    - [ ] `EstablishmentListing` — matches `establishment_listing` schema fields
    - [ ] `DiscoveryCategory` — matches `category` schema fields
    - [ ] `DiscoveryArea` — matches `area` schema fields with parent-child support
- [ ] Task: Build `DiscoveryRepository` (read-side)
    - [ ] `fetchListings({category?, city?, query?})` — SELECT from `establishment_listing`
    - [ ] `searchListings(query)` — BM25 full-text search on name + about
    - [ ] `fetchCategories()` — SELECT from `category`
    - [ ] `fetchAreas({parent?})` — SELECT from `area` with optional parent filter
    - [ ] DB connection management (anonymous or service user on `companies/discovery`)
- [ ] Task: Build `ListingSyncService` (write-side)
    - [ ] `syncListing(EstablishmentData, companySlug)` — CREATE/UPDATE `establishment_listing`
    - [ ] `deactivateListing(companySlug, establishmentSlug)` — SET `is_active=false`
    - [ ] Build denormalization logic (EstablishmentData → EstablishmentListing projection)
    - [ ] Create `categorized_as` graph edge on sync
- [ ] Task: Upgrade `bp_portal` on discovery DB
    - [ ] Change from VIEWER to EDITOR for `establishment_listing` table
    - [ ] Update `test-db-seed.sh` with new permissions
- [ ] Task: Wire PublishSync into BP
    - [ ] Hook into `is_published` toggle in establishment edit view
    - [ ] On publish: call `ListingSyncService.syncListing()`
    - [ ] On unpublish: call `ListingSyncService.deactivateListing()`
    - [ ] On any establishment update when `is_published=true`: re-sync
- [ ] Task: Write tests for Phase 1
    - [ ] Model serialization/deserialization tests
    - [ ] DiscoveryRepository unit tests (mock DB)
    - [ ] ListingSyncService projection logic tests
    - [ ] BP integration test: publish → verify listing in discovery

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
