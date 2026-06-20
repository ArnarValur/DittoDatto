#!/usr/bin/env bash
# Tear down the ephemeral test SurrealDB (deletes all data — it's in-memory).
set -euo pipefail
cd "$(dirname "$0")/.."

echo "🛑 Stopping test SurrealDB..."
docker compose -f docker-compose.test.yml down -v
echo "✅ Test DB stopped."
