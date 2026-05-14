from __future__ import annotations

from pathlib import Path
import numpy as np
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

ASSET_REGISTER = DATA_DIR / "asset_register.csv"
CONDITION = DATA_DIR / "condition_inspections.csv"
CRITICALITY = DATA_DIR / "criticality_scores.csv"
LCC = DATA_DIR / "lifecycle_cost_scenarios.csv"

def estimate_failure_probability(age_years: pd.Series, condition_score: pd.Series, criticality_score: pd.Series) -> pd.Series:
    linear_risk = (
        -3.0
        + 0.045 * age_years
        + 2.5 * (1 - condition_score)
        + 0.8 * criticality_score
    )
    return 1 / (1 + np.exp(-linear_risk))

def recommended_strategy(priority_score: float) -> str:
    if priority_score >= 0.70:
        return "urgent_review"
    if priority_score >= 0.55:
        return "planned_intervention"
    if priority_score >= 0.40:
        return "condition_based_maintenance"
    return "monitor"

def main() -> None:
    assets = pd.read_csv(ASSET_REGISTER)
    condition = pd.read_csv(CONDITION).sort_values("inspection_date").drop_duplicates("asset_id", keep="last")
    criticality = pd.read_csv(CRITICALITY)
    lcc = pd.read_csv(LCC)

    portfolio = (
        assets
        .merge(condition[["asset_id", "condition_score", "defect_score", "inspection_date"]], on="asset_id", how="left")
        .merge(criticality[["asset_id", "criticality_score", "service_consequence", "environmental_consequence", "equity_consequence"]], on="asset_id", how="left")
    )

    portfolio["age_years"] = 2026 - portfolio["install_year"]
    portfolio["failure_probability"] = estimate_failure_probability(
        portfolio["age_years"],
        portfolio["condition_score"],
        portfolio["criticality_score"],
    )
    portfolio["risk_score"] = portfolio["failure_probability"] * portfolio["criticality_score"]

    portfolio["priority_score"] = (
        0.35 * (1 - portfolio["condition_score"])
        + 0.25 * portfolio["failure_probability"]
        + 0.25 * portfolio["criticality_score"]
        + 0.10 * (portfolio["environmental_consequence"] / 5)
        + 0.05 * (portfolio["equity_consequence"] / 5)
    )

    portfolio["recommended_strategy"] = portfolio["priority_score"].apply(recommended_strategy)

    shortlist = portfolio.sort_values("priority_score", ascending=False).reset_index(drop=True)
    shortlist_path = OUTPUT_DIR / "asset_priority_shortlist.csv"
    shortlist.to_csv(shortlist_path, index=False)

    strategy_summary = (
        portfolio.groupby(["asset_class", "recommended_strategy"], dropna=False)
        .agg(
            asset_count=("asset_id", "count"),
            mean_condition=("condition_score", "mean"),
            mean_failure_probability=("failure_probability", "mean"),
            mean_criticality=("criticality_score", "mean"),
            mean_priority=("priority_score", "mean"),
        )
        .reset_index()
        .round(3)
        .sort_values(["recommended_strategy", "mean_priority"], ascending=[True, False])
    )
    summary_path = OUTPUT_DIR / "asset_strategy_summary.csv"
    strategy_summary.to_csv(summary_path, index=False)

    lcc_summary = (
        lcc.groupby(["asset_id", "strategy"], dropna=False)
        .agg(total_cost_proxy=("total_cost_proxy", "sum"))
        .reset_index()
        .sort_values(["asset_id", "total_cost_proxy"])
    )
    lcc_path = OUTPUT_DIR / "lifecycle_cost_comparison.csv"
    lcc_summary.to_csv(lcc_path, index=False)

    print("Asset priority shortlist")
    print(shortlist[[
        "asset_id",
        "asset_class",
        "asset_name",
        "age_years",
        "condition_score",
        "criticality_score",
        "failure_probability",
        "risk_score",
        "priority_score",
        "recommended_strategy",
    ]].to_string(index=False))

    print(f"\nWrote: {shortlist_path}")
    print(f"Wrote: {summary_path}")
    print(f"Wrote: {lcc_path}")

if __name__ == "__main__":
    main()
