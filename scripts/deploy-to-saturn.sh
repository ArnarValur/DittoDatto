#!/usr/bin/env bash
# Deploy a Flutter web app to Saturn.
# Encodes the canonical Caddy-served paths so rsync always goes to the right place.
#
# Usage:
#   ./scripts/deploy-to-saturn.sh portal     # Deploy Business Portal
#   ./scripts/deploy-to-saturn.sh admin      # Deploy Admin Panel
#   ./scripts/deploy-to-saturn.sh marketplace # Deploy Public Marketplace
#
# What it does:
#   1. flutter build web --release
#   2. rsync to the CORRECT Caddy-served path on Saturn
#   3. Verify the served file matches the local build (hash check)
#   4. Run post-deploy-smoke.sh for the deployed app

set -euo pipefail

# ── Canonical deploy paths ──────────────────────────────────────────────────
# These MUST match the Caddy container volume mounts on Saturn.
# Caddy container        → mount source on Saturn host
# dittodatto-caddy       → /srv/dittodatto/admin-panel/web   → port 8002
# dittodatto-portal-caddy → /srv/dittodatto/business-portal/web → port 8003
# (marketplace TBD)      → /srv/dittodatto/marketplace/web   → port 8004
declare -A APP_LOCAL_DIR=(
  [portal]="apps/business-portal"
  [admin]="apps/admin"
  [marketplace]="apps/marketplace"
)

declare -A SATURN_DEPLOY_PATH=(
  [portal]="/srv/dittodatto/business-portal/web"
  [admin]="/srv/dittodatto/admin-panel/web"
  [marketplace]="/srv/dittodatto/marketplace/web"
)

declare -A APP_PORT=(
  [portal]="8003"
  [admin]="8002"
  [marketplace]="8004"
)

# ── Dart-define flags per app ───────────────────────────────────────────────
# These are compile-time constants injected via --dart-define.
# Add new defines here when apps need them — NOT in ad-hoc build commands.
declare -A DART_DEFINES=(
  [portal]="--dart-define=BP_PORTAL_PASS=test-portal-pass"
  [admin]=""
  [marketplace]="--dart-define=SURREAL_URL=ws://dittodatto:8001/rpc --dart-define=DEBUG_DB_PASS=test-portal-pass"
)

SATURN_HOST="${SATURN_HOST:-saturn}"
SATURN_HOSTNAME="${SATURN_HOSTNAME:-dittodatto}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ── Args ────────────────────────────────────────────────────────────────────
TARGET="${1:-}"

if [[ -z "$TARGET" ]] || [[ -z "${APP_LOCAL_DIR[$TARGET]+x}" ]]; then
  echo "Usage: $0 <portal|admin|marketplace>"
  echo ""
  echo "Canonical deploy paths on Saturn:"
  for key in "${!SATURN_DEPLOY_PATH[@]}"; do
    echo "  $key → ${SATURN_DEPLOY_PATH[$key]}"
  done
  exit 1
fi

LOCAL_DIR="${APP_LOCAL_DIR[$TARGET]}"
REMOTE_PATH="${SATURN_DEPLOY_PATH[$TARGET]}"
PORT="${APP_PORT[$TARGET]}"
DEFINES="${DART_DEFINES[$TARGET]}"

echo ""
echo "🚀 Deploy: $TARGET"
echo "   Local:  $LOCAL_DIR"
echo "   Remote: $SATURN_HOST:$REMOTE_PATH"
echo "   Port:   $PORT"
if [[ -n "$DEFINES" ]]; then
  echo "   Defines: (set)"
fi
echo ""

# ── Step 1: Build ───────────────────────────────────────────────────────────
echo "📦 Building web release..."
cd "$PROJECT_ROOT/$LOCAL_DIR"
# shellcheck disable=SC2086
flutter build web --release $DEFINES
cd "$PROJECT_ROOT"
echo "✅ Build complete."
echo ""

# ── Step 2: rsync ───────────────────────────────────────────────────────────
echo "📤 Deploying to Saturn..."
rsync -avz --delete "$LOCAL_DIR/build/web/" "$SATURN_HOST:$REMOTE_PATH/"
echo "✅ rsync complete."
echo ""

# ── Step 3: Hash verification ───────────────────────────────────────────────
echo "🔍 Verifying served content matches deployed build..."
LOCAL_HASH=$(md5sum "$LOCAL_DIR/build/web/main.dart.js" | cut -d' ' -f1)
SERVED_HASH=$(ssh "$SATURN_HOST" "curl -s http://localhost:${PORT}/main.dart.js | md5sum | cut -d' ' -f1")

if [[ "$LOCAL_HASH" == "$SERVED_HASH" ]]; then
  echo "✅ Hash match: $LOCAL_HASH"
else
  echo "❌ HASH MISMATCH!"
  echo "   Local build: $LOCAL_HASH"
  echo "   Served file: $SERVED_HASH"
  echo ""
  echo "   The Caddy container may be serving from a different path."
  echo "   Check: docker inspect <caddy-container> --format '{{json .Mounts}}'"
  exit 1
fi
echo ""

# ── Step 4: Smoke test ──────────────────────────────────────────────────────
echo "🔥 Running smoke test..."
SATURN_HOST="$SATURN_HOSTNAME" "$SCRIPT_DIR/post-deploy-smoke.sh" "$TARGET"
