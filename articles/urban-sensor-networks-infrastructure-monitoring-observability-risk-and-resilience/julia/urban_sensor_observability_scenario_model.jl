records = [
    ("USN-TRN-001", "transport", 0.96, 0.94, 0.92, 0.90, 0.90, 0.80, 0.78, 0.90, 0.68),
    ("USN-AIR-001", "environmental_exposure", 0.82, 0.68, 0.82, 0.60, 0.80, 0.43, 0.66, 0.88, 0.58),
    ("USN-BRG-001", "structural_health", 0.70, 0.62, 0.78, 0.40, 0.76, 0.80, 0.78, 0.93, 0.68)
]

println("sensor_id,domain,sensor_quality_score,urban_observability_score")

for (sensor_id, domain, uptime, calibration, metadata, latency, provenance, coverage, interoperability, service_relevance, governance) in records
    sensor_quality = 0.25 * uptime + 0.20 * calibration + 0.20 * metadata + 0.20 * latency + 0.15 * provenance
    observability = 0.30 * sensor_quality + 0.20 * coverage + 0.20 * interoperability + 0.15 * service_relevance + 0.15 * governance
    println("$(sensor_id),$(domain),$(round(sensor_quality, digits=3)),$(round(observability, digits=3))")
end
