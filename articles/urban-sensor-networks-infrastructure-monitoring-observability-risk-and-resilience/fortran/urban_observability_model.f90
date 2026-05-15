program urban_observability_model
  implicit none
  real :: uptime, calibration, metadata, latency, provenance
  real :: sensor_quality, coverage, interoperability, service_relevance, governance
  real :: urban_observability

  uptime = 0.70
  calibration = 0.62
  metadata = 0.78
  latency = 0.45
  provenance = 0.76
  coverage = 0.80
  interoperability = 0.78
  service_relevance = 0.93
  governance = 0.68

  sensor_quality = 0.25 * uptime + 0.20 * calibration + 0.20 * metadata + 0.20 * latency + 0.15 * provenance
  urban_observability = 0.30 * sensor_quality + 0.20 * coverage + 0.20 * interoperability + 0.15 * service_relevance + 0.15 * governance

  print *, "sensor_quality_score=", sensor_quality
  print *, "urban_observability_score=", urban_observability
end program urban_observability_model
