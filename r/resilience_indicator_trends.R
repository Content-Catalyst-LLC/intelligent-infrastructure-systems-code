library(readr)
library(dplyr)

project_root <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."))
output_tables_dir <- file.path(project_root, "outputs", "tables")
dir.create(output_tables_dir, recursive = TRUE, showWarnings = FALSE)

resilience <- tibble::tibble(
  sector = c("water", "transportation", "energy", "disaster_monitoring"),
  redundancy_score = c(0.70, 0.62, 0.80, 0.68),
  observability_score = c(0.75, 0.66, 0.85, 0.72),
  recovery_capacity = c(0.60, 0.58, 0.76, 0.70)
) |>
  mutate(resilience_index = redundancy_score * observability_score * recovery_capacity)

write_csv(resilience, file.path(output_tables_dir, "resilience_indicator_trends.csv"))
print(resilience)
