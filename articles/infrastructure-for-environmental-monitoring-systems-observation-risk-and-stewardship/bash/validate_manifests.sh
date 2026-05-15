#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/environmental_monitoring_objective.yml"
  "$ARTICLE_DIR/config/monitoring_quality_policy.yml"
  "$ARTICLE_DIR/data/monitoring_site_inventory.csv"
  "$ARTICLE_DIR/data/environmental_observations_sample.csv"
  "$ARTICLE_DIR/data/environmental_threshold_indicator_catalog.csv"
  "$ARTICLE_DIR/data/calibration_device_health_log.csv"
  "$ARTICLE_DIR/data/coverage_equity_review.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/environmental_monitoring_indicator_review.py"
  "$ARTICLE_DIR/r/environmental_monitoring_reporting.R"
  "$ARTICLE_DIR/c/src/environmental_monitoring_quality.c"
  "$ARTICLE_DIR/embedded_c/environmental_sensor_quality_check.c"
  "$ARTICLE_DIR/fortran/environmental_risk_model.f90"
  "$ARTICLE_DIR/go/environmental_monitoring_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/environmental_monitoring_node.py"
  "$ARTICLE_DIR/pynq/pynq_environmental_stream_quality.py"
  "$ARTICLE_DIR/hdl/verilog/environmental_quality_check.v"
  "$ARTICLE_DIR/typescript/src/environmental_monitoring_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required environmental monitoring infrastructure scaffold files are present."
