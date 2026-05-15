#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/urban_sensing_objective.yml"
  "$ARTICLE_DIR/config/sensor_quality_policy.yml"
  "$ARTICLE_DIR/data/urban_sensor_inventory.csv"
  "$ARTICLE_DIR/data/urban_sensor_telemetry_sample.csv"
  "$ARTICLE_DIR/data/sensor_asset_linkage.csv"
  "$ARTICLE_DIR/data/calibration_device_health_log.csv"
  "$ARTICLE_DIR/data/coverage_exposure_review.csv"
  "$ARTICLE_DIR/data/urban_sensor_indicator_catalog.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/urban_sensor_network_monitoring_review.py"
  "$ARTICLE_DIR/r/urban_sensor_network_reporting.R"
  "$ARTICLE_DIR/c/src/urban_sensor_quality.c"
  "$ARTICLE_DIR/embedded_c/edge_sensor_quality_check.c"
  "$ARTICLE_DIR/fortran/urban_observability_model.f90"
  "$ARTICLE_DIR/go/urban_sensor_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/urban_sensor_node.py"
  "$ARTICLE_DIR/pynq/pynq_urban_sensor_stream_quality.py"
  "$ARTICLE_DIR/hdl/verilog/urban_sensor_quality_check.v"
  "$ARTICLE_DIR/typescript/src/urban_sensor_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required urban sensor network scaffold files are present."
