from __future__ import annotations

import csv
import json
from pathlib import Path

from adaptation_infrastructure.core import review_record

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_PATH = ARTICLE_DIR / "data" / "adaptation_readiness_scores.csv"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def main() -> None:
    with DATA_PATH.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    enriched: list[dict[str, object]] = []
    for row in rows:
        result = review_record(row)
        enriched.append(
            {
                **row,
                "adaptation_readiness": result.readiness_score,
                "net_adaptation_readiness": result.net_readiness_score,
                "review_priority": result.review_priority,
                "review_flags": ";".join(result.flags) if result.flags else "none",
            }
        )

    enriched.sort(key=lambda r: (str(r["review_priority"]), float(r["net_adaptation_readiness"])))

    csv_path = OUTPUT_DIR / "adaptation_readiness_results.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=list(enriched[0].keys()))
        writer.writeheader()
        writer.writerows(enriched)

    summary = {
        "record_count": len(enriched),
        "review_counts": {},
        "minimum_net_readiness": min(float(row["net_adaptation_readiness"]) for row in enriched),
        "maximum_net_readiness": max(float(row["net_adaptation_readiness"]) for row in enriched),
    }
    for row in enriched:
        key = str(row["review_priority"])
        summary["review_counts"][key] = summary["review_counts"].get(key, 0) + 1

    json_path = OUTPUT_DIR / "adaptation_readiness_summary.json"
    json_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")

    for row in enriched:
        print(
            f"{row['program_id']}: net={row['net_adaptation_readiness']} "
            f"priority={row['review_priority']} flags={row['review_flags']}"
        )
    print(f"Wrote: {csv_path}")
    print(f"Wrote: {json_path}")


if __name__ == "__main__":
    main()
