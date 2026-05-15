from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

REFERENCE_START = pd.Timestamp("1991-01-01")
REFERENCE_END = pd.Timestamp("2020-12-31")


def load_inputs() -> tuple[pd.DataFrame, pd.DataFrame, pd.DataFrame]:
    observations = pd.read_csv(DATA_DIR / "climate_observations_sample.csv", parse_dates=["date"])
    metadata = pd.read_csv(DATA_DIR / "instrument_metadata_calibration_log.csv")
    platforms = pd.read_csv(DATA_DIR / "climate_observation_platforms.csv")
    return observations, metadata, platforms


def compute_baselines(observations: pd.DataFrame) -> pd.DataFrame:
    reference = observations[
        (observations["date"] >= REFERENCE_START)
        & (observations["date"] <= REFERENCE_END)
        & (observations["quality_flag"].isin(["good", "review"]))
    ]

    return (
        reference.groupby(["station_id", "variable"], as_index=False)["value"]
        .mean()
        .rename(columns={"value": "baseline_value"})
    )


def compute_record_counts(observations: pd.DataFrame) -> pd.DataFrame:
    expected_count = observations["date"].nunique()

    counts = (
        observations.groupby(["station_id", "variable"], as_index=False)
        .agg(
            observed_count=("value", "count"),
            first_date=("date", "min"),
            last_date=("date", "max"),
        )
    )

    counts["record_completeness"] = counts["observed_count"] / max(expected_count, 1)
    return counts


def review_records() -> pd.DataFrame:
    observations, metadata, platforms = load_inputs()
    baseline = compute_baselines(observations)
    counts = compute_record_counts(observations)

    review = (
        observations
        .merge(baseline, on=["station_id", "variable"], how="left")
        .merge(counts, on=["station_id", "variable"], how="left")
        .merge(metadata, on=["station_id", "variable"], how="left")
        .merge(platforms[["station_id", "station_name", "platform_type", "domain", "operational_status"]], on="station_id", how="left")
    )

    review["anomaly"] = review["value"] - review["baseline_value"]

    review["quality_review_flag"] = (
        (review["record_completeness"] < 0.80)
        | (review["calibration_status"] != "current")
        | (review["metadata_status"] != "complete")
        | (review["known_breakpoint"].astype(str).str.lower() == "true")
    )

    return review


def main() -> None:
    review = review_records()
    review.to_csv(OUTPUT_DIR / "climate_anomaly_quality_review.csv", index=False)

    station_summary = (
        review.groupby(["station_id", "station_name", "domain", "variable"], as_index=False)
        .agg(
            mean_anomaly=("anomaly", "mean"),
            max_anomaly=("anomaly", "max"),
            min_anomaly=("anomaly", "min"),
            record_completeness=("record_completeness", "first"),
            quality_review_flag=("quality_review_flag", "max"),
        )
        .sort_values(["quality_review_flag", "record_completeness"], ascending=[False, True])
    )

    station_summary.to_csv(OUTPUT_DIR / "climate_station_summary.csv", index=False)

    print("Climate anomaly quality review written to outputs/climate_anomaly_quality_review.csv")
    print("Climate station summary written to outputs/climate_station_summary.csv")
    print(station_summary.to_string(index=False))


if __name__ == "__main__":
    main()
