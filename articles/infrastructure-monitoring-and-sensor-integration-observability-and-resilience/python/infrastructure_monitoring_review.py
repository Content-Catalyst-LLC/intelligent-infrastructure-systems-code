from __future__ import annotations

from pathlib import Path
import numpy as np
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def build_review() -> pd.DataFrame:
    sensors = pd.read_csv(DATA_DIR / "sensor_inventory.csv")
    assets = pd.read_csv(DATA_DIR / "monitored_asset_registry.csv")
    telemetry = pd.read_csv(DATA_DIR / "sensor_telemetry_records.csv", parse_dates=["timestamp"])
    calibration = pd.read_csv(DATA_DIR / "calibration_validation_log.csv", parse_dates=["last_calibration_date"])
    coverage = pd.read_csv(DATA_DIR / "coverage_blindspot_review.csv")
    alerts = pd.read_csv(DATA_DIR / "monitoring_alert_response_register.csv")

    review = (
        telemetry
        .merge(sensors, on="sensor_id", how="left")
        .merge(assets, on=["asset_id", "source_system_id"], how="left", suffixes=("", "_asset"))
        .merge(calibration, on="sensor_id", how="left")
        .merge(coverage, on="service_zone_id", how="left", suffixes=("", "_coverage"))
    )

    review["signal_quality_score"] = (
        0.25 * review["accuracy_score"]
        + 0.20 * review["precision_score"]
        + 0.20 * review["completeness_score"]
        + 0.20 * review["validity_score"]
        + 0.15 * review["freshness_score"]
    ).clip(lower=0, upper=1)

    now = pd.Timestamp.utcnow().tz_localize(None)
    review["days_since_calibration"] = (
        now - review["last_calibration_date"].dt.tz_localize(None)
    ).dt.days.clip(lower=0)

    review["calibration_confidence_score"] = np.exp(
        -0.004 * review["days_since_calibration"]
    ).clip(0, 1)

    review["telemetry_reliability_score"] = (
        1
        - (
            review["missing_readings"]
            + review["late_readings"]
            + review["invalid_readings"]
        )
        / review["expected_readings"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    metadata_fields = [
        "has_sensor_id",
        "has_asset_id",
        "has_location",
        "has_unit",
        "has_timestamp_source",
        "has_owner",
        "has_quality_flag",
        "has_valid_use",
    ]

    review["metadata_completeness_score"] = (
        review[metadata_fields].astype(float).mean(axis=1).clip(lower=0, upper=1)
    )

    review["sensor_coverage_score"] = (
        review["monitored_critical_assets"]
        / review["critical_assets"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["blindspot_penalty"] = (
        review["unmonitored_high_risk_zones"]
        / review["total_service_zones"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["monitoring_observability_score"] = (
        0.20 * review["sensor_coverage_score"]
        + 0.20 * review["signal_quality_score"]
        + 0.20 * review["calibration_confidence_score"]
        + 0.20 * review["telemetry_reliability_score"]
        + 0.15 * review["metadata_completeness_score"]
        - 0.15 * review["blindspot_penalty"]
    ).clip(lower=0, upper=1)

    alert_actions = (
        alerts
        .assign(has_action=lambda df: df["response_status"].isin(["open", "closed", "in_progress"]))
        .groupby("sensor_id", as_index=False)
        .agg(actionability_score=("has_action", "mean"))
    )

    review = review.merge(alert_actions, on="sensor_id", how="left")
    review["actionability_score"] = review["actionability_score"].fillna(0).clip(lower=0, upper=1)

    review["monitoring_resilience_score"] = (
        0.35 * review["monitoring_observability_score"]
        + 0.25 * review["actionability_score"]
        + 0.20 * review["field_validation_score"]
        + 0.10 * review["device_health_score"]
        - 0.10 * review["blindspot_penalty"]
    ).clip(lower=0, upper=1)

    review["monitoring_review_flag"] = (
        (review["signal_quality_score"] < 0.80)
        | (review["calibration_confidence_score"] < 0.70)
        | (review["telemetry_reliability_score"] < 0.85)
        | (review["metadata_completeness_score"] < 0.85)
        | (review["sensor_coverage_score"] < 0.75)
        | (review["monitoring_observability_score"] < 0.75)
        | (review["actionability_score"] < 0.50)
        | (review["quality_flag"].eq("review"))
    )

    return review


def main() -> None:
    review = build_review()
    review.to_csv(OUTPUT_DIR / "infrastructure_monitoring_review.csv", index=False)

    watchlist = (
        review[review["monitoring_review_flag"]]
        .sort_values(
            ["monitoring_observability_score", "signal_quality_score", "telemetry_reliability_score"],
            ascending=[True, True, True],
        )
    )
    watchlist.to_csv(OUTPUT_DIR / "infrastructure_monitoring_watchlist.csv", index=False)

    zone_summary = (
        review.groupby(["service_zone_id", "infrastructure_domain", "owner_operator"], as_index=False)
        .agg(
            sensors=("sensor_id", "nunique"),
            assets=("asset_id", "nunique"),
            mean_signal_quality=("signal_quality_score", "mean"),
            mean_calibration_confidence=("calibration_confidence_score", "mean"),
            mean_telemetry_reliability=("telemetry_reliability_score", "mean"),
            mean_metadata_completeness=("metadata_completeness_score", "mean"),
            mean_sensor_coverage=("sensor_coverage_score", "mean"),
            mean_monitoring_observability=("monitoring_observability_score", "mean"),
            mean_actionability=("actionability_score", "mean"),
            mean_resilience=("monitoring_resilience_score", "mean"),
            review_flags=("monitoring_review_flag", "sum"),
        )
        .sort_values(["review_flags", "mean_monitoring_observability"], ascending=[False, True])
    )
    zone_summary.to_csv(OUTPUT_DIR / "infrastructure_monitoring_zone_summary.csv", index=False)

    print("Infrastructure monitoring review written to outputs/infrastructure_monitoring_review.csv")
    print("Infrastructure monitoring watchlist written to outputs/infrastructure_monitoring_watchlist.csv")
    print(watchlist[[
        "sensor_id", "asset_id", "service_zone_id", "measurement_name",
        "signal_quality_score", "calibration_confidence_score",
        "telemetry_reliability_score", "sensor_coverage_score",
        "monitoring_observability_score", "actionability_score"
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
