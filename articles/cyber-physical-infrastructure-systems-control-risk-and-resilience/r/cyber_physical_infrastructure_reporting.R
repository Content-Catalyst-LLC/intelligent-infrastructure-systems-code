library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

assets <- read_csv(file.path(data_dir, "cyber_physical_asset_inventory.csv"), show_col_types = FALSE)
loops <- read_csv(file.path(data_dir, "control_loop_register.csv"), show_col_types = FALSE)
telemetry <- read_csv(file.path(data_dir, "telemetry_command_records.csv"), show_col_types = FALSE)
dependencies <- read_csv(file.path(data_dir, "dependency_exposure_map.csv"), show_col_types = FALSE)
assurance <- read_csv(file.path(data_dir, "assurance_fallback_review.csv"), show_col_types = FALSE)

review <- telemetry %>%
  left_join(loops, by = "control_loop_id") %>%
  left_join(assets, by = "asset_id") %>%
  left_join(dependencies, by = "asset_id") %>%
  left_join(assurance, by = "control_loop_id") %>%
  mutate(
    signal_quality_score = pmax(
      0,
      pmin(
        1,
        0.25 * accuracy_score +
        0.20 * calibration_score +
        0.20 * timeliness_score +
        0.20 * validity_score +
        0.15 * metadata_completeness_score
      )
    ),
    telemetry_reliability_score = if_else(
      expected_signals > 0,
      pmax(0, pmin(1, 1 - (missing_signals + late_signals + invalid_signals) / expected_signals)),
      0
    ),
    dependency_intensity_score = if_else(
      critical_functions > 0,
      pmax(0, pmin(1, cyber_dependent_functions / critical_functions)),
      0
    ),
    control_validation_score = rowMeans(
      across(
        c(
          timing_validated,
          safety_boundary_validated,
          degraded_mode_tested,
          manual_override_tested,
          recovery_tested
        ),
        as.numeric
      ),
      na.rm = TRUE
    ),
    human_oversight_score = rowMeans(
      across(
        c(
          operator_visibility,
          override_authority,
          training_current,
          escalation_path_defined
        ),
        as.numeric
      ),
      na.rm = TRUE
    ),
    control_integrity_score = pmax(
      0,
      pmin(
        1,
        0.25 * signal_quality_score +
        0.20 * telemetry_reliability_score +
        0.20 * control_validation_score +
        0.15 * security_control_score +
        0.15 * human_oversight_score -
        0.10 * exposure_score
      )
    ),
    cyber_physical_resilience_score = pmax(
      0,
      pmin(
        1,
        0.30 * control_integrity_score +
        0.20 * fallback_capability_score +
        0.20 * manual_override_score +
        0.20 * recovery_effectiveness_score -
        0.10 * dependency_intensity_score -
        0.10 * exposure_score
      )
    ),
    command_review_flag = !command_within_bounds | !operator_acknowledged,
    cyber_physical_review_flag =
      signal_quality_score < 0.80 |
      telemetry_reliability_score < 0.85 |
      control_validation_score < 0.75 |
      human_oversight_score < 0.75 |
      control_integrity_score < 0.75 |
      cyber_physical_resilience_score < 0.70 |
      dependency_intensity_score > 0.70 |
      exposure_score > 0.40 |
      quality_flag == "review" |
      command_review_flag
  )

domain_summary <- review %>%
  group_by(infrastructure_domain, service_zone_id, owner_operator) %>%
  summarise(
    control_loops = n_distinct(control_loop_id),
    assets = n_distinct(asset_id),
    mean_signal_quality = mean(signal_quality_score, na.rm = TRUE),
    mean_telemetry_reliability = mean(telemetry_reliability_score, na.rm = TRUE),
    mean_control_validation = mean(control_validation_score, na.rm = TRUE),
    mean_human_oversight = mean(human_oversight_score, na.rm = TRUE),
    mean_control_integrity = mean(control_integrity_score, na.rm = TRUE),
    mean_resilience = mean(cyber_physical_resilience_score, na.rm = TRUE),
    mean_dependency_intensity = mean(dependency_intensity_score, na.rm = TRUE),
    mean_exposure = mean(exposure_score, na.rm = TRUE),
    review_flags = sum(cyber_physical_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(review_flags), mean_resilience)

write_csv(review, file.path(output_dir, "cyber_physical_infrastructure_review_report.csv"))
write_csv(domain_summary, file.path(output_dir, "cyber_physical_domain_summary.csv"))

print(domain_summary)
