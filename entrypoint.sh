#!/bin/sh
set -e

# -------------------------------------------------------
# Secrets are NEVER in the repo.
# They come from Koyeb dashboard → Environment Variables.
# This script injects them into app.conf at startup.
# -------------------------------------------------------

# Validate required env vars are set
if [ -z "$DB_CONNECTION_STRING" ]; then
  echo "❌ ERROR: DB_CONNECTION_STRING env var is not set."
  echo "   Set it in Koyeb dashboard → Service → Variables"
  exit 1
fi

if [ -z "$CASDOOR_ORIGIN" ]; then
  echo "❌ ERROR: CASDOOR_ORIGIN env var is not set."
  echo "   Set it in Koyeb dashboard → Service → Variables"
  exit 1
fi

# Inject env vars into app.conf placeholders
sed -i "s|\${DB_CONNECTION_STRING}|${DB_CONNECTION_STRING}|g" /conf/app.conf
sed -i "s|\${CASDOOR_ORIGIN}|${CASDOOR_ORIGIN}|g" /conf/app.conf

echo "✅ Config injected successfully"
echo "🌐 Origin: ${CASDOOR_ORIGIN}"

# Start Casdoor
exec /server -config /conf/app.conf