program grid_resilience_model
  implicit none
  real :: telemetry, data_quality, coverage, metadata, latency, observability
  real :: voltage, nominal, allowed, voltage_score
  real :: flex_available, flex_need, flexibility
  real :: load, supply, balancing
  real :: served_hours, required_hours, continuity
  real :: backup, response, exposure, resilience

  telemetry = 0.74
  data_quality = 0.72
  coverage = 0.68
  metadata = 0.64
  latency = 0.27
  voltage = 0.94
  nominal = 1.0
  allowed = 0.05
  flex_available = 16.0
  flex_need = 30.0
  load = 25.0
  supply = 21.0
  served_hours = 20.5
  required_hours = 24.0
  backup = 0.46
  response = 0.54
  exposure = 0.56

  observability = max(0.0, min(1.0, 0.25 * telemetry + 0.25 * data_quality + 0.20 * coverage + 0.15 * metadata + 0.15 * latency))
  voltage_score = max(0.0, min(1.0, 1.0 - abs(voltage - nominal) / allowed))
  flexibility = max(0.0, min(1.0, flex_available / flex_need))
  balancing = max(0.0, min(1.0, abs(load - supply - flex_available) / load))
  continuity = max(0.0, min(1.0, served_hours / required_hours))
  resilience = max(0.0, min(1.0, 0.25 * continuity + 0.20 * flexibility + 0.20 * observability + 0.15 * backup + 0.15 * response - 0.15 * exposure))

  print *, "grid_observability_score=", observability
  print *, "voltage_adequacy_score=", voltage_score
  print *, "flexibility_adequacy_score=", flexibility
  print *, "balancing_pressure_score=", balancing
  print *, "service_continuity_score=", continuity
  print *, "grid_resilience_score=", resilience
end program grid_resilience_model
