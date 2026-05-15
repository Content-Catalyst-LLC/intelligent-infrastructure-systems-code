from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/smart_grid_objective.yml",
    "data/grid_asset_inventory.csv",
    "data/grid_telemetry_records.csv",
    "data/distributed_resource_coordination_register.csv",
    "data/grid_reliability_resilience_review.csv",
    "data/cyber_physical_grid_review.csv",
    "python/smart_grid_infrastructure_review.py",
    "r/smart_grid_infrastructure_reporting.R",
    "sql/schema.sql",
    "c/src/smart_grid_metrics.c",
    "embedded_c/edge_grid_quality_check.c",
    "fortran/grid_resilience_model.f90",
    "go/smart_grid_status_service.go",
    "rust/src/main.rs",
    "micropython/edge_grid_quality_node.py",
    "pynq/pynq_grid_stream_quality.py",
    "hdl/verilog/grid_quality_check.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
