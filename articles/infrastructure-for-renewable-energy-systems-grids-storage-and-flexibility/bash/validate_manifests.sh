#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/renewable_infrastructure_objective.yml"
  "$ARTICLE_DIR/config/renewable_scoring_policy.yml"
  "$ARTICLE_DIR/data/renewable_asset_inventory.csv"
  "$ARTICLE_DIR/data/grid_connection_constraint_register.csv"
  "$ARTICLE_DIR/data/renewable_generation_forecast_records.csv"
  "$ARTICLE_DIR/data/storage_flexibility_register.csv"
  "$ARTICLE_DIR/data/renewable_reliability_resilience_review.csv"
  "$ARTICLE_DIR/data/renewable_governance_planning_log.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/renewable_infrastructure_review.py"
  "$ARTICLE_DIR/r/renewable_infrastructure_reporting.R"
  "$ARTICLE_DIR/c/src/renewable_infrastructure_metrics.c"
  "$ARTICLE_DIR/embedded_c/edge_renewable_quality_check.c"
  "$ARTICLE_DIR/fortran/renewable_flexibility_model.f90"
  "$ARTICLE_DIR/go/renewable_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/edge_renewable_monitoring_node.py"
  "$ARTICLE_DIR/pynq/pynq_renewable_stream_quality.py"
  "$ARTICLE_DIR/hdl/verilog/renewable_quality_check.v"
  "$ARTICLE_DIR/typescript/src/renewable_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required renewable infrastructure scaffold files are present."
