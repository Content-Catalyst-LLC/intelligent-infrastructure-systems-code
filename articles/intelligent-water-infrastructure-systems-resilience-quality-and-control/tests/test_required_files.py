from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/water_infrastructure_objective.yml",
    "data/water_asset_inventory.csv",
    "data/water_telemetry_records.csv",
    "data/water_quality_public_health_review.csv",
    "data/leakage_hydraulic_control_review.csv",
    "data/wastewater_stormwater_risk_review.csv",
    "python/intelligent_water_infrastructure_review.py",
    "r/intelligent_water_infrastructure_reporting.R",
    "sql/schema.sql",
    "c/src/water_infrastructure_metrics.c",
    "embedded_c/edge_water_quality_check.c",
    "fortran/water_resilience_model.f90",
    "go/water_status_service.go",
    "rust/src/main.rs",
    "micropython/edge_water_quality_node.py",
    "pynq/pynq_water_stream_quality.py",
    "hdl/verilog/water_quality_check.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
