#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/asset_management_objective.yml"
  "$ARTICLE_DIR/config/risk_scoring_policy.yml"
  "$ARTICLE_DIR/config/predictive_maintenance_policy.yml"
  "$ARTICLE_DIR/config/public_evidence_policy.yml"
  "$ARTICLE_DIR/schemas/asset_register.schema.json"
  "$ARTICLE_DIR/schemas/work_order.schema.json"
  "$ARTICLE_DIR/model_cards/predictive_maintenance_model_card.md"
  "$ARTICLE_DIR/model_cards/lifecycle_cost_model_card.md"
  "$ARTICLE_DIR/docs/mathematical_lens.md"
  "$ARTICLE_DIR/docs/asset_management_framework.md"
  "$ARTICLE_DIR/docs/readiness_gate.md"
  "$ARTICLE_DIR/docs/digital_twin_governance_note.md"
  "$ARTICLE_DIR/docs/public_evidence_package.md"
  "$ARTICLE_DIR/data/asset_register.csv"
  "$ARTICLE_DIR/data/condition_inspections.csv"
  "$ARTICLE_DIR/data/criticality_scores.csv"
  "$ARTICLE_DIR/data/telemetry_observations.csv"
  "$ARTICLE_DIR/data/work_orders.csv"
  "$ARTICLE_DIR/data/failure_events.csv"
  "$ARTICLE_DIR/data/lifecycle_cost_scenarios.csv"
  "$ARTICLE_DIR/data/risk_priority_scores.csv"
  "$ARTICLE_DIR/data/governance_review_log.csv"
  "$ARTICLE_DIR/data/asset_locations.geojson"
  "$ARTICLE_DIR/python/asset_priority_workflow.py"
  "$ARTICLE_DIR/r/lifecycle_reliability_reporting.R"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/sql/sample_queries.sql"
  "$ARTICLE_DIR/typescript/src/asset_management_types.ts"
  "$ARTICLE_DIR/go/program_status_endpoint.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/c/asset_sensor_record.c"
  "$ARTICLE_DIR/cpp/maintenance_priority_queue.cpp"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required asset-management scaffold files are present."
