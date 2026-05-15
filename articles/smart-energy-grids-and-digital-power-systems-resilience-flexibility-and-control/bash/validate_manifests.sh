#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/smart_grid_objective.yml"
  "$ARTICLE_DIR/config/smart_grid_scoring_policy.yml"
  "$ARTICLE_DIR/data/grid_asset_inventory.csv"
  "$ARTICLE_DIR/data/grid_telemetry_records.csv"
  "$ARTICLE_DIR/data/distributed_resource_coordination_register.csv"
  "$ARTICLE_DIR/data/grid_reliability_resilience_review.csv"
  "$ARTICLE_DIR/data/cyber_physical_grid_review.csv"
  "$ARTICLE_DIR/data/grid_governance_interoperability_log.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/smart_grid_infrastructure_review.py"
  "$ARTICLE_DIR/r/smart_grid_infrastructure_reporting.R"
  "$ARTICLE_DIR/c/src/smart_grid_metrics.c"
  "$ARTICLE_DIR/embedded_c/edge_grid_quality_check.c"
  "$ARTICLE_DIR/fortran/grid_resilience_model.f90"
  "$ARTICLE_DIR/go/smart_grid_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/edge_grid_quality_node.py"
  "$ARTICLE_DIR/pynq/pynq_grid_stream_quality.py"
  "$ARTICLE_DIR/hdl/verilog/grid_quality_check.v"
  "$ARTICLE_DIR/typescript/src/smart_grid_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required smart grid scaffold files are present."
