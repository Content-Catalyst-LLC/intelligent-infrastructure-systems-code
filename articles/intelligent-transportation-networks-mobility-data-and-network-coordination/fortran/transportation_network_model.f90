program transportation_network_model
  implicit none
  real :: mean_t, std_t, reliability
  real :: accessibility, safety, coordination, emissions
  real :: quality
  real :: expected_recovery, target_recovery, recovery_lag

  mean_t = 34.0
  std_t = 13.0
  accessibility = 0.76
  safety = 0.70
  coordination = 0.60
  emissions = 0.30
  expected_recovery = 35.0
  target_recovery = 20.0

  reliability = max(0.0, min(1.0, 1.0 - std_t / mean_t))
  recovery_lag = max(0.0, expected_recovery - target_recovery)
  quality = max(0.0, min(1.0, 0.25 * reliability + 0.20 * accessibility + 0.20 * safety + 0.20 * coordination - 0.15 * emissions))

  print *, "travel_time_reliability=", reliability
  print *, "recovery_lag_minutes=", recovery_lag
  print *, "mobility_quality_score=", quality
end program transportation_network_model
