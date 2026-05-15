library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

hazards <- read_csv(file.path(data_dir, "hazard_stress_register.csv"), show_col_types = FALSE)
services <- read_csv(file.path(data_dir, "critical_service_inventory.csv"), show_col_types = FALSE)
continuity <- read_csv(file.path(data_dir, "continuity_recovery_plan.csv"), show_col_types = FALSE)
equity <- read_csv(file.path(data_dir, "vulnerability_service_equity_review.csv"), show_col_types = FALSE)

zone_hazards <- hazards %>%
  group_by(service_zone_id) %>%
  summarise(
    hazard_intensity = max(hazard_intensity, na.rm = TRUE),
    exposure_score = max(exposure_score, na.rm = TRUE),
    hazard_types = paste(sort(unique(hazard_type)), collapse = ";"),
    .groups = "drop"
  )

review <- services %>%
  left_join(continuity, by = "service_id") %>%
  left_join(equity, by = "service_zone_id") %>%
  left_join(zone_hazards, by = "service_zone_id") %>%
  mutate(
    service_continuity_score = pmin(disruption_capacity / normal_capacity, 1),
    recovery_lag_hours = pmax(expected_recovery_hours - target_recovery_hours, 0),
    urban_risk_score =
      hazard_intensity *
      exposure_score *
      vulnerability_score *
      (1 - governance_response_score),
    service_resilience_score =
      0.30 * service_continuity_score +
      0.20 * redundancy_score +
      0.20 * maintainability_score +
      0.15 * adaptability_score +
      0.15 * governance_response_score,
    resilience_review_flag =
      service_continuity_score < 0.75 |
      recovery_lag_hours > 0 |
      urban_risk_score >= 0.25 |
      equity_gap_score >= 0.35 |
      continuity_plan_status == "review_required"
  )

domain_summary <- review %>%
  group_by(service_domain) %>%
  summarise(
    services = n_distinct(service_id),
    mean_service_continuity = mean(service_continuity_score, na.rm = TRUE),
    mean_recovery_lag_hours = mean(recovery_lag_hours, na.rm = TRUE),
    mean_urban_risk = mean(urban_risk_score, na.rm = TRUE),
    mean_equity_gap = mean(equity_gap_score, na.rm = TRUE),
    mean_service_resilience = mean(service_resilience_score, na.rm = TRUE),
    review_flags = sum(resilience_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(mean_urban_risk))

write_csv(review, file.path(output_dir, "urban_resilience_review_report.csv"))
write_csv(domain_summary, file.path(output_dir, "urban_resilience_domain_summary.csv"))

print(domain_summary)
