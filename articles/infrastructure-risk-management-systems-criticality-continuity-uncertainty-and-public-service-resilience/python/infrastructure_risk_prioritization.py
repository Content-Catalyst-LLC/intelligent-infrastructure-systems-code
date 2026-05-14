from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

RISK_REGISTER = DATA_DIR / "infrastructure_risk_register.csv"
CRITICALITY = DATA_DIR / "criticality_matrix.csv"
CONTINUITY = DATA_DIR / "continuity_recovery_log.csv"
FINANCE = DATA_DIR / "risk_financing_register.csv"
TREATMENT = DATA_DIR / "treatment_mitigation_plan.csv"

def classify_review(row: pd.Series) -> str:
    if row["criticality_score"] >= 0.75 and row["continuity_readiness"] < 0.65:
        return "urgent_continuity_review"
    if row["criticality_score"] >= 0.75 and row["governance_readiness"] < 0.65:
        return "urgent_governance_review"
    if row["residual_risk"] > 0.40:
        return "residual_risk_review"
    if row["mitigation_effectiveness"] < 0.50:
        return "mitigation_review"
    if row["priority_score"] > 0.50:
        return "priority_risk_review"
    return "routine_monitoring"

def main() -> None:
    risks = pd.read_csv(RISK_REGISTER)
    criticality = pd.read_csv(CRITICALITY)
    continuity = pd.read_csv(CONTINUITY)
    finance = pd.read_csv(FINANCE)
    treatment = pd.read_csv(TREATMENT)

    risk_table = (
        risks
        .merge(criticality, on="asset_id", how="left")
        .merge(
            continuity[["risk_id", "fallback_mode", "recovery_time_objective_hours", "exercise_status"]],
            on="risk_id",
            how="left",
        )
        .merge(
            finance[["risk_id", "financing_strategy", "insured", "reserve_required", "finance_owner"]],
            on="risk_id",
            how="left",
        )
    )

    risk_table["basic_risk"] = risk_table["failure_probability"] * risk_table["consequence_score"]
    risk_table["system_risk"] = risk_table["basic_risk"] * (1 + risk_table["dependency_centrality"])
    risk_table["residual_risk"] = risk_table["system_risk"] * (1 - risk_table["mitigation_effectiveness"])
    risk_table["continuity_gap"] = (1 - risk_table["continuity_readiness"]).clip(lower=0)
    risk_table["governance_gap"] = (1 - risk_table["governance_readiness"]).clip(lower=0)

    risk_table["priority_score"] = (
        0.35 * risk_table["residual_risk"]
        + 0.25 * risk_table["criticality_score"]
        + 0.20 * risk_table["continuity_gap"]
        + 0.20 * risk_table["governance_gap"]
    )

    risk_table["review_priority"] = risk_table.apply(classify_review, axis=1)

    priority_cols = [
        "risk_id",
        "asset_id",
        "sector",
        "risk_type",
        "hazard",
        "criticality_score",
        "basic_risk",
        "system_risk",
        "residual_risk",
        "continuity_readiness",
        "governance_readiness",
        "priority_score",
        "review_priority",
        "fallback_mode",
        "recovery_time_objective_hours",
        "financing_strategy",
        "reserve_required",
    ]

    risk_priority = (
        risk_table[priority_cols]
        .round(3)
        .sort_values(["review_priority", "priority_score"], ascending=[True, False])
    )

    priority_output = OUTPUT_DIR / "infrastructure_risk_priority_table.csv"
    risk_priority.to_csv(priority_output, index=False)

    sector_summary = (
        risk_table.groupby("sector", dropna=False)
        .agg(
            risks=("risk_id", "count"),
            mean_criticality=("criticality_score", "mean"),
            mean_basic_risk=("basic_risk", "mean"),
            mean_system_risk=("system_risk", "mean"),
            mean_residual_risk=("residual_risk", "mean"),
            mean_priority=("priority_score", "mean"),
            continuity_reviews=("review_priority", lambda s: int((s == "urgent_continuity_review").sum())),
            governance_reviews=("review_priority", lambda s: int((s == "urgent_governance_review").sum())),
        )
        .reset_index()
        .round(3)
        .sort_values(["mean_priority", "mean_residual_risk"], ascending=[False, False])
    )

    sector_output = OUTPUT_DIR / "infrastructure_risk_sector_summary.csv"
    sector_summary.to_csv(sector_output, index=False)

    treatment_summary = (
        treatment.groupby(["owner", "status"], dropna=False)
        .agg(
            treatments=("treatment_id", "count"),
            total_estimated_cost=("estimated_cost", "sum"),
            mean_mitigation_gain=("mitigation_gain", "mean"),
        )
        .reset_index()
        .round(3)
        .sort_values(["status", "total_estimated_cost"], ascending=[False, False])
    )

    treatment_output = OUTPUT_DIR / "treatment_mitigation_summary.csv"
    treatment_summary.to_csv(treatment_output, index=False)

    governance_watchlist = risk_priority[risk_priority["review_priority"] != "routine_monitoring"]
    watchlist_output = OUTPUT_DIR / "risk_governance_watchlist.csv"
    governance_watchlist.to_csv(watchlist_output, index=False)

    print("Infrastructure risk priority table:")
    print(risk_priority.to_string(index=False))
    print(f"\nWrote: {priority_output}")

    print("\nSector summary:")
    print(sector_summary.to_string(index=False))
    print(f"\nWrote: {sector_output}")

    print("\nTreatment summary:")
    print(treatment_summary.to_string(index=False))
    print(f"\nWrote: {treatment_output}")

    print("\nGovernance watchlist:")
    print(governance_watchlist.to_string(index=False))
    print(f"\nWrote: {watchlist_output}")

if __name__ == "__main__":
    main()
