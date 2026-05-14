#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

test -f "$ARTICLE_DIR/README.md"
test -f "$ARTICLE_DIR/companion_manifest.yml"
test -f "$ARTICLE_DIR/python/cyber_resilience_readiness.py"
test -f "$ARTICLE_DIR/r/cyber_resilience_reporting.R"
test -f "$ARTICLE_DIR/sql/schema.sql"
test -f "$ARTICLE_DIR/schemas/cyber_asset_register.schema.json"
test -f "$ARTICLE_DIR/schemas/cyber_resilience_kpi.schema.json"
test -f "$ARTICLE_DIR/schemas/cyber_incident_scenario.schema.json"
test -f "$ARTICLE_DIR/typescript/src/cyber_resilience_types.ts"
test -f "$ARTICLE_DIR/data/cyber_asset_register.csv"
test -f "$ARTICLE_DIR/data/cyber_resilience_kpis.csv"
test -f "$ARTICLE_DIR/data/continuity_recovery_log.csv"

echo "Expected file test passed."
