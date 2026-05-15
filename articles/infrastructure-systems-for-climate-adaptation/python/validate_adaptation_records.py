from __future__ import annotations

import csv
from pathlib import Path

from adaptation_infrastructure.core import REQUIRED_SCORE_FIELDS, parse_bool, parse_float, require_columns

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_PATH = ARTICLE_DIR / "data" / "adaptation_readiness_scores.csv"

REQUIRED_COLUMNS = {
    "program_id",
    "project_name",
    "infrastructure_domain",
    "primary_hazard",
    "high_stakes_use",
    *REQUIRED_SCORE_FIELDS,
}


def main() -> None:
    with DATA_PATH.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        require_columns(reader.fieldnames or [], REQUIRED_COLUMNS)
        row_count = 0
        for row in reader:
            row_count += 1
            for field in REQUIRED_SCORE_FIELDS:
                parse_float(row, field)
            parse_bool(row["high_stakes_use"])
            if not row["program_id"].strip():
                raise ValueError("program_id cannot be empty")
        if row_count == 0:
            raise ValueError("No adaptation readiness records found")
    print(f"Validated {row_count} adaptation readiness records: {DATA_PATH}")


if __name__ == "__main__":
    main()
