#!/bin/bash
# =============================================================================
# Startup Script - Runs both Nginx (Panel) and LiteLLM (Proxy)
# =============================================================================

echo "🚀 Starting AI Gateway..."
echo "   Panel: http://localhost:8080"
echo "   Proxy: http://localhost:4000"

# Start nginx in background (serves panel on port 8080)
nginx &

# Start LiteLLM proxy (port 4000)
exec litellm --config /app/config.yaml --port 4000
