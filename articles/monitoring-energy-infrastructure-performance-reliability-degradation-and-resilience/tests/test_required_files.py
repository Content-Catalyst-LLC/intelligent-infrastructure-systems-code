from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/energy_monitoring_objective.yml",
    "data/energy_asset_inventory.csv",
    "data/energy_performance_telemetry.csv",
    "data/condition_degradation_log.csv",
    "data/reliability_resilience_review.csv",
    "data/power_quality_stability_records.csv",
    "python/energy_infrastructure_performance_review.py",
    "r/energy_infrastructure_performance_reporting.R",
    "sql/schema.sql",
    "c/src/energy_performance_metrics.c",
    "embedded_c/edge_energy_quality_check.c",
    "fortran/energy_resilience_model.f90",
    "go/energy_asset_status_service.go",
    "rust/src/main.rs",
    "micropython/edge_energy_monitoring_node.py",
    "pynq/pynq_energy_stream_quality.py",
    "hdl/verilog/energy_quality_check.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
