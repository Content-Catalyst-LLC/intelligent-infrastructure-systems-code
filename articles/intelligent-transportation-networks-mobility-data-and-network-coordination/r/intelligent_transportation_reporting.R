library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

inventory <- read_csv(file.path(data_dir, "transport_network_inventory.csv"), show_col_types = FALSE)
telemetry <- read_csv(file.path(data_dir, "mobility_telemetry_sample.csv"), show_col_types = FALSE)
performance <- read_csv(file.path(data_dir, "service_performance_review.csv"), show_col_types = FALSE)
safety_access <- read_csv(file.path(data_dir, "safety_accessibility_review.csv"), show_col_types = FALSE)

review <- telemetry %>%
  left_join(inventory, by = "network_element_id") %>%
  left_join(performance, by = "network_element_id") %>%
  left_join(safety_access, by = "service_zone_id") %>%
  mutate(
    travel_time_reliability = pmax(0, pmin(1, 1 - travel_time_std_minutes / travel_time_mean_minutes)),
    incident_recovery_lag_minutes = pmax(expected_recovery_minutes - target_recovery_minutes, 0),
    mobility_quality_score = pmax(
      0,
      pmin(
        1,
        0.25 * travel_time_reliability +
        0.20 * accessibility_score +
        0.20 * safety_score +
        0.20 * coordination_score -
        0.15 * emissions_burden_score
      )
    ),
    transport_review_flag =
      travel_time_reliability < 0.70 |
      accessibility_gap_score >= 0.35 |
      safety_risk_score >= 0.35 |
      incident_recovery_lag_minutes > 0 |
      coordination_score < 0.65 |
      quality_flag == "review"
  )

mode_summary <- review %>%
  group_by(mode) %>%
  summarise(
    network_elements = n_distinct(network_element_id),
    observations = n(),
    mean_reliability = mean(travel_time_reliability, na.rm = TRUE),
    mean_accessibility_gap = mean(accessibility_gap_score, na.rm = TRUE),
    mean_safety_risk = mean(safety_risk_score, na.rm = TRUE),
    mean_coordination = mean(coordination_score, na.rm = TRUE),
    mean_mobility_quality = mean(mobility_quality_score, na.rm = TRUE),
    review_flags = sum(transport_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(review_flags), desc(mean_safety_risk))

write_csv(review, file.path(output_dir, "intelligent_transportation_review_report.csv"))
write_csv(mode_summary, file.path(output_dir, "transportation_mode_summary.csv"))

print(mode_summary)
