program monitoring_resilience_model
  implicit none
  real :: coverage, accuracy, precision, completeness, validity, freshness
  real :: signal_quality, calibration, telemetry, metadata, blindspot, observability
  real :: actionability, backup, validation, exposure, resilience
  real :: expected, missing, late, invalid

  coverage = 12.0 / 20.0
  accuracy = 0.70
  precision = 0.68
  completeness = 0.66
  validity = 0.64
  freshness = 0.84
  calibration = exp(-0.004 * 244.0)
  expected = 1440.0
  missing = 130.0
  late = 110.0
  invalid = 85.0
  metadata = 7.0 / 8.0
  blindspot = 3.0 / 6.0
  actionability = 1.0
  backup = 0.60
  validation = 0.66
  exposure = 0.42

  signal_quality = max(0.0, min(1.0, 0.25 * accuracy + 0.20 * precision + 0.20 * completeness + 0.20 * validity + 0.15 * freshness))
  telemetry = max(0.0, min(1.0, 1.0 - (missing + late + invalid) / expected))
  observability = max(0.0, min(1.0, 0.20 * coverage + 0.20 * signal_quality + 0.20 * calibration + 0.20 * telemetry + 0.15 * metadata - 0.15 * blindspot))
  resilience = max(0.0, min(1.0, 0.35 * observability + 0.25 * actionability + 0.20 * backup + 0.10 * validation - 0.10 * exposure))

  print *, "sensor_coverage_score=", coverage
  print *, "signal_quality_score=", signal_quality
  print *, "calibration_confidence_score=", calibration
  print *, "telemetry_reliability_score=", telemetry
  print *, "metadata_completeness_score=", metadata
  print *, "monitoring_observability_score=", observability
  print *, "monitoring_resilience_score=", resilience
end program monitoring_resilience_model
