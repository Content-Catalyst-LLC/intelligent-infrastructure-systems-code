#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/cyber_resilience_objective.yml"
  "$ARTICLE_DIR/config/cyber_resilience_scoring_policy.yml"
  "$ARTICLE_DIR/config/continuity_policy.yml"
  "$ARTICLE_DIR/config/public_evidence_policy.yml"
  "$ARTICLE_DIR/schemas/cyber_asset_register.schema.json"
  "$ARTICLE_DIR/schemas/cyber_resilience_kpi.schema.json"
  "$ARTICLE_DIR/schemas/cyber_incident_scenario.schema.json"
  "$ARTICLE_DIR/model_cards/cyber_resilience_readiness_model_card.md"
  "$ARTICLE_DIR/model_cards/ot_security_model_card.md"
  "$ARTICLE_DIR/model_cards/vendor_risk_model_card.md"
  "$ARTICLE_DIR/docs/mathematical_lens.md"
  "$ARTICLE_DIR/docs/cyber_resilience_framework.md"
  "$ARTICLE_DIR/docs/readiness_gate.md"
  "$ARTICLE_DIR/docs/public_evidence_package.md"
  "$ARTICLE_DIR/docs/ot_security_note.md"
  "$ARTICLE_DIR/docs/vendor_risk_note.md"
  "$ARTICLE_DIR/data/cyber_asset_register.csv"
  "$ARTICLE_DIR/data/ot_zone_conduit_map.csv"
  "$ARTICLE_DIR/data/cyber_control_baseline.csv"
  "$ARTICLE_DIR/data/cyber_incident_scenario_manifest.csv"
  "$ARTICLE_DIR/data/continuity_recovery_log.csv"
  "$ARTICLE_DIR/data/vendor_risk_register.csv"
  "$ARTICLE_DIR/data/cyber_governance_log.csv"
  "$ARTICLE_DIR/data/cyber_resilience_kpis.csv"
  "$ARTICLE_DIR/data/cyber_resilience_service_points.geojson"
  "$ARTICLE_DIR/python/cyber_resilience_readiness.py"
  "$ARTICLE_DIR/r/cyber_resilience_reporting.R"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/sql/sample_queries.sql"
  "$ARTICLE_DIR/typescript/src/cyber_resilience_types.ts"
  "$ARTICLE_DIR/go/program_status_endpoint.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/c/cyber_signal_record.c"
  "$ARTICLE_DIR/cpp/cyber_incident_priority_queue.cpp"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required infrastructure cyber resilience scaffold files are present."
