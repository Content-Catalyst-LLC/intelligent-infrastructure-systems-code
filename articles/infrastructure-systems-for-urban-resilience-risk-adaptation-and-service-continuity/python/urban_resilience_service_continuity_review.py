from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def load_inputs() -> tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame, pd.DataFrame, pd.DataFrame]:
    hazards = pd.read_csv(DATA_DIR / "hazard_stress_register.csv")
    services = pd.read_csv(DATA_DIR / "critical_service_inventory.csv")
    dependencies = pd.read_csv(DATA_DIR / "infrastructure_dependency_edges.csv")
    equity = pd.read_csv(DATA_DIR / "vulnerability_service_equity_review.csv")
    continuity = pd.read_csv(DATA_DIR / "continuity_recovery_plan.csv")
    return hazards, services, dependencies, equity, continuity


def compute_dependency_stress(services: pd.DataFrame, dependencies: pd.DataFrame) -> pd.DataFrame:
    return (
        dependencies
        .merge(
            services[["service_id", "service_failure_probability"]],
            left_on="dependent_service_id",
            right_on="service_id",
            how="left"
        )
        .assign(
            dependency_stress=lambda df: df["dependency_weight"] * df["service_failure_probability"].fillna(0)
        )
        .groupby("source_service_id", as_index=False)["dependency_stress"]
        .sum()
        .rename(columns={"source_service_id": "service_id"})
    )


def build_review() -> pd.DataFrame:
    hazards, services, dependencies, equity, continuity = load_inputs()

    zone_hazards = (
        hazards.groupby("service_zone_id", as_index=False)
        .agg(
            hazard_intensity=("hazard_intensity", "max"),
            exposure_score=("exposure_score", "max"),
            hazard_types=("hazard_type", lambda x: ";".join(sorted(set(x)))),
        )
    )

    review = (
        services
        .merge(continuity, on="service_id", how="left")
        .merge(equity, on="service_zone_id", how="left")
        .merge(zone_hazards, on="service_zone_id", how="left")
    )

    review["service_continuity_score"] = (
        review["disruption_capacity"] / review["normal_capacity"]
    ).clip(upper=1.0)

    review["recovery_lag_hours"] = (
        review["expected_recovery_hours"] - review["target_recovery_hours"]
    ).clip(lower=0)

    review["urban_risk_score"] = (
        review["hazard_intensity"]
        * review["exposure_score"]
        * review["vulnerability_score"]
        * (1 - review["governance_response_score"])
    )

    review["service_resilience_score"] = (
        0.30 * review["service_continuity_score"]
        + 0.20 * review["redundancy_score"]
        + 0.20 * review["maintainability_score"]
        + 0.15 * review["adaptability_score"]
        + 0.15 * review["governance_response_score"]
    )

    dependency_stress = compute_dependency_stress(services, dependencies)
    review = review.merge(dependency_stress, on="service_id", how="left")
    review["dependency_stress"] = review["dependency_stress"].fillna(0)

    review["resilience_review_flag"] = (
        (review["service_continuity_score"] < 0.75)
        | (review["recovery_lag_hours"] > 0)
        | (review["urban_risk_score"] >= 0.25)
        | (review["dependency_stress"] >= 0.30)
        | (review["equity_gap_score"] >= 0.35)
        | (review["continuity_plan_status"].eq("review_required"))
    )

    return review


def main() -> None:
    review = build_review()

    review.to_csv(OUTPUT_DIR / "urban_resilience_service_continuity_review.csv", index=False)

    watchlist = (
        review[review["resilience_review_flag"]]
        .sort_values(
            ["urban_risk_score", "dependency_stress", "recovery_lag_hours"],
            ascending=[False, False, False],
        )
    )

    watchlist.to_csv(OUTPUT_DIR / "urban_resilience_governance_watchlist.csv", index=False)

    domain_summary = (
        review.groupby("service_domain", as_index=False)
        .agg(
            services=("service_id", "nunique"),
            mean_service_continuity=("service_continuity_score", "mean"),
            mean_recovery_lag_hours=("recovery_lag_hours", "mean"),
            mean_dependency_stress=("dependency_stress", "mean"),
            mean_urban_risk=("urban_risk_score", "mean"),
            mean_equity_gap=("equity_gap_score", "mean"),
            review_flags=("resilience_review_flag", "sum"),
        )
        .sort_values("mean_urban_risk", ascending=False)
    )

    domain_summary.to_csv(OUTPUT_DIR / "urban_resilience_domain_summary.csv", index=False)

    print("Urban resilience service continuity review written to outputs/urban_resilience_service_continuity_review.csv")
    print("Urban resilience governance watchlist written to outputs/urban_resilience_governance_watchlist.csv")
    print(watchlist[[
        "service_id",
        "service_name",
        "service_zone_id",
        "service_continuity_score",
        "recovery_lag_hours",
        "dependency_stress",
        "urban_risk_score",
        "equity_gap_score",
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
