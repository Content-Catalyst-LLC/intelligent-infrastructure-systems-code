program urban_resilience_model
  implicit none

  real :: disruption_capacity, normal_capacity
  real :: expected_recovery, target_recovery
  real :: continuity, recovery_lag
  real :: hazard, exposure, vulnerability, governance
  real :: urban_risk

  disruption_capacity = 58.0
  normal_capacity = 100.0
  expected_recovery = 14.0
  target_recovery = 6.0

  hazard = 0.82
  exposure = 0.78
  vulnerability = 0.76
  governance = 0.66

  continuity = min(disruption_capacity / normal_capacity, 1.0)
  recovery_lag = max(0.0, expected_recovery - target_recovery)
  urban_risk = hazard * exposure * vulnerability * (1.0 - governance)

  print *, "service_continuity_score=", continuity
  print *, "recovery_lag_hours=", recovery_lag
  print *, "urban_risk_score=", urban_risk
end program urban_resilience_model
