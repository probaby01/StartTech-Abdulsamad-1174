#!/bin/bash

BACKEND_URL=$1

if [ -z "$BACKEND_URL" ]; then
    echo "Usage: ./health-check.sh <backend-url>"
    exit 1
fi

response=$(curl -s -o /dev/null -w "%{http_code}" $BACKEND_URL/health)

if [ $response -eq 200 ]; then
    echo "✅ Health check passed!"
    exit 0
else
    echo "❌ Health check failed with status: $response"
    exit 1
fi