-- =============================================================================
-- DittoDatto — Company Database Blueprint
-- =============================================================================
-- Applied to: companies/company_{slug}
-- Version:    0.1.0
-- Created:    2026-05-03
-- Source:     Zod schemas in packages/shared-types/src/
-- Decisions:  Session 8 (namespace arch) + Session 9 (schema sequencing)
--
-- This file is the template for every company database.
-- MercuryEngine applies it on company onboard via provisioning endpoint.
-- =============================================================================

-- =============================================================================
-- 1. CORE TABLES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1.1 establishment (source: StoreSchema)
-- -----------------------------------------------------------------------------
-- Renamed from "store" per ADR decision. Zod adapter maps establishment ↔ store.
-- companyId DROPPED — implicit via database isolation (companies/company_{slug}).

DEFINE TABLE establishment SCHEMAFULL;

DEFINE FIELD name              ON establishment TYPE string;
DEFINE FIELD slug              ON establishment TYPE string;

-- Address
DEFINE FIELD address           ON establishment TYPE string;
DEFINE FIELD city              ON establishment TYPE string;
DEFINE FIELD zip               ON establishment TYPE string;
DEFINE FIELD country           ON establishment TYPE string          DEFAULT 'NO';

-- Geo — native SurrealDB geometry replaces gmapCoord + geoHash
DEFINE FIELD location          ON establishment TYPE option<geometry<point>>;

-- Contact & Branding
DEFINE FIELD phone             ON establishment TYPE option<string>;
DEFINE FIELD email             ON establishment TYPE option<string>;
DEFINE FIELD website           ON establishment TYPE option<string>;
DEFINE FIELD social_links      ON establishment TYPE option<array<object>>;
DEFINE FIELD social_links[*].platform ON establishment TYPE string;
DEFINE FIELD social_links[*].url      ON establishment TYPE string;

DEFINE FIELD about             ON establishment TYPE option<string>;

-- Media
DEFINE FIELD images            ON establishment TYPE object          DEFAULT {};
DEFINE FIELD images.logo       ON establishment TYPE option<string>;
DEFINE FIELD images.cover      ON establishment TYPE option<string>;
DEFINE FIELD images.gallery    ON establishment TYPE array<string>   DEFAULT [];

DEFINE FIELD cover_layout_mode ON establishment TYPE string          DEFAULT 'bento'
  ASSERT $value IN ['showcase', 'spotlight', 'bento'];

-- Schedule (embedded — always fetched with establishment)
DEFINE FIELD opening_schedule  ON establishment TYPE option<object> DEFAULT {};
DEFINE FIELD opening_schedule.* ON establishment TYPE object;
DEFINE FIELD opening_schedule.*.is_open ON establishment TYPE bool;
DEFINE FIELD opening_schedule.*.open    ON establishment TYPE string;
DEFINE FIELD opening_schedule.*.close   ON establishment TYPE string;

DEFINE FIELD timezone          ON establishment TYPE string          DEFAULT 'Europe/Oslo';

-- Booking Policy (embedded 1:1)
DEFINE FIELD booking_policy    ON establishment TYPE option<object>;
DEFINE FIELD booking_policy.max_bookable_future_days   ON establishment TYPE int     DEFAULT 60;
DEFINE FIELD booking_policy.min_booking_notice_minutes  ON establishment TYPE int     DEFAULT 60;
DEFINE FIELD booking_policy.slot_interval               ON establishment TYPE int     DEFAULT 15;
DEFINE FIELD booking_policy.client_cancel_enabled       ON establishment TYPE bool    DEFAULT true;
DEFINE FIELD booking_policy.min_cancel_notice_hours     ON establishment TYPE int     DEFAULT 24;
DEFINE FIELD booking_policy.client_reschedule_enabled   ON establishment TYPE bool    DEFAULT true;
DEFINE FIELD booking_policy.min_reschedule_notice_hours ON establishment TYPE int     DEFAULT 24;
DEFINE FIELD booking_policy.booking_confirmation_message ON establishment TYPE option<string>;
DEFINE FIELD booking_policy.no_show_fee_percent         ON establishment TYPE int     DEFAULT 0;

