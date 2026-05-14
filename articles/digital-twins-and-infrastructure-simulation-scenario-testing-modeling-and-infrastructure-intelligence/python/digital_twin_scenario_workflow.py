"""
Digital Twins and Infrastructure Simulation Workflow

This educational workflow demonstrates:
1. digital twin asset state records
2. scenario stress testing
3. intervention comparison
4. service risk and decision-value scoring
5. governance-ready output tables

It uses synthetic data from this article directory.
"""

from __future__ import annotations

from pathlib import Path
import pandas as pd

ARTICLE_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = ARTICLE_DIR / "data"
OUTPUT_DIR = ARTICLE_DIR / "outputs"
OUTPUT_DIR.mkdir(exist_ok=True)

STATE_PATH = DATA_DIR / "digital_twin_state_table.csv"
SCENARIO_PATH = DATA_DIR / "simulation_scenario_manifest.csv"
MODEL_PATH = DATA_DIR / "model_registry.csv"
VALIDATION_PATH = DATA_DIR / "validation_sensitivity_log.csv"


INTERVENTION_GAIN = {
    "defer": 0.00,
    "inspect": 0.03,
    "targeted_repair": 0.15,
    "renewal": 0.35,
}

INTERVENTION_COST = {
    "defer": 0.00,
    "inspect": 0.10,
    "targeted_repair": 0.35,
    "renewal": 0.85,
}


def simulate_scenario(state: pd.DataFrame, scenario: pd.Series) -> pd.DataFrame:
    intervention = scenario["intervention"]
    condition_gain = INTERVENTION_GAIN.get(intervention, 0.0)
    cost_index = INTERVENTION_COST.get(intervention, 0.0)

    result = state.copy()
    result["scenario_id"] = scenario["scenario_id"]
    result["scenario_type"] = scenario["scenario_type"]
    result["intervention"] = intervention

    result["sim_condition"] = (result["condition_state"] + condition_gain).clip(0, 1)

    result["stress_index"] = (
        scenario["load_multiplier"] * result["load_factor"]
        + scenario["climate_multiplier"] * result["climate_exposure"]
        + scenario["disruption_multiplier"] * result["estimated_failure_risk"]
    ) / 3

    result["failure_risk"] = (
        (1 - result["sim_condition"]) * 0.50
        + result["stress_index"] * 0.35
        + result["service_criticality"] * 0.15
    ).clip(0, 1)

    result["service_risk"] = result["failure_risk"] * result["service_criticality"]

    result["decision_value"] = (
        1.20 * (result["condition_state"] - result["service_risk"])
        - cost_index
    )

    result["cost_index"] = cost_index
    result["review_required"] = (
        (result["state_quality_flag"] != "pass")
        | (result["service_risk"] > 0.40)
        | (result["decision_value"] < 0.20)
    )

    return result


def main() -> None:
    state = pd.read_csv(STATE_PATH)
    scenarios = pd.read_csv(SCENARIO_PATH)
    model_registry = pd.read_csv(MODEL_PATH)
    validation = pd.read_csv(VALIDATION_PATH)

    simulation_frames = [
        simulate_scenario(state, scenario)
        for _, scenario in scenarios.iterrows()
    ]

    simulation_results = pd.concat(simulation_frames, ignore_index=True)

    output_columns = [
        "scenario_id",
        "scenario_type",
        "asset_id",
        "intervention",
        "sim_condition",
        "stress_index",
        "failure_risk",
        "service_risk",
        "cost_index",
        "decision_value",
        "review_required",
    ]

    simulation_output = simulation_results[output_columns].round(3)
    simulation_output_path = OUTPUT_DIR / "digital_twin_simulation_results.csv"
    simulation_output.to_csv(simulation_output_path, index=False)

    scenario_summary = (
        simulation_output
        .groupby(["scenario_id", "scenario_type", "intervention"], dropna=False)
        .agg(
            assets=("asset_id", "count"),
            mean_failure_risk=("failure_risk", "mean"),
            max_failure_risk=("failure_risk", "max"),
            mean_service_risk=("service_risk", "mean"),
            mean_decision_value=("decision_value", "mean"),
            review_items=("review_required", "sum"),
        )
        .reset_index()
        .round(3)
        .sort_values(["mean_service_risk", "review_items"], ascending=[False, False])
    )

    summary_output_path = OUTPUT_DIR / "digital_twin_scenario_summary.csv"
    scenario_summary.to_csv(summary_output_path, index=False)

    governance_watchlist = (
        simulation_output[simulation_output["review_required"]]
        .sort_values(["service_risk", "decision_value"], ascending=[False, True])
        .head(20)
    )

    watchlist_output_path = OUTPUT_DIR / "digital_twin_governance_watchlist.csv"
    governance_watchlist.to_csv(watchlist_output_path, index=False)

    model_review_summary = (
        model_registry.merge(
            validation.groupby("model_id", dropna=False)
            .agg(
                validation_tests=("validation_id", "count"),
                review_required=("status", lambda s: int((s != "current").sum())),
            )
            .reset_index(),
            on="model_id",
            how="left",
        )
        .fillna({"validation_tests": 0, "review_required": 0})
    )

    model_review_output_path = OUTPUT_DIR / "digital_twin_model_review_summary.csv"
    model_review_summary.to_csv(model_review_output_path, index=False)

    print("Digital twin scenario summary:")
    print(scenario_summary.to_string(index=False))

    print("\nGovernance watchlist:")
    print(governance_watchlist.to_string(index=False))

    print("\nModel review summary:")
    print(model_review_summary.to_string(index=False))

    print(f"\nWrote: {simulation_output_path}")
    print(f"Wrote: {summary_output_path}")
    print(f"Wrote: {watchlist_output_path}")
    print(f"Wrote: {model_review_output_path}")


if __name__ == "__main__":
    main()
