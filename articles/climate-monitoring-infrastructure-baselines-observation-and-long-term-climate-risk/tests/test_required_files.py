from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/climate_monitoring_objective.yml",
    "data/essential_climate_variable_map.csv",
    "data/climate_observation_platforms.csv",
    "data/instrument_metadata_calibration_log.csv",
    "data/climate_observations_sample.csv",
    "python/climate_baseline_anomaly_review.py",
    "r/climate_station_trend_reporting.R",
    "sql/schema.sql",
    "c/src/climate_record_quality.c",
    "embedded_c/station_sensor_quality_check.c",
    "fortran/climate_baseline_model.f90",
    "go/climate_monitoring_status_service.go",
    "rust/src/main.rs",
    "micropython/climate_station_node.py",
    "pynq/pynq_climate_stream_quality.py",
    "hdl/verilog/climate_quality_check.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