-- Classification
DEFINE FIELD establishment_type ON establishment TYPE string          DEFAULT 'shop'
  ASSERT $value IN ['shop', 'restaurant', 'venue'];
DEFINE FIELD category          ON establishment TYPE option<string>;

-- Feature flags
DEFINE FIELD resources_enabled ON establishment TYPE bool            DEFAULT false;


-- Reservation config (embedded, optional)
DEFINE FIELD reservation_config ON establishment TYPE option<object>;
DEFINE FIELD reservation_config.max_guests             ON establishment TYPE int     DEFAULT 8;
DEFINE FIELD reservation_config.large_party_handling   ON establishment TYPE string  DEFAULT 'notify'
  ASSERT $value IN ['notify', 'email', 'call', 'form', 'disabled'];
DEFINE FIELD reservation_config.large_party_contact    ON establishment TYPE option<string>;
DEFINE FIELD reservation_config.default_duration       ON establishment TYPE int     DEFAULT 90;
DEFINE FIELD reservation_config.slot_interval          ON establishment TYPE int     DEFAULT 30;
DEFINE FIELD reservation_config.buffer_between_slots   ON establishment TYPE int     DEFAULT 0;
DEFINE FIELD reservation_config.capacity_mode          ON establishment TYPE string  DEFAULT 'pool'
  ASSERT $value IN ['pool', 'tables', 'hybrid'];
DEFINE FIELD reservation_config.total_capacity         ON establishment TYPE option<int>;
DEFINE FIELD reservation_config.auto_confirm           ON establishment TYPE bool    DEFAULT true;

-- Status & Metrics
DEFINE FIELD is_published      ON establishment TYPE bool            DEFAULT false;
DEFINE FIELD is_active         ON establishment TYPE bool            DEFAULT true;
DEFINE FIELD aggregate_rating  ON establishment TYPE option<object>;
DEFINE FIELD aggregate_rating.average ON establishment TYPE number;
DEFINE FIELD aggregate_rating.count   ON establishment TYPE int;
DEFINE FIELD favorites_count   ON establishment TYPE int             DEFAULT 0;

-- Soft delete (GDPR pattern from Session 9)
DEFINE FIELD deleted_at        ON establishment TYPE option<datetime>;

-- Timestamps
DEFINE FIELD created_at        ON establishment TYPE datetime        VALUE $value OR time::now();
DEFINE FIELD updated_at        ON establishment TYPE datetime        VALUE time::now();

-- Indexes
DEFINE INDEX idx_establishment_slug ON establishment FIELDS slug UNIQUE;
DEFINE INDEX idx_establishment_active ON establishment FIELDS is_active, is_published;

-- -----------------------------------------------------------------------------
-- 1.2 media (company media library)
-- -----------------------------------------------------------------------------
-- Metadata for media assets. Actual bytes stored in Firebase Storage (PoC)
-- or a future European-sovereign object store. URL points to the storage backend.

DEFINE TABLE media SCHEMAFULL;

DEFINE FIELD establishment  ON media TYPE option<record<establishment>>;
DEFINE FIELD uploader_id    ON media TYPE string;
DEFINE FIELD category       ON media TYPE string              DEFAULT 'general'
  ASSERT $value IN ['general', 'logo', 'cover', 'gallery', 'staff', 'service', 'menu'];

-- Storage
DEFINE FIELD url            ON media TYPE string;        -- Download URL from storage backend
DEFINE FIELD storage_path   ON media TYPE string;        -- Full backend path (for deletion)
DEFINE FIELD filename       ON media TYPE string;
DEFINE FIELD mime_type      ON media TYPE string
  ASSERT $value IN ['image/jpeg', 'image/png', 'image/webp', 'image/svg+xml'];
DEFINE FIELD size           ON media TYPE int;

