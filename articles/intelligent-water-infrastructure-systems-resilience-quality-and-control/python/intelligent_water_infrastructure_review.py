from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def build_review() -> pd.DataFrame:
    assets = pd.read_csv(DATA_DIR / "water_asset_inventory.csv")
    telemetry = pd.read_csv(DATA_DIR / "water_telemetry_records.csv", parse_dates=["timestamp"])
    quality = pd.read_csv(DATA_DIR / "water_quality_public_health_review.csv")
    hydraulic = pd.read_csv(DATA_DIR / "leakage_hydraulic_control_review.csv")
    storm = pd.read_csv(DATA_DIR / "wastewater_stormwater_risk_review.csv")

    review = (
        telemetry
        .merge(assets, on="asset_id", how="left")
        .merge(quality, on="service_zone_id", how="left")
        .merge(hydraulic, on="service_zone_id", how="left")
        .merge(storm, on="service_zone_id", how="left")
    )

    review["quality_compliance_score"] = (
        review["compliant_observations"] / review["tested_observations"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    pressure_denominator = (
        review["maximum_pressure_psi"] - review["minimum_pressure_psi"]
    ).replace(0, pd.NA)
    review["pressure_adequacy_score"] = (
        (review["pressure_psi"] - review["minimum_pressure_psi"]) / pressure_denominator
    ).fillna(0).clip(lower=0, upper=1)

    review["leakage_rate"] = (
        (review["system_input_volume_m3"] - review["authorized_consumption_m3"])
        / review["system_input_volume_m3"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    # Illustrative service continuity proxy using telemetry reliability and backup/response readiness.
    review["available_service_hours"] = 24 * (
        0.50 * review["telemetry_reliability_score"]
        + 0.25 * review["backup_capacity_score"]
        + 0.25 * review["response_capacity_score"]
    ).clip(lower=0, upper=1)
    review["required_service_hours"] = 24

    review["service_continuity_score"] = (
        review["available_service_hours"] / review["required_service_hours"]
    ).clip(lower=0, upper=1)

    max_latency = max(review["latency_seconds"].max(), 1)
    review["latency_score"] = (
        1 - review["latency_seconds"] / max_latency
    ).clip(lower=0, upper=1)

    review["water_observability_score"] = (
        0.25 * review["telemetry_reliability_score"]
        + 0.25 * review["data_quality_score"]
        + 0.20 * review["coverage_score"]
        + 0.15 * review["metadata_completeness_score"]
        + 0.15 * review["latency_score"]
    ).clip(lower=0, upper=1)

    review["water_resilience_score"] = (
        0.25 * review["service_continuity_score"]
        + 0.20 * review["quality_compliance_score"]
        + 0.20 * review["backup_capacity_score"]
        + 0.15 * review["water_observability_score"]
        + 0.15 * review["response_capacity_score"]
        - 0.15 * review["exposure_risk_score"]
    ).clip(lower=0, upper=1)

    review["water_review_flag"] = (
        (review["quality_compliance_score"] < 0.98)
        | (review["pressure_adequacy_score"] < 0.35)
        | (review["leakage_rate"] >= 0.20)
        | (review["service_continuity_score"] < 0.90)
        | (review["water_observability_score"] < 0.70)
        | (review["water_resilience_score"] < 0.70)
        | (review["overflow_risk_score"] >= 0.35)
        | (review["quality_flag"].eq("review"))
    )

    return review


def main() -> None:
    review = build_review()
    review.to_csv(OUTPUT_DIR / "intelligent_water_infrastructure_review.csv", index=False)

    watchlist = (
        review[review["water_review_flag"]]
        .sort_values(
            ["exposure_risk_score", "leakage_rate", "overflow_risk_score"],
            ascending=[False, False, False],
        )
    )
    watchlist.to_csv(OUTPUT_DIR / "water_infrastructure_governance_watchlist.csv", index=False)

    zone_summary = (
        review.groupby("service_zone_id", as_index=False)
        .agg(
            assets=("asset_id", "nunique"),
            observations=("telemetry_id", "count"),
            mean_quality_compliance=("quality_compliance_score", "mean"),
            mean_pressure_adequacy=("pressure_adequacy_score", "mean"),
            mean_leakage_rate=("leakage_rate", "mean"),
            mean_observability=("water_observability_score", "mean"),
            mean_resilience=("water_resilience_score", "mean"),
            mean_overflow_risk=("overflow_risk_score", "mean"),
            review_flags=("water_review_flag", "sum"),
        )
        .sort_values(["review_flags", "mean_leakage_rate"], ascending=[False, False])
    )
    zone_summary.to_csv(OUTPUT_DIR / "water_service_zone_summary.csv", index=False)

    print("Intelligent water infrastructure review written to outputs/intelligent_water_infrastructure_review.csv")
    print("Water infrastructure governance watchlist written to outputs/water_infrastructure_governance_watchlist.csv")
    print(watchlist[[
        "asset_id", "asset_name", "asset_class", "service_zone_id",
        "quality_compliance_score", "pressure_adequacy_score",
        "leakage_rate", "water_observability_score", "water_resilience_score"
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
