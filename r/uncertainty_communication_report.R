library(dplyr)

uncertainty <- tibble::tibble(
  metric = c("water_level", "vibration", "strain"),
  estimate = c(2.8, 1.42, 12.5),
  lower_bound = c(2.5, 1.20, 11.8),
  upper_bound = c(3.1, 1.64, 13.2)
)

print(uncertainty)
