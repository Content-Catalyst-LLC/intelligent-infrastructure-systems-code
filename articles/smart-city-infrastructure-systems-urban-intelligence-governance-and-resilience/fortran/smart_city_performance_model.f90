program smart_city_performance_model
  implicit none
  real :: observed_capacity, normal_capacity, continuity
  real :: quality, coverage, interoperability, latency, governance, observability
  real :: accessibility, resilience, inclusion, trust, burden, public_value

  observed_capacity = 0.58
  normal_capacity = 1.00
  quality = 0.78
  coverage = 0.56
  interoperability = 0.70
  latency = 0.58
  governance = 0.62
  accessibility = 0.66
  resilience = 0.58
  inclusion = 0.62
  trust = 0.60
  burden = 0.44

  continuity = max(0.0, min(1.0, observed_capacity / normal_capacity))
  observability = max(0.0, min(1.0, 0.25 * quality + 0.20 * coverage + 0.20 * interoperability + 0.20 * latency + 0.15 * governance))
  public_value = max(0.0, min(1.0, 0.25 * continuity + 0.20 * accessibility + 0.20 * resilience + 0.20 * inclusion + 0.15 * trust - 0.15 * burden))

  print *, "service_continuity_score=", continuity
  print *, "domain_observability_score=", observability
  print *, "public_value_score=", public_value
end program smart_city_performance_model