-- Categorization
DEFINE FIELD tags           ON media TYPE array<string>  DEFAULT [];
DEFINE FIELD name           ON media TYPE option<string>;

-- Timestamps
DEFINE FIELD created_at     ON media TYPE datetime       VALUE $value OR time::now();
DEFINE FIELD updated_at     ON media TYPE datetime       VALUE time::now();

-- Indexes
DEFINE INDEX idx_media_establishment ON media FIELDS establishment;
DEFINE INDEX idx_media_category      ON media FIELDS category;

-- -----------------------------------------------------------------------------
-- 1.3 service (source: ServiceSchema)
-- -----------------------------------------------------------------------------

DEFINE TABLE service SCHEMAFULL;

-- Record link to parent (ownership, single-hop)
DEFINE FIELD establishment     ON service TYPE record<establishment>;
DEFINE FIELD group             ON service TYPE option<record<service_group>>;

-- Staff assignment (many-to-many via array of record links)
DEFINE FIELD assigned_staff    ON service TYPE array<record<staff>>  DEFAULT [];

-- Resource requirements
DEFINE FIELD required_resource_groups ON service TYPE array<record<resource_group>> DEFAULT [];

DEFINE FIELD title             ON service TYPE string;
DEFINE FIELD description       ON service TYPE option<string>;

-- Booking mode (per-service, per ADR-0004)
DEFINE FIELD booking_mode      ON service TYPE string                DEFAULT 'standard'
  ASSERT $value IN ['standard', 'tableReservation', 'ticketSystem'];

-- Media
DEFINE FIELD cover_image       ON service TYPE option<string>;
DEFINE FIELD gallery           ON service TYPE option<array<string>>;

-- Taxonomy
DEFINE FIELD service_type      ON service TYPE array<string>         DEFAULT [];
DEFINE FIELD subcategory       ON service TYPE option<string>;

-- AI / Discovery
DEFINE FIELD keywords          ON service TYPE array<string>         DEFAULT [];
DEFINE FIELD ai_description    ON service TYPE option<string>;
DEFINE FIELD embedding         ON service TYPE option<array<float>>;

-- Time & Pricing
DEFINE FIELD duration          ON service TYPE int;
DEFINE FIELD price             ON service TYPE number;
DEFINE FIELD buffer_time       ON service TYPE int                   DEFAULT 0;
DEFINE FIELD currency          ON service TYPE string                DEFAULT 'NOK'
  ASSERT $value IN ['NOK', 'SEK', 'DKK', 'EUR', 'ISK'];

-- Policies
DEFINE FIELD over_capacity_policy       ON service TYPE string       DEFAULT 'reject'
  ASSERT $value IN ['reject', 'request', 'allow'];
DEFINE FIELD min_booking_notice_minutes ON service TYPE int          DEFAULT 0;
DEFINE FIELD slot_interval              ON service TYPE int          DEFAULT 15;

DEFINE FIELD is_active         ON service TYPE bool                  DEFAULT true;
DEFINE FIELD deleted_at        ON service TYPE option<datetime>;
DEFINE FIELD created_at        ON service TYPE datetime              VALUE $value OR time::now();
DEFINE FIELD updated_at        ON service TYPE datetime              VALUE time::now();

-- Indexes
DEFINE INDEX idx_service_establishment ON service FIELDS establishment;
DEFINE INDEX idx_service_active ON service FIELDS is_active;
-- Vector index for AI search (when embeddings are populated)
-- DEFINE INDEX idx_service_embedding ON service FIELDS embedding HNSW DIMENSION 768 DIST COSINE TYPE F32;

-- -----------------------------------------------------------------------------
-- 1.3 service_group (source: ServiceGroupSchema)
-- -----------------------------------------------------------------------------

DEFINE TABLE service_group SCHEMAFULL;

