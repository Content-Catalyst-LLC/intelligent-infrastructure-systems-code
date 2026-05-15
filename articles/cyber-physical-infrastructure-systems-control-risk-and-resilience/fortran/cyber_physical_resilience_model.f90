program cyber_physical_resilience_model
  implicit none
  real :: signal_quality, telemetry, dependency, validation, oversight
  real :: security, exposure, integrity, fallback, manual_override, recovery, resilience

  signal_quality = max(0.0, min(1.0, 0.25 * 0.70 + 0.20 * 0.66 + 0.20 * 0.84 + 0.20 * 0.64 + 0.15 * 0.78))
  telemetry = max(0.0, min(1.0, 1.0 - (130.0 + 110.0 + 85.0) / 1440.0))
  dependency = max(0.0, min(1.0, 9.0 / 10.0))
  validation = max(0.0, min(1.0, 1.0 / 5.0))
  oversight = max(0.0, min(1.0, 3.0 / 4.0))
  security = 0.62
  exposure = 0.55
  fallback = 0.58
  manual_override = 0.76
  recovery = 0.60

  integrity = max(0.0, min(1.0, 0.25 * signal_quality + 0.20 * telemetry + 0.20 * validation + 0.15 * security + 0.15 * oversight - 0.10 * exposure))
  resilience = max(0.0, min(1.0, 0.30 * integrity + 0.20 * fallback + 0.20 * manual_override + 0.20 * recovery - 0.10 * dependency - 0.10 * exposure))

  print *, "signal_quality_score=", signal_quality
  print *, "telemetry_reliability_score=", telemetry
  print *, "dependency_intensity_score=", dependency
  print *, "control_validation_score=", validation
  print *, "human_oversight_score=", oversight
  print *, "control_integrity_score=", integrity
  print *, "cyber_physical_resilience_score=", resilience
end program cyber_physical_resilience_model
