suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- sub(file_arg, "", args[grep(file_arg, args)])
article_dir <- normalizePath(file.path(dirname(script_path), ".."))

risk_path <- file.path(article_dir, "data", "infrastructure_risk_register.csv")
criticality_path <- file.path(article_dir, "data", "criticality_matrix.csv")
continuity_path <- file.path(article_dir, "data", "continuity_recovery_log.csv")
finance_path <- file.path(article_dir, "data", "risk_financing_register.csv")
output_dir <- file.path(article_dir, "outputs")

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

risks <- read_csv(risk_path, show_col_types = FALSE)
criticality <- read_csv(criticality_path, show_col_types = FALSE)
continuity <- read_csv(continuity_path, show_col_types = FALSE)
finance <- read_csv(finance_path, show_col_types = FALSE)

risk_summary <- risks %>%
  left_join(criticality, by = "asset_id") %>%
  left_join(
    continuity %>% select(risk_id, fallback_mode, recovery_time_objective_hours, exercise_status),
    by = "risk_id"
  ) %>%
  left_join(
    finance %>% select(risk_id, financing_strategy, insured, reserve_required, finance_owner),
    by = "risk_id"
  ) %>%
  mutate(
    basic_risk = failure_probability * consequence_score,
    system_risk = basic_risk * (1 + dependency_centrality),
    residual_risk = system_risk * (1 - mitigation_effectiveness),
    continuity_gap = pmax(0, 1 - continuity_readiness),
    governance_gap = pmax(0, 1 - governance_readiness),
    priority_score = (
      0.35 * residual_risk +
        0.25 * criticality_score +
        0.20 * continuity_gap +
        0.20 * governance_gap
    ),
    review_priority = case_when(
      criticality_score >= 0.75 & continuity_readiness < 0.65 ~ "urgent_continuity_review",
      criticality_score >= 0.75 & governance_readiness < 0.65 ~ "urgent_governance_review",
      residual_risk > 0.40 ~ "residual_risk_review",
      mitigation_effectiveness < 0.50 ~ "mitigation_review",
      priority_score > 0.50 ~ "priority_risk_review",
      TRUE ~ "routine_monitoring"
    )
  ) %>%
  arrange(review_priority, desc(priority_score))

sector_summary <- risk_summary %>%
  group_by(sector) %>%
  summarise(
    risks = n(),
    mean_criticality = round(mean(criticality_score, na.rm = TRUE), 3),
    mean_basic_risk = round(mean(basic_risk, na.rm = TRUE), 3),
    mean_system_risk = round(mean(system_risk, na.rm = TRUE), 3),
    mean_residual_risk = round(mean(residual_risk, na.rm = TRUE), 3),
    mean_priority = round(mean(priority_score, na.rm = TRUE), 3),
    continuity_reviews = sum(review_priority == "urgent_continuity_review"),
    governance_reviews = sum(review_priority == "urgent_governance_review"),
    .groups = "drop"
  ) %>%
  arrange(desc(mean_priority))

finance_summary <- risk_summary %>%
  group_by(financing_strategy, insured) %>%
  summarise(
    risks = n(),
    total_reserve_required = sum(reserve_required, na.rm = TRUE),
    mean_residual_risk = round(mean(residual_risk, na.rm = TRUE), 3),
    .groups = "drop"
  ) %>%
  arrange(desc(mean_residual_risk))

write_csv(risk_summary, file.path(output_dir, "r_infrastructure_risk_priority_table.csv"))
write_csv(sector_summary, file.path(output_dir, "r_infrastructure_risk_sector_summary.csv"))
write_csv(finance_summary, file.path(output_dir, "r_risk_financing_summary.csv"))

print(risk_summary)
print(sector_summary)
print(finance_summary)
