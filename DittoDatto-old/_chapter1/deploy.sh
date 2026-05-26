#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# DittoDatto — Deploy Nuxt SSR apps to Cloud Run
# Usage: ./deploy.sh [app-name]    (deploys one app)
#        ./deploy.sh all           (deploys all 3)
#
# Prerequisites:
#   - gcloud CLI authenticated
#   - Docker running locally
#   - gcloud auth configure-docker europe-west1-docker.pkg.dev
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

PROJECT_ID="cs-poc-4zmxog23jmy4io0d4yx6rj0"
REGION="europe-west4"
REGISTRY="europe-west1-docker.pkg.dev/${PROJECT_ID}/dittodatto-web"

deploy_app() {
  local APP_NAME=$1
  local SERVICE_NAME=$2
  local IMAGE="${REGISTRY}/${SERVICE_NAME}:latest"
  echo ""
  echo "🚀 Deploying ${SERVICE_NAME} (${APP_NAME})..."
  echo "─────────────────────────────────────────────"

  # Build Docker image
  echo "📦 Building image..."
  docker build --build-arg "APP_NAME=${APP_NAME}" -f Dockerfile.web -t "${IMAGE}" .

  # Push to Artifact Registry
  echo "⬆️  Pushing image..."
  docker push "${IMAGE}"

  # Deploy to Cloud Run
  echo "☁️  Deploying to Cloud Run..."
  gcloud run deploy "${SERVICE_NAME}" \
    --image "${IMAGE}" \
    --region "${REGION}" \
    --project "${PROJECT_ID}" \
    --allow-unauthenticated \
    --port 8080 \
    --memory 512Mi \
    --cpu 1 \
    --min-instances 0 \
    --max-instances 3 \
    --set-env-vars "NODE_ENV=production,GOOGLE_APPLICATION_CREDENTIALS=./service-account.json,NUXT_PUBLIC_MERCURY_URL=https://mercury.dittodatto.no"

  echo "✅ ${SERVICE_NAME} deployed!"
  echo ""
}

case "${1:-all}" in
  admin|admin-panel)
    deploy_app "admin-panel" "admin-panel"
    ;;
  portal|business-portal)
    deploy_app "business-portal" "business-portal"
    ;;
  public|public-marketplace)
    deploy_app "public-marketplace" "public-marketplace"
    ;;
  all)
    deploy_app "public-marketplace" "public-marketplace"
    deploy_app "business-portal" "business-portal"
    deploy_app "admin-panel" "admin-panel"
    ;;
  *)
    echo "Usage: ./deploy.sh [admin|portal|public|all]"
    exit 1
    ;;
esac

echo "🎉 All done! Services:"
gcloud run services list --region="${REGION}" --project="${PROJECT_ID}" --format="table(SERVICE,URL)" --filter="metadata.name:(admin-panel OR business-portal OR public-marketplace)"
