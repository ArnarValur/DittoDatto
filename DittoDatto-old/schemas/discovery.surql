-- =============================================================================
-- DittoDatto — Discovery Database Schema
-- =============================================================================
-- Applied to: titan/discovery
-- Version:    0.1.0
-- Created:    2026-05-03
--
-- Public aggregator — "Ditto's eyes" into the graph.
-- Populated via MercuryEngine dual-write (syncToDiscovery).
-- Read-heavy, eventually consistent with company source-of-truth.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. category (source: CategorySchema docs)
-- -----------------------------------------------------------------------------
-- Platform-wide taxonomy. Admin-managed.

DEFINE TABLE category SCHEMAFULL;

DEFINE FIELD name              ON category TYPE string;
DEFINE FIELD slug              ON category TYPE string;
DEFINE FIELD description       ON category TYPE option<string>;
DEFINE FIELD icon              ON category TYPE option<string>;
DEFINE FIELD count             ON category TYPE int                  DEFAULT 0;

DEFINE FIELD created_at        ON category TYPE datetime             VALUE $value OR time::now();
DEFINE FIELD updated_at        ON category TYPE datetime             VALUE time::now();

DEFINE INDEX idx_category_slug ON category FIELDS slug UNIQUE;

-- -----------------------------------------------------------------------------
-- 2. area (geographic region for discovery filtering)
-- -----------------------------------------------------------------------------

DEFINE TABLE area SCHEMAFULL;

DEFINE FIELD name              ON area TYPE string;
DEFINE FIELD slug              ON area TYPE string;
DEFINE FIELD boundary          ON area TYPE option<geometry<polygon>>;
DEFINE FIELD center            ON area TYPE option<geometry<point>>;
DEFINE FIELD parent            ON area TYPE option<record<area>>;

DEFINE FIELD created_at        ON area TYPE datetime                 VALUE $value OR time::now();
DEFINE FIELD updated_at        ON area TYPE datetime                 VALUE time::now();

DEFINE INDEX idx_area_slug ON area FIELDS slug UNIQUE;

-- -----------------------------------------------------------------------------
-- 3. establishment_listing (projected from company DBs)
-- -----------------------------------------------------------------------------
-- Denormalized projection of establishment data for discovery queries.
-- MercuryEngine writes here via syncToDiscovery() on establishment CRUD.

DEFINE TABLE establishment_listing SCHEMAFULL;

-- Source reference (company_slug + establishment record ID as strings)
DEFINE FIELD company_slug      ON establishment_listing TYPE string;
DEFINE FIELD source_id         ON establishment_listing TYPE string;

-- Discoverable fields
DEFINE FIELD name              ON establishment_listing TYPE string;
DEFINE FIELD slug              ON establishment_listing TYPE string;
DEFINE FIELD about             ON establishment_listing TYPE option<string>;

-- Address
DEFINE FIELD address           ON establishment_listing TYPE string;
DEFINE FIELD city              ON establishment_listing TYPE string;
DEFINE FIELD zip               ON establishment_listing TYPE string;
DEFINE FIELD country           ON establishment_listing TYPE string  DEFAULT 'NO';

-- Geo (native geometry for spatial queries)
DEFINE FIELD location          ON establishment_listing TYPE option<geometry<point>>;

-- Media
DEFINE FIELD logo              ON establishment_listing TYPE option<string>;
DEFINE FIELD cover             ON establishment_listing TYPE option<string>;

-- Classification
DEFINE FIELD store_type        ON establishment_listing TYPE string  DEFAULT 'store';
DEFINE FIELD category          ON establishment_listing TYPE option<string>;
DEFINE FIELD category_ref      ON establishment_listing TYPE option<record<category>>;

-- Metrics (synced periodically)
DEFINE FIELD aggregate_rating  ON establishment_listing TYPE option<object>;
DEFINE FIELD aggregate_rating.average ON establishment_listing TYPE number;
DEFINE FIELD aggregate_rating.count   ON establishment_listing TYPE int;
DEFINE FIELD favorites_count   ON establishment_listing TYPE int     DEFAULT 0;

