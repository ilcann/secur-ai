#!/usr/bin/env bash
set -euo pipefail

ROOT_ENV_FILE=".env"

# Uygulama adı -> ilgili değişken isimleri (boşlukla ayrılmış)
declare -A apps
apps["backend-fastapi"]=""
apps["backend-nestjs"]="DATABASE_URL JWT_SECRET JWT_EXPIRES_IN"
apps["frontend-nextjs"]=""

# Ortak değişkenler (boşlukla ayrılmış)
common_vars="NEXTJS_HOST NEXTJS_PORT NESTJS_HOST NESTJS_PORT FASTAPI_HOST FASTAPI_PORT"

for app in "${!apps[@]}"; do
  vars="${apps[$app]}"
  output="apps/$app/.env"

  echo "🔧 Generating $output from $ROOT_ENV_FILE"

  if [ -f "$output" ]; then
      rm -f "$output"
  fi

  mkdir -p "apps/$app"

  # Ortak değişkenler
  for var in $common_vars; do
    grep "^$var=" "$ROOT_ENV_FILE" >> "$output" || true
  done

  # Uygulamaya özel değişkenler
  for var in $vars; do
    grep "^$var=" "$ROOT_ENV_FILE" >> "$output" || true
  done
done

echo "✅ Environment files generated."