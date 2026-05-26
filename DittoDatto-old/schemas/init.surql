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
DEFINE NAMESPACE IF NOT EXISTS titan;
DEFINE NAMESPACE IF NOT EXISTS enceladus;

-- 2. Define databases in titan
USE NS titan;
DEFINE DATABASE IF NOT EXISTS discovery;
DEFINE DATABASE IF NOT EXISTS platform;

-- 3. Define database in enceladus
USE NS enceladus;
DEFINE DATABASE IF NOT EXISTS users;

-- 4. Define namespace-level service accounts for MercuryEngine (Session 9 Q7)
USE NS titan;
DEFINE USER IF NOT EXISTS mercury ON NAMESPACE PASSWORD 'CHANGE_ME_TITAN' ROLES OWNER;

USE NS enceladus;
DEFINE USER IF NOT EXISTS mercury ON NAMESPACE PASSWORD 'CHANGE_ME_ENCELADUS' ROLES OWNER;

-- =============================================================================
-- To apply schemas after init:
--
--   # Discovery
--   surreal sql --ns titan --db discovery < schemas/discovery.surql
--
--   # Platform
--   surreal sql --ns titan --db platform < schemas/platform.surql
--
--   # Users
--   surreal sql --ns enceladus --db users < schemas/users.surql
--
--   # Company (per-company, e.g. Sawasdee)
--   USE NS titan; DEFINE DATABASE IF NOT EXISTS company_sawasdee;
--   surreal sql --ns titan --db company_sawasdee < schemas/company-blueprint.surql
-- =============================================================================
