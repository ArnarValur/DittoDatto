#!/usr/bin/env bash
# Post-deploy smoke test — verify deployed apps on Saturn actually respond.
# Run after rsync + Caddy restart. Exits 0 if all checks pass, 1 on any failure.
#
# Usage:
#   ./scripts/post-deploy-smoke.sh              # test all apps
#   ./scripts/post-deploy-smoke.sh admin         # test Admin Panel only
#   ./scripts/post-deploy-smoke.sh portal        # test Business Portal only
#   ./scripts/post-deploy-smoke.sh marketplace   # test Marketplace only
#   ./scripts/post-deploy-smoke.sh hub           # test SurrealDB Hub only

set -uo pipefail

# ── Config ──────────────────────────────────────────────────────────────────
SATURN_HOST="${SATURN_HOST:-dittodatto}"
ADMIN_PORT="${ADMIN_PORT:-8002}"
PORTAL_PORT="${PORTAL_PORT:-8003}"
MARKETPLACE_PORT="${MARKETPLACE_PORT:-8004}"
HUB_PORT="${HUB_PORT:-8001}"
TIMEOUT=10  # seconds per request

# ── State ───────────────────────────────────────────────────────────────────
PASS=0
FAIL=0
SKIP=0

# ── Helpers ─────────────────────────────────────────────────────────────────
check_http() {
  local name="$1"
  local url="$2"
  local expect_in_body="${3:-}"  # optional string to grep for in response body

  printf "  %-25s %s ... " "$name" "$url"

  local http_code body
  body=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$TIMEOUT" "$url" 2>/dev/null) || true

  if [[ "$body" == "000" ]]; then
    echo "❌ UNREACHABLE"
    ((FAIL++))
    return 1
  elif [[ "$body" != "200" ]]; then
    echo "❌ HTTP $body"
    ((FAIL++))
    return 1
  fi

  # If we need to check body content
  if [[ -n "$expect_in_body" ]]; then
    local full_body
    full_body=$(curl -s --max-time "$TIMEOUT" "$url" 2>/dev/null)
    if echo "$full_body" | grep -qi "$expect_in_body"; then
      echo "✅"
      ((PASS++))
      return 0
    else
      echo "⚠️  HTTP 200 but missing expected content: '$expect_in_body'"
      ((FAIL++))
      return 1
    fi
  fi

  echo "✅"
  ((PASS++))
  return 0
}

check_hub() {
  local url="http://${SATURN_HOST}:${HUB_PORT}/health"
  printf "  %-25s %s ... " "SurrealDB Hub" "$url"

  local http_code
  http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$TIMEOUT" "$url" 2>/dev/null) || true

  if [[ "$http_code" == "200" ]]; then
    echo "✅"
    ((PASS++))
    return 0
  elif [[ "$http_code" == "000" ]]; then
    echo "❌ UNREACHABLE"
    ((FAIL++))
    return 1
  else
    echo "❌ HTTP $http_code"
    ((FAIL++))
    return 1
  fi
}

skip_check() {
  local name="$1"
  printf "  %-25s %s\n" "$name" "⏭️  skipped"
  ((SKIP++))
}

# ── Filter ──────────────────────────────────────────────────────────────────
TARGET="${1:-all}"

# ── Run ─────────────────────────────────────────────────────────────────────
echo ""
echo "🔥 Post-Deploy Smoke Test"
echo "   Host: $SATURN_HOST"
echo ""

# Admin Panel
if [[ "$TARGET" == "all" || "$TARGET" == "admin" ]]; then
  check_http "Admin Panel" "http://${SATURN_HOST}:${ADMIN_PORT}" "flutter" || true
else
  skip_check "Admin Panel"
fi

# Business Portal
if [[ "$TARGET" == "all" || "$TARGET" == "portal" ]]; then
  check_http "Business Portal" "http://${SATURN_HOST}:${PORTAL_PORT}" "flutter" || true
else
  skip_check "Business Portal"
fi

# Marketplace (may not be deployed yet)
if [[ "$TARGET" == "all" || "$TARGET" == "marketplace" ]]; then
  # Check if marketplace is even deployed — don't fail hard if it's not there yet
  local_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 "http://${SATURN_HOST}:${MARKETPLACE_PORT}" 2>/dev/null) || true
  if [[ "$local_code" == "000" ]]; then
    skip_check "Marketplace (not deployed)"
  else
    check_http "Marketplace" "http://${SATURN_HOST}:${MARKETPLACE_PORT}" "flutter" || true
  fi
else
  skip_check "Marketplace"
fi

# SurrealDB Hub
if [[ "$TARGET" == "all" || "$TARGET" == "hub" ]]; then
  check_hub || true
else
  skip_check "SurrealDB Hub"
fi

# ── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $FAIL -eq 0 ]]; then
  echo "✅ All smoke checks passed ($PASS passed, $SKIP skipped)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 0
else
  echo "❌ $FAIL FAILED / $PASS passed / $SKIP skipped"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 1
fi
