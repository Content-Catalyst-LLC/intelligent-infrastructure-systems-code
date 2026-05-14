#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

test -f "$ARTICLE_DIR/README.md"
test -f "$ARTICLE_DIR/companion_manifest.yml"
test -f "$ARTICLE_DIR/python/infrastructure_intelligence_readiness.py"
test -f "$ARTICLE_DIR/r/infrastructure_intelligence_reporting.R"
test -f "$ARTICLE_DIR/sql/schema.sql"
test -f "$ARTICLE_DIR/schemas/infrastructure_intelligence_kpi.schema.json"
test -f "$ARTICLE_DIR/schemas/asset_service_register.schema.json"
test -f "$ARTICLE_DIR/schemas/resilience_scenario.schema.json"
test -f "$ARTICLE_DIR/typescript/src/infrastructure_intelligence_types.ts"
test -f "$ARTICLE_DIR/data/asset_service_register.csv"
test -f "$ARTICLE_DIR/data/infrastructure_intelligence_kpis.csv"
test -f "$ARTICLE_DIR/data/cyber_resilience_controls.csv"

echo "Expected file test passed."
