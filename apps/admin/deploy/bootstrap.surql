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
DEFINE DATABASE IF NOT EXISTS profiles;

-- ═══════════════════════════════════════════════════
-- 4. Table Schemas — users/profiles
-- ═══════════════════════════════════════════════════

USE NS users DB profiles;

DEFINE TABLE IF NOT EXISTS user SCHEMAFULL;
DEFINE FIELD name        ON TABLE user TYPE string;
DEFINE FIELD email       ON TABLE user TYPE string;
DEFINE FIELD phone       ON TABLE user TYPE option<string>;
DEFINE FIELD password_hash ON TABLE user TYPE option<string>;
DEFINE FIELD role        ON TABLE user TYPE string DEFAULT 'customer';
DEFINE FIELD company_slug ON TABLE user TYPE option<string>;
DEFINE FIELD vipps_sub   ON TABLE user TYPE option<string>;
DEFINE FIELD created_at  ON TABLE user TYPE datetime DEFAULT time::now();
DEFINE FIELD updated_at  ON TABLE user TYPE datetime DEFAULT time::now();

DEFINE INDEX idx_user_email ON TABLE user FIELDS email UNIQUE;

-- ═══════════════════════════════════════════════════
-- 5. Table Schemas — companies/registry
-- ═══════════════════════════════════════════════════

USE NS companies DB registry;

DEFINE TABLE IF NOT EXISTS company SCHEMAFULL;
DEFINE FIELD name               ON TABLE company TYPE string;
DEFINE FIELD slug               ON TABLE company TYPE string;
DEFINE FIELD description        ON TABLE company TYPE option<string>;
DEFINE FIELD email              ON TABLE company TYPE option<string>;
DEFINE FIELD phone              ON TABLE company TYPE option<string>;
DEFINE FIELD address            ON TABLE company TYPE option<string>;
DEFINE FIELD city               ON TABLE company TYPE option<string>;
DEFINE FIELD postal_code        ON TABLE company TYPE option<string>;
DEFINE FIELD country            ON TABLE company TYPE string DEFAULT 'NO';
DEFINE FIELD tier               ON TABLE company TYPE string DEFAULT 'free';
DEFINE FIELD onboarding_status  ON TABLE company TYPE string DEFAULT 'not_started';
DEFINE FIELD owner_email        ON TABLE company TYPE option<string>;
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
