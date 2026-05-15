suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- sub(file_arg, "", args[grep(file_arg, args)])
article_dir <- normalizePath(file.path(dirname(script_path), ".."))
data_path <- file.path(article_dir, "data", "adaptation_readiness_scores.csv")
output_dir <- file.path(article_dir, "outputs")

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

portfolio <- read_csv(data_path, show_col_types = FALSE)

summary_table <- portfolio %>%
  mutate(
    adaptation_readiness =
      0.18 * scenario_credibility +
      0.14 * dependency_mapping +
      0.16 * service_protection +
      0.14 * equity_screen +
      0.14 * finance_readiness +
      0.10 * maintenance_readiness +
      0.10 * observability +
      0.04 * governance_clarity,
    readiness_band = case_when(
      maladaptation_risk >= 0.65 ~ "maladaptation review",
      adaptation_readiness >= 0.80 ~ "strong",
      adaptation_readiness >= 0.70 ~ "moderate",
      TRUE ~ "needs review"
    )
  ) %>%
  group_by(primary_hazard, infrastructure_domain, readiness_band) %>%
  summarise(
    projects = n(),
    mean_readiness = round(mean(adaptation_readiness), 3),
    mean_maladaptation_risk = round(mean(maladaptation_risk), 3),
    .groups = "drop"
  )

write_csv(summary_table, file.path(output_dir, "adaptation_portfolio_summary.csv"))
print(summary_table)
