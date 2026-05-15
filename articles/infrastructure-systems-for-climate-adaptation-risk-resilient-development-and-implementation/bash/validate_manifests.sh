#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/adaptation_objective.yml"
  "$ARTICLE_DIR/config/adaptation_scoring_policy.yml"
  "$ARTICLE_DIR/data/climate_scenario_manifest.csv"
  "$ARTICLE_DIR/data/infrastructure_exposure_inventory.csv"
  "$ARTICLE_DIR/data/vulnerability_adaptive_capacity.csv"
  "$ARTICLE_DIR/data/adaptation_option_portfolio.csv"
  "$ARTICLE_DIR/data/adaptation_finance_implementation_log.csv"
  "$ARTICLE_DIR/data/maladaptation_review.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/adaptation_readiness_review.py"
  "$ARTICLE_DIR/r/adaptation_portfolio_reporting.R"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required adaptation infrastructure scaffold files are present."
