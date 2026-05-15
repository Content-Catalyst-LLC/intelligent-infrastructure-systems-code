from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/mobility_objective.yml",
    "data/transport_network_inventory.csv",
    "data/mobility_telemetry_sample.csv",
    "data/service_performance_review.csv",
    "data/multimodal_coordination_edges.csv",
    "data/safety_accessibility_review.csv",
    "python/intelligent_transportation_network_review.py",
    "r/intelligent_transportation_reporting.R",
    "sql/schema.sql",
    "c/src/transportation_metrics.c",
    "embedded_c/edge_mobility_quality_check.c",
    "fortran/transportation_network_model.f90",
    "go/transportation_status_service.go",
    "rust/src/main.rs",
    "micropython/edge_transportation_node.py",
    "pynq/pynq_transport_stream_quality.py",
    "hdl/verilog/transportation_quality_check.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
