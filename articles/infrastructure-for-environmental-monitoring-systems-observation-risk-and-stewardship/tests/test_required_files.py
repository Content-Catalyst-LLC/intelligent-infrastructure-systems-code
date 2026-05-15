from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/environmental_monitoring_objective.yml",
    "data/monitoring_site_inventory.csv",
    "data/environmental_observations_sample.csv",
    "data/environmental_threshold_indicator_catalog.csv",
    "data/calibration_device_health_log.csv",
    "python/environmental_monitoring_indicator_review.py",
    "r/environmental_monitoring_reporting.R",
    "sql/schema.sql",
    "c/src/environmental_monitoring_quality.c",
    "embedded_c/environmental_sensor_quality_check.c",
    "fortran/environmental_risk_model.f90",
    "go/environmental_monitoring_status_service.go",
    "rust/src/main.rs",
    "micropython/environmental_monitoring_node.py",
    "pynq/pynq_environmental_stream_quality.py",
    "hdl/verilog/environmental_quality_check.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
