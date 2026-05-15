#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ARTICLE_DIR"

bash bash/validate_manifests.sh
python3 python/infrastructure_monitoring_review.py

if command -v sqlite3 >/dev/null 2>&1; then
  sqlite3 outputs/infrastructure_monitoring.db < sql/schema.sql
  sqlite3 outputs/infrastructure_monitoring.db < sql/load_csvs.sql
  sqlite3 outputs/infrastructure_monitoring.db < sql/sample_queries.sql
else
  echo "sqlite3 not installed; skipping SQL workflow."
fi

if command -v cc >/dev/null 2>&1; then
  cc c/src/monitoring_observability_metrics.c -I c/include -lm -o outputs/monitoring_observability_metrics
  ./outputs/monitoring_observability_metrics || true

  cc embedded_c/edge_sensor_quality_check.c -o outputs/edge_sensor_quality_check
  ./outputs/edge_sensor_quality_check || true
else
  echo "C compiler not found; skipping C checks."
fi

echo "Local workflow run complete."
