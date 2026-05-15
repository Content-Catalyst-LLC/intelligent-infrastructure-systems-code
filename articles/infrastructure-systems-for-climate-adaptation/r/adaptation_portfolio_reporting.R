args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- sub(file_arg, "", args[grep(file_arg, args)])
article_dir <- normalizePath(file.path(dirname(script_path), ".."))
data_path <- file.path(article_dir, "data", "adaptation_readiness_scores.csv")
output_dir <- file.path(article_dir, "outputs")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

portfolio <- read.csv(data_path, stringsAsFactors = FALSE)

portfolio$adaptation_readiness <- with(
  portfolio,
  0.16 * scenario_credibility +
    0.14 * dependency_mapping +
    0.15 * service_protection +
    0.14 * equity_screen +
    0.12 * finance_readiness +
    0.10 * maintenance_readiness +
    0.10 * observability +
    0.09 * governance_clarity
)
portfolio$net_adaptation_readiness <- pmax(0, portfolio$adaptation_readiness - 0.20 * portfolio$maladaptation_risk)
portfolio$readiness_band <- ifelse(
  portfolio$maladaptation_risk >= 0.60,
  "maladaptation review",
  ifelse(portfolio$net_adaptation_readiness >= 0.80, "strong",
    ifelse(portfolio$net_adaptation_readiness >= 0.70, "moderate", "needs review")
  )
)

summary_table <- aggregate(
  cbind(net_adaptation_readiness, maladaptation_risk) ~ primary_hazard + infrastructure_domain + readiness_band,
  data = portfolio,
  FUN = mean
)
summary_table$net_adaptation_readiness <- round(summary_table$net_adaptation_readiness, 3)
summary_table$maladaptation_risk <- round(summary_table$maladaptation_risk, 3)

write.csv(portfolio, file.path(output_dir, "adaptation_portfolio_scored.csv"), row.names = FALSE)
write.csv(summary_table, file.path(output_dir, "adaptation_portfolio_summary.csv"), row.names = FALSE)
print(summary_table)
