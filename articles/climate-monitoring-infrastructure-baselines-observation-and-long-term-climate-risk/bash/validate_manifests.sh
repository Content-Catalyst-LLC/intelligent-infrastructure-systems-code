#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/climate_monitoring_objective.yml"
  "$ARTICLE_DIR/config/climate_record_quality_policy.yml"
  "$ARTICLE_DIR/data/essential_climate_variable_map.csv"
  "$ARTICLE_DIR/data/climate_observation_platforms.csv"
  "$ARTICLE_DIR/data/instrument_metadata_calibration_log.csv"
  "$ARTICLE_DIR/data/climate_observations_sample.csv"
  "$ARTICLE_DIR/data/climate_archive_manifest.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/climate_baseline_anomaly_review.py"
  "$ARTICLE_DIR/r/climate_station_trend_reporting.R"
  "$ARTICLE_DIR/c/src/climate_record_quality.c"
  "$ARTICLE_DIR/embedded_c/station_sensor_quality_check.c"
  "$ARTICLE_DIR/fortran/climate_baseline_model.f90"
  "$ARTICLE_DIR/go/climate_monitoring_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/climate_station_node.py"
  "$ARTICLE_DIR/pynq/pynq_climate_stream_quality.py"
  "$ARTICLE_DIR/hdl/verilog/climate_quality_check.v"
  "$ARTICLE_DIR/typescript/src/climate_monitoring_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required climate monitoring infrastructure scaffold files are present."
