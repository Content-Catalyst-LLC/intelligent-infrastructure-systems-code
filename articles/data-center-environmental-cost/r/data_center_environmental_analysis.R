# Data center environmental analysis with synthetic data.

library(readr)
library(dplyr)

root <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."))
data_path <- file.path(root, "data", "raw", "data_center_environmental_synthetic.csv")
out_path <- file.path(root, "outputs", "tables", "data_center_environmental_summary_r.csv")
processed_path <- file.path(root, "data", "processed", "data_center_environmental_scored_r.csv")

df <- read_csv(data_path, show_col_types = FALSE) %>%
  mutate(
    pue = total_facility_energy_mwh / it_energy_mwh,
    wue_l_per_kwh_it = (water_consumption_m3 * 1000) / (it_energy_mwh * 1000),
    operational_emissions_tco2e =
      total_facility_energy_mwh * grid_carbon_intensity_kgco2e_mwh / 1000,
    renewable_mismatch_share = 1 - renewable_hourly_match_share,
    high_ai_workload = ai_workload_share >= 0.50,
    high_water_stress_flag = water_stress_level == "high",
    environmental_risk_score =
      as.numeric(pue > 1.25) +
      as.numeric(wue_l_per_kwh_it > 1.0) +
      as.numeric(water_stress_level == "high") +
      as.numeric(ai_workload_share >= 0.50) +
      as.numeric(renewable_hourly_match_share < 0.50) +
      as.numeric(operational_emissions_tco2e > 250000),
    environmental_risk_category = case_when(
      environmental_risk_score >= 4 ~ "high",
      environmental_risk_score >= 2 ~ "medium",
      TRUE ~ "lower"
    )
  )

summary <- df %>%
  select(
    facility_id,
    region,
    facility_type,
    pue,
    wue_l_per_kwh_it,
    operational_emissions_tco2e,
    ai_workload_share,
    peak_load_mw,
    renewable_hourly_match_share,
    water_stress_level,
    environmental_risk_category
  )

dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(processed_path), recursive = TRUE, showWarnings = FALSE)

write_csv(df, processed_path)
write_csv(summary, out_path)

print(summary)
