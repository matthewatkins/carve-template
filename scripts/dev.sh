#!/bin/bash

# Function to cleanup Docker containers
cleanup() {
    echo "🛑 Stopping Docker containers..."
    docker-compose stop >/dev/null 2>&1
    exit 0
}

# Set trap to cleanup on signals
trap cleanup INT TERM

# Start Docker containers
echo "🐳 Starting Docker containers..."
docker-compose up -d

# Build shared packages first (force clean build)
echo "🔨 Building shared packages..."
echo "Building @carve/shared-types..."
cd packages/shared-types && bun run build && cd ../..

echo "Building @carve/shared-utils..."
cd packages/shared-utils && bun run build && cd ../..

echo "✅ Shared packages built successfully!"

# Start turbo dev in foreground
echo "🚀 Starting development servers..."
bun run turbo dev || true

# If turbo exits (normally or interrupted), cleanup
cleanup
