#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ARTICLE_DIR"

bash bash/validate_manifests.sh
python3 python/urban_sensor_network_monitoring_review.py

if command -v sqlite3 >/dev/null 2>&1; then
  sqlite3 outputs/urban_sensor_networks.db < sql/schema.sql
  sqlite3 outputs/urban_sensor_networks.db < sql/load_csvs.sql
  sqlite3 outputs/urban_sensor_networks.db < sql/sample_queries.sql
else
  echo "sqlite3 not installed; skipping SQL workflow."
fi

if command -v cc >/dev/null 2>&1; then
  cc c/src/urban_sensor_quality.c -I c/include -o outputs/urban_sensor_quality
  ./outputs/urban_sensor_quality || true

  cc embedded_c/edge_sensor_quality_check.c -o outputs/edge_sensor_quality_check
  ./outputs/edge_sensor_quality_check || true
else
  echo "C compiler not found; skipping C checks."
fi

echo "Local workflow run complete."
