from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/monitoring_objective.yml",
    "data/sensor_inventory.csv",
    "data/monitored_asset_registry.csv",
    "data/sensor_telemetry_records.csv",
    "data/calibration_validation_log.csv",
    "data/coverage_blindspot_review.csv",
    "data/monitoring_alert_response_register.csv",
    "python/infrastructure_monitoring_review.py",
    "r/infrastructure_monitoring_reporting.R",
    "sql/schema.sql",
    "c/src/monitoring_observability_metrics.c",
    "embedded_c/edge_sensor_quality_check.c",
    "fortran/monitoring_resilience_model.f90",
    "go/monitoring_status_service.go",
    "rust/src/main.rs",
    "micropython/edge_monitoring_node.py",
    "pynq/pynq_monitoring_stream_quality.py",
    "hdl/verilog/monitoring_stream_quality.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
