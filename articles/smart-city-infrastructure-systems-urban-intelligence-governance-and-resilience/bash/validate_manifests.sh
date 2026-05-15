#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/smart_city_objective.yml"
  "$ARTICLE_DIR/config/smart_city_scoring_policy.yml"
  "$ARTICLE_DIR/data/urban_infrastructure_inventory.csv"
  "$ARTICLE_DIR/data/urban_observability_records.csv"
  "$ARTICLE_DIR/data/cross_domain_dependency_edges.csv"
  "$ARTICLE_DIR/data/public_value_indicator_catalog.csv"
  "$ARTICLE_DIR/data/digital_inclusion_rights_review.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/smart_city_infrastructure_review.py"
  "$ARTICLE_DIR/r/smart_city_infrastructure_reporting.R"
  "$ARTICLE_DIR/c/src/smart_city_metrics.c"
  "$ARTICLE_DIR/embedded_c/edge_smart_city_quality_check.c"
  "$ARTICLE_DIR/fortran/smart_city_performance_model.f90"
  "$ARTICLE_DIR/go/smart_city_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/edge_smart_city_node.py"
  "$ARTICLE_DIR/pynq/pynq_smart_city_stream_quality.py"
  "$ARTICLE_DIR/hdl/verilog/smart_city_quality_check.v"
  "$ARTICLE_DIR/typescript/src/smart_city_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required smart city infrastructure scaffold files are present."
