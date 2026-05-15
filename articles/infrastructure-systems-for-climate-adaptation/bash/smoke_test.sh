#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ARTICLE_DIR"

bash bash/validate_manifests.sh
python3 -m py_compile python/adaptation_infrastructure/core.py python/validate_adaptation_records.py python/adaptation_readiness_scoring.py python/service_continuity_analysis.py
PYTHONPATH="$ARTICLE_DIR/python" python3 python/validate_adaptation_records.py
PYTHONPATH="$ARTICLE_DIR/python" python3 python/adaptation_readiness_scoring.py
PYTHONPATH="$ARTICLE_DIR/python" python3 python/service_continuity_analysis.py
PYTHONPATH="$ARTICLE_DIR/python" python3 -m unittest discover -s tests

if command -v sqlite3 >/dev/null 2>&1; then
  rm -f outputs/climate_adaptation_infrastructure.db
  sqlite3 outputs/climate_adaptation_infrastructure.db < sql/schema.sql
  sqlite3 outputs/climate_adaptation_infrastructure.db < sql/load_sample_data.sql
  sqlite3 outputs/climate_adaptation_infrastructure.db < sql/sample_queries.sql > outputs/sql_query_results.txt
  echo "SQLite smoke test wrote outputs/sql_query_results.txt"
else
  echo "sqlite3 not found; skipping SQL smoke test."
fi

if command -v Rscript >/dev/null 2>&1; then
  Rscript r/adaptation_portfolio_reporting.R
else
  echo "Rscript not found; skipping R smoke test."
fi

echo "Smoke test completed."
