library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

sensors <- read_csv(file.path(data_dir, "urban_sensor_inventory.csv"), show_col_types = FALSE)
telemetry <- read_csv(file.path(data_dir, "urban_sensor_telemetry_sample.csv"), show_col_types = FALSE)
linkage <- read_csv(file.path(data_dir, "sensor_asset_linkage.csv"), show_col_types = FALSE)
health <- read_csv(file.path(data_dir, "calibration_device_health_log.csv"), show_col_types = FALSE)
coverage <- read_csv(file.path(data_dir, "coverage_exposure_review.csv"), show_col_types = FALSE)
indicators <- read_csv(file.path(data_dir, "urban_sensor_indicator_catalog.csv"), show_col_types = FALSE)

review <- telemetry %>%
  left_join(sensors, by = c("sensor_id", "domain", "variable")) %>%
  left_join(linkage, by = "sensor_id") %>%
  left_join(health, by = "sensor_id") %>%
  left_join(coverage, by = "service_zone_id") %>%
  left_join(indicators, by = c("domain", "variable")) %>%
  mutate(
    threshold_exceeded = value >= threshold_value,
    latency_score = pmax(0, pmin(1, 1 - latency_seconds / max(latency_seconds, na.rm = TRUE))),
    sensor_quality_score =
      0.25 * uptime_score +
      0.20 * calibration_score +
      0.20 * metadata_score +
      0.20 * latency_score +
      0.15 * provenance_score,
    coverage_gap_score = 1 - coverage_score,
    urban_observability_score =
      0.30 * sensor_quality_score +
      0.20 * coverage_score +
      0.20 * interoperability_score +
      0.15 * service_relevance_score +
      0.15 * governance_response_score,
    monitoring_review_flag =
      threshold_exceeded |
      sensor_quality_score < 0.75 |
      coverage_gap_score >= 0.35 |
      latency_seconds > max_acceptable_latency_seconds |
      governance_response_score < 0.60 |
      device_health_status == "review_required"
  )

domain_summary <- review %>%
  group_by(domain) %>%
  summarise(
    sensors = n_distinct(sensor_id),
    observations = n(),
    threshold_exceedances = sum(threshold_exceeded, na.rm = TRUE),
    mean_sensor_quality = mean(sensor_quality_score, na.rm = TRUE),
    mean_coverage_gap = mean(coverage_gap_score, na.rm = TRUE),
    mean_observability = mean(urban_observability_score, na.rm = TRUE),
    review_flags = sum(monitoring_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(review_flags), desc(mean_coverage_gap))

write_csv(review, file.path(output_dir, "urban_sensor_monitoring_review_report.csv"))
write_csv(domain_summary, file.path(output_dir, "urban_sensor_domain_summary.csv"))

print(domain_summary)
