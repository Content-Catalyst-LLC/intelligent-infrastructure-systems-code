#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ARTICLE_DIR"

bash bash/validate_manifests.sh
python3 python/early_warning_chain_review.py

if command -v sqlite3 >/dev/null 2>&1; then
  sqlite3 outputs/early_warning_infrastructure.db < sql/schema.sql
  sqlite3 outputs/early_warning_infrastructure.db < sql/load_csvs.sql
  sqlite3 outputs/early_warning_infrastructure.db < sql/sample_queries.sql
else
  echo "sqlite3 not installed; skipping SQL workflow."
fi

if command -v cc >/dev/null 2>&1; then
  cc c/src/warning_chain_math.c -I c/include -o outputs/warning_chain_math
  ./outputs/warning_chain_math || true

  cc embedded_c/edge_threshold_detector.c -o outputs/edge_threshold_detector
  ./outputs/edge_threshold_detector || true
else
  echo "C compiler not found; skipping C checks."
fi

echo "Local workflow run complete."