-- Status
DEFINE FIELD is_active         ON establishment_listing TYPE bool    DEFAULT true;

-- AI / Search
DEFINE FIELD keywords          ON establishment_listing TYPE array<string> DEFAULT [];
DEFINE FIELD embedding         ON establishment_listing TYPE option<array<float>>;

DEFINE FIELD synced_at         ON establishment_listing TYPE datetime VALUE time::now();
DEFINE FIELD created_at        ON establishment_listing TYPE datetime VALUE $value OR time::now();

-- Indexes
DEFINE INDEX idx_listing_slug ON establishment_listing FIELDS company_slug, slug UNIQUE;
DEFINE INDEX idx_listing_category ON establishment_listing FIELDS category;
DEFINE INDEX idx_listing_city ON establishment_listing FIELDS city;
DEFINE INDEX idx_listing_active ON establishment_listing FIELDS is_active;
-- Geo index for "near me" queries
-- DEFINE INDEX idx_listing_location ON establishment_listing FIELDS location MTREE DIMENSION 2;

-- Full-text search analyzer for DittoBar
DEFINE ANALYZER search_analyzer TOKENIZERS blank, class FILTERS ascii, lowercase, snowball(norwegian);
-- SurrealDB 3.0: FULLTEXT indexes are per-field
DEFINE INDEX idx_listing_name ON establishment_listing COLUMNS name FULLTEXT ANALYZER search_analyzer BM25;
DEFINE INDEX idx_listing_about ON establishment_listing COLUMNS about FULLTEXT ANALYZER search_analyzer BM25;

-- -----------------------------------------------------------------------------
-- 4. discovery graph edges
-- -----------------------------------------------------------------------------

-- establishment_listing → category
DEFINE TABLE categorized_as SCHEMAFULL TYPE RELATION FROM establishment_listing TO category;
DEFINE FIELD created_at        ON categorized_as TYPE datetime       VALUE $value OR time::now();

-- establishment_listing → area
DEFINE TABLE located_in SCHEMAFULL TYPE RELATION FROM establishment_listing TO area;
DEFINE FIELD created_at        ON located_in TYPE datetime           VALUE $value OR time::now();

-- -----------------------------------------------------------------------------
-- 5. search_event (source: SearchEventSchema)
-- -----------------------------------------------------------------------------
-- Demand signal capture. DittoBar intelligence harvester.

DEFINE TABLE search_event SCHEMAFULL;

DEFINE FIELD query             ON search_event TYPE string;
DEFINE FIELD raw_query         ON search_event TYPE string;
DEFINE FIELD result_count      ON search_event TYPE int;

-- Selected result (if user clicked something)
DEFINE FIELD selected_result   ON search_event TYPE option<object>;
DEFINE FIELD selected_result.type ON search_event TYPE string
  ASSERT $value IN ['store', 'category'];
DEFINE FIELD selected_result.id   ON search_event TYPE string;
DEFINE FIELD selected_result.name ON search_event TYPE string;

-- User context
DEFINE FIELD user_id           ON search_event TYPE option<string>;
DEFINE FIELD session_id        ON search_event TYPE string;
DEFINE FIELD source            ON search_event TYPE string
  ASSERT $value IN ['dittobar', 'discover', 'dattobar'];

-- Geo enrichment (Session 4 decision)
DEFINE FIELD user_location     ON search_event TYPE option<geometry<point>>;
DEFINE FIELD filters           ON search_event TYPE option<object>;
DEFINE FIELD nearest_result_distance_m ON search_event TYPE option<number>;

DEFINE FIELD created_at        ON search_event TYPE datetime         VALUE $value OR time::now();

-- Indexes
DEFINE INDEX idx_search_query ON search_event FIELDS query;
DEFINE INDEX idx_search_source ON search_event FIELDS source;
DEFINE INDEX idx_search_created ON search_event FIELDS created_at;

-- =============================================================================
-- END OF DISCOVERY SCHEMA
-- =============================================================================
