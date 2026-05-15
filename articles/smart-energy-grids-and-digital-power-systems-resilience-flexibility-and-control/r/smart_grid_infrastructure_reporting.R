library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

assets <- read_csv(file.path(data_dir, "grid_asset_inventory.csv"), show_col_types = FALSE)
telemetry <- read_csv(file.path(data_dir, "grid_telemetry_records.csv"), show_col_types = FALSE)
der <- read_csv(file.path(data_dir, "distributed_resource_coordination_register.csv"), show_col_types = FALSE)
resilience <- read_csv(file.path(data_dir, "grid_reliability_resilience_review.csv"), show_col_types = FALSE)
cyber <- read_csv(file.path(data_dir, "cyber_physical_grid_review.csv"), show_col_types = FALSE)

review <- telemetry %>%
  left_join(assets, by = "asset_id") %>%
  left_join(der, by = "service_zone_id") %>%
  left_join(resilience, by = "service_zone_id") %>%
  left_join(cyber, by = "service_zone_id") %>%
  mutate(
    latency_score = pmax(0, pmin(1, 1 - latency_seconds / max(latency_seconds, na.rm = TRUE))),
    grid_observability_score = pmax(
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
    voltage_adequacy_score = pmax(
      0,
      pmin(1, 1 - abs(voltage_pu - 1.0) / allowed_voltage_deviation_pu)
    ),
    flexibility_adequacy_score = if_else(
      flexibility_need_mw > 0,
      pmax(0, pmin(1, available_flexibility_mw / flexibility_need_mw)),
      1
    ),
    balancing_pressure_score = if_else(
      load_mw > 0,
      pmax(0, pmin(1, abs(load_mw - available_supply_mw - available_flexibility_mw) / load_mw)),
      0
    ),
    service_continuity_score = if_else(
      required_service_hours > 0,
      pmax(0, pmin(1, served_hours / required_service_hours)),
      0
    ),
    grid_resilience_score = pmax(
      0,
      pmin(
        1,
        0.25 * service_continuity_score +
        0.20 * flexibility_adequacy_score +
        0.20 * grid_observability_score +
        0.15 * backup_capability_score +
        0.15 * response_capacity_score -
        0.15 * exposure_risk_score
      )
    ),
    smart_grid_review_flag =
      grid_observability_score < 0.70 |
      voltage_adequacy_score < 0.70 |
      flexibility_adequacy_score < 0.75 |
      balancing_pressure_score >= 0.20 |
      service_continuity_score < 0.90 |
      grid_resilience_score < 0.70 |
      cyber_physical_risk_score >= 0.35 |
      quality_flag == "review"
  )

zone_summary <- review %>%
  group_by(service_zone_id) %>%
  summarise(
    assets = n_distinct(asset_id),
    observations = n(),
    mean_observability = mean(grid_observability_score, na.rm = TRUE),
    mean_voltage_adequacy = mean(voltage_adequacy_score, na.rm = TRUE),
    mean_flexibility_adequacy = mean(flexibility_adequacy_score, na.rm = TRUE),
    mean_balancing_pressure = mean(balancing_pressure_score, na.rm = TRUE),
    mean_resilience = mean(grid_resilience_score, na.rm = TRUE),
    mean_cyber_physical_risk = mean(cyber_physical_risk_score, na.rm = TRUE),
    review_flags = sum(smart_grid_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(review_flags), desc(mean_cyber_physical_risk))

write_csv(review, file.path(output_dir, "smart_grid_infrastructure_review_report.csv"))
write_csv(zone_summary, file.path(output_dir, "smart_grid_service_zone_summary.csv"))

print(zone_summary)
