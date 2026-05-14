#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/infrastructure_intelligence_objective.yml"
  "$ARTICLE_DIR/config/readiness_scoring_policy.yml"
  "$ARTICLE_DIR/config/public_evidence_policy.yml"
  "$ARTICLE_DIR/config/scenario_policy.yml"
  "$ARTICLE_DIR/schemas/infrastructure_intelligence_kpi.schema.json"
  "$ARTICLE_DIR/schemas/asset_service_register.schema.json"
  "$ARTICLE_DIR/schemas/resilience_scenario.schema.json"
  "$ARTICLE_DIR/model_cards/infrastructure_readiness_model_card.md"
  "$ARTICLE_DIR/model_cards/ai_governance_model_card.md"
  "$ARTICLE_DIR/model_cards/cyber_resilience_model_card.md"
  "$ARTICLE_DIR/docs/mathematical_lens.md"
  "$ARTICLE_DIR/docs/intelligent_infrastructure_framework.md"
  "$ARTICLE_DIR/docs/readiness_gate.md"
  "$ARTICLE_DIR/docs/public_evidence_package.md"
  "$ARTICLE_DIR/docs/cyber_resilience_note.md"
  "$ARTICLE_DIR/docs/ai_governance_note.md"
  "$ARTICLE_DIR/data/asset_service_register.csv"
  "$ARTICLE_DIR/data/observability_registry.csv"
  "$ARTICLE_DIR/data/interoperability_map.csv"
  "$ARTICLE_DIR/data/ai_analytics_registry.csv"
  "$ARTICLE_DIR/data/cyber_resilience_controls.csv"
  "$ARTICLE_DIR/data/resilience_scenario_manifest.csv"
  "$ARTICLE_DIR/data/infrastructure_intelligence_kpis.csv"
  "$ARTICLE_DIR/data/decision_intervention_log.csv"
  "$ARTICLE_DIR/data/governance_review_log.csv"
  "$ARTICLE_DIR/data/infrastructure_service_zones.geojson"
  "$ARTICLE_DIR/python/infrastructure_intelligence_readiness.py"
  "$ARTICLE_DIR/r/infrastructure_intelligence_reporting.R"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/sql/sample_queries.sql"
  "$ARTICLE_DIR/typescript/src/infrastructure_intelligence_types.ts"
  "$ARTICLE_DIR/go/program_status_endpoint.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/c/infrastructure_signal_record.c"
  "$ARTICLE_DIR/cpp/resilience_review_queue.cpp"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required future intelligent infrastructure scaffold files are present."
