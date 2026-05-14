#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/governance_objective.yml"
  "$ARTICLE_DIR/config/governance_scoring_policy.yml"
  "$ARTICLE_DIR/data/infrastructure_project_register.csv"
  "$ARTICLE_DIR/data/project_appraisal_register.csv"
  "$ARTICLE_DIR/data/fiscal_risk_register.csv"
  "$ARTICLE_DIR/data/procurement_delivery_log.csv"
  "$ARTICLE_DIR/data/asset_stewardship_register.csv"
  "$ARTICLE_DIR/data/accountability_transparency_log.csv"
  "$ARTICLE_DIR/data/policy_learning_log.csv"
  "$ARTICLE_DIR/python/governance_readiness_review.py"
  "$ARTICLE_DIR/r/governance_reporting.R"
  "$ARTICLE_DIR/sql/schema.sql"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required infrastructure governance manifests and workflow files are present."
