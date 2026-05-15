#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/early_warning_objective.yml"
  "$ARTICLE_DIR/config/early_warning_scoring_policy.yml"
  "$ARTICLE_DIR/data/hazard_exposure_register.csv"
  "$ARTICLE_DIR/data/observation_network_inventory.csv"
  "$ARTICLE_DIR/data/forecast_product_register.csv"
  "$ARTICLE_DIR/data/warning_channel_register.csv"
  "$ARTICLE_DIR/data/preparedness_action_log.csv"
  "$ARTICLE_DIR/data/accessibility_inclusion_review.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/early_warning_chain_review.py"
  "$ARTICLE_DIR/r/early_warning_reporting.R"
  "$ARTICLE_DIR/c/src/warning_chain_math.c"
  "$ARTICLE_DIR/embedded_c/edge_threshold_detector.c"
  "$ARTICLE_DIR/fortran/warning_risk_model.f90"
  "$ARTICLE_DIR/go/early_warning_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/rainfall_river_stage_node.py"
  "$ARTICLE_DIR/pynq/pynq_threshold_stream.py"
  "$ARTICLE_DIR/hdl/verilog/early_warning_threshold.v"
  "$ARTICLE_DIR/typescript/src/early_warning_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required early warning infrastructure scaffold files are present."
