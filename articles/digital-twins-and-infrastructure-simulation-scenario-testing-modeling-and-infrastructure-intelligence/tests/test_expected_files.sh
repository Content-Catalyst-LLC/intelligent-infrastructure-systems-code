#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

test -f "$ARTICLE_DIR/README.md"
test -f "$ARTICLE_DIR/companion_manifest.yml"
test -f "$ARTICLE_DIR/python/digital_twin_scenario_workflow.py"
test -f "$ARTICLE_DIR/r/digital_twin_scenario_reporting.R"
test -f "$ARTICLE_DIR/sql/schema.sql"
test -f "$ARTICLE_DIR/schemas/twin_asset_registry.schema.json"
test -f "$ARTICLE_DIR/schemas/simulation_scenario.schema.json"
test -f "$ARTICLE_DIR/schemas/model_registry.schema.json"
test -f "$ARTICLE_DIR/typescript/src/digital_twin_types.ts"
test -f "$ARTICLE_DIR/data/twin_asset_registry.csv"
test -f "$ARTICLE_DIR/data/digital_twin_state_table.csv"
test -f "$ARTICLE_DIR/data/simulation_scenario_manifest.csv"

echo "Expected file test passed."
