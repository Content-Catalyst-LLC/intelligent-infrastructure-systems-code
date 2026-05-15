library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

inventory <- read_csv(file.path(data_dir, "urban_infrastructure_inventory.csv"), show_col_types = FALSE)
observability <- read_csv(file.path(data_dir, "urban_observability_records.csv"), show_col_types = FALSE)
indicators <- read_csv(file.path(data_dir, "public_value_indicator_catalog.csv"), show_col_types = FALSE)
rights <- read_csv(file.path(data_dir, "digital_inclusion_rights_review.csv"), show_col_types = FALSE)

review <- observability %>%
  left_join(inventory, by = c("infrastructure_id", "domain")) %>%
  left_join(rights, by = "service_zone_id") %>%
  left_join(indicators, by = c("domain", "indicator_name")) %>%
  mutate(
    service_continuity_score = pmax(0, pmin(1, observed_service_capacity / normal_service_capacity)),
    latency_score = pmax(0, pmin(1, 1 - latency_seconds / max(latency_seconds, na.rm = TRUE))),
    domain_observability_score =
      0.25 * data_quality_score +
      0.20 * coverage_score +
      0.20 * interoperability_score +
      0.20 * latency_score +
      0.15 * governance_response_score,
    public_value_score = pmax(
      0,
      pmin(
        1,
        0.25 * service_continuity_score +
        0.20 * accessibility_score +
        0.20 * resilience_score +
        0.20 * inclusion_score +
        0.15 * trust_score -
        0.15 * unequal_burden_score
      )
    ),
    smart_city_review_flag =
      service_continuity_score < 0.75 |
      domain_observability_score < 0.70 |
      public_value_score < 0.65 |
      digital_access_gap_score >= 0.35 |
      privacy_risk_score >= 0.35 |
      quality_flag == "review"
  )

domain_summary <- review %>%
  group_by(domain) %>%
  summarise(
    infrastructure_assets = n_distinct(infrastructure_id),
    observations = n(),
    mean_service_continuity = mean(service_continuity_score, na.rm = TRUE),
    mean_observability = mean(domain_observability_score, na.rm = TRUE),
    mean_public_value = mean(public_value_score, na.rm = TRUE),
    mean_digital_access_gap = mean(digital_access_gap_score, na.rm = TRUE),
    mean_privacy_risk = mean(privacy_risk_score, na.rm = TRUE),
    review_flags = sum(smart_city_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(review_flags), desc(mean_digital_access_gap))

write_csv(review, file.path(output_dir, "smart_city_infrastructure_review_report.csv"))
write_csv(domain_summary, file.path(output_dir, "smart_city_domain_summary.csv"))

print(domain_summary)
