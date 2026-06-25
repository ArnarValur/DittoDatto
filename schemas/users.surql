-- =============================================================================
-- DittoDatto — Users Database Schema
-- =============================================================================
-- Applied to: users/users
-- Version:    0.1.0
-- Created:    2026-05-03
--
-- GDPR-isolated namespace for consumer PII.
-- Hard boundary: company data (companies) never touches this namespace directly.
-- MercuryEngine mediates all cross-namespace data flows.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. user (source: UserSchema)
-- -----------------------------------------------------------------------------

DEFINE TABLE user SCHEMAFULL
  PERMISSIONS
    FOR select WHERE id = $auth.id
    FOR create, update, delete NONE;

-- Profile
DEFINE FIELD name              ON user TYPE string;
DEFINE FIELD email             ON user TYPE string;
DEFINE FIELD username          ON user TYPE option<string>;
DEFINE FIELD bio               ON user TYPE option<string>;
DEFINE FIELD phone             ON user TYPE option<string>;
DEFINE FIELD photo_url         ON user TYPE option<string>;

-- System Access
DEFINE FIELD role              ON user TYPE string                   DEFAULT 'customer'
  ASSERT $value IN ['customer', 'business', 'admin', 'super_admin'];
DEFINE FIELD is_onboarded      ON user TYPE bool                    DEFAULT false;

-- Auth (ADR-0010 — Session 14/16)
DEFINE FIELD vipps_sub         ON user TYPE option<string>;
DEFINE FIELD password_hash     ON user TYPE option<string>;
DEFINE FIELD company_slug      ON user TYPE option<string>;

-- RBAC & Company Memberships
DEFINE FIELD company_memberships ON user TYPE array<object>          DEFAULT [];
DEFINE FIELD company_memberships.*.company_id ON user TYPE string;
DEFINE FIELD company_memberships.*.role       ON user TYPE string
  ASSERT $value IN ['owner', 'admin', 'employee'];
DEFINE FIELD company_memberships.*.assigned_at ON user TYPE datetime;

-- Shortcut for permission checks
DEFINE FIELD company_membership_ids ON user TYPE array<string>       DEFAULT [];

-- Preferences
DEFINE FIELD language           ON user TYPE string                  DEFAULT 'en'
  ASSERT $value IN ['nb', 'en'];

-- BankID / Vipps verification (GDPR-sensitive — stays in users ONLY)
DEFINE FIELD bankid_verified    ON user TYPE bool                   DEFAULT false;
DEFINE FIELD bankid_verified_at ON user TYPE option<datetime>;
DEFINE FIELD nin_hash           ON user TYPE option<string>;

-- Soft delete (GDPR right to erasure — mark, then cascade purge to company DBs)
DEFINE FIELD deleted_at         ON user TYPE option<datetime>;

-- Timestamps
DEFINE FIELD created_at         ON user TYPE datetime               VALUE $value OR time::now();
DEFINE FIELD updated_at         ON user TYPE datetime               VALUE time::now();

-- Indexes
DEFINE INDEX idx_user_email ON user FIELDS email UNIQUE;
DEFINE INDEX idx_user_username ON user FIELDS username UNIQUE;
DEFINE INDEX idx_user_vipps ON user FIELDS vipps_sub UNIQUE;

-- -----------------------------------------------------------------------------
-- 2. Graph edges from user
-- -----------------------------------------------------------------------------

-- user → establishment_listing (favorited)
-- NOTE: This references discovery DB listings by string ID (cross-DB).
-- The edge lives HERE in users to keep user preferences with user data.

DEFINE TABLE favorited SCHEMAFULL TYPE RELATION FROM user TO user;
-- Using self-relation as placeholder — actual target is cross-DB.
-- In practice, `out` stores a string reference, not a record link.
-- MercuryEngine resolves the cross-DB lookup at query time.

-- Re-define as a regular table since cross-DB record links aren't possible:
REMOVE TABLE favorited;

