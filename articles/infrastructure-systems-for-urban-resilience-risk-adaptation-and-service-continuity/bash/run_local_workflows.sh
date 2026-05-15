#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ARTICLE_DIR"

bash bash/validate_manifests.sh
python3 python/urban_resilience_service_continuity_review.py

if command -v sqlite3 >/dev/null 2>&1; then
  sqlite3 outputs/urban_resilience_infrastructure.db < sql/schema.sql
  sqlite3 outputs/urban_resilience_infrastructure.db < sql/load_csvs.sql
  sqlite3 outputs/urban_resilience_infrastructure.db < sql/sample_queries.sql
else
  echo "sqlite3 not installed; skipping SQL workflow."
fi

if command -v cc >/dev/null 2>&1; then
  cc c/src/urban_resilience_metrics.c -I c/include -o outputs/urban_resilience_metrics
  ./outputs/urban_resilience_metrics || true

  cc embedded_c/service_status_quality_check.c -o outputs/service_status_quality_check
  ./outputs/service_status_quality_check || true
else
  echo "C compiler not found; skipping C checks."
fi

echo "Local workflow run complete."
