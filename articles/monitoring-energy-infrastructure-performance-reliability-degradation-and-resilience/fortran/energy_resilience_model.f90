program energy_resilience_model
  implicit none
  real :: available_hours, total_hours, availability
  real :: served, demand, continuity
  real :: baseline_health, current_health, degradation
  real :: loading, thermal, cycling, environmental, stress
  real :: fallback, observability, restoration_time, resilience

  available_hours = 20.5
  total_hours = 24.0
  served = 21.0
  demand = 25.0
  baseline_health = 0.90
  current_health = 0.58
  loading = 0.88
  thermal = 0.86
  cycling = 0.44
  environmental = 0.54
  fallback = 0.42
  observability = 0.62
  restoration_time = 0.86

  availability = max(0.0, min(1.0, available_hours / total_hours))
  continuity = max(0.0, min(1.0, served / demand))
  degradation = max(0.0, min(1.0, (baseline_health - current_health) / baseline_health))
  stress = max(0.0, min(1.0, 0.30 * loading + 0.25 * thermal + 0.25 * cycling + 0.20 * environmental))
  resilience = max(0.0, min(1.0, 0.25 * availability + 0.25 * continuity + 0.20 * fallback + 0.15 * observability - 0.15 * restoration_time))

  print *, "availability_score=", availability
  print *, "service_continuity_score=", continuity
  print *, "degradation_score=", degradation
  print *, "stress_score=", stress
  print *, "resilience_score=", resilience
end program energy_resilience_model
