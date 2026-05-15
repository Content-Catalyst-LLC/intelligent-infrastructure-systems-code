from pathlib import Path
import csv
import sys
import unittest

ARTICLE_DIR = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ARTICLE_DIR / "python"))

from adaptation_infrastructure.core import review_record, service_continuity  # noqa: E402


class AdaptationWorkflowTests(unittest.TestCase):
    def test_expected_files_exist(self):
        expected = [
            "README.md",
            "companion_manifest.yml",
            "config/climate_scenario_manifest.yml",
            "data/adaptation_readiness_scores.csv",
            "data/dependency_edges.csv",
            "python/adaptation_readiness_scoring.py",
            "python/service_continuity_analysis.py",
            "r/adaptation_portfolio_reporting.R",
            "sql/schema.sql",
            "sql/load_sample_data.sql",
            "docs/readiness_gate.md",
        ]
        missing = [path for path in expected if not (ARTICLE_DIR / path).exists()]
        self.assertEqual(missing, [])

    def test_readiness_records_score(self):
        data_path = ARTICLE_DIR / "data" / "adaptation_readiness_scores.csv"
        with data_path.open(newline="", encoding="utf-8") as f:
            rows = list(csv.DictReader(f))
        self.assertGreaterEqual(len(rows), 5)
        result = review_record(rows[0])
        self.assertGreaterEqual(result.readiness_score, 0)
        self.assertLessEqual(result.readiness_score, 1)

    def test_service_continuity_bounds(self):
        self.assertEqual(service_continuity(0, 2), 1.0)
        self.assertEqual(service_continuity(2, 2), 0.0)
        self.assertEqual(service_continuity(5, 2), 0.0)


if __name__ == "__main__":
    unittest.main()
