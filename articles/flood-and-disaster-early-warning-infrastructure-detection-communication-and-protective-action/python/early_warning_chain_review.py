from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

def load_inputs() -> pd.DataFrame:
    hazards = pd.read_csv(DATA_DIR / "hazard_exposure_register.csv")
    observations = pd.read_csv(DATA_DIR / "observation_network_inventory.csv")
    forecasts = pd.read_csv(DATA_DIR / "forecast_product_register.csv")
    channels = pd.read_csv(DATA_DIR / "warning_channel_register.csv")
    preparedness = pd.read_csv(DATA_DIR / "preparedness_action_log.csv")
    inclusion = pd.read_csv(DATA_DIR / "accessibility_inclusion_review.csv")

    return (
        hazards
        .merge(observations[["hazard_id", "detection_reliability", "uptime_score", "maintenance_status"]], on="hazard_id", how="left")
        .merge(forecasts, on="hazard_id", how="left")
        .merge(channels, on="warning_zone_id", how="left")
        .merge(preparedness, on="warning_zone_id", how="left")
        .merge(inclusion, on="warning_zone_id", how="left")
    )

def score_warning_chain(df: pd.DataFrame) -> pd.DataFrame:
    scored = df.copy()

    scored["useful_lead_time_minutes"] = (
        scored["forecast_lead_time_minutes"]
        - scored["decision_delay_minutes"]
        - scored["communication_delay_minutes"]
        - scored["mobilization_time_minutes"]
    )

    scored["protective_warning_probability"] = (
        scored["detection_reliability"]
        * scored["population_reach"]
        * scored["message_comprehension"]
        * scored["trust_score"]
        * scored["action_capacity"]
    )

    scored["residual_warning_risk"] = (
        scored["hazard_severity"]
        * scored["exposure_score"]
        * scored["vulnerability_score"]
        * (1 - scored["protective_warning_probability"])
    )

    scored["accessibility_gap"] = 1 - scored["accessibility_readiness"]

    scored["watchlist_flag"] = (
        (scored["criticality"].eq("high"))
        & (
            (scored["useful_lead_time_minutes"] < scored["lead_time_need_minutes"] * 0.50)
            | (scored["residual_warning_risk"] >= 0.25)
            | (scored["accessibility_gap"] >= 0.35)
            | (scored["channel_test_status"].eq("review_required"))
        )
    )

    return scored

def main() -> None:
    df = score_warning_chain(load_inputs())

    review_cols = [
        "hazard_id",
        "warning_zone_id",
        "community_name",
        "hazard_type",
        "criticality",
        "useful_lead_time_minutes",
        "protective_warning_probability",
        "residual_warning_risk",
        "accessibility_gap",
        "channel_test_status",
        "preparedness_owner",
        "watchlist_flag",
    ]

    review = df[review_cols].sort_values(
        ["watchlist_flag", "residual_warning_risk", "useful_lead_time_minutes"],
        ascending=[False, False, True],
    )

    watchlist = review[review["watchlist_flag"]].copy()

    review.to_csv(OUTPUT_DIR / "early_warning_chain_review.csv", index=False)
    watchlist.to_csv(OUTPUT_DIR / "early_warning_governance_watchlist.csv", index=False)

    print("Early warning chain review written to outputs/early_warning_chain_review.csv")
    print("Governance watchlist written to outputs/early_warning_governance_watchlist.csv")
    print(watchlist.to_string(index=False))

if __name__ == "__main__":
    main()
