suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- sub(file_arg, "", args[grep(file_arg, args)])
article_dir <- normalizePath(file.path(dirname(script_path), ".."))

kpi_path <- file.path(article_dir, "data", "infrastructure_intelligence_kpis.csv")
asset_path <- file.path(article_dir, "data", "asset_service_register.csv")
cyber_path <- file.path(article_dir, "data", "cyber_resilience_controls.csv")
scenario_path <- file.path(article_dir, "data", "resilience_scenario_manifest.csv")
output_dir <- file.path(article_dir, "outputs")

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

readiness <- read_csv(kpi_path, show_col_types = FALSE) %>%
  mutate(
    intelligence_quality = round(
      0.15 * observability +
        0.13 * interoperability +
        0.12 * ai_governance +
        0.15 * resilience_readiness +
        0.14 * cyber_resilience +
        0.12 * equity_readiness +
        0.10 * public_accountability +
        0.09 * adaptive_capacity,
      3
    ),
    review_priority = case_when(
      high_criticality & cyber_resilience < 0.70 ~ "urgent_cyber_resilience_review",
      high_criticality & resilience_readiness < 0.70 ~ "urgent_resilience_review",
      ai_governance < 0.70 ~ "ai_governance_review",
      interoperability < 0.65 ~ "interoperability_review",
      equity_readiness < 0.65 ~ "equity_review",
      public_accountability < 0.65 ~ "public_accountability_review",
      intelligence_quality < 0.70 ~ "infrastructure_intelligence_review",
      TRUE ~ "routine_monitoring"
    )
  ) %>%
  arrange(review_priority, intelligence_quality)

sector_summary <- readiness %>%
  group_by(sector) %>%
  summarise(
    systems = n(),
    mean_intelligence_quality = round(mean(intelligence_quality), 3),
    mean_observability = round(mean(observability), 3),
    mean_interoperability = round(mean(interoperability), 3),
    mean_resilience = round(mean(resilience_readiness), 3),
    mean_cyber_resilience = round(mean(cyber_resilience), 3),
    mean_equity_readiness = round(mean(equity_readiness), 3),
    review_items = sum(review_priority != "routine_monitoring"),
    .groups = "drop"
  ) %>%
  arrange(desc(review_items), mean_intelligence_quality)

assets <- read_csv(asset_path, show_col_types = FALSE) %>%
  mutate(
    observability_coverage = round(observable_critical_assets / critical_assets, 3)
  ) %>%
  arrange(observability_coverage)

cyber <- read_csv(cyber_path, show_col_types = FALSE) %>%
  mutate(
    cyber_resilience_recomputed = round(
      0.25 * segmentation_score +
        0.25 * access_control_score +
        0.25 * recovery_score +
        0.25 * monitoring_score,
      3
    ),
    cyber_review_required = cyber_resilience_recomputed < 0.70
  ) %>%
  arrange(desc(cyber_review_required), cyber_resilience_recomputed)

scenarios <- read_csv(scenario_path, show_col_types = FALSE) %>%
  group_by(system_id, scenario_status) %>%
  summarise(
    scenarios = n(),
    max_recovery_objective_hours = max(recovery_objective_hours),
    .groups = "drop"
  ) %>%
  arrange(desc(scenario_status), desc(max_recovery_objective_hours))

write_csv(readiness, file.path(output_dir, "r_infrastructure_intelligence_readiness.csv"))
write_csv(sector_summary, file.path(output_dir, "r_infrastructure_intelligence_sector_summary.csv"))
write_csv(assets, file.path(output_dir, "r_asset_service_observability_summary.csv"))
write_csv(cyber, file.path(output_dir, "r_cyber_resilience_review_summary.csv"))
write_csv(scenarios, file.path(output_dir, "r_resilience_scenario_review_summary.csv"))

print(readiness)
print(sector_summary)
print(cyber)
print(scenarios)
