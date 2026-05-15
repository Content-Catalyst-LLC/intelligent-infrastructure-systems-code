#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ARTICLE_DIR"

bash bash/validate_manifests.sh
python3 python/smart_city_infrastructure_review.py

if command -v sqlite3 >/dev/null 2>&1; then
  sqlite3 outputs/smart_city_infrastructure.db < sql/schema.sql
  sqlite3 outputs/smart_city_infrastructure.db < sql/load_csvs.sql
  sqlite3 outputs/smart_city_infrastructure.db < sql/sample_queries.sql
else
  echo "sqlite3 not installed; skipping SQL workflow."
fi

if command -v cc >/dev/null 2>&1; then
  cc c/src/smart_city_metrics.c -I c/include -o outputs/smart_city_metrics
  ./outputs/smart_city_metrics || true

  cc embedded_c/edge_smart_city_quality_check.c -o outputs/edge_smart_city_quality_check
  ./outputs/edge_smart_city_quality_check || true
else
  echo "C compiler not found; skipping C checks."
fi

echo "Local workflow run complete."
