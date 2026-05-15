from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def load_inputs() -> tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame, pd.DataFrame, pd.DataFrame]:
    sites = pd.read_csv(DATA_DIR / "monitoring_site_inventory.csv")
    observations = pd.read_csv(DATA_DIR / "environmental_observations_sample.csv", parse_dates=["timestamp"])
    thresholds = pd.read_csv(DATA_DIR / "environmental_threshold_indicator_catalog.csv")
    calibration = pd.read_csv(DATA_DIR / "calibration_device_health_log.csv")
    coverage = pd.read_csv(DATA_DIR / "coverage_equity_review.csv")
    return sites, observations, thresholds, calibration, coverage


def build_review() -> pd.DataFrame:
    sites, observations, thresholds, calibration, coverage = load_inputs()

    review = (
        observations
        .merge(sites, on="site_id", how="left")
        .merge(thresholds, on=["domain", "variable"], how="left")
        .merge(calibration, on="site_id", how="left")
        .merge(coverage, on="monitoring_zone_id", how="left")
    )

    review["threshold_exceeded"] = review["value"] >= review["threshold_value"]

    review["monitoring_quality_score"] = (
        0.25 * review["record_completeness"]
        + 0.20 * review["calibration_score"]
        + 0.20 * review["metadata_score"]
        + 0.20 * review["provenance_score"]
        + 0.15 * review["sampling_design_score"]
    )

    review["hazard_intensity"] = review["value"] / review["threshold_value"]
    review["hazard_intensity"] = review["hazard_intensity"].clip(upper=2.0) / 2.0

    review["environmental_risk_score"] = (
        review["hazard_intensity"]
        * review["exposure_score"]
        * review["vulnerability_score"]
        * (1 - review["governance_response_score"])
    )

    review["stewardship_review_flag"] = (
        (review["threshold_exceeded"])
        | (review["monitoring_quality_score"] < 0.75)
        | (review["coverage_gap_score"] >= 0.35)
        | (review["environmental_risk_score"] >= 0.25)
        | (review["calibration_status"].eq("review_required"))
    )

    return review


def main() -> None:
    review = build_review()

    review.to_csv(OUTPUT_DIR / "environmental_monitoring_indicator_review.csv", index=False)

    watchlist = (
        review[review["stewardship_review_flag"]]
        .sort_values(["environmental_risk_score", "monitoring_quality_score"], ascending=[False, True])
    )

    watchlist.to_csv(OUTPUT_DIR / "environmental_stewardship_watchlist.csv", index=False)

    domain_summary = (
        review.groupby("domain", as_index=False)
        .agg(
            sites=("site_id", "nunique"),
            observations=("observation_id", "count"),
            threshold_exceedances=("threshold_exceeded", "sum"),
            mean_monitoring_quality=("monitoring_quality_score", "mean"),
            mean_environmental_risk=("environmental_risk_score", "mean"),
            review_flags=("stewardship_review_flag", "sum"),
        )
        .sort_values("mean_environmental_risk", ascending=False)
    )

    domain_summary.to_csv(OUTPUT_DIR / "environmental_monitoring_domain_summary.csv", index=False)

    print("Environmental monitoring indicator review written to outputs/environmental_monitoring_indicator_review.csv")
    print("Environmental stewardship watchlist written to outputs/environmental_stewardship_watchlist.csv")
    print(watchlist[[
        "site_id",
        "site_name",
        "domain",
        "variable",
        "value",
        "threshold_value",
        "environmental_risk_score",
        "monitoring_quality_score",
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
