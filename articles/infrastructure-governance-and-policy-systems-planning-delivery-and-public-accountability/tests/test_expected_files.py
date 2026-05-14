from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

EXPECTED = [
    "README.md",
    "companion_manifest.yml",
    "config/governance_objective.yml",
    "config/governance_scoring_policy.yml",
    "data/infrastructure_project_register.csv",
    "data/project_appraisal_register.csv",
    "data/fiscal_risk_register.csv",
    "data/procurement_delivery_log.csv",
    "data/asset_stewardship_register.csv",
    "data/accountability_transparency_log.csv",
    "python/governance_readiness_review.py",
    "r/governance_reporting.R",
    "sql/schema.sql",
]

def test_expected_files_exist():
    missing = [path for path in EXPECTED if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing expected files: {missing}"
