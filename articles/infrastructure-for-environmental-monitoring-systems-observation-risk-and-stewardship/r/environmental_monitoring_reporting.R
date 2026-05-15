library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

sites <- read_csv(file.path(data_dir, "monitoring_site_inventory.csv"), show_col_types = FALSE)
observations <- read_csv(file.path(data_dir, "environmental_observations_sample.csv"), show_col_types = FALSE)
thresholds <- read_csv(file.path(data_dir, "environmental_threshold_indicator_catalog.csv"), show_col_types = FALSE)
calibration <- read_csv(file.path(data_dir, "calibration_device_health_log.csv"), show_col_types = FALSE)
coverage <- read_csv(file.path(data_dir, "coverage_equity_review.csv"), show_col_types = FALSE)

review <- observations %>%
  left_join(sites, by = "site_id") %>%
  left_join(thresholds, by = c("domain", "variable")) %>%
  left_join(calibration, by = "site_id") %>%
  left_join(coverage, by = "monitoring_zone_id") %>%
  mutate(
    threshold_exceeded = value >= threshold_value,
    monitoring_quality_score =
      0.25 * record_completeness +
      0.20 * calibration_score +
      0.20 * metadata_score +
      0.20 * provenance_score +
      0.15 * sampling_design_score,
    hazard_intensity = pmin(value / threshold_value, 2.0) / 2.0,
    environmental_risk_score =
      hazard_intensity *
      exposure_score *
      vulnerability_score *
      (1 - governance_response_score),
    stewardship_review_flag =
      threshold_exceeded |
      monitoring_quality_score < 0.75 |
      coverage_gap_score >= 0.35 |
      environmental_risk_score >= 0.25 |
      calibration_status == "review_required"
  )

domain_summary <- review %>%
  group_by(domain) %>%
  summarise(
    sites = n_distinct(site_id),
    observations = n(),
    threshold_exceedances = sum(threshold_exceeded, na.rm = TRUE),
    mean_monitoring_quality = mean(monitoring_quality_score, na.rm = TRUE),
    mean_environmental_risk = mean(environmental_risk_score, na.rm = TRUE),
    review_flags = sum(stewardship_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(mean_environmental_risk))

write_csv(review, file.path(output_dir, "environmental_monitoring_review_report.csv"))
write_csv(domain_summary, file.path(output_dir, "environmental_monitoring_domain_summary.csv"))

print(domain_summary)
