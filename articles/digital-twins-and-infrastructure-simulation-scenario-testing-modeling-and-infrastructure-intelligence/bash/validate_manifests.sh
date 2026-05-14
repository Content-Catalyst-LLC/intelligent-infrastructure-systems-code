#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/digital_twin_objective.yml"
  "$ARTICLE_DIR/config/model_governance_policy.yml"
  "$ARTICLE_DIR/config/scenario_policy.yml"
  "$ARTICLE_DIR/config/public_evidence_policy.yml"
  "$ARTICLE_DIR/schemas/twin_asset_registry.schema.json"
  "$ARTICLE_DIR/schemas/simulation_scenario.schema.json"
  "$ARTICLE_DIR/schemas/model_registry.schema.json"
  "$ARTICLE_DIR/model_cards/scenario_stress_model_card.md"
  "$ARTICLE_DIR/model_cards/digital_twin_state_model_card.md"
  "$ARTICLE_DIR/model_cards/public_evidence_model_card.md"
  "$ARTICLE_DIR/docs/mathematical_lens.md"
  "$ARTICLE_DIR/docs/digital_twin_framework.md"
  "$ARTICLE_DIR/docs/readiness_gate.md"
  "$ARTICLE_DIR/docs/model_validation_note.md"
  "$ARTICLE_DIR/docs/public_evidence_package.md"
  "$ARTICLE_DIR/docs/interoperability_governance_note.md"
  "$ARTICLE_DIR/data/twin_asset_registry.csv"
  "$ARTICLE_DIR/data/telemetry_source_registry.csv"
  "$ARTICLE_DIR/data/digital_twin_state_table.csv"
  "$ARTICLE_DIR/data/model_registry.csv"
  "$ARTICLE_DIR/data/simulation_scenario_manifest.csv"
  "$ARTICLE_DIR/data/simulation_outputs.csv"
  "$ARTICLE_DIR/data/validation_sensitivity_log.csv"
  "$ARTICLE_DIR/data/decision_intervention_log.csv"
  "$ARTICLE_DIR/data/governance_review_log.csv"
  "$ARTICLE_DIR/data/twin_asset_locations.geojson"
  "$ARTICLE_DIR/python/digital_twin_scenario_workflow.py"
  "$ARTICLE_DIR/r/digital_twin_scenario_reporting.R"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/sql/sample_queries.sql"
  "$ARTICLE_DIR/typescript/src/digital_twin_types.ts"
  "$ARTICLE_DIR/go/program_status_endpoint.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/c/twin_state_record.c"
  "$ARTICLE_DIR/cpp/scenario_priority_queue.cpp"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required digital twin scaffold files are present."
