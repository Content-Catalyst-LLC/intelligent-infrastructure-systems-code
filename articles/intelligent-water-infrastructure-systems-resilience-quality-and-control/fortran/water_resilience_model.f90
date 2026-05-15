program water_resilience_model
  implicit none
  real :: compliant, tested, quality
  real :: pressure, pmin, pmax, pressure_score
  real :: input_volume, authorized_volume, leakage
  real :: available_hours, required_hours, continuity
  real :: telemetry, data_quality, coverage, metadata, latency, observability
  real :: backup, response, exposure, resilience

  compliant = 132.0
  tested = 140.0
  pressure = 34.0
  pmin = 35.0
  pmax = 80.0
  input_volume = 125000.0
  authorized_volume = 93000.0
  available_hours = 19.0
  required_hours = 24.0
  telemetry = 0.76
  data_quality = 0.74
  coverage = 0.70
  metadata = 0.66
  latency = 0.27
  backup = 0.58
  response = 0.60
  exposure = 0.42

  quality = max(0.0, min(1.0, compliant / tested))
  pressure_score = max(0.0, min(1.0, (pressure - pmin) / (pmax - pmin)))
  leakage = max(0.0, min(1.0, (input_volume - authorized_volume) / input_volume))
  continuity = max(0.0, min(1.0, available_hours / required_hours))
  observability = max(0.0, min(1.0, 0.25 * telemetry + 0.25 * data_quality + 0.20 * coverage + 0.15 * metadata + 0.15 * latency))
  resilience = max(0.0, min(1.0, 0.25 * continuity + 0.20 * quality + 0.20 * backup + 0.15 * observability + 0.15 * response - 0.15 * exposure))

  print *, "quality_compliance_score=", quality
  print *, "pressure_adequacy_score=", pressure_score
  print *, "leakage_rate=", leakage
  print *, "service_continuity_score=", continuity
  print *, "water_observability_score=", observability
  print *, "water_resilience_score=", resilience
end program water_resilience_model