DEFINE FIELD establishment     ON service_group TYPE record<establishment>;
DEFINE FIELD name              ON service_group TYPE string;
DEFINE FIELD description       ON service_group TYPE option<string>;
DEFINE FIELD staff_ids         ON service_group TYPE option<array<record<staff>>>;
DEFINE FIELD sort_order        ON service_group TYPE int             DEFAULT 0;
DEFINE FIELD show_on_booking_panel ON service_group TYPE bool        DEFAULT true;
DEFINE FIELD multi_select      ON service_group TYPE bool            DEFAULT false;

DEFINE FIELD deleted_at        ON service_group TYPE option<datetime>;
DEFINE FIELD created_at        ON service_group TYPE datetime        VALUE $value OR time::now();
DEFINE FIELD updated_at        ON service_group TYPE datetime        VALUE time::now();

DEFINE INDEX idx_sg_establishment ON service_group FIELDS establishment;

-- -----------------------------------------------------------------------------
-- 1.4 staff (source: StaffMemberSchema)
-- -----------------------------------------------------------------------------

DEFINE TABLE staff SCHEMAFULL;

-- Auth link — cross-DB reference stored as string (users/users)
DEFINE FIELD user_id           ON staff TYPE option<string>;
DEFINE FIELD email             ON staff TYPE string;
DEFINE FIELD display_name      ON staff TYPE string;
DEFINE FIELD avatar_url        ON staff TYPE option<string>;

-- Multi-store assignment
DEFINE FIELD store_ids         ON staff TYPE array<record<establishment>> DEFAULT [];
DEFINE FIELD position          ON staff TYPE option<string>;

-- Capabilities
DEFINE FIELD default_capabilities ON staff TYPE array<string>        DEFAULT [];
DEFINE FIELD store_capabilities   ON staff TYPE object FLEXIBLE      DEFAULT {};

-- Bookability
DEFINE FIELD is_bookable       ON staff TYPE bool                    DEFAULT false;
DEFINE FIELD show_on_storefront ON staff TYPE bool                   DEFAULT false;

-- Weekly shifts (embedded object with mon-sun keys)
DEFINE FIELD weekly_shifts     ON staff TYPE option<object>;
DEFINE FIELD weekly_shifts.*   ON staff TYPE object;
DEFINE FIELD weekly_shifts.*.is_working ON staff TYPE bool;
DEFINE FIELD weekly_shifts.*.blocks     ON staff TYPE array<object>  DEFAULT [];
DEFINE FIELD weekly_shifts.*.blocks.*.start ON staff TYPE string;
DEFINE FIELD weekly_shifts.*.blocks.*.end   ON staff TYPE string;
DEFINE FIELD weekly_shifts.*.blocks.*.label ON staff TYPE option<string>;

-- Lifecycle
DEFINE FIELD status            ON staff TYPE string                  DEFAULT 'invited'
  ASSERT $value IN ['invited', 'active', 'suspended', 'removed'];
DEFINE FIELD invited_at        ON staff TYPE option<datetime>;
DEFINE FIELD joined_at         ON staff TYPE option<datetime>;

DEFINE FIELD deleted_at        ON staff TYPE option<datetime>;
DEFINE FIELD created_at        ON staff TYPE datetime                VALUE $value OR time::now();
DEFINE FIELD updated_at        ON staff TYPE datetime                VALUE time::now();

-- Indexes
DEFINE INDEX idx_staff_email ON staff FIELDS email;
DEFINE INDEX idx_staff_user_id ON staff FIELDS user_id;
DEFINE INDEX idx_staff_bookable ON staff FIELDS is_bookable;

-- -----------------------------------------------------------------------------
-- 1.5 customer (source: CustomerSchema)
-- -----------------------------------------------------------------------------
-- Cross-DB projection from users/users. Synced fields only.
-- Direction: users → company_X. Never reverse. (Session 9 contract)

DEFINE TABLE customer SCHEMAFULL;

-- Cross-DB reference (string, not record link — different namespace)
DEFINE FIELD user_id           ON customer TYPE option<string>;
DEFINE FIELD store_ids         ON customer TYPE array<record<establishment>> DEFAULT [];

