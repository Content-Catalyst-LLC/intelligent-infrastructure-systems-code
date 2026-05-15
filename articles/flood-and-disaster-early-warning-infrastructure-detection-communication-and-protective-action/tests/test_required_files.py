from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/early_warning_objective.yml",
    "data/hazard_exposure_register.csv",
    "data/warning_channel_register.csv",
    "python/early_warning_chain_review.py",
    "r/early_warning_reporting.R",
    "sql/schema.sql",
    "c/src/warning_chain_math.c",
    "embedded_c/edge_threshold_detector.c",
    "fortran/warning_risk_model.f90",
    "go/early_warning_status_service.go",
    "rust/src/main.rs",
    "micropython/rainfall_river_stage_node.py",
    "pynq/pynq_threshold_stream.py",
    "hdl/verilog/early_warning_threshold.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
