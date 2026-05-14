#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/risk_management_objective.yml"
  "$ARTICLE_DIR/config/risk_scoring_policy.yml"
  "$ARTICLE_DIR/config/continuity_policy.yml"
  "$ARTICLE_DIR/config/public_evidence_policy.yml"
  "$ARTICLE_DIR/schemas/infrastructure_risk_register.schema.json"
  "$ARTICLE_DIR/schemas/criticality_matrix.schema.json"
  "$ARTICLE_DIR/schemas/risk_scenario.schema.json"
  "$ARTICLE_DIR/model_cards/risk_prioritization_model_card.md"
  "$ARTICLE_DIR/model_cards/continuity_readiness_model_card.md"
  "$ARTICLE_DIR/model_cards/risk_governance_model_card.md"
  "$ARTICLE_DIR/docs/mathematical_lens.md"
  "$ARTICLE_DIR/docs/risk_management_framework.md"
  "$ARTICLE_DIR/docs/readiness_gate.md"
  "$ARTICLE_DIR/docs/public_evidence_package.md"
  "$ARTICLE_DIR/docs/risk_financing_note.md"
  "$ARTICLE_DIR/docs/continuity_recovery_note.md"
  "$ARTICLE_DIR/data/asset_service_register.csv"
  "$ARTICLE_DIR/data/infrastructure_risk_register.csv"
  "$ARTICLE_DIR/data/criticality_matrix.csv"
  "$ARTICLE_DIR/data/dependency_graph_edges.csv"
  "$ARTICLE_DIR/data/risk_scenario_manifest.csv"
  "$ARTICLE_DIR/data/treatment_mitigation_plan.csv"
  "$ARTICLE_DIR/data/continuity_recovery_log.csv"
  "$ARTICLE_DIR/data/risk_financing_register.csv"
  "$ARTICLE_DIR/data/risk_governance_log.csv"
  "$ARTICLE_DIR/data/risk_exposure_zones.geojson"
  "$ARTICLE_DIR/python/infrastructure_risk_prioritization.py"
  "$ARTICLE_DIR/r/infrastructure_risk_reporting.R"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/sql/sample_queries.sql"
  "$ARTICLE_DIR/typescript/src/infrastructure_risk_types.ts"
  "$ARTICLE_DIR/go/program_status_endpoint.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/c/risk_signal_record.c"
  "$ARTICLE_DIR/cpp/risk_priority_queue.cpp"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required infrastructure risk management scaffold files are present."
