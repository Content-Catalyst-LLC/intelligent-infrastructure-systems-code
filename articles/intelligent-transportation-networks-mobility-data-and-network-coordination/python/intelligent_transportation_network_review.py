from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def build_review() -> pd.DataFrame:
    inventory = pd.read_csv(DATA_DIR / "transport_network_inventory.csv")
    telemetry = pd.read_csv(DATA_DIR / "mobility_telemetry_sample.csv", parse_dates=["timestamp"])
    performance = pd.read_csv(DATA_DIR / "service_performance_review.csv")
    safety_access = pd.read_csv(DATA_DIR / "safety_accessibility_review.csv")

    review = (
        telemetry
        .merge(inventory, on="network_element_id", how="left")
        .merge(performance, on="network_element_id", how="left")
        .merge(safety_access, on="service_zone_id", how="left")
    )

    review["travel_time_reliability"] = (
        1 - (review["travel_time_std_minutes"] / review["travel_time_mean_minutes"])
    ).clip(lower=0, upper=1)

    review["incident_recovery_lag_minutes"] = (
        review["expected_recovery_minutes"] - review["target_recovery_minutes"]
    ).clip(lower=0)

    review["mobility_quality_score"] = (
        0.25 * review["travel_time_reliability"]
        + 0.20 * review["accessibility_score"]
        + 0.20 * review["safety_score"]
        + 0.20 * review["coordination_score"]
        - 0.15 * review["emissions_burden_score"]
    ).clip(lower=0, upper=1)

    review["transport_review_flag"] = (
        (review["travel_time_reliability"] < 0.70)
        | (review["accessibility_gap_score"] >= 0.35)
        | (review["safety_risk_score"] >= 0.35)
        | (review["incident_recovery_lag_minutes"] > 0)
        | (review["coordination_score"] < 0.65)
        | (review["quality_flag"].eq("review"))
    )

    return review


def main() -> None:
    review = build_review()
    review.to_csv(OUTPUT_DIR / "intelligent_transportation_network_review.csv", index=False)

    watchlist = (
        review[review["transport_review_flag"]]
        .sort_values(
            ["safety_risk_score", "accessibility_gap_score", "incident_recovery_lag_minutes"],
            ascending=[False, False, False],
        )
    )
    watchlist.to_csv(OUTPUT_DIR / "transportation_governance_watchlist.csv", index=False)

    mode_summary = (
        review.groupby("mode", as_index=False)
        .agg(
            network_elements=("network_element_id", "nunique"),
            observations=("telemetry_id", "count"),
            mean_reliability=("travel_time_reliability", "mean"),
            mean_accessibility_gap=("accessibility_gap_score", "mean"),
            mean_safety_risk=("safety_risk_score", "mean"),
            mean_coordination=("coordination_score", "mean"),
            mean_mobility_quality=("mobility_quality_score", "mean"),
            review_flags=("transport_review_flag", "sum"),
        )
        .sort_values(["review_flags", "mean_safety_risk"], ascending=[False, False])
    )
    mode_summary.to_csv(OUTPUT_DIR / "transportation_mode_summary.csv", index=False)

    print("Intelligent transportation review written to outputs/intelligent_transportation_network_review.csv")
    print("Transportation governance watchlist written to outputs/transportation_governance_watchlist.csv")
    print(watchlist[[
        "network_element_id", "network_element_name", "mode", "service_zone_id",
        "travel_time_reliability", "accessibility_gap_score", "safety_risk_score",
        "coordination_score", "incident_recovery_lag_minutes"
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