-- Profile
DEFINE FIELD name              ON customer TYPE string;
DEFINE FIELD first_name        ON customer TYPE option<string>;
DEFINE FIELD last_name         ON customer TYPE option<string>;
DEFINE FIELD email             ON customer TYPE option<string>;
DEFINE FIELD phone             ON customer TYPE option<string>;
DEFINE FIELD phone_country_code ON customer TYPE option<string>;

-- CRM
DEFINE FIELD notes             ON customer TYPE option<string>;
DEFINE FIELD status            ON customer TYPE string               DEFAULT 'new'
  ASSERT $value IN ['new', 'active', 'inactive'];
DEFINE FIELD staff_ids         ON customer TYPE array<record<staff>> DEFAULT [];
DEFINE FIELD channel           ON customer TYPE string               DEFAULT 'app'
  ASSERT $value IN ['app', 'web', 'portal', 'import'];

-- Booking refs
DEFINE FIELD last_booking      ON customer TYPE option<record<booking>>;

-- Metrics
DEFINE FIELD total_visits      ON customer TYPE int                  DEFAULT 0;
DEFINE FIELD total_spent       ON customer TYPE number               DEFAULT 0;
DEFINE FIELD first_visit_at    ON customer TYPE option<datetime>;
DEFINE FIELD last_visit_at     ON customer TYPE option<datetime>;

DEFINE FIELD deleted_at        ON customer TYPE option<datetime>;
DEFINE FIELD created_at        ON customer TYPE datetime             VALUE $value OR time::now();
DEFINE FIELD updated_at        ON customer TYPE datetime             VALUE time::now();

DEFINE INDEX idx_customer_user_id ON customer FIELDS user_id;
DEFINE INDEX idx_customer_email ON customer FIELDS email;

-- =============================================================================
-- 2. BOOKING TABLES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 2.1 booking (source: BookingSchema)
-- -----------------------------------------------------------------------------

DEFINE TABLE booking SCHEMAFULL;

-- Relationships (record links for ownership)
DEFINE FIELD user_id           ON booking TYPE string;
DEFINE FIELD establishment     ON booking TYPE record<establishment>;
DEFINE FIELD service           ON booking TYPE record<service>;
DEFINE FIELD staff             ON booking TYPE option<record<staff>>;
DEFINE FIELD resource          ON booking TYPE option<record<resource>>;
DEFINE FIELD addon_resources   ON booking TYPE array<record<resource>> DEFAULT [];

-- Status & Time
DEFINE FIELD status            ON booking TYPE string
  ASSERT $value IN ['confirmed', 'completed', 'cancelled', 'no-show', 'pending'];
DEFINE FIELD start_time        ON booking TYPE datetime;
DEFINE FIELD end_time          ON booking TYPE datetime;

-- Fiscal snapshot (immutable at booking time — Norwegian law)
DEFINE FIELD service_title     ON booking TYPE string;
DEFINE FIELD duration          ON booking TYPE int;
DEFINE FIELD price_at_booking  ON booking TYPE number;
DEFINE FIELD currency          ON booking TYPE string                DEFAULT 'NOK'
  ASSERT $value IN ['NOK', 'SEK', 'DKK', 'EUR', 'ISK'];

-- User snapshot (in case user deletes account — Norwegian law)
DEFINE FIELD user_name         ON booking TYPE string;
DEFINE FIELD user_email        ON booking TYPE string;
DEFINE FIELD user_phone        ON booking TYPE option<string>;

-- Multi-service items (embedded array)
DEFINE FIELD items             ON booking TYPE array<object>         DEFAULT [];
DEFINE FIELD items.*.service   ON booking TYPE record<service>;
DEFINE FIELD items.*.title     ON booking TYPE string;
DEFINE FIELD items.*.price     ON booking TYPE number;
DEFINE FIELD items.*.duration  ON booking TYPE int;
DEFINE FIELD items.*.staff     ON booking TYPE option<record<staff>>;

