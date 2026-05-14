library(readr)
library(dplyr)

args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- sub(file_arg, "", args[grep(file_arg, args)])
article_dir <- normalizePath(file.path(dirname(script_path), ".."))
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

read_article_csv <- function(filename) {
  read_csv(file.path(data_dir, filename), show_col_types = FALSE)
}

projects <- read_article_csv("infrastructure_project_register.csv")
appraisal <- read_article_csv("project_appraisal_register.csv")
fiscal <- read_article_csv("fiscal_risk_register.csv")
delivery <- read_article_csv("procurement_delivery_log.csv")
stewardship <- read_article_csv("asset_stewardship_register.csv")
accountability <- read_article_csv("accountability_transparency_log.csv")

governance <- projects |>
  left_join(appraisal, by = "project_id") |>
  left_join(fiscal, by = "project_id") |>
  left_join(delivery, by = "project_id") |>
  left_join(stewardship, by = "project_id") |>
  left_join(accountability, by = "project_id") |>
  mutate(
    learning_capacity_score = case_when(
      public_evidence_status == "current" ~ 0.74,
      public_evidence_status == "partial" ~ 0.64,
      public_evidence_status == "review_required" ~ 0.55,
      TRUE ~ 0.55
    ),
    maintenance_backlog_musd = pmax(required_annual_maintenance_musd - funded_annual_maintenance_musd, 0),
    accountability_quality = rowMeans(
      across(c(transparency_score, consultation_score, auditability_score, disclosure_usability_score)),
      na.rm = TRUE
    ),
    governance_quality =
      0.20 * public_value_score +
      0.15 * affordability_score +
      0.15 * delivery_readiness_score +
      0.20 * stewardship_readiness_score +
      0.15 * accountability_quality +
      0.15 * learning_capacity_score,
    governance_risk = (1 - governance_quality) * complexity_score * criticality_score,
    readiness_status = case_when(
      governance_quality < 0.60 ~ "escalate",
      governance_risk > 0.25 ~ "escalate",
      maintenance_backlog_musd > 0 ~ "review_required",
      accountability_quality < 0.65 ~ "review_required",
      fiscal_risk_status == "review_required" ~ "review_required",
      TRUE ~ "ready_with_monitoring"
    )
  )

sector_summary <- governance |>
  group_by(sector) |>
  summarise(
    projects = n(),
    avg_governance_quality = mean(governance_quality, na.rm = TRUE),
    avg_governance_risk = mean(governance_risk, na.rm = TRUE),
    total_maintenance_backlog_musd = sum(maintenance_backlog_musd, na.rm = TRUE),
    escalation_count = sum(readiness_status == "escalate"),
    review_required_count = sum(readiness_status == "review_required"),
    .groups = "drop"
  ) |>
  arrange(desc(avg_governance_risk))

write_csv(governance, file.path(output_dir, "governance_project_diagnostics.csv"))
write_csv(sector_summary, file.path(output_dir, "governance_sector_summary.csv"))

print(sector_summary)
