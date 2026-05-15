#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ARTICLE_DIR"

bash bash/validate_manifests.sh
python3 python/energy_infrastructure_performance_review.py

if command -v sqlite3 >/dev/null 2>&1; then
  sqlite3 outputs/energy_infrastructure_performance.db < sql/schema.sql
  sqlite3 outputs/energy_infrastructure_performance.db < sql/load_csvs.sql
  sqlite3 outputs/energy_infrastructure_performance.db < sql/sample_queries.sql
else
  echo "sqlite3 not installed; skipping SQL workflow."
fi

if command -v cc >/dev/null 2>&1; then
  cc c/src/energy_performance_metrics.c -I c/include -o outputs/energy_performance_metrics
  ./outputs/energy_performance_metrics || true

  cc embedded_c/edge_energy_quality_check.c -o outputs/edge_energy_quality_check
  ./outputs/edge_energy_quality_check || true
else
  echo "C compiler not found; skipping C checks."
fi

echo "Local workflow run complete."
