from pathlib import Path

ARTICLE_DIR = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "companion_manifest.yml",
    "config/adaptation_objective.yml",
    "data/infrastructure_exposure_inventory.csv",
    "data/adaptation_option_portfolio.csv",
    "python/adaptation_readiness_review.py",
    "r/adaptation_portfolio_reporting.R",
    "sql/schema.sql",
]


def test_required_files_exist():
    missing = [path for path in REQUIRED_FILES if not (ARTICLE_DIR / path).exists()]
    assert not missing, f"Missing required files: {missing}"
