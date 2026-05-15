library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

hazards <- read_csv(file.path(data_dir, "hazard_exposure_register.csv"), show_col_types = FALSE)
observations <- read_csv(file.path(data_dir, "observation_network_inventory.csv"), show_col_types = FALSE)
forecasts <- read_csv(file.path(data_dir, "forecast_product_register.csv"), show_col_types = FALSE)
channels <- read_csv(file.path(data_dir, "warning_channel_register.csv"), show_col_types = FALSE)
preparedness <- read_csv(file.path(data_dir, "preparedness_action_log.csv"), show_col_types = FALSE)
inclusion <- read_csv(file.path(data_dir, "accessibility_inclusion_review.csv"), show_col_types = FALSE)

report <- hazards %>%
  left_join(observations %>% select(hazard_id, detection_reliability, uptime_score), by = "hazard_id") %>%
  left_join(forecasts, by = "hazard_id") %>%
  left_join(channels, by = "warning_zone_id") %>%
  left_join(preparedness, by = "warning_zone_id") %>%
  left_join(inclusion, by = "warning_zone_id") %>%
  mutate(
    useful_lead_time_minutes = forecast_lead_time_minutes -
      decision_delay_minutes -
      communication_delay_minutes -
      mobilization_time_minutes,
    protective_warning_probability = detection_reliability *
      population_reach *
      message_comprehension *
      trust_score *
      action_capacity,
    residual_warning_risk = hazard_severity *
      exposure_score *
      vulnerability_score *
      (1 - protective_warning_probability),
    accessibility_gap = 1 - accessibility_readiness
  )

hazard_summary <- report %>%
  group_by(hazard_type) %>%
  summarise(
    zones = n_distinct(warning_zone_id),
    mean_useful_lead_time = mean(useful_lead_time_minutes, na.rm = TRUE),
    mean_protective_probability = mean(protective_warning_probability, na.rm = TRUE),
    mean_residual_warning_risk = mean(residual_warning_risk, na.rm = TRUE),
    high_accessibility_gap_zones = sum(accessibility_gap >= 0.35, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(mean_residual_warning_risk))

write_csv(report, file.path(output_dir, "early_warning_accessibility_report.csv"))
write_csv(hazard_summary, file.path(output_dir, "early_warning_hazard_summary.csv"))

print(hazard_summary)
