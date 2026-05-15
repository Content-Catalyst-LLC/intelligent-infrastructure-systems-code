from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/urban_resilience_objective.yml",
    "data/hazard_stress_register.csv",
    "data/critical_service_inventory.csv",
    "data/infrastructure_dependency_edges.csv",
    "data/continuity_recovery_plan.csv",
    "data/vulnerability_service_equity_review.csv",
    "python/urban_resilience_service_continuity_review.py",
    "r/urban_resilience_reporting.R",
    "sql/schema.sql",
    "c/src/urban_resilience_metrics.c",
    "embedded_c/service_status_quality_check.c",
    "fortran/urban_resilience_model.f90",
    "go/urban_resilience_status_service.go",
    "rust/src/main.rs",
    "micropython/urban_service_status_node.py",
    "pynq/pynq_service_continuity_stream.py",
    "hdl/verilog/service_continuity_check.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
