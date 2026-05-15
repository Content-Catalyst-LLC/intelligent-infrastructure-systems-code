from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def build_review() -> pd.DataFrame:
    sensors = pd.read_csv(DATA_DIR / "urban_sensor_inventory.csv")
    telemetry = pd.read_csv(DATA_DIR / "urban_sensor_telemetry_sample.csv", parse_dates=["timestamp"])
    linkage = pd.read_csv(DATA_DIR / "sensor_asset_linkage.csv")
    health = pd.read_csv(DATA_DIR / "calibration_device_health_log.csv")
    coverage = pd.read_csv(DATA_DIR / "coverage_exposure_review.csv")
    indicators = pd.read_csv(DATA_DIR / "urban_sensor_indicator_catalog.csv")

    review = (
        telemetry
        .merge(sensors, on=["sensor_id", "domain", "variable"], how="left")
        .merge(linkage, on="sensor_id", how="left")
        .merge(health, on="sensor_id", how="left")
        .merge(coverage, on="service_zone_id", how="left")
        .merge(indicators, on=["domain", "variable"], how="left")
    )

    review["threshold_exceeded"] = review["value"] >= review["threshold_value"]

    max_latency = max(review["latency_seconds"].max(), 1)
    review["latency_score"] = (1 - (review["latency_seconds"] / max_latency)).clip(0, 1)

    review["sensor_quality_score"] = (
        0.25 * review["uptime_score"]
        + 0.20 * review["calibration_score"]
        + 0.20 * review["metadata_score"]
        + 0.20 * review["latency_score"]
        + 0.15 * review["provenance_score"]
    )

    review["coverage_gap_score"] = 1 - review["coverage_score"]

    review["urban_risk_score"] = (
        review["exposure_score"]
        * review["vulnerability_score"]
        * (1 - review["governance_response_score"])
    )

    review["urban_observability_score"] = (
        0.30 * review["sensor_quality_score"]
        + 0.20 * review["coverage_score"]
        + 0.20 * review["interoperability_score"]
        + 0.15 * review["service_relevance_score"]
        + 0.15 * review["governance_response_score"]
    )

    review["monitoring_review_flag"] = (
        (review["threshold_exceeded"])
        | (review["sensor_quality_score"] < 0.75)
        | (review["coverage_gap_score"] >= 0.35)
        | (review["latency_seconds"] > review["max_acceptable_latency_seconds"])
        | (review["governance_response_score"] < 0.60)
        | (review["device_health_status"].eq("review_required"))
    )

    return review


def main() -> None:
    review = build_review()
    review.to_csv(OUTPUT_DIR / "urban_sensor_network_monitoring_review.csv", index=False)

    watchlist = review[review["monitoring_review_flag"]].sort_values(
        ["threshold_exceeded", "coverage_gap_score", "sensor_quality_score"],
        ascending=[False, False, True],
    )
    watchlist.to_csv(OUTPUT_DIR / "urban_sensor_governance_watchlist.csv", index=False)

    domain_summary = (
        review.groupby("domain", as_index=False)
        .agg(
            sensors=("sensor_id", "nunique"),
            observations=("telemetry_id", "count"),
            threshold_exceedances=("threshold_exceeded", "sum"),
            mean_sensor_quality=("sensor_quality_score", "mean"),
            mean_coverage_gap=("coverage_gap_score", "mean"),
            mean_observability=("urban_observability_score", "mean"),
            mean_urban_risk=("urban_risk_score", "mean"),
            review_flags=("monitoring_review_flag", "sum"),
        )
        .sort_values(["review_flags", "mean_coverage_gap"], ascending=[False, False])
    )
    domain_summary.to_csv(OUTPUT_DIR / "urban_sensor_domain_summary.csv", index=False)

    print("Urban sensor monitoring review written to outputs/urban_sensor_network_monitoring_review.csv")
    print("Urban sensor governance watchlist written to outputs/urban_sensor_governance_watchlist.csv")
    print(watchlist[[
        "sensor_id", "asset_id", "domain", "variable", "value", "threshold_value",
        "sensor_quality_score", "coverage_gap_score", "urban_observability_score"
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
