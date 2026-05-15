library(readr)
library(dplyr)
library(lubridate)
library(broom)

article_dir <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = TRUE)
data_dir <- file.path(article_dir, "data")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

observations <- read_csv(file.path(data_dir, "climate_observations_sample.csv"), show_col_types = FALSE) %>%
  mutate(date = as.Date(date), year = year(date))

metadata <- read_csv(file.path(data_dir, "instrument_metadata_calibration_log.csv"), show_col_types = FALSE)
platforms <- read_csv(file.path(data_dir, "climate_observation_platforms.csv"), show_col_types = FALSE)

reference <- observations %>%
  filter(date >= as.Date("1991-01-01"), date <= as.Date("2020-12-31"))

baseline <- reference %>%
  group_by(station_id, variable) %>%
  summarise(baseline_value = mean(value, na.rm = TRUE), .groups = "drop")

annual_anomalies <- observations %>%
  left_join(baseline, by = c("station_id", "variable")) %>%
  mutate(anomaly = value - baseline_value) %>%
  group_by(station_id, variable, year) %>%
  summarise(mean_anomaly = mean(anomaly, na.rm = TRUE), .groups = "drop")

trend_summary <- annual_anomalies %>%
  group_by(station_id, variable) %>%
  do(tidy(lm(mean_anomaly ~ year, data = .))) %>%
  ungroup() %>%
  filter(term == "year") %>%
  transmute(
    station_id,
    variable,
    annual_trend = estimate,
    p_value = p.value
  ) %>%
  left_join(metadata, by = c("station_id", "variable")) %>%
  left_join(platforms %>% select(station_id, station_name, domain, platform_type), by = "station_id")

write_csv(annual_anomalies, file.path(output_dir, "annual_climate_anomalies.csv"))
write_csv(trend_summary, file.path(output_dir, "station_trend_summary.csv"))

print(trend_summary)
