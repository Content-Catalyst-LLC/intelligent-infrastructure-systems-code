#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/water_infrastructure_objective.yml"
  "$ARTICLE_DIR/config/water_scoring_policy.yml"
  "$ARTICLE_DIR/data/water_asset_inventory.csv"
  "$ARTICLE_DIR/data/water_telemetry_records.csv"
  "$ARTICLE_DIR/data/water_quality_public_health_review.csv"
  "$ARTICLE_DIR/data/leakage_hydraulic_control_review.csv"
  "$ARTICLE_DIR/data/wastewater_stormwater_risk_review.csv"
  "$ARTICLE_DIR/data/water_governance_response_log.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/intelligent_water_infrastructure_review.py"
  "$ARTICLE_DIR/r/intelligent_water_infrastructure_reporting.R"
  "$ARTICLE_DIR/c/src/water_infrastructure_metrics.c"
  "$ARTICLE_DIR/embedded_c/edge_water_quality_check.c"
  "$ARTICLE_DIR/fortran/water_resilience_model.f90"
  "$ARTICLE_DIR/go/water_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/edge_water_quality_node.py"
  "$ARTICLE_DIR/pynq/pynq_water_stream_quality.py"
  "$ARTICLE_DIR/hdl/verilog/water_quality_check.v"
  "$ARTICLE_DIR/typescript/src/water_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required intelligent water infrastructure scaffold files are present."
