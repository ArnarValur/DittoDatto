-- =============================================================================
-- DittoDatto — Namespace & Database Initialization
-- =============================================================================
-- Run ONCE as root user to bootstrap the SurrealDB instance.
-- After this, apply individual schema files per database.
--
-- Usage:
--   surreal sql --endpoint http://localhost:8000 --user root --pass <pw> < schemas/init.surql
-- =============================================================================

-- 1. Define namespaces
DEFINE NAMESPACE IF NOT EXISTS companies;
DEFINE NAMESPACE IF NOT EXISTS users;

-- 2. Define databases in companies
USE NS companies;
DEFINE DATABASE IF NOT EXISTS discovery;
DEFINE DATABASE IF NOT EXISTS platform;

-- 3. Define database in users
USE NS users;
DEFINE DATABASE IF NOT EXISTS users;

-- 4. Define namespace-level service accounts for MercuryEngine (Session 9 Q7)
USE NS companies;
DEFINE USER IF NOT EXISTS mercury ON NAMESPACE PASSWORD 'CHANGE_ME_COMPANIES' ROLES OWNER;

USE NS users;
DEFINE USER IF NOT EXISTS mercury ON NAMESPACE PASSWORD 'CHANGE_ME_USERS' ROLES OWNER;

-- =============================================================================
-- To apply schemas after init:
--
--   # Discovery
--   surreal sql --ns companies --db discovery < schemas/discovery.surql
--
--   # Platform
--   surreal sql --ns companies --db platform < schemas/platform.surql
--
--   # Users
--   surreal sql --ns users --db users < schemas/users.surql
--
--   # Company (per-company, e.g. Sawasdee)
--   USE NS companies; DEFINE DATABASE IF NOT EXISTS company_sawasdee;
--   surreal sql --ns companies --db company_sawasdee < schemas/company-blueprint.surql
-- =============================================================================
