suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- sub(file_arg, "", args[grep(file_arg, args)])
article_dir <- normalizePath(file.path(dirname(script_path), ".."))

kpi_path <- file.path(article_dir, "data", "cyber_resilience_kpis.csv")
control_path <- file.path(article_dir, "data", "cyber_control_baseline.csv")
vendor_path <- file.path(article_dir, "data", "vendor_risk_register.csv")
continuity_path <- file.path(article_dir, "data", "continuity_recovery_log.csv")
output_dir <- file.path(article_dir, "outputs")

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

readiness <- read_csv(kpi_path, show_col_types = FALSE) %>%
  mutate(
    raw_exposure = exposure * vulnerability,
    residual_exposure = raw_exposure * (1 - control_effectiveness),
    resilience_quality = round(
      0.14 * asset_visibility +
        0.14 * identity_governance +
        0.15 * control_effectiveness +
        0.14 * detection_capability +
        0.13 * containment_readiness +
        0.15 * recovery_readiness +
        0.15 * governance_readiness,
      3
    ),
    review_priority = case_when(
      high_criticality & continuity_readiness < 0.65 ~ "urgent_continuity_review",
      high_criticality & recovery_readiness < 0.65 ~ "urgent_recovery_review",
      identity_governance < 0.65 ~ "identity_access_review",
      detection_capability < 0.65 ~ "detection_monitoring_review",
      residual_exposure > 0.30 ~ "residual_exposure_review",
      resilience_quality < 0.70 ~ "cyber_resilience_review",
      TRUE ~ "routine_monitoring"
    )
  ) %>%
  arrange(review_priority, desc(residual_exposure))

sector_summary <- readiness %>%
  group_by(sector) %>%
  summarise(
    systems = n(),
    mean_residual_exposure = round(mean(residual_exposure), 3),
    mean_resilience_quality = round(mean(resilience_quality), 3),
    mean_recovery = round(mean(recovery_readiness), 3),
    mean_continuity = round(mean(continuity_readiness), 3),
    review_items = sum(review_priority != "routine_monitoring"),
    .groups = "drop"
  ) %>%
  arrange(desc(review_items), mean_resilience_quality)

controls <- read_csv(control_path, show_col_types = FALSE) %>%
  group_by(system_id, implementation_status) %>%
  summarise(
    controls = n(),
    mean_control_effectiveness = round(mean(control_effectiveness), 3),
    .groups = "drop"
  ) %>%
  arrange(implementation_status, mean_control_effectiveness)

vendors <- read_csv(vendor_path, show_col_types = FALSE) %>%
  filter(review_status != "current" | concentration_risk == "high") %>%
  arrange(review_status, concentration_risk)

continuity <- read_csv(continuity_path, show_col_types = FALSE) %>%
  filter(
    backup_test_status != "current" |
      manual_operation_status != "current" |
      public_communication_status != "current"
  )

write_csv(readiness, file.path(output_dir, "r_cyber_resilience_readiness.csv"))
write_csv(sector_summary, file.path(output_dir, "r_cyber_resilience_sector_summary.csv"))
write_csv(controls, file.path(output_dir, "r_cyber_control_baseline_summary.csv"))
write_csv(vendors, file.path(output_dir, "r_vendor_risk_watchlist.csv"))
write_csv(continuity, file.path(output_dir, "r_continuity_recovery_watchlist.csv"))

print(readiness)
print(sector_summary)
print(controls)
print(vendors)
print(continuity)
