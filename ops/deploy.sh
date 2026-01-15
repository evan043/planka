#!/bin/bash
# Deploy custom Planka to DigitalOcean droplet
# Usage: ./ops/deploy.sh [--build]
#
# Prerequisites:
# - SSH access to droplet (192.241.152.115)
# - GitHub Container Registry login

set -e

DROPLET_IP="192.241.152.115"
DROPLET_USER="root"
REMOTE_DIR="/opt/planka"
IMAGE="ghcr.io/evan043/planka:latest"

echo "🚀 Deploying Planka to $DROPLET_IP..."

# Check if we should build first
if [ "$1" == "--build" ]; then
    echo "📦 Building Docker image locally..."
    docker build -t "$IMAGE" .

    echo "📤 Pushing to GitHub Container Registry..."
    docker push "$IMAGE"
fi

echo "🔄 Deploying to droplet..."

ssh "${DROPLET_USER}@${DROPLET_IP}" << 'ENDSSH'
    set -e
    cd /opt/planka

    echo "📥 Pulling latest image..."
    docker pull ghcr.io/evan043/planka:latest

    echo "🔄 Restarting containers..."
    docker compose down
    docker compose up -d

    echo "⏳ Waiting for health check..."
    sleep 15

    echo "✅ Checking status..."
    docker compose ps

    echo "🧹 Cleaning up old images..."
    docker image prune -f

    echo "🎉 Deployment complete!"
ENDSSH

echo ""
echo "✅ Planka deployed successfully!"
echo "   URL: https://planka.eroland.me"
