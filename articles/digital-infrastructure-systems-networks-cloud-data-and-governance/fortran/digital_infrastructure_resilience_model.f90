program digital_infrastructure_resilience_model
  implicit none
  real :: access, network, compute, interoperability, trust, dependency, exposure, resilience

  access = 42000.0 / 65000.0
  network = max(0.0, min(1.0, 0.30 * 0.62 + 0.25 * 0.58 + 0.25 * 0.70 + 0.20 * 0.46))
  compute = max(0.0, min(1.0, 0.30 * 0.62 + 0.25 * 0.64 + 0.25 * 0.42 + 0.20 * 0.38))
  interoperability = 8.0 / 18.0
  trust = max(0.0, min(1.0, 0.25 * 0.62 + 0.20 * 0.58 + 0.20 * 0.50 + 0.20 * 0.52 + 0.15 * 0.48))
  dependency = 10.0 / 12.0
  exposure = 0.55

  resilience = max(0.0, min(1.0, 0.20 * access + 0.20 * network + 0.20 * compute + 0.15 * interoperability + 0.20 * trust - 0.15 * dependency - 0.10 * exposure))

  print *, "digital_access_score=", access
  print *, "network_capacity_score=", network
  print *, "compute_storage_score=", compute
  print *, "interoperability_score=", interoperability
  print *, "trust_security_score=", trust
  print *, "vendor_dependency_score=", dependency
  print *, "digital_resilience_score=", resilience
end program digital_infrastructure_resilience_model
