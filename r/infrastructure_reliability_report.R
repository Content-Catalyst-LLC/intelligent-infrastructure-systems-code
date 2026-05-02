library(readr)
library(dplyr)
library(ggplot2)

project_root <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."))
input_path <- file.path(project_root, "data", "processed", "infrastructure_telemetry.csv")
output_tables_dir <- file.path(project_root, "outputs", "tables")
output_figures_dir <- file.path(project_root, "outputs", "figures")

dir.create(output_tables_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(output_figures_dir, recursive = TRUE, showWarnings = FALSE)

telemetry <- read_csv(input_path, show_col_types = FALSE)

sector_summary <- telemetry |>
  mutate(
    valid_record = !is.na(observed_value) &
      battery_voltage >= 3.3 &
      signal_quality >= 0.80
  ) |>
  group_by(sector, communication_mode) |>
  summarise(
    records = n(),
    missing_values = sum(is.na(observed_value)),
    valid_record_rate = mean(valid_record),
    mean_battery_voltage = mean(battery_voltage, na.rm = TRUE),
    mean_signal_quality = mean(signal_quality, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(
  sector_summary,
  file.path(output_tables_dir, "infrastructure_reliability_sector_summary.csv")
)

quality_plot <- ggplot(sector_summary, aes(x = sector, y = valid_record_rate)) +
  geom_col() +
  labs(
    title = "Valid Telemetry Record Rate by Infrastructure Sector",
    x = "Infrastructure sector",
    y = "Valid record rate"
  ) +
  theme_minimal()

ggsave(
  filename = file.path(output_figures_dir, "valid_record_rate_by_sector.png"),
  plot = quality_plot,
  width = 8,
  height = 5,
  dpi = 300
)

print(sector_summary)
