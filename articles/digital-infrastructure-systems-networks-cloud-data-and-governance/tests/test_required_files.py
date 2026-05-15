from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/digital_infrastructure_objective.yml",
    "data/connectivity_infrastructure_inventory.csv",
    "data/cloud_data_infrastructure_register.csv",
    "data/interoperability_exchange_register.csv",
    "data/identity_trust_register.csv",
    "data/digital_dependency_continuity_review.csv",
    "data/access_inclusion_review.csv",
    "data/digital_infrastructure_governance_action_log.csv",
    "python/digital_infrastructure_review.py",
    "r/digital_infrastructure_reporting.R",
    "sql/schema.sql",
    "c/src/digital_infrastructure_capacity_metrics.c",
    "embedded_c/edge_service_continuity_check.c",
    "fortran/digital_infrastructure_resilience_model.f90",
    "go/digital_infrastructure_status_service.go",
    "rust/src/main.rs",
    "micropython/edge_service_health_node.py",
    "pynq/pynq_packet_latency_validator.py",
    "hdl/verilog/packet_latency_validator.v",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
