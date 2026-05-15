#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/companion_manifest.yml"
  "$ARTICLE_DIR/config/urban_resilience_objective.yml"
  "$ARTICLE_DIR/config/resilience_scoring_policy.yml"
  "$ARTICLE_DIR/data/hazard_stress_register.csv"
  "$ARTICLE_DIR/data/critical_service_inventory.csv"
  "$ARTICLE_DIR/data/infrastructure_dependency_edges.csv"
  "$ARTICLE_DIR/data/continuity_recovery_plan.csv"
  "$ARTICLE_DIR/data/vulnerability_service_equity_review.csv"
  "$ARTICLE_DIR/data/nature_based_resilience_register.csv"
  "$ARTICLE_DIR/sql/schema.sql"
  "$ARTICLE_DIR/python/urban_resilience_service_continuity_review.py"
  "$ARTICLE_DIR/r/urban_resilience_reporting.R"
  "$ARTICLE_DIR/c/src/urban_resilience_metrics.c"
  "$ARTICLE_DIR/embedded_c/service_status_quality_check.c"
  "$ARTICLE_DIR/fortran/urban_resilience_model.f90"
  "$ARTICLE_DIR/go/urban_resilience_status_service.go"
  "$ARTICLE_DIR/rust/src/main.rs"
  "$ARTICLE_DIR/micropython/urban_service_status_node.py"
  "$ARTICLE_DIR/pynq/pynq_service_continuity_stream.py"
  "$ARTICLE_DIR/hdl/verilog/service_continuity_check.v"
  "$ARTICLE_DIR/typescript/src/urban_resilience_dashboard_model.ts"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "All required urban resilience infrastructure scaffold files are present."
