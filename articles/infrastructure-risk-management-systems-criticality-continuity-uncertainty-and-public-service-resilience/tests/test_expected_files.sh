#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

test -f "$ARTICLE_DIR/README.md"
test -f "$ARTICLE_DIR/companion_manifest.yml"
test -f "$ARTICLE_DIR/python/infrastructure_risk_prioritization.py"
test -f "$ARTICLE_DIR/r/infrastructure_risk_reporting.R"
test -f "$ARTICLE_DIR/sql/schema.sql"
test -f "$ARTICLE_DIR/schemas/infrastructure_risk_register.schema.json"
test -f "$ARTICLE_DIR/schemas/criticality_matrix.schema.json"
test -f "$ARTICLE_DIR/schemas/risk_scenario.schema.json"
test -f "$ARTICLE_DIR/typescript/src/infrastructure_risk_types.ts"
test -f "$ARTICLE_DIR/data/infrastructure_risk_register.csv"
test -f "$ARTICLE_DIR/data/criticality_matrix.csv"
test -f "$ARTICLE_DIR/data/continuity_recovery_log.csv"

echo "Expected file test passed."
