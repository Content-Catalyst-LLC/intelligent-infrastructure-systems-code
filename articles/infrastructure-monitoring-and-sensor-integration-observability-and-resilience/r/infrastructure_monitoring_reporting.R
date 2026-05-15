library(readr)
library(dplyr)
library(lubridate)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

sensors <- read_csv(file.path(data_dir, "sensor_inventory.csv"), show_col_types = FALSE)
assets <- read_csv(file.path(data_dir, "monitored_asset_registry.csv"), show_col_types = FALSE)
telemetry <- read_csv(file.path(data_dir, "sensor_telemetry_records.csv"), show_col_types = FALSE)
calibration <- read_csv(file.path(data_dir, "calibration_validation_log.csv"), show_col_types = FALSE)
coverage <- read_csv(file.path(data_dir, "coverage_blindspot_review.csv"), show_col_types = FALSE)
alerts <- read_csv(file.path(data_dir, "monitoring_alert_response_register.csv"), show_col_types = FALSE)

alert_actions <- alerts %>%
  mutate(has_action = response_status %in% c("open", "closed", "in_progress")) %>%
  group_by(sensor_id) %>%
  summarise(actionability_score = mean(has_action), .groups = "drop")

review <- telemetry %>%
  left_join(sensors, by = "sensor_id") %>%
  left_join(assets, by = c("asset_id", "source_system_id"), suffix = c("", "_asset")) %>%
  left_join(calibration, by = "sensor_id") %>%
  left_join(coverage, by = "service_zone_id", suffix = c("", "_coverage")) %>%
  left_join(alert_actions, by = "sensor_id") %>%
  mutate(
    signal_quality_score = pmax(
      0,
      pmin(
        1,
        0.25 * accuracy_score +
        0.20 * precision_score +
        0.20 * completeness_score +
        0.20 * validity_score +
        0.15 * freshness_score
      )
    ),
    days_since_calibration = as.numeric(as.Date(Sys.time()) - as.Date(last_calibration_date)),
    calibration_confidence_score = pmax(0, pmin(1, exp(-0.004 * days_since_calibration))),
    telemetry_reliability_score = if_else(
      expected_readings > 0,
      pmax(
        0,
        pmin(1, 1 - (missing_readings + late_readings + invalid_readings) / expected_readings)
      ),
      0
    ),
    metadata_completeness_score = rowMeans(
      across(
        c(
          has_sensor_id,
          has_asset_id,
          has_location,
          has_unit,
          has_timestamp_source,
          has_owner,
          has_quality_flag,
          has_valid_use
        ),
        as.numeric
      ),
      na.rm = TRUE
    ),
    sensor_coverage_score = if_else(
      critical_assets > 0,
      pmax(0, pmin(1, monitored_critical_assets / critical_assets)),
      0
    ),
    blindspot_penalty = if_else(
      total_service_zones > 0,
      pmax(0, pmin(1, unmonitored_high_risk_zones / total_service_zones)),
      0
    ),
    monitoring_observability_score = pmax(
      0,
      pmin(
        1,
        0.20 * sensor_coverage_score +
        0.20 * signal_quality_score +
        0.20 * calibration_confidence_score +
        0.20 * telemetry_reliability_score +
        0.15 * metadata_completeness_score -
        0.15 * blindspot_penalty
      )
    ),
    actionability_score = if_else(is.na(actionability_score), 0, actionability_score),
    monitoring_resilience_score = pmax(
      0,
      pmin(
        1,
        0.35 * monitoring_observability_score +
        0.25 * actionability_score +
        0.20 * field_validation_score +
        0.10 * device_health_score -
        0.10 * blindspot_penalty
      )
    ),
    monitoring_review_flag =
      signal_quality_score < 0.80 |
      calibration_confidence_score < 0.70 |
      telemetry_reliability_score < 0.85 |
      metadata_completeness_score < 0.85 |
      sensor_coverage_score < 0.75 |
      monitoring_observability_score < 0.75 |
      actionability_score < 0.50 |
      quality_flag == "review"
  )

zone_summary <- review %>%
  group_by(service_zone_id, infrastructure_domain, owner_operator) %>%
  summarise(
    sensors = n_distinct(sensor_id),
    assets = n_distinct(asset_id),
    mean_signal_quality = mean(signal_quality_score, na.rm = TRUE),
    mean_calibration_confidence = mean(calibration_confidence_score, na.rm = TRUE),
    mean_telemetry_reliability = mean(telemetry_reliability_score, na.rm = TRUE),
    mean_metadata_completeness = mean(metadata_completeness_score, na.rm = TRUE),
    mean_sensor_coverage = mean(sensor_coverage_score, na.rm = TRUE),
    mean_monitoring_observability = mean(monitoring_observability_score, na.rm = TRUE),
    mean_actionability = mean(actionability_score, na.rm = TRUE),
    mean_resilience = mean(monitoring_resilience_score, na.rm = TRUE),
    review_flags = sum(monitoring_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(review_flags), mean_monitoring_observability)

write_csv(review, file.path(output_dir, "infrastructure_monitoring_review_report.csv"))
write_csv(zone_summary, file.path(output_dir, "infrastructure_monitoring_zone_summary.csv"))

print(zone_summary)