-- Metadata
DEFINE FIELD channel           ON booking TYPE string                DEFAULT 'app'
  ASSERT $value IN ['app', 'web', 'voice_agent', 'portal', 'phone'];
DEFINE FIELD attendee_count    ON booking TYPE int                   DEFAULT 1;
DEFINE FIELD notes             ON booking TYPE option<string>;
DEFINE FIELD cancellation_reason ON booking TYPE option<string>;
DEFINE FIELD payment_id        ON booking TYPE option<string>;

DEFINE FIELD deleted_at        ON booking TYPE option<datetime>;
DEFINE FIELD created_at        ON booking TYPE datetime              VALUE $value OR time::now();
DEFINE FIELD updated_at        ON booking TYPE option<datetime>;

-- Indexes
DEFINE INDEX idx_booking_user ON booking FIELDS user_id;
DEFINE INDEX idx_booking_establishment ON booking FIELDS establishment;
DEFINE INDEX idx_booking_status ON booking FIELDS status;
DEFINE INDEX idx_booking_time ON booking FIELDS start_time, end_time;

-- -----------------------------------------------------------------------------
-- 2.2 hold (source: HoldSchema)
-- -----------------------------------------------------------------------------
-- Transient slot locks. TTL-managed by MercuryEngine.

DEFINE TABLE hold SCHEMAFULL;

DEFINE FIELD user_id           ON hold TYPE string;
DEFINE FIELD establishment     ON hold TYPE record<establishment>;
DEFINE FIELD services          ON hold TYPE array<record<service>>;
DEFINE FIELD staff             ON hold TYPE option<record<staff>>;
DEFINE FIELD resource          ON hold TYPE option<record<resource>>;

DEFINE FIELD date              ON hold TYPE string;
DEFINE FIELD slot_time         ON hold TYPE string;
DEFINE FIELD duration          ON hold TYPE int;

DEFINE FIELD expires_at        ON hold TYPE datetime;
DEFINE FIELD created_at        ON hold TYPE datetime                VALUE $value OR time::now();

DEFINE FIELD payment_status    ON hold TYPE option<string>
  ASSERT $value IN ['pending', 'initiated', 'failed'] OR $value IS NONE;
DEFINE FIELD vipps_order_id    ON hold TYPE option<string>;

DEFINE INDEX idx_hold_expires ON hold FIELDS expires_at;
DEFINE INDEX idx_hold_establishment_date ON hold FIELDS establishment, date;

-- =============================================================================
-- 3. SCHEDULE TABLES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 3.1 date_override (source: DateOverrideSchema, extracted from staff)
-- -----------------------------------------------------------------------------
-- Separate table for scalability (staff accumulate overrides over years).

DEFINE TABLE date_override SCHEMAFULL;

DEFINE FIELD staff             ON date_override TYPE record<staff>;
DEFINE FIELD date              ON date_override TYPE string;
DEFINE FIELD type              ON date_override TYPE string
  ASSERT $value IN ['off', 'sick', 'custom'];
DEFINE FIELD reason            ON date_override TYPE option<string>;
DEFINE FIELD blocks            ON date_override TYPE option<array<object>>;
DEFINE FIELD blocks.*.start    ON date_override TYPE string;
DEFINE FIELD blocks.*.end      ON date_override TYPE string;

DEFINE FIELD created_at        ON date_override TYPE datetime        VALUE $value OR time::now();

DEFINE INDEX idx_override_staff_date ON date_override FIELDS staff, date UNIQUE;

-- =============================================================================
-- 4. RESOURCE TABLES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 4.1 resource_group (source: ResourceGroupSchema)
-- -----------------------------------------------------------------------------

DEFINE TABLE resource_group SCHEMAFULL;

DEFINE FIELD establishment     ON resource_group TYPE record<establishment>;
DEFINE FIELD name              ON resource_group TYPE string;
DEFINE FIELD description       ON resource_group TYPE option<string>;
DEFINE FIELD sort_order        ON resource_group TYPE int            DEFAULT 0;
DEFINE FIELD show_on_storefront ON resource_group TYPE bool          DEFAULT false;

