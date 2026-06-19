#!/usr/bin/env bash
# =============================================================================
# test-db-seed.sh — Bootstrap the test SurrealDB with real schemas + test auth
# =============================================================================
# Applies the production schemas and creates:
# - RECORD ACCESS (bp_auth) on users/users for portal login
# - DB-level service user (bp_portal) on each company DB
# - Test user records with password_hash (argon2)
#
# Requires: surreal CLI, test SurrealDB running on localhost:18000.
# =============================================================================
set -euo pipefail

DB_URL="${SURREAL_TEST_URL:-http://localhost:18000}"
DB_USER="${SURREAL_TEST_ROOT_USER:-root}"
DB_PASS="${SURREAL_TEST_ROOT_PASS:-root}"
SCHEMAS_DIR="$(cd "$(dirname "$0")/../schemas" && pwd)"

# Service credentials for BP company DB access (matches dart-define in tests).
BP_PORTAL_USER="${BP_PORTAL_USER:-bp_portal}"
BP_PORTAL_PASS="${BP_PORTAL_PASS:-test-portal-pass}"

echo "🔌 Waiting for SurrealDB at $DB_URL..."
for i in $(seq 1 30); do
  if curl -sf "$DB_URL/health" > /dev/null 2>&1; then
    echo "✅ SurrealDB is up."
    break
  fi
  if [ "$i" -eq 30 ]; then
    echo "❌ SurrealDB not reachable after 30s. Abort."
    exit 1
  fi
  sleep 1
done

SURREAL_CMD="surreal sql --endpoint $DB_URL --user $DB_USER --pass $DB_PASS --hide-welcome --multi"

echo "📦 Applying init.surql (namespaces + databases)..."
$SURREAL_CMD < "$SCHEMAS_DIR/init.surql"

echo "📦 Applying users.surql (includes DEFINE ACCESS bp_auth)..."
$SURREAL_CMD --ns users --db users < "$SCHEMAS_DIR/users.surql"

echo "📦 Applying platform.surql..."
$SURREAL_CMD --ns companies --db platform < "$SCHEMAS_DIR/platform.surql"

echo "📦 Applying discovery.surql..."
$SURREAL_CMD --ns companies --db discovery < "$SCHEMAS_DIR/discovery.surql"

echo "📦 Creating test company database + applying company-blueprint..."
$SURREAL_CMD <<'SQL'
USE NS companies;
DEFINE DATABASE IF NOT EXISTS company_testcompany;
SQL
$SURREAL_CMD --ns companies --db company_testcompany < "$SCHEMAS_DIR/company-blueprint.surql"

# ─── DB-level service user for BP company DB access ──────────────────────────
# This is a deployment credential — NOT the user's password.
# In production, this is injected via --dart-define=BP_PORTAL_PASS=<secret>.
echo "🔑 Creating BP service user on company_testcompany..."
$SURREAL_CMD <<SQL
USE NS companies DB company_testcompany;
DEFINE USER IF NOT EXISTS $BP_PORTAL_USER ON DATABASE PASSWORD '$BP_PORTAL_PASS' ROLES EDITOR;
SQL

# ─── NS-level user for users namespace (needed for RECORD ACCESS to work) ────
# The seed script connects as root, but the RECORD ACCESS bp_auth definition
# handles user authentication. We still need an NS user for the admin panel
# (separate concern — admin panel uses NS-level auth, BP uses RECORD ACCESS).
echo "👤 Creating admin NS user on users namespace (for admin panel only)..."
$SURREAL_CMD <<'SQL'
USE NS users;
DEFINE USER IF NOT EXISTS testadmin ON NAMESPACE PASSWORD 'testadmin-pass' ROLES OWNER;
SQL

# ─── Test user records with password_hash ────────────────────────────────────
# These are APPLICATION users — they authenticate via RECORD ACCESS (bp_auth)
# which validates their password against the password_hash field.
echo "👤 Creating test user profile records with password_hash..."
$SURREAL_CMD --ns users --db users <<'SQL'
-- Business user: authenticates via RECORD ACCESS bp_auth.
-- password_hash is argon2 hash of 'testbiz-pass'.
CREATE user SET
  name       = 'Test Business User',
  email      = 'testbiz@dittodatto.no',
  username   = 'testbiz',
  password_hash = crypto::argon2::generate('testbiz-pass'),
  role       = 'business',
  company_slug = 'testcompany',
  is_onboarded = true,
  created_at = time::now(),
  updated_at = time::now();

-- Customer user: should be rejected by BP role check.
CREATE user SET
  name       = 'Test Customer User',
  email      = 'testcustomer@dittodatto.no',
  username   = 'testcustomer',
  password_hash = crypto::argon2::generate('testcustomer-pass'),
  role       = 'customer',
  company_slug = NONE,
  is_onboarded = true,
  created_at = time::now(),
  updated_at = time::now();
SQL

echo "✅ Test database seeded successfully."
echo "   - Namespaces: companies, users"
echo "   - Databases: discovery, platform, users, company_testcompany"
echo "   - RECORD ACCESS: bp_auth on users/users (validates password_hash)"
echo "   - DB service user: $BP_PORTAL_USER on company_testcompany (EDITOR)"
echo "   - Test users: testbiz (business, password_hash), testcustomer (customer)"
echo "   - Endpoint: $DB_URL"