DEFINE TABLE favorite SCHEMAFULL;
DEFINE FIELD user              ON favorite TYPE record<user>;
DEFINE FIELD target_id         ON favorite TYPE string;
DEFINE FIELD target_type       ON favorite TYPE string               DEFAULT 'store'
  ASSERT $value IN ['store', 'person'];
DEFINE FIELD added_at          ON favorite TYPE datetime             VALUE $value OR time::now();

DEFINE INDEX idx_favorite_user ON favorite FIELDS user;
DEFINE INDEX idx_favorite_unique ON favorite FIELDS user, target_id, target_type UNIQUE;

-- user booking history refs (cross-DB, stored as strings)
DEFINE TABLE booking_ref SCHEMAFULL;
DEFINE FIELD user              ON booking_ref TYPE record<user>;
DEFINE FIELD company_slug      ON booking_ref TYPE string;
DEFINE FIELD booking_id        ON booking_ref TYPE string;
DEFINE FIELD establishment_name ON booking_ref TYPE string;
DEFINE FIELD service_title     ON booking_ref TYPE string;
DEFINE FIELD start_time        ON booking_ref TYPE datetime;
DEFINE FIELD status            ON booking_ref TYPE string;
DEFINE FIELD created_at        ON booking_ref TYPE datetime          VALUE $value OR time::now();

DEFINE INDEX idx_bookingref_user ON booking_ref FIELDS user;
DEFINE INDEX idx_bookingref_time ON booking_ref FIELDS start_time;

-- -----------------------------------------------------------------------------
-- 3. RECORD ACCESS — Business Portal Authentication (ADR-0016)
-- -----------------------------------------------------------------------------
-- Authenticates portal users against their password_hash.
-- The user's login password is validated via argon2 — no database system
-- credentials are involved. The issued token is scoped to the authenticated
-- user's record ($auth).
--
-- Client signin params: { NS: 'users', DB: 'users', AC: 'bp_auth',
--                         email: '...', pass: '...' }
--
-- Security: role gate ensures only business/admin/super_admin users can
-- authenticate. Consumer-role users are rejected at the DB level.
-- WITH REFRESH enables short-lived access tokens (15m) + refresh tokens,
-- so users stay logged in within the session window (8h) without
-- re-entering credentials.

DEFINE ACCESS IF NOT EXISTS bp_auth ON DATABASE TYPE RECORD
  SIGNIN (
    SELECT *
    FROM user
    WHERE email = $email
      AND crypto::argon2::compare(password_hash, $pass)
      AND role IN ['business', 'admin', 'super_admin']
  )
  DURATION FOR TOKEN 15m, FOR SESSION 8h;

-- -----------------------------------------------------------------------------
-- 4. RECORD ACCESS — Consumer Authentication (ADR-0019)
-- -----------------------------------------------------------------------------
-- Authenticates marketplace consumers via email + argon2 password.
-- SIGNUP clause creates new user records with role='customer'.
-- Role gate ensures only customer-role users can authenticate.
--
-- Client signup params: { NS: 'users', DB: 'users', AC: 'consumer_auth',
--                         name: '...', email: '...', pass: '...' }
-- Client signin params: { NS: 'users', DB: 'users', AC: 'consumer_auth',
--                         email: '...', pass: '...' }

DEFINE ACCESS IF NOT EXISTS consumer_auth ON DATABASE TYPE RECORD
  SIGNUP (
    CREATE user SET
      name = $name,
      email = $email,
      password_hash = crypto::argon2::generate($pass),
      role = 'customer',
      is_onboarded = false,
      language = 'en',
      company_memberships = [],
      company_membership_ids = [],
      bankid_verified = false
  )
  SIGNIN (
    -- No role gate — hierarchical RBAC: all roles can use the marketplace.
    -- super_admin > admin > business > customer — higher includes lower.
    -- SIGNUP still enforces role='customer' for new account creation.
    SELECT *
    FROM user
    WHERE email = $email
      AND crypto::argon2::compare(password_hash, $pass)
  )
  DURATION FOR TOKEN 24h, FOR SESSION 24h;

-- =============================================================================
-- END OF USERS SCHEMA
-- =============================================================================