DEFINE FIELD created_at        ON resource_group TYPE datetime       VALUE $value OR time::now();
DEFINE FIELD updated_at        ON resource_group TYPE datetime       VALUE time::now();

-- -----------------------------------------------------------------------------
-- 4.2 resource (source: ResourceSchema)
-- -----------------------------------------------------------------------------

DEFINE TABLE resource SCHEMAFULL;

DEFINE FIELD establishment     ON resource TYPE record<establishment>;
DEFINE FIELD resource_group    ON resource TYPE option<record<resource_group>>;

DEFINE FIELD name              ON resource TYPE string;
DEFINE FIELD description       ON resource TYPE option<string>;
DEFINE FIELD type              ON resource TYPE string
  ASSERT $value IN ['room', 'table', 'station', 'equipment', 'addon'];

-- Capacity (table reservation mode)
DEFINE FIELD min_capacity      ON resource TYPE int                  DEFAULT 1;
DEFINE FIELD max_capacity      ON resource TYPE int                  DEFAULT 1;

-- Pricing (add-on resources)
DEFINE FIELD price             ON resource TYPE option<number>;
DEFINE FIELD currency          ON resource TYPE string               DEFAULT 'NOK';

DEFINE FIELD image_url         ON resource TYPE option<string>;

-- Booking behavior
DEFINE FIELD is_bookable       ON resource TYPE bool                 DEFAULT true;
DEFINE FIELD allow_overlapping ON resource TYPE bool                 DEFAULT false;
DEFINE FIELD booking_interval  ON resource TYPE option<int>;
DEFINE FIELD priority          ON resource TYPE string               DEFAULT 'normal'
  ASSERT $value IN ['low', 'normal', 'high'];
DEFINE FIELD sort_order        ON resource TYPE int                  DEFAULT 0;

DEFINE FIELD created_at        ON resource TYPE datetime             VALUE $value OR time::now();
DEFINE FIELD updated_at        ON resource TYPE datetime             VALUE time::now();

DEFINE INDEX idx_resource_establishment ON resource FIELDS establishment;

-- =============================================================================
-- 5. GRAPH EDGES (Session 9 Q1 — traversable, carry metadata)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 5.1 offers — establishment → service
-- -----------------------------------------------------------------------------
DEFINE TABLE offers SCHEMAFULL TYPE RELATION FROM establishment TO service;
DEFINE FIELD sort_order        ON offers TYPE int                    DEFAULT 0;
DEFINE FIELD featured          ON offers TYPE bool                   DEFAULT false;
DEFINE FIELD created_at        ON offers TYPE datetime               VALUE $value OR time::now();

-- -----------------------------------------------------------------------------
-- 5.2 works_at — staff → establishment
-- -----------------------------------------------------------------------------
DEFINE TABLE works_at SCHEMAFULL TYPE RELATION FROM staff TO establishment;
DEFINE FIELD role              ON works_at TYPE string               DEFAULT 'employee'
  ASSERT $value IN ['owner', 'admin', 'employee'];
DEFINE FIELD since             ON works_at TYPE option<datetime>;
DEFINE FIELD created_at        ON works_at TYPE datetime             VALUE $value OR time::now();

-- -----------------------------------------------------------------------------
-- 5.3 assigned_to — booking → staff
-- -----------------------------------------------------------------------------
DEFINE TABLE assigned_to SCHEMAFULL TYPE RELATION FROM booking TO staff;
DEFINE FIELD confirmed         ON assigned_to TYPE bool              DEFAULT false;
DEFINE FIELD notified_at       ON assigned_to TYPE option<datetime>;
DEFINE FIELD created_at        ON assigned_to TYPE datetime          VALUE $value OR time::now();

-- =============================================================================
-- 6. COMMS (v1.4 — define schema now, populate later)
-- =============================================================================

