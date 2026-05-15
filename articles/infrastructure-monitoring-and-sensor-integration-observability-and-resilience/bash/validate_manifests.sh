#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/monitoring_objective.yml"
  "$ARTICLE_DIR/config/monitoring_scoring_policy.yml"
  "$ARTICLE_DIR/data/sensor_inventory.csv"
  "$ARTICLE_DIR/data/monitored_asset_registry.csv"
  "$ARTICLE_DIR/data/sensor_telemetry_records.csv"
  "$ARTICLE_DIR/data/calibration_validation_log.csv"
  "$ARTICLE_DIR/data/coverage_blindspot_review.csv"
  "$ARTICLE_DIR/data/monitoring_alert_response_register.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/infrastructure_monitoring_review.py"
  "$ARTICLE_DIR/r/infrastructure_monitoring_reporting.R"
  "$ARTICLE_DIR/c/src/monitoring_observability_metrics.c"
  "$ARTICLE_DIR/embedded_c/edge_sensor_quality_check.c"
  "$ARTICLE_DIR/fortran/monitoring_resilience_model.f90"
  "$ARTICLE_DIR/go/monitoring_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/edge_monitoring_node.py"
  "$ARTICLE_DIR/pynq/pynq_monitoring_stream_quality.py"
  "$ARTICLE_DIR/hdl/verilog/monitoring_stream_quality.v"
  "$ARTICLE_DIR/typescript/src/monitoring_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required infrastructure monitoring scaffold files are present."
