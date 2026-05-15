from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)


def build_review() -> pd.DataFrame:
    assets = pd.read_csv(DATA_DIR / "cyber_physical_asset_inventory.csv")
    loops = pd.read_csv(DATA_DIR / "control_loop_register.csv")
    telemetry = pd.read_csv(DATA_DIR / "telemetry_command_records.csv", parse_dates=["timestamp"])
    dependencies = pd.read_csv(DATA_DIR / "dependency_exposure_map.csv")
    assurance = pd.read_csv(DATA_DIR / "assurance_fallback_review.csv")

    review = (
        telemetry
        .merge(loops, on="control_loop_id", how="left")
        .merge(assets, on="asset_id", how="left")
        .merge(dependencies, on="asset_id", how="left")
        .merge(assurance, on="control_loop_id", how="left")
    )

    review["signal_quality_score"] = (
        0.25 * review["accuracy_score"]
        + 0.20 * review["calibration_score"]
        + 0.20 * review["timeliness_score"]
        + 0.20 * review["validity_score"]
        + 0.15 * review["metadata_completeness_score"]
    ).clip(lower=0, upper=1)

    review["telemetry_reliability_score"] = (
        1
        - (
            review["missing_signals"]
            + review["late_signals"]
            + review["invalid_signals"]
        )
        / review["expected_signals"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["dependency_intensity_score"] = (
        review["cyber_dependent_functions"]
        / review["critical_functions"].replace(0, pd.NA)
    ).fillna(0).clip(lower=0, upper=1)

    review["control_validation_score"] = (
        review[
            [
                "timing_validated",
                "safety_boundary_validated",
                "degraded_mode_tested",
                "manual_override_tested",
                "recovery_tested",
            ]
        ]
        .astype(float)
        .mean(axis=1)
        .clip(lower=0, upper=1)
    )

    review["human_oversight_score"] = (
        review[
            [
                "operator_visibility",
                "override_authority",
                "training_current",
                "escalation_path_defined",
            ]
        ]
        .astype(float)
        .mean(axis=1)
        .clip(lower=0, upper=1)
    )

    review["control_integrity_score"] = (
        0.25 * review["signal_quality_score"]
        + 0.20 * review["telemetry_reliability_score"]
        + 0.20 * review["control_validation_score"]
        + 0.15 * review["security_control_score"]
        + 0.15 * review["human_oversight_score"]
        - 0.10 * review["exposure_score"]
    ).clip(lower=0, upper=1)

    review["cyber_physical_resilience_score"] = (
        0.30 * review["control_integrity_score"]
        + 0.20 * review["fallback_capability_score"]
        + 0.20 * review["manual_override_score"]
        + 0.20 * review["recovery_effectiveness_score"]
        - 0.10 * review["dependency_intensity_score"]
        - 0.10 * review["exposure_score"]
    ).clip(lower=0, upper=1)

    review["command_review_flag"] = (
        (~review["command_within_bounds"].astype(bool))
        | (~review["operator_acknowledged"].astype(bool))
    )

    review["cyber_physical_review_flag"] = (
        (review["signal_quality_score"] < 0.80)
        | (review["telemetry_reliability_score"] < 0.85)
        | (review["control_validation_score"] < 0.75)
        | (review["human_oversight_score"] < 0.75)
        | (review["control_integrity_score"] < 0.75)
        | (review["cyber_physical_resilience_score"] < 0.70)
        | (review["dependency_intensity_score"] > 0.70)
        | (review["exposure_score"] > 0.40)
        | (review["quality_flag"].eq("review"))
        | (review["command_review_flag"])
    )

    return review


def main() -> None:
    review = build_review()
    review.to_csv(OUTPUT_DIR / "cyber_physical_infrastructure_review.csv", index=False)

    watchlist = (
        review[review["cyber_physical_review_flag"]]
        .sort_values(
            ["cyber_physical_resilience_score", "control_integrity_score", "exposure_score"],
            ascending=[True, True, False],
        )
    )
    watchlist.to_csv(OUTPUT_DIR / "cyber_physical_infrastructure_watchlist.csv", index=False)

    domain_summary = (
        review.groupby(["infrastructure_domain", "service_zone_id", "owner_operator"], as_index=False)
        .agg(
            control_loops=("control_loop_id", "nunique"),
            assets=("asset_id", "nunique"),
            mean_signal_quality=("signal_quality_score", "mean"),
            mean_telemetry_reliability=("telemetry_reliability_score", "mean"),
            mean_control_validation=("control_validation_score", "mean"),
            mean_human_oversight=("human_oversight_score", "mean"),
            mean_control_integrity=("control_integrity_score", "mean"),
            mean_resilience=("cyber_physical_resilience_score", "mean"),
            mean_dependency_intensity=("dependency_intensity_score", "mean"),
            mean_exposure=("exposure_score", "mean"),
            review_flags=("cyber_physical_review_flag", "sum"),
        )
        .sort_values(["review_flags", "mean_resilience"], ascending=[False, True])
    )
    domain_summary.to_csv(OUTPUT_DIR / "cyber_physical_domain_summary.csv", index=False)

    print("Cyber-physical infrastructure review written to outputs/cyber_physical_infrastructure_review.csv")
    print("Cyber-physical infrastructure watchlist written to outputs/cyber_physical_infrastructure_watchlist.csv")
    print(watchlist[[
        "control_loop_id",
        "asset_id",
        "asset_name",
        "infrastructure_domain",
        "signal_quality_score",
        "telemetry_reliability_score",
        "control_validation_score",
        "control_integrity_score",
        "cyber_physical_resilience_score",
        "dependency_intensity_score",
        "exposure_score",
    ]].to_string(index=False))


if __name__ == "__main__":
    main()
