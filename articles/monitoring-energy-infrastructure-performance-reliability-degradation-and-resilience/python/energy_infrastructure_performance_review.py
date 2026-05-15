from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def build_review() -> pd.DataFrame:
    assets = pd.read_csv(DATA_DIR / "energy_asset_inventory.csv")
    telemetry = pd.read_csv(DATA_DIR / "energy_performance_telemetry.csv", parse_dates=["timestamp"])
    condition = pd.read_csv(DATA_DIR / "condition_degradation_log.csv")
    resilience = pd.read_csv(DATA_DIR / "reliability_resilience_review.csv")
    power_quality = pd.read_csv(DATA_DIR / "power_quality_stability_records.csv")

    review = (
        telemetry
        .merge(assets, on="asset_id", how="left")
        .merge(condition, on="asset_id", how="left")
        .merge(resilience, on="asset_id", how="left")
        .merge(power_quality, on="asset_id", how="left")
    )

    review["availability_score"] = (
        review["available_hours"] / review["total_hours"]
    ).clip(lower=0, upper=1)

    demand = review["power_demand_mw"].replace(0, pd.NA)
    review["service_continuity_score"] = (
        review["power_served_mw"] / demand
    ).fillna(1.0).clip(lower=0, upper=1)

    review["degradation_score"] = (
        (review["baseline_health_score"] - review["current_health_score"])
        / review["baseline_health_score"]
    ).clip(lower=0, upper=1)

    review["stress_score"] = (
        0.30 * review["loading_stress_score"]
        + 0.25 * review["thermal_stress_score"]
        + 0.25 * review["cycling_stress_score"]
        + 0.20 * review["environmental_exposure_score"]
    ).clip(lower=0, upper=1)

    review["resilience_score"] = (
        0.25 * review["availability_score"]
        + 0.25 * review["service_continuity_score"]
        + 0.20 * review["fallback_capacity_score"]
        + 0.15 * review["observability_score"]
        - 0.15 * review["restoration_time_score"]
    ).clip(lower=0, upper=1)

    review["performance_review_flag"] = (
        (review["availability_score"] < 0.95)
        | (review["service_continuity_score"] < 0.90)
        | (review["degradation_score"] >= 0.25)
        | (review["stress_score"] >= 0.65)
        | (review["power_quality_risk_score"] >= 0.35)
        | (review["resilience_score"] < 0.70)
        | (review["quality_flag"].eq("review"))
        | (review["maintenance_status"].eq("review_required"))
    )

    return review


def main() -> None:
    review = build_review()
    review.to_csv(OUTPUT_DIR / "energy_infrastructure_performance_review.csv", index=False)

    watchlist = (
        review[review["performance_review_flag"]]
        .sort_values(
            ["stress_score", "degradation_score", "power_quality_risk_score"],
            ascending=[False, False, False],
        )
    )
    watchlist.to_csv(OUTPUT_DIR / "energy_performance_governance_watchlist.csv", index=False)

    asset_summary = (
        review.groupby("asset_class", as_index=False)
        .agg(
            assets=("asset_id", "nunique"),
            observations=("telemetry_id", "count"),
            mean_availability=("availability_score", "mean"),
            mean_service_continuity=("service_continuity_score", "mean"),
            mean_degradation=("degradation_score", "mean"),
            mean_stress=("stress_score", "mean"),
            mean_power_quality_risk=("power_quality_risk_score", "mean"),
            mean_resilience=("resilience_score", "mean"),
            review_flags=("performance_review_flag", "sum"),
        )
        .sort_values(["review_flags", "mean_stress"], ascending=[False, False])
    )
    asset_summary.to_csv(OUTPUT_DIR / "energy_asset_class_summary.csv", index=False)

    print("Energy infrastructure performance review written to outputs/energy_infrastructure_performance_review.csv")
    print("Energy performance governance watchlist written to outputs/energy_performance_governance_watchlist.csv")
    print(watchlist[[
        "asset_id", "asset_name", "asset_class", "criticality",
        "availability_score", "service_continuity_score",
        "degradation_score", "stress_score", "power_quality_risk_score",
        "resilience_score"
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
