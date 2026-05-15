from __future__ import annotations

import csv
from pathlib import Path

from adaptation_infrastructure.core import service_continuity

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_PATH = ARTICLE_DIR / "data" / "service_continuity_records.csv"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def priority(score: float, priority_population: bool) -> str:
    if priority_population and score < 0.75:
        return "priority_population_service_gap"
    if score < 0.70:
        return "service_continuity_gap"
    if score < 0.85:
        return "monitoring_required"
    return "continuity_target_supported"


def as_bool(value: object) -> bool:
    return str(value).strip().lower() in {"true", "1", "yes", "y"}


def main() -> None:
    with DATA_PATH.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    output = []
    for row in rows:
        score = service_continuity(float(row["outage_hours"]), float(row["critical_hours"]))
        flag = priority(score, as_bool(row["priority_population_flag"]))
        output.append({**row, "service_continuity_score": score, "continuity_priority": flag})

    out_path = OUTPUT_DIR / "service_continuity_results.csv"
    with out_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=list(output[0].keys()))
        writer.writeheader()
        writer.writerows(output)

    for row in output:
        print(f"{row['service_id']} {row['scenario_id']}: {row['service_continuity_score']} {row['continuity_priority']}")
    print(f"Wrote: {out_path}")


if __name__ == "__main__":
    main()
