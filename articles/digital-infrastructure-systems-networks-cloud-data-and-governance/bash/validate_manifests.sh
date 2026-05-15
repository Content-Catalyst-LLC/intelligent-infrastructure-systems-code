#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/digital_infrastructure_objective.yml"
  "$ARTICLE_DIR/config/digital_infrastructure_scoring_policy.yml"
  "$ARTICLE_DIR/data/connectivity_infrastructure_inventory.csv"
  "$ARTICLE_DIR/data/cloud_data_infrastructure_register.csv"
  "$ARTICLE_DIR/data/interoperability_exchange_register.csv"
  "$ARTICLE_DIR/data/identity_trust_register.csv"
  "$ARTICLE_DIR/data/digital_dependency_continuity_review.csv"
  "$ARTICLE_DIR/data/access_inclusion_review.csv"
  "$ARTICLE_DIR/data/digital_infrastructure_governance_action_log.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/digital_infrastructure_review.py"
  "$ARTICLE_DIR/r/digital_infrastructure_reporting.R"
  "$ARTICLE_DIR/c/src/digital_infrastructure_capacity_metrics.c"
  "$ARTICLE_DIR/embedded_c/edge_service_continuity_check.c"
  "$ARTICLE_DIR/fortran/digital_infrastructure_resilience_model.f90"
  "$ARTICLE_DIR/go/digital_infrastructure_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/edge_service_health_node.py"
  "$ARTICLE_DIR/pynq/pynq_packet_latency_validator.py"
  "$ARTICLE_DIR/hdl/verilog/packet_latency_validator.v"
  "$ARTICLE_DIR/typescript/src/digital_infrastructure_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required digital infrastructure scaffold files are present."
