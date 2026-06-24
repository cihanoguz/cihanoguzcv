#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${APP_DIR:-/home/deploy/cihanoguzcv}"
REPO_URL="${REPO_URL:-https://github.com/cihanoguz/cihanoguzcv.git}"

if [ ! -d "$APP_DIR/.git" ]; then
  git clone "$REPO_URL" "$APP_DIR"
fi

cd "$APP_DIR"
git pull origin gh-pages

docker compose -f docker-compose.prod.yml up -d --build
docker ps --filter name=cihanoguzcv

echo "Local check:"
curl -I http://127.0.0.1:8082/
