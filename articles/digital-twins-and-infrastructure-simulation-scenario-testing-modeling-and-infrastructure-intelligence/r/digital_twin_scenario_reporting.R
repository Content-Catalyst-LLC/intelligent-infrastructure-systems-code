suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- sub(file_arg, "", args[grep(file_arg, args)])
article_dir <- normalizePath(file.path(dirname(script_path), ".."))

state_path <- file.path(article_dir, "data", "digital_twin_state_table.csv")
scenario_path <- file.path(article_dir, "data", "simulation_scenario_manifest.csv")
validation_path <- file.path(article_dir, "data", "validation_sensitivity_log.csv")
output_dir <- file.path(article_dir, "outputs")

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

state <- read_csv(state_path, show_col_types = FALSE)
scenarios <- read_csv(scenario_path, show_col_types = FALSE)
validation <- read_csv(validation_path, show_col_types = FALSE)

intervention_gain <- c(
  defer = 0.00,
  inspect = 0.03,
  targeted_repair = 0.15,
  renewal = 0.35
)

intervention_cost <- c(
  defer = 0.00,
  inspect = 0.10,
  targeted_repair = 0.35,
  renewal = 0.85
)

simulate_case <- function(state_data, scenario) {
  intervention <- scenario$intervention
  condition_gain <- intervention_gain[[intervention]]
  cost_index <- intervention_cost[[intervention]]

  state_data %>%
    mutate(
      scenario_id = scenario$scenario_id,
      scenario_type = scenario$scenario_type,
      intervention = intervention,
      sim_condition = pmin(1, condition_state + condition_gain),
      stress_index = (
        scenario$load_multiplier * load_factor +
          scenario$climate_multiplier * climate_exposure +
          scenario$disruption_multiplier * estimated_failure_risk
      ) / 3,
      failure_risk = pmin(
        1,
        (1 - sim_condition) * 0.50 +
          stress_index * 0.35 +
          service_criticality * 0.15
      ),
      service_risk = failure_risk * service_criticality,
      decision_value = 1.20 * (condition_state - service_risk) - cost_index,
      cost_index = cost_index,
      review_required = state_quality_flag != "pass" | service_risk > 0.40 | decision_value < 0.20
    )
}

results <- bind_rows(
  lapply(seq_len(nrow(scenarios)), function(i) {
    simulate_case(state, scenarios[i, ])
  })
)

scenario_summary <- results %>%
  group_by(scenario_id, scenario_type, intervention) %>%
  summarise(
    assets = n(),
    mean_failure_risk = round(mean(failure_risk, na.rm = TRUE), 3),
    max_failure_risk = round(max(failure_risk, na.rm = TRUE), 3),
    mean_service_risk = round(mean(service_risk, na.rm = TRUE), 3),
    mean_decision_value = round(mean(decision_value, na.rm = TRUE), 3),
    review_items = sum(review_required),
    .groups = "drop"
  ) %>%
  arrange(desc(mean_service_risk), desc(review_items))

governance_watchlist <- results %>%
  filter(review_required) %>%
  arrange(desc(service_risk), decision_value) %>%
  select(
    scenario_id,
    scenario_type,
    asset_id,
    intervention,
    sim_condition,
    failure_risk,
    service_risk,
    decision_value,
    review_required
  )

validation_summary <- validation %>%
  group_by(model_id, status) %>%
  summarise(
    tests = n(),
    .groups = "drop"
  ) %>%
  arrange(status, model_id)

write_csv(results, file.path(output_dir, "r_digital_twin_simulation_results.csv"))
write_csv(scenario_summary, file.path(output_dir, "r_digital_twin_scenario_summary.csv"))
write_csv(governance_watchlist, file.path(output_dir, "r_digital_twin_governance_watchlist.csv"))
write_csv(validation_summary, file.path(output_dir, "r_digital_twin_validation_summary.csv"))

print(scenario_summary)
print(governance_watchlist)
print(validation_summary)
