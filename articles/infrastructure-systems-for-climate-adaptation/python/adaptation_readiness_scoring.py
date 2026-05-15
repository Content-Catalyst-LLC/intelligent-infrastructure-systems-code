from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_PATH = ARTICLE_DIR / "data" / "adaptation_readiness_scores.csv"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

WEIGHTS = {
    "scenario_credibility": 0.18,
    "dependency_mapping": 0.14,
    "service_protection": 0.16,
    "equity_screen": 0.14,
    "finance_readiness": 0.14,
    "maintenance_readiness": 0.10,
    "observability": 0.10,
    "governance_clarity": 0.04,
}

def as_bool(value) -> bool:
    if isinstance(value, bool):
        return value
    return str(value).strip().lower() in {"true", "1", "yes", "y"}

def readiness_score(row: pd.Series) -> float:
    return sum(row[column] * weight for column, weight in WEIGHTS.items())

def classify_review_priority(row: pd.Series) -> str:
    if row["maladaptation_risk"] >= 0.65:
        return "maladaptation_review_required"
    if as_bool(row["high_stakes_use"]) and row["equity_screen"] < 0.70:
        return "high_stakes_equity_review"
    if row["finance_readiness"] < 0.70:
        return "finance_gap"
    if row["maintenance_readiness"] < 0.70:
        return "maintenance_gap"
    if row["dependency_mapping"] < 0.70:
        return "dependency_mapping_review"
    if row["adaptation_readiness"] < 0.75:
        return "readiness_review"
    return "implementation_ready"

def main() -> None:
    df = pd.read_csv(DATA_PATH)
    df["adaptation_readiness"] = df.apply(readiness_score, axis=1).round(3)
    df["review_priority"] = df.apply(classify_review_priority, axis=1)
    out = df.sort_values(["review_priority", "adaptation_readiness"])
    output_path = OUTPUT_DIR / "adaptation_readiness_results.csv"
    out.to_csv(output_path, index=False)
    print(out.to_string(index=False))
    print(f"Wrote: {output_path}")

if __name__ == "__main__":
    main()
