from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def build_review() -> pd.DataFrame:
    assets = pd.read_csv(DATA_DIR / "grid_asset_inventory.csv")
    telemetry = pd.read_csv(DATA_DIR / "grid_telemetry_records.csv", parse_dates=["timestamp"])
    der = pd.read_csv(DATA_DIR / "distributed_resource_coordination_register.csv")
    resilience = pd.read_csv(DATA_DIR / "grid_reliability_resilience_review.csv")
    cyber = pd.read_csv(DATA_DIR / "cyber_physical_grid_review.csv")

    review = (
        telemetry
        .merge(assets, on="asset_id", how="left")
        .merge(der, on="service_zone_id", how="left")
        .merge(resilience, on="service_zone_id", how="left")
        .merge(cyber, on="service_zone_id", how="left")
    )

    max_latency = max(review["latency_seconds"].max(), 1)
    review["latency_score"] = (
        1 - review["latency_seconds"] / max_latency
    ).clip(lower=0, upper=1)

    review["grid_observability_score"] = (
        0.25 * review["telemetry_reliability_score"]
        + 0.25 * review["data_quality_score"]
        + 0.20 * review["coverage_score"]
        + 0.15 * review["metadata_completeness_score"]
        + 0.15 * review["latency_score"]
    ).clip(lower=0, upper=1)

    review["voltage_adequacy_score"] = (
        1 - (review["voltage_pu"] - 1.0).abs() / review["allowed_voltage_deviation_pu"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["flexibility_adequacy_score"] = (
        review["available_flexibility_mw"] / review["flexibility_need_mw"].replace(0, pd.NA)
    ).fillna(1).clip(lower=0, upper=1)

    review["balancing_pressure_score"] = (
        (review["load_mw"] - review["available_supply_mw"] - review["available_flexibility_mw"]).abs()
        / review["load_mw"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["service_continuity_score"] = (
        review["served_hours"] / review["required_service_hours"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["grid_resilience_score"] = (
        0.25 * review["service_continuity_score"]
        + 0.20 * review["flexibility_adequacy_score"]
        + 0.20 * review["grid_observability_score"]
        + 0.15 * review["backup_capability_score"]
        + 0.15 * review["response_capacity_score"]
        - 0.15 * review["exposure_risk_score"]
    ).clip(lower=0, upper=1)

    review["smart_grid_review_flag"] = (
        (review["grid_observability_score"] < 0.70)
        | (review["voltage_adequacy_score"] < 0.70)
        | (review["flexibility_adequacy_score"] < 0.75)
        | (review["balancing_pressure_score"] >= 0.20)
        | (review["service_continuity_score"] < 0.90)
        | (review["grid_resilience_score"] < 0.70)
        | (review["cyber_physical_risk_score"] >= 0.35)
        | (review["quality_flag"].eq("review"))
    )

    return review


def main() -> None:
    review = build_review()
    review.to_csv(OUTPUT_DIR / "smart_grid_infrastructure_review.csv", index=False)

    watchlist = (
        review[review["smart_grid_review_flag"]]
        .sort_values(
            ["cyber_physical_risk_score", "balancing_pressure_score", "exposure_risk_score"],
            ascending=[False, False, False],
        )
    )
    watchlist.to_csv(OUTPUT_DIR / "smart_grid_governance_watchlist.csv", index=False)

    zone_summary = (
        review.groupby("service_zone_id", as_index=False)
        .agg(
            assets=("asset_id", "nunique"),
            observations=("telemetry_id", "count"),
            mean_observability=("grid_observability_score", "mean"),
            mean_voltage_adequacy=("voltage_adequacy_score", "mean"),
            mean_flexibility_adequacy=("flexibility_adequacy_score", "mean"),
            mean_balancing_pressure=("balancing_pressure_score", "mean"),
            mean_resilience=("grid_resilience_score", "mean"),
            mean_cyber_physical_risk=("cyber_physical_risk_score", "mean"),
            review_flags=("smart_grid_review_flag", "sum"),
        )
        .sort_values(["review_flags", "mean_cyber_physical_risk"], ascending=[False, False])
    )
    zone_summary.to_csv(OUTPUT_DIR / "smart_grid_service_zone_summary.csv", index=False)

    print("Smart grid infrastructure review written to outputs/smart_grid_infrastructure_review.csv")
    print("Smart grid governance watchlist written to outputs/smart_grid_governance_watchlist.csv")
    print(watchlist[[
        "asset_id", "asset_name", "asset_class", "service_zone_id",
        "grid_observability_score", "voltage_adequacy_score",
        "flexibility_adequacy_score", "grid_resilience_score",
        "cyber_physical_risk_score"
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
