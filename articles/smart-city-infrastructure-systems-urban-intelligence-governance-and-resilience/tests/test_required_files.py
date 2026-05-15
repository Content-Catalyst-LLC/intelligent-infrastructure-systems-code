from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/smart_city_objective.yml",
    "data/urban_infrastructure_inventory.csv",
    "data/urban_observability_records.csv",
    "data/cross_domain_dependency_edges.csv",
    "data/public_value_indicator_catalog.csv",
    "data/digital_inclusion_rights_review.csv",
    "python/smart_city_infrastructure_review.py",
    "r/smart_city_infrastructure_reporting.R",
    "sql/schema.sql",
    "c/src/smart_city_metrics.c",
    "embedded_c/edge_smart_city_quality_check.c",
    "fortran/smart_city_performance_model.f90",
    "go/smart_city_status_service.go",
    "rust/src/main.rs",
    "micropython/edge_smart_city_node.py",
    "pynq/pynq_smart_city_stream_quality.py",
    "hdl/verilog/smart_city_quality_check.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
