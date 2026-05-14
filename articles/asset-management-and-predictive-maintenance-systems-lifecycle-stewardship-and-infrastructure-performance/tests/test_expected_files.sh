#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

test -f "$ARTICLE_DIR/README.md"
test -f "$ARTICLE_DIR/companion_manifest.yml"
test -f "$ARTICLE_DIR/python/asset_priority_workflow.py"
test -f "$ARTICLE_DIR/r/lifecycle_reliability_reporting.R"
test -f "$ARTICLE_DIR/sql/schema.sql"
test -f "$ARTICLE_DIR/schemas/asset_register.schema.json"
test -f "$ARTICLE_DIR/schemas/work_order.schema.json"
test -f "$ARTICLE_DIR/typescript/src/asset_management_types.ts"
test -f "$ARTICLE_DIR/data/asset_register.csv"
test -f "$ARTICLE_DIR/data/condition_inspections.csv"
test -f "$ARTICLE_DIR/data/risk_priority_scores.csv"

echo "Expected file test passed."
