#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/cyber_physical_objective.yml"
  "$ARTICLE_DIR/config/cyber_physical_scoring_policy.yml"
  "$ARTICLE_DIR/data/cyber_physical_asset_inventory.csv"
  "$ARTICLE_DIR/data/control_loop_register.csv"
  "$ARTICLE_DIR/data/telemetry_command_records.csv"
  "$ARTICLE_DIR/data/dependency_exposure_map.csv"
  "$ARTICLE_DIR/data/assurance_fallback_review.csv"
  "$ARTICLE_DIR/data/cyber_physical_governance_action_log.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/cyber_physical_infrastructure_review.py"
  "$ARTICLE_DIR/r/cyber_physical_infrastructure_reporting.R"
  "$ARTICLE_DIR/c/src/control_integrity_metrics.c"
  "$ARTICLE_DIR/embedded_c/edge_control_safety_check.c"
  "$ARTICLE_DIR/fortran/cyber_physical_resilience_model.f90"
  "$ARTICLE_DIR/go/cyber_physical_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/edge_control_node.py"
  "$ARTICLE_DIR/pynq/pynq_control_stream_integrity.py"
  "$ARTICLE_DIR/hdl/verilog/control_stream_integrity.v"
  "$ARTICLE_DIR/typescript/src/cyber_physical_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required cyber-physical infrastructure scaffold files are present."
