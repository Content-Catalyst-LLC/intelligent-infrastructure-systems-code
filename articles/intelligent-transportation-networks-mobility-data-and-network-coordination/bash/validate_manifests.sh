#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/mobility_objective.yml"
  "$ARTICLE_DIR/config/transportation_scoring_policy.yml"
  "$ARTICLE_DIR/data/transport_network_inventory.csv"
  "$ARTICLE_DIR/data/mobility_telemetry_sample.csv"
  "$ARTICLE_DIR/data/service_performance_review.csv"
  "$ARTICLE_DIR/data/multimodal_coordination_edges.csv"
  "$ARTICLE_DIR/data/safety_accessibility_review.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/intelligent_transportation_network_review.py"
  "$ARTICLE_DIR/r/intelligent_transportation_reporting.R"
  "$ARTICLE_DIR/c/src/transportation_metrics.c"
  "$ARTICLE_DIR/embedded_c/edge_mobility_quality_check.c"
  "$ARTICLE_DIR/fortran/transportation_network_model.f90"
  "$ARTICLE_DIR/go/transportation_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/edge_transportation_node.py"
  "$ARTICLE_DIR/pynq/pynq_transport_stream_quality.py"
  "$ARTICLE_DIR/hdl/verilog/transportation_quality_check.v"
  "$ARTICLE_DIR/typescript/src/transportation_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required intelligent transportation scaffold files are present."
