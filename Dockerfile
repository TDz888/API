# =============================================================================
# AI Gateway - LiteLLM Proxy
# Unified Free LLM API Gateway
# Deploy: Railway.app | Docker | Any container platform
# =============================================================================

FROM ghcr.io/berriai/litellm-database:main-latest

LABEL maintainer="AI Gateway"
LABEL description="Unified AI Gateway aggregating 10+ free LLM providers"
LABEL version="1.0.0"

WORKDIR /app

# Install curl for healthcheck + nginx for static panel
RUN apt-get update &&     apt-get install -y curl nginx &&     rm -rf /var/lib/apt/lists/*

# Copy configuration
COPY config.yaml /app/config.yaml

# Copy static panel
COPY static/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports
EXPOSE 4000 8080

# Healthcheck
HEALTHCHECK --interval=30s             --timeout=10s             --start-period=60s             --retries=3   CMD curl -fsS http://localhost:4000/health/liveliness > /dev/null || exit 1

# Start both nginx (panel) and litellm (proxy) via supervisord
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENTRYPOINT ["/app/start.sh"]
