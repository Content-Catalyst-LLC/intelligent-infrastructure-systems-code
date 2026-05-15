library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

assets <- read_csv(file.path(data_dir, "energy_asset_inventory.csv"), show_col_types = FALSE)
telemetry <- read_csv(file.path(data_dir, "energy_performance_telemetry.csv"), show_col_types = FALSE)
condition <- read_csv(file.path(data_dir, "condition_degradation_log.csv"), show_col_types = FALSE)
resilience <- read_csv(file.path(data_dir, "reliability_resilience_review.csv"), show_col_types = FALSE)
power_quality <- read_csv(file.path(data_dir, "power_quality_stability_records.csv"), show_col_types = FALSE)

review <- telemetry %>%
  left_join(assets, by = "asset_id") %>%
  left_join(condition, by = "asset_id") %>%
  left_join(resilience, by = "asset_id") %>%
  left_join(power_quality, by = "asset_id") %>%
  mutate(
    availability_score = pmax(0, pmin(1, available_hours / total_hours)),
    service_continuity_score = if_else(
      power_demand_mw > 0,
      pmax(0, pmin(1, power_served_mw / power_demand_mw)),
      1.0
    ),
    degradation_score = pmax(
      0,
      pmin(1, (baseline_health_score - current_health_score) / baseline_health_score)
    ),
    stress_score = pmax(
      0,
      pmin(
        1,
        0.30 * loading_stress_score +
        0.25 * thermal_stress_score +
        0.25 * cycling_stress_score +
        0.20 * environmental_exposure_score
      )
    ),
    resilience_score = pmax(
      0,
      pmin(
        1,
        0.25 * availability_score +
        0.25 * service_continuity_score +
        0.20 * fallback_capacity_score +
        0.15 * observability_score -
        0.15 * restoration_time_score
      )
    ),
    performance_review_flag =
      availability_score < 0.95 |
      service_continuity_score < 0.90 |
      degradation_score >= 0.25 |
      stress_score >= 0.65 |
      power_quality_risk_score >= 0.35 |
      resilience_score < 0.70 |
      quality_flag == "review" |
      maintenance_status == "review_required"
  )

asset_class_summary <- review %>%
  group_by(asset_class) %>%
  summarise(
    assets = n_distinct(asset_id),
    observations = n(),
    mean_availability = mean(availability_score, na.rm = TRUE),
    mean_service_continuity = mean(service_continuity_score, na.rm = TRUE),
    mean_degradation = mean(degradation_score, na.rm = TRUE),
    mean_stress = mean(stress_score, na.rm = TRUE),
    mean_power_quality_risk = mean(power_quality_risk_score, na.rm = TRUE),
    mean_resilience = mean(resilience_score, na.rm = TRUE),
    review_flags = sum(performance_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(review_flags), desc(mean_stress))

write_csv(review, file.path(output_dir, "energy_infrastructure_performance_report.csv"))
write_csv(asset_class_summary, file.path(output_dir, "energy_asset_class_summary.csv"))

print(asset_class_summary)
