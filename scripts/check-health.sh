#!/bin/bash

# Health Check Script
# Checks the health of deployed backend

set -e

BACKEND_URL=${1:-"http://localhost:5000"}

echo "🏥 Checking backend health at $BACKEND_URL..."

# Check health endpoint
HEALTH_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/health" || echo "000")

if [ "$HEALTH_RESPONSE" = "200" ]; then
    echo "✅ Backend is healthy!"
    curl -s "$BACKEND_URL/health" | jq '.' || curl -s "$BACKEND_URL/health"
else
    echo "❌ Backend health check failed (HTTP $HEALTH_RESPONSE)"
    exit 1
fi

# Check API status
echo ""
echo "📊 Checking API status..."
API_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$BACKEND_URL/api/status" || echo "000")

if [ "$API_RESPONSE" = "200" ]; then
    echo "✅ API is operational!"
    curl -s "$BACKEND_URL/api/status" | jq '.' || curl -s "$BACKEND_URL/api/status"
else
    echo "⚠️  API status check returned HTTP $API_RESPONSE"
fi

