from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

EXPECTED = [
    "README.md",
    "companion_manifest.yml",
    "config/climate_scenario_manifest.yml",
    "data/adaptation_readiness_scores.csv",
    "python/adaptation_readiness_scoring.py",
    "r/adaptation_portfolio_reporting.R",
    "sql/schema.sql",
    "docs/readiness_gate.md",
]

def test_expected_files_exist():
    missing = [path for path in EXPECTED if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing expected files: {missing}"
