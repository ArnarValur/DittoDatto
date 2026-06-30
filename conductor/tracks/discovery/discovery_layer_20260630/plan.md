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

- [x] Task: Build `EstablishmentListingCard` widget
    - [x] Cover image (or logo fallback, or placeholder)
    - [x] Name, category chip, rating stars (average + count)
    - [x] City/address subtitle
    - [x] Tap callback → navigate to establishment detail
- [x] Task: Build `HomeScreen` (replace placeholder)
    - [x] DittoBar search field at top (text input with search icon)
    - [x] Horizontal scrolling category chip row (from `fetchCategories()`)
    - [x] Vertical list of EstablishmentListingCards (from `fetchListings()`)
    - [x] Empty state: "Ingen virksomheter funnet" with illustration
    - [x] Loading skeleton shimmer
- [x] Task: Wire DittoBar search
    - [x] Debounced text input → `searchListings(query)` via BM25
    - [x] Results replace the listing list
    - [x] Clear button resets to default listings
- [x] Task: Wire category filtering
    - [x] Tap category chip → `fetchListings(category: slug)`
    - [x] Active chip visual state
    - [x] "Alle" chip to clear filter
- [x] Task: Connect Marketplace to discovery DB
    - [x] Riverpod providers for listings, categories, search
    - [x] DB connection via service user on `companies/discovery`
- [x] Task: Write tests for Phase 2
    - [x] EstablishmentListingCard renders correctly (6 tests)
    - [x] Router redirect tests updated with provider overrides (5 tests)
    - [ ] HomeScreen shows listings from provider (deferred — needs provider mock harness)
    - [ ] Search filters results (deferred — needs provider mock harness)
    - [ ] Category chip selection updates listings (deferred — needs provider mock harness)
    - [x] Empty state displayed when no results (via router test)

## Phase 3 — Area Hierarchy + Geo Filtering ⏸️ DEFERRED

> **Sticker:** Lean skip — only one listing in Drammen, area filtering adds no value yet.
> `DiscoveryRepository.fetchListings(city:)` already supports city-based filtering.
> Evolve to full polygon hierarchy + Admin CRUD when listing density justifies it.
> Re-scope via `/grill` when needed: Kartverket bydel polygons, `located_in` graph edges, Admin Areas screen.

- [~] Deferred — city filter infrastructure exists, full area hierarchy postponed
    - [x] `fetchListings(city:)` already in DiscoveryRepository
    - [ ] Kartverket bydel boundary GeoJSON polygons
    - [ ] Admin Panel Areas management screen
    - [ ] Point-in-polygon auto-detection on PublishSync
    - [ ] `located_in` graph edge creation
    - [ ] Area filter UI on Home screen

## Phase 4 — Two-Phase Detail Load (Replace Debug Pipe)

> **Architecture pivot:** SurrealDB Sidekick consultation revealed NS-level VIEWER user
> eliminates per-DB provisioning. `fn::get_storefront()` moves query logic server-side.
> DEFINE API exists but NS auth doesn't work with it (SDB 3.1.2) — using WS + fn call.

- [x] Task: NS-level marketplace reader (replaces per-DB user)
    - [x] `DEFINE USER marketplace_reader ON NAMESPACE ROLES VIEWER` in `init.surql`
    - [x] Added to `test-db-seed.sh`
    - [x] Applied to Saturn production
- [x] Task: Server-side storefront function
    - [x] `fn::get_storefront()` in `company-blueprint.surql`
    - [x] Returns `{ establishment, services, service_groups }`
    - [x] Applied to `company_dittodatto-as` on Saturn
- [x] Task: HTTP API endpoint (bonus)
    - [x] `DEFINE API "/establishment" FOR get` in blueprint
    - [x] Works with root auth, NS auth returns 401 (SDB 3.1.2 limitation)
- [x] Task: Build `StorefrontService`
    - [x] WS connect → signin(NS VIEWER) → use(company DB) → fn::get_storefront() → close
    - [x] Maps response to `EstablishmentData`
    - [x] ~50 lines (replaces 224-line debug service)
- [x] Task: Build `EstablishmentDetailScreen`
    - [x] Receives `companySlug` + `slug` from route params
    - [x] FutureProvider.autoDispose.family for per-company fetch
    - [x] Loading/error/data states with retry
    - [x] Favorites + booking integration preserved
- [x] Task: Wire dynamic route
    - [x] `/establishment/:companySlug/:slug` in router
    - [x] Listing card tap → `context.push('/establishment/${listing.companySlug}/${listing.slug}')`
- [x] Task: Remove debug pipe
    - [x] Deleted `establishment_debug_service.dart` (224 lines)
    - [x] Deleted `establishment_providers.dart` (21 lines)
    - [x] Deleted `establishment_test_screen.dart` (126 lines)
- [x] Task: Verification
    - [x] WS E2E test on Saturn (Python): signin → use → fn → data ✅
    - [x] 0 analysis errors, 40/40 widget tests pass
    - [x] Deployed to Galaxy S21 — House of the North loads from card tap ✅

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
