from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/renewable_infrastructure_objective.yml",
    "data/renewable_asset_inventory.csv",
    "data/grid_connection_constraint_register.csv",
    "data/renewable_generation_forecast_records.csv",
    "data/storage_flexibility_register.csv",
    "data/renewable_reliability_resilience_review.csv",
    "python/renewable_infrastructure_review.py",
    "r/renewable_infrastructure_reporting.R",
    "sql/schema.sql",
    "c/src/renewable_infrastructure_metrics.c",
    "embedded_c/edge_renewable_quality_check.c",
    "fortran/renewable_flexibility_model.f90",
    "go/renewable_status_service.go",
    "rust/src/main.rs",
    "micropython/edge_renewable_monitoring_node.py",
    "pynq/pynq_renewable_stream_quality.py",
    "hdl/verilog/renewable_quality_check.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
