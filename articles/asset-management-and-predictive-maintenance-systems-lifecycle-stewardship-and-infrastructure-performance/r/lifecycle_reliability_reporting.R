suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- sub(file_arg, "", args[grep(file_arg, args)])
article_dir <- normalizePath(file.path(dirname(script_path), ".."))

asset_path <- file.path(article_dir, "data", "asset_register.csv")
condition_path <- file.path(article_dir, "data", "condition_inspections.csv")
criticality_path <- file.path(article_dir, "data", "criticality_scores.csv")
lcc_path <- file.path(article_dir, "data", "lifecycle_cost_scenarios.csv")
output_dir <- file.path(article_dir, "outputs")

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

assets <- read_csv(asset_path, show_col_types = FALSE)
conditions <- read_csv(condition_path, show_col_types = FALSE) %>%
  arrange(inspection_date) %>%
  group_by(asset_id) %>%
  slice_tail(n = 1) %>%
  ungroup()

criticality <- read_csv(criticality_path, show_col_types = FALSE)
lcc <- read_csv(lcc_path, show_col_types = FALSE)

portfolio <- assets %>%
  left_join(conditions %>% select(asset_id, condition_score, defect_score, inspection_date), by = "asset_id") %>%
  left_join(
    criticality %>% select(asset_id, criticality_score, service_consequence, environmental_consequence, equity_consequence),
    by = "asset_id"
  ) %>%
  mutate(
    age_years = 2026 - install_year,
    failure_probability = 1 / (1 + exp(-(-3.0 + 0.045 * age_years + 2.5 * (1 - condition_score) + 0.8 * criticality_score))),
    risk_score = failure_probability * criticality_score,
    priority_score = round(
      0.35 * (1 - condition_score) +
      0.25 * failure_probability +
      0.25 * criticality_score +
      0.10 * (environmental_consequence / 5) +
      0.05 * (equity_consequence / 5),
      3
    ),
    recommended_strategy = case_when(
      priority_score >= 0.70 ~ "urgent_review",
      priority_score >= 0.55 ~ "planned_intervention",
      priority_score >= 0.40 ~ "condition_based_maintenance",
      TRUE ~ "monitor"
    )
  )

portfolio_summary <- portfolio %>%
  group_by(asset_class, recommended_strategy) %>%
  summarise(
    asset_count = n(),
    mean_condition = round(mean(condition_score, na.rm = TRUE), 3),
    mean_failure_probability = round(mean(failure_probability, na.rm = TRUE), 3),
    mean_criticality = round(mean(criticality_score, na.rm = TRUE), 3),
    mean_priority = round(mean(priority_score, na.rm = TRUE), 3),
    .groups = "drop"
  ) %>%
  arrange(recommended_strategy, desc(mean_priority))

lcc_summary <- lcc %>%
  group_by(asset_id, strategy) %>%
  summarise(
    total_cost_proxy = sum(total_cost_proxy, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(asset_id, total_cost_proxy)

write_csv(portfolio, file.path(output_dir, "r_asset_priority_portfolio.csv"))
write_csv(portfolio_summary, file.path(output_dir, "r_asset_strategy_summary.csv"))
write_csv(lcc_summary, file.path(output_dir, "r_lifecycle_cost_summary.csv"))

print(portfolio_summary)
print(lcc_summary)
