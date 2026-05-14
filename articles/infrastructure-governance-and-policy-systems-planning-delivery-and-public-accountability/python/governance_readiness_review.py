from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

def load_csv(name: str) -> pd.DataFrame:
    return pd.read_csv(DATA_DIR / name)

def bounded(series: pd.Series) -> pd.Series:
    """Clip governance indicator values into a conservative 0..1 range."""
    return pd.to_numeric(series, errors="coerce").clip(lower=0, upper=1)

def classify(row: pd.Series) -> str:
    if row["governance_quality"] < 0.60:
        return "escalate"
    if row["governance_risk"] > 0.25:
        return "escalate"
    if row["maintenance_backlog_musd"] > 0:
        return "review_required"
    if row["accountability_quality"] < 0.65:
        return "review_required"
    if row["fiscal_risk_status"] == "review_required":
        return "review_required"
    return "ready_with_monitoring"

def main() -> None:
    projects = load_csv("infrastructure_project_register.csv")
    appraisal = load_csv("project_appraisal_register.csv")
    fiscal = load_csv("fiscal_risk_register.csv")
    delivery = load_csv("procurement_delivery_log.csv")
    stewardship = load_csv("asset_stewardship_register.csv")
    accountability = load_csv("accountability_transparency_log.csv")

    df = (
        projects
        .merge(appraisal, on="project_id", how="left")
        .merge(fiscal, on="project_id", how="left")
        .merge(delivery, on="project_id", how="left")
        .merge(stewardship, on="project_id", how="left")
        .merge(accountability, on="project_id", how="left")
    )

    score_columns = [
        "public_value_score",
        "affordability_score",
        "delivery_readiness_score",
        "stewardship_readiness_score",
        "learning_capacity_score",
        "transparency_score",
        "consultation_score",
        "auditability_score",
        "disclosure_usability_score",
        "complexity_score",
        "criticality_score",
    ]

    # Not every input table provides all values. Add a learning capacity proxy.
    if "learning_capacity_score" not in df.columns:
        df["learning_capacity_score"] = df["public_evidence_status"].map(
            {"current": 0.74, "partial": 0.64, "review_required": 0.55}
        ).fillna(0.55)

    for column in score_columns:
        if column in df.columns:
            df[column] = bounded(df[column])

    df["maintenance_backlog_musd"] = (
        df["required_annual_maintenance_musd"] -
        df["funded_annual_maintenance_musd"]
    ).clip(lower=0)

    df["accountability_quality"] = df[
        ["transparency_score", "consultation_score", "auditability_score", "disclosure_usability_score"]
    ].mean(axis=1)

    df["governance_quality"] = (
        0.20 * df["public_value_score"] +
        0.15 * df["affordability_score"] +
        0.15 * df["delivery_readiness_score"] +
        0.20 * df["stewardship_readiness_score"] +
        0.15 * df["accountability_quality"] +
        0.15 * df["learning_capacity_score"]
    )

    df["governance_risk"] = (
        (1 - df["governance_quality"]) *
        df["complexity_score"] *
        df["criticality_score"]
    )

    df["readiness_status"] = df.apply(classify, axis=1)

    review = df[
        [
            "project_id",
            "project_name",
            "sector",
            "capital_cost_musd",
            "governance_quality",
            "governance_risk",
            "maintenance_backlog_musd",
            "accountability_quality",
            "fiscal_risk_status",
            "readiness_status",
        ]
    ].sort_values(["readiness_status", "governance_risk"], ascending=[True, False])

    sector_summary = (
        df.groupby("sector", as_index=False)
        .agg(
            projects=("project_id", "count"),
            avg_governance_quality=("governance_quality", "mean"),
            avg_governance_risk=("governance_risk", "mean"),
            maintenance_backlog_musd=("maintenance_backlog_musd", "sum"),
            escalation_count=("readiness_status", lambda s: (s == "escalate").sum()),
            review_required_count=("readiness_status", lambda s: (s == "review_required").sum()),
        )
        .sort_values("avg_governance_risk", ascending=False)
    )

    review.to_csv(OUTPUT_DIR / "governance_readiness_review.csv", index=False)
    sector_summary.to_csv(OUTPUT_DIR / "governance_sector_summary.csv", index=False)

    print("\nInfrastructure governance readiness review")
    print(review.to_string(index=False))
    print("\nSector summary")
    print(sector_summary.to_string(index=False))

if __name__ == "__main__":
    main()
