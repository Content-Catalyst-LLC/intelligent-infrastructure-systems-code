#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/climate_scenario_manifest.yml"
  "$ARTICLE_DIR/config/adaptation_readiness_policy.yml"
  "$ARTICLE_DIR/data/adaptation_readiness_scores.csv"
  "$ARTICLE_DIR/data/asset_exposure_inventory.csv"
  "$ARTICLE_DIR/data/dependency_edges.csv"
  "$ARTICLE_DIR/docs/readiness_gate.md"
  "$ARTICLE_DIR/schemas/adaptation_readiness.schema.json"
  "$ARTICLE_DIR/python/adaptation_readiness_scoring.py"
  "$ARTICLE_DIR/sql/schema.sql"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file"
    exit 1
  fi
  echo "Found: $file"
done

echo "Manifest validation passed."
