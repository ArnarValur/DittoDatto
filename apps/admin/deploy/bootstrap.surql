-- DittoDatto — SurrealDB Bootstrap
-- Run as root user against SurrealDB on Saturn.
--
-- Creates namespaces, databases, tables, and namespace users.
-- Idempotent: safe to re-run (DEFINE uses OVERWRITE implicitly in v3).

-- ═══════════════════════════════════════════════════
-- 1. Namespaces
-- ═══════════════════════════════════════════════════

DEFINE NAMESPACE IF NOT EXISTS companies;
DEFINE NAMESPACE IF NOT EXISTS users;

-- ═══════════════════════════════════════════════════
-- 2. Namespace Users (admin panel auth)
-- ═══════════════════════════════════════════════════
-- Credentials used by the Flutter admin panel.
-- ROLES OWNER grants full access to all databases in the namespace.

USE NS companies;
DEFINE USER arnarvalur ON NAMESPACE PASSWORD 'admin123' ROLES OWNER;
DEFINE USER gurkudrengur ON NAMESPACE PASSWORD 'admin123' ROLES OWNER;

USE NS users;
DEFINE USER arnarvalur ON NAMESPACE PASSWORD 'admin123' ROLES OWNER;
DEFINE USER gurkudrengur ON NAMESPACE PASSWORD 'admin123' ROLES OWNER;

-- ═══════════════════════════════════════════════════
-- 3. Databases
-- ═══════════════════════════════════════════════════

USE NS companies;
DEFINE DATABASE IF NOT EXISTS registry;
DEFINE DATABASE IF NOT EXISTS discovery;

USE NS users;
DEFINE DATABASE IF NOT EXISTS users;

-- ═══════════════════════════════════════════════════
-- 4. Table Schemas — users/users
-- ═══════════════════════════════════════════════════
-- Aligned with production schema: schemas/users.surql

USE NS users DB users;

DEFINE TABLE IF NOT EXISTS user SCHEMAFULL
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

-- Auth (ADR-0016 — RECORD ACCESS)
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

-- Soft delete (GDPR right to erasure)
DEFINE FIELD deleted_at         ON user TYPE option<datetime>;

-- Timestamps
DEFINE FIELD created_at         ON user TYPE datetime               VALUE $value OR time::now();
DEFINE FIELD updated_at         ON user TYPE datetime               VALUE time::now();

-- Indexes
DEFINE INDEX idx_user_email ON user FIELDS email UNIQUE;
DEFINE INDEX idx_user_username ON user FIELDS username UNIQUE;
DEFINE INDEX idx_user_vipps ON user FIELDS vipps_sub UNIQUE;

-- RECORD ACCESS — Business Portal Authentication (ADR-0016)
-- Authenticates portal users against their password_hash.
-- The user's login password is validated via argon2 — no database system
-- credentials are involved.
DEFINE ACCESS IF NOT EXISTS bp_auth ON DATABASE TYPE RECORD
  SIGNIN (
    SELECT *
    FROM user
    WHERE email = $email
      AND crypto::argon2::compare(password_hash, $pass)
  )
  DURATION FOR TOKEN 24h, FOR SESSION 7d;

-- ═══════════════════════════════════════════════════
-- 5. Table Schemas — companies/registry
-- ═══════════════════════════════════════════════════

USE NS companies DB registry;

DEFINE TABLE IF NOT EXISTS company SCHEMAFULL;
DEFINE FIELD name               ON TABLE company TYPE string;
DEFINE FIELD slug               ON TABLE company TYPE string;
DEFINE FIELD db_slug            ON TABLE company TYPE string;
DEFINE FIELD owner_id           ON TABLE company TYPE string;
DEFINE FIELD owner_email        ON TABLE company TYPE option<string>;
DEFINE FIELD description        ON TABLE company TYPE option<string>;
DEFINE FIELD email              ON TABLE company TYPE option<string>;
DEFINE FIELD phone              ON TABLE company TYPE option<string>;
DEFINE FIELD address            ON TABLE company TYPE option<string>;
DEFINE FIELD city               ON TABLE company TYPE option<string>;
DEFINE FIELD postal_code        ON TABLE company TYPE option<string>;
DEFINE FIELD zip                ON TABLE company TYPE option<string>;
DEFINE FIELD country            ON TABLE company TYPE string DEFAULT 'NO';
DEFINE FIELD tier               ON TABLE company TYPE string DEFAULT 'free';
DEFINE FIELD onboarding_status  ON TABLE company TYPE string DEFAULT 'not_started';
DEFINE FIELD social_links       ON TABLE company TYPE option<object>;
DEFINE FIELD store_policy       ON TABLE company TYPE option<object>;
DEFINE FIELD enabled_features   ON TABLE company TYPE option<object>;
DEFINE FIELD created_at         ON TABLE company TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at         ON TABLE company TYPE datetime DEFAULT time::now();

DEFINE INDEX idx_company_slug ON TABLE company FIELDS slug UNIQUE;

-- ═══════════════════════════════════════════════════
-- 6. Table Schemas — companies/discovery
-- ═══════════════════════════════════════════════════

USE NS companies DB discovery;

DEFINE TABLE IF NOT EXISTS category SCHEMAFULL;
DEFINE FIELD name        ON TABLE category TYPE string;
DEFINE FIELD slug        ON TABLE category TYPE string;
DEFINE FIELD description ON TABLE category TYPE option<string>;
DEFINE FIELD icon        ON TABLE category TYPE option<string>;
DEFINE FIELD count       ON TABLE category TYPE int DEFAULT 0;
DEFINE FIELD created_at  ON TABLE category TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at  ON TABLE category TYPE datetime DEFAULT time::now();

DEFINE INDEX idx_category_slug ON TABLE category FIELDS slug UNIQUE;
