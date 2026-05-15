library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

assets <- read_csv(file.path(data_dir, "water_asset_inventory.csv"), show_col_types = FALSE)
telemetry <- read_csv(file.path(data_dir, "water_telemetry_records.csv"), show_col_types = FALSE)
quality <- read_csv(file.path(data_dir, "water_quality_public_health_review.csv"), show_col_types = FALSE)
hydraulic <- read_csv(file.path(data_dir, "leakage_hydraulic_control_review.csv"), show_col_types = FALSE)
storm <- read_csv(file.path(data_dir, "wastewater_stormwater_risk_review.csv"), show_col_types = FALSE)

review <- telemetry %>%
  left_join(assets, by = "asset_id") %>%
  left_join(quality, by = "service_zone_id") %>%
  left_join(hydraulic, by = "service_zone_id") %>%
  left_join(storm, by = "service_zone_id") %>%
  mutate(
    quality_compliance_score = if_else(
      tested_observations > 0,
      pmax(0, pmin(1, compliant_observations / tested_observations)),
      0
    ),
    pressure_adequacy_score = pmax(
      0,
      pmin(1, (pressure_psi - minimum_pressure_psi) / (maximum_pressure_psi - minimum_pressure_psi))
    ),
    leakage_rate = if_else(
      system_input_volume_m3 > 0,
      pmax(0, pmin(1, (system_input_volume_m3 - authorized_consumption_m3) / system_input_volume_m3)),
      0
    ),
    available_service_hours = 24 * pmax(
      0,
      pmin(1, 0.50 * telemetry_reliability_score + 0.25 * backup_capacity_score + 0.25 * response_capacity_score)
    ),
    required_service_hours = 24,
    service_continuity_score = pmax(0, pmin(1, available_service_hours / required_service_hours)),
    latency_score = pmax(0, pmin(1, 1 - latency_seconds / max(latency_seconds, na.rm = TRUE))),
    water_observability_score = pmax(
      0,
      pmin(
        1,
        0.25 * telemetry_reliability_score +
        0.25 * data_quality_score +
        0.20 * coverage_score +
        0.15 * metadata_completeness_score +
        0.15 * latency_score
      )
    ),
    water_resilience_score = pmax(
      0,
      pmin(
        1,
        0.25 * service_continuity_score +
        0.20 * quality_compliance_score +
        0.20 * backup_capacity_score +
        0.15 * water_observability_score +
        0.15 * response_capacity_score -
        0.15 * exposure_risk_score
      )
    ),
    water_review_flag =
      quality_compliance_score < 0.98 |
      pressure_adequacy_score < 0.35 |
      leakage_rate >= 0.20 |
      service_continuity_score < 0.90 |
      water_observability_score < 0.70 |
      water_resilience_score < 0.70 |
      overflow_risk_score >= 0.35 |
      quality_flag == "review"
  )

zone_summary <- review %>%
  group_by(service_zone_id) %>%
  summarise(
    assets = n_distinct(asset_id),
    observations = n(),
    mean_quality_compliance = mean(quality_compliance_score, na.rm = TRUE),
    mean_pressure_adequacy = mean(pressure_adequacy_score, na.rm = TRUE),
    mean_leakage_rate = mean(leakage_rate, na.rm = TRUE),
    mean_observability = mean(water_observability_score, na.rm = TRUE),
    mean_resilience = mean(water_resilience_score, na.rm = TRUE),
    mean_overflow_risk = mean(overflow_risk_score, na.rm = TRUE),
    review_flags = sum(water_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(review_flags), desc(mean_leakage_rate))

write_csv(review, file.path(output_dir, "intelligent_water_infrastructure_review_report.csv"))
write_csv(zone_summary, file.path(output_dir, "water_service_zone_summary.csv"))

print(zone_summary)
