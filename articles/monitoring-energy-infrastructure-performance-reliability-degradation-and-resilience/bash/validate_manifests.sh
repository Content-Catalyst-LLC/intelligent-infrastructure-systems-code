#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/energy_monitoring_objective.yml"
  "$ARTICLE_DIR/config/performance_scoring_policy.yml"
  "$ARTICLE_DIR/data/energy_asset_inventory.csv"
  "$ARTICLE_DIR/data/energy_performance_telemetry.csv"
  "$ARTICLE_DIR/data/condition_degradation_log.csv"
  "$ARTICLE_DIR/data/reliability_resilience_review.csv"
  "$ARTICLE_DIR/data/power_quality_stability_records.csv"
  "$ARTICLE_DIR/data/energy_governance_maintenance_log.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/energy_infrastructure_performance_review.py"
  "$ARTICLE_DIR/r/energy_infrastructure_performance_reporting.R"
  "$ARTICLE_DIR/c/src/energy_performance_metrics.c"
  "$ARTICLE_DIR/embedded_c/edge_energy_quality_check.c"
  "$ARTICLE_DIR/fortran/energy_resilience_model.f90"
  "$ARTICLE_DIR/go/energy_asset_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/edge_energy_monitoring_node.py"
  "$ARTICLE_DIR/pynq/pynq_energy_stream_quality.py"
  "$ARTICLE_DIR/hdl/verilog/energy_quality_check.v"
  "$ARTICLE_DIR/typescript/src/energy_performance_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required energy performance monitoring scaffold files are present."
