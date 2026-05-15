library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

exposure <- read_csv(file.path(data_dir, "infrastructure_exposure_inventory.csv"), show_col_types = FALSE)
vulnerability <- read_csv(file.path(data_dir, "vulnerability_adaptive_capacity.csv"), show_col_types = FALSE)
options <- read_csv(file.path(data_dir, "adaptation_option_portfolio.csv"), show_col_types = FALSE)

report <- exposure %>%
  left_join(vulnerability, by = "community_id") %>%
  left_join(options, by = "system_id") %>%
  mutate(
    baseline_risk = hazard_intensity * exposure_score * sensitivity_score * (1 - adaptive_capacity_score),
    residual_risk = baseline_risk * (1 - option_effectiveness) + maladaptation_penalty,
    equity_priority = vulnerable_population_share * health_sensitivity_score * residual_risk
  )

sector_summary <- report %>%
  group_by(sector) %>%
  summarise(
    systems = n_distinct(system_id),
    mean_residual_risk = mean(residual_risk, na.rm = TRUE),
    mean_equity_priority = mean(equity_priority, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(mean_equity_priority))

write_csv(report, file.path(output_dir, "adaptation_vulnerability_report.csv"))
write_csv(sector_summary, file.path(output_dir, "adaptation_sector_summary.csv"))
print(sector_summary)
