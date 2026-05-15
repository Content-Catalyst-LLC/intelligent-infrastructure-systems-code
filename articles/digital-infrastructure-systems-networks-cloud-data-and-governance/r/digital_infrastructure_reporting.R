library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

connectivity <- read_csv(file.path(data_dir, "connectivity_infrastructure_inventory.csv"), show_col_types = FALSE)
cloud <- read_csv(file.path(data_dir, "cloud_data_infrastructure_register.csv"), show_col_types = FALSE)
interoperability <- read_csv(file.path(data_dir, "interoperability_exchange_register.csv"), show_col_types = FALSE)
trust <- read_csv(file.path(data_dir, "identity_trust_register.csv"), show_col_types = FALSE)
continuity <- read_csv(file.path(data_dir, "digital_dependency_continuity_review.csv"), show_col_types = FALSE)
inclusion <- read_csv(file.path(data_dir, "access_inclusion_review.csv"), show_col_types = FALSE)

review <- connectivity %>%
  left_join(cloud, by = "service_zone_id") %>%
  left_join(interoperability, by = "service_zone_id") %>%
  left_join(trust, by = "service_zone_id") %>%
  left_join(continuity, by = "service_zone_id") %>%
  left_join(inclusion, by = "service_zone_id") %>%
  mutate(
    digital_access_score = if_else(
      users_needing_access > 0,
      pmax(0, pmin(1, users_with_affordable_reliable_access / users_needing_access)),
      0
    ),
    network_capacity_score = pmax(
      0,
      pmin(
        1,
        0.30 * bandwidth_score +
        0.25 * latency_score +
        0.25 * uptime_score +
        0.20 * redundancy_score
      )
    ),
    compute_storage_score = pmax(
      0,
      pmin(
        1,
        0.30 * compute_capacity_score +
        0.25 * storage_capacity_score +
        0.25 * geo_redundancy_score +
        0.20 * edge_readiness_score
      )
    ),
    interoperability_score = if_else(
      systems_requiring_exchange > 0,
      pmax(0, pmin(1, systems_using_shared_standards / systems_requiring_exchange)),
      0
    ),
    trust_security_score = pmax(
      0,
      pmin(
        1,
        0.25 * security_control_score +
        0.20 * privacy_safeguard_score +
        0.20 * auditability_score +
        0.20 * recovery_readiness_score +
        0.15 * governance_maturity_score
      )
    ),
    vendor_dependency_score = if_else(
      critical_digital_services > 0,
      pmax(0, pmin(1, critical_services_dependent_on_concentrated_providers / critical_digital_services)),
      0
    ),
    inclusion_capacity_score = pmax(
      0,
      pmin(
        1,
        0.20 * affordability_score +
        0.20 * accessibility_score +
        0.15 * language_support_score +
        0.15 * device_access_score +
        0.20 * assisted_service_availability_score +
        0.10 * (1 - documentation_burden_score)
      )
    ),
    digital_resilience_score = pmax(
      0,
      pmin(
        1,
        0.20 * digital_access_score +
        0.20 * network_capacity_score +
        0.20 * compute_storage_score +
        0.15 * interoperability_score +
        0.20 * trust_security_score -
        0.15 * vendor_dependency_score -
        0.10 * exposure_score
      )
    ),
    digital_infrastructure_review_flag =
      digital_access_score < 0.85 |
      network_capacity_score < 0.80 |
      compute_storage_score < 0.75 |
      interoperability_score < 0.70 |
      trust_security_score < 0.75 |
      digital_resilience_score < 0.75 |
      vendor_dependency_score > 0.70 |
      exposure_score > 0.40 |
      exclusion_risk_score > 0.30
  )

zone_summary <- review %>%
  group_by(service_zone_id, region_name, infrastructure_context) %>%
  summarise(
    mean_access = mean(digital_access_score, na.rm = TRUE),
    mean_network_capacity = mean(network_capacity_score, na.rm = TRUE),
    mean_compute_storage = mean(compute_storage_score, na.rm = TRUE),
    mean_interoperability = mean(interoperability_score, na.rm = TRUE),
    mean_trust_security = mean(trust_security_score, na.rm = TRUE),
    mean_vendor_dependency = mean(vendor_dependency_score, na.rm = TRUE),
    mean_resilience = mean(digital_resilience_score, na.rm = TRUE),
    mean_inclusion_capacity = mean(inclusion_capacity_score, na.rm = TRUE),
    mean_exclusion_risk = mean(exclusion_risk_score, na.rm = TRUE),
    review_flags = sum(digital_infrastructure_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(review_flags), mean_resilience)

write_csv(review, file.path(output_dir, "digital_infrastructure_review_report.csv"))
write_csv(zone_summary, file.path(output_dir, "digital_infrastructure_zone_summary.csv"))

print(zone_summary)
