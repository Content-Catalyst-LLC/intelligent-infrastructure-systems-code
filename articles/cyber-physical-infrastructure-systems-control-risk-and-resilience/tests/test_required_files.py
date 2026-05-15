from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/cyber_physical_objective.yml",
    "data/cyber_physical_asset_inventory.csv",
    "data/control_loop_register.csv",
    "data/telemetry_command_records.csv",
    "data/dependency_exposure_map.csv",
    "data/assurance_fallback_review.csv",
    "data/cyber_physical_governance_action_log.csv",
    "python/cyber_physical_infrastructure_review.py",
    "r/cyber_physical_infrastructure_reporting.R",
    "sql/schema.sql",
    "c/src/control_integrity_metrics.c",
    "embedded_c/edge_control_safety_check.c",
    "fortran/cyber_physical_resilience_model.f90",
    "go/cyber_physical_status_service.go",
    "rust/src/main.rs",
    "micropython/edge_control_node.py",
    "pynq/pynq_control_stream_integrity.py",
    "hdl/verilog/control_stream_integrity.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
