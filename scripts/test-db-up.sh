#!/usr/bin/env bash
# Start the ephemeral test SurrealDB and seed it.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "🚀 Starting test SurrealDB (port 18000, in-memory)..."
docker compose -f docker-compose.test.yml up -d --wait

echo "🌱 Seeding..."
./scripts/test-db-seed.sh

echo ""
echo "✅ Test DB ready. Run tests with:"
echo "   cd apps/business-portal && flutter test --tags integration"
echo "   cd services/mercury-engine && SURREAL_TEST_URL=ws://localhost:18000/rpc uv run pytest"
echo ""
echo "Tear down with: ./scripts/test-db-down.sh"
