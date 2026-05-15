from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/urban_sensing_objective.yml",
    "data/urban_sensor_inventory.csv",
    "data/urban_sensor_telemetry_sample.csv",
    "data/sensor_asset_linkage.csv",
    "data/calibration_device_health_log.csv",
    "data/coverage_exposure_review.csv",
    "data/urban_sensor_indicator_catalog.csv",
    "python/urban_sensor_network_monitoring_review.py",
    "r/urban_sensor_network_reporting.R",
    "sql/schema.sql",
    "c/src/urban_sensor_quality.c",
    "embedded_c/edge_sensor_quality_check.c",
    "fortran/urban_observability_model.f90",
    "go/urban_sensor_status_service.go",
    "rust/src/main.rs",
    "micropython/urban_sensor_node.py",
    "pynq/pynq_urban_sensor_stream_quality.py",
    "hdl/verilog/urban_sensor_quality_check.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
