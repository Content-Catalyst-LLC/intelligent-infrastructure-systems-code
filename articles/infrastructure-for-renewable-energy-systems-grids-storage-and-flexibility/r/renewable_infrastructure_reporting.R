library(readr)
library(dplyr)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

assets <- read_csv(file.path(data_dir, "renewable_asset_inventory.csv"), show_col_types = FALSE)
grid <- read_csv(file.path(data_dir, "grid_connection_constraint_register.csv"), show_col_types = FALSE)
generation <- read_csv(file.path(data_dir, "renewable_generation_forecast_records.csv"), show_col_types = FALSE)
flexibility <- read_csv(file.path(data_dir, "storage_flexibility_register.csv"), show_col_types = FALSE)
resilience <- read_csv(file.path(data_dir, "renewable_reliability_resilience_review.csv"), show_col_types = FALSE)

review <- generation %>%
  left_join(assets, by = "asset_id") %>%
  left_join(grid, by = "grid_node_id") %>%
  left_join(flexibility, by = "flexibility_zone_id") %>%
  left_join(resilience, by = "service_zone_id") %>%
  mutate(
    forecast_error_mw = abs(forecast_generation_mw - actual_generation_mw),
    usable_base_mw = pmin(actual_generation_mw, grid_transfer_capacity_mw),
    usable_renewable_mw = pmin(
      actual_generation_mw,
      usable_base_mw + available_flexibility_mw + available_storage_charge_mw
    ),
    curtailment_mw = pmax(actual_generation_mw - usable_renewable_mw, 0),
    curtailment_rate = if_else(
      actual_generation_mw > 0,
      pmax(0, pmin(1, curtailment_mw / actual_generation_mw)),
      0
    ),
    flexibility_adequacy_score = if_else(
      flexibility_need_mw > 0,
      pmax(0, pmin(1, available_flexibility_mw / flexibility_need_mw)),
      1
    ),
    grid_constraint_score = if_else(
      connection_capacity_mw > 0,
      pmax(0, pmin(1, 1 - grid_transfer_capacity_mw / connection_capacity_mw)),
      0
    ),
    renewable_infrastructure_score = pmax(
      0,
      pmin(
        1,
        0.25 * (1 - curtailment_rate) +
        0.20 * flexibility_adequacy_score +
        0.20 * resilience_score +
        0.15 * forecast_quality_score +
        0.10 * storage_readiness_score -
        0.10 * grid_constraint_score
      )
    ),
    renewable_review_flag =
      curtailment_rate >= 0.10 |
      flexibility_adequacy_score < 0.75 |
      grid_constraint_score >= 0.30 |
      forecast_quality_score < 0.70 |
      resilience_score < 0.70 |
      interconnection_status %in% c("delayed", "queued", "constrained") |
      quality_flag == "review"
  )

technology_summary <- review %>%
  group_by(technology) %>%
  summarise(
    assets = n_distinct(asset_id),
    observations = n(),
    mean_curtailment_rate = mean(curtailment_rate, na.rm = TRUE),
    mean_flexibility_adequacy = mean(flexibility_adequacy_score, na.rm = TRUE),
    mean_grid_constraint = mean(grid_constraint_score, na.rm = TRUE),
    mean_resilience = mean(resilience_score, na.rm = TRUE),
    mean_infrastructure_score = mean(renewable_infrastructure_score, na.rm = TRUE),
    review_flags = sum(renewable_review_flag, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(review_flags), desc(mean_curtailment_rate))

write_csv(review, file.path(output_dir, "renewable_infrastructure_review_report.csv"))
write_csv(technology_summary, file.path(output_dir, "renewable_technology_summary.csv"))

print(technology_summary)