DEFINE TABLE message_thread SCHEMAFULL;
DEFINE FIELD establishment     ON message_thread TYPE record<establishment>;
DEFINE FIELD customer          ON message_thread TYPE record<customer>;
DEFINE FIELD subject           ON message_thread TYPE option<string>;
DEFINE FIELD status            ON message_thread TYPE string         DEFAULT 'open'
  ASSERT $value IN ['open', 'closed', 'archived'];
DEFINE FIELD created_at        ON message_thread TYPE datetime       VALUE $value OR time::now();
DEFINE FIELD updated_at        ON message_thread TYPE datetime       VALUE time::now();

DEFINE TABLE message SCHEMAFULL;
DEFINE FIELD thread            ON message TYPE record<message_thread>;
DEFINE FIELD sender_type       ON message TYPE string
  ASSERT $value IN ['customer', 'staff', 'datto'];
DEFINE FIELD sender_id         ON message TYPE string;
DEFINE FIELD body              ON message TYPE string;
DEFINE FIELD created_at        ON message TYPE datetime              VALUE $value OR time::now();

-- =============================================================================
-- 7. AGENT MEMORY (Spectron-compatible manual graph)
-- =============================================================================

DEFINE TABLE entity SCHEMAFULL;
DEFINE FIELD name              ON entity TYPE string;
DEFINE FIELD entity_type       ON entity TYPE string;
DEFINE FIELD properties        ON entity TYPE object FLEXIBLE        DEFAULT {};
DEFINE FIELD embedding         ON entity TYPE option<array<float>>;
DEFINE FIELD created_at        ON entity TYPE datetime               VALUE $value OR time::now();
DEFINE FIELD updated_at        ON entity TYPE datetime               VALUE time::now();

DEFINE TABLE fact SCHEMAFULL;
DEFINE FIELD content           ON fact TYPE string;
DEFINE FIELD source            ON fact TYPE option<string>;
DEFINE FIELD confidence        ON fact TYPE number                   DEFAULT 1.0;
DEFINE FIELD valid_from        ON fact TYPE option<datetime>;
DEFINE FIELD valid_until       ON fact TYPE option<datetime>;
DEFINE FIELD created_at        ON fact TYPE datetime                 VALUE $value OR time::now();

DEFINE TABLE relates_to SCHEMAFULL TYPE RELATION FROM entity TO entity;
DEFINE FIELD relation_type     ON relates_to TYPE string;
DEFINE FIELD weight            ON relates_to TYPE number             DEFAULT 1.0;
DEFINE FIELD created_at        ON relates_to TYPE datetime           VALUE $value OR time::now();

-- =============================================================================
-- 8. MARKETPLACE ESTABLISHMENT DETAIL (ADR-0025 — Two-Phase Detail Load)
-- =============================================================================
-- Server-side query bundle for the Public Marketplace.
-- Primary: Marketplace connects via WS, calls fn::get_establishment_detail() directly.
-- Bonus:   HTTP API at GET /api/companies/company_{slug}/establishment.
-- Auth:    Namespace-level VIEWER user (marketplace_reader) — no per-DB users.

-- ── Function: bundled read query ──────────────────────────────────────────────

DEFINE FUNCTION fn::get_establishment_detail() {
    LET $est = SELECT * FROM establishment
        WHERE is_published = true
        LIMIT 1
    ;
    LET $svc = SELECT * FROM service
        WHERE is_active = true AND deleted_at IS NONE
        ORDER BY title
    ;
    LET $grp = SELECT * FROM service_group
        WHERE deleted_at IS NONE
        ORDER BY sort_order
    ;
    RETURN {
        establishment: $est[0],
        services: $svc,
        service_groups: $grp
    }
};

-- ── HTTP API endpoint ─────────────────────────────────────────────────────────

DEFINE API "/establishment" FOR get THEN {
    RETURN {
        status: 200,
        body: fn::get_establishment_detail()
    }
};

-- =============================================================================
-- END OF COMPANY BLUEPRINT
-- =============================================================================
