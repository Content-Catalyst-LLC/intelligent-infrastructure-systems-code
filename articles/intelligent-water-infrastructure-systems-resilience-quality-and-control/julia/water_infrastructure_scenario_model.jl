records = [
    ("WZ-CBD-B", 156.0, 160.0, 55.0, 35.0, 80.0, 145000.0, 118000.0, 0.84, 0.82, 0.78, 0.76, 0.52, 0.72, 0.70, 0.28),
    ("WZ-SOUTH-D", 132.0, 140.0, 34.0, 35.0, 80.0, 125000.0, 93000.0, 0.76, 0.74, 0.70, 0.66, 0.27, 0.58, 0.60, 0.42),
    ("WZ-RIVER-F", 64.0, 70.0, 0.0, 0.0, 1.0, 80000.0, 62000.0, 0.74, 0.72, 0.68, 0.64, 0.21, 0.52, 0.54, 0.58)
]

println("service_zone_id,quality,pressure,leakage,observability,resilience")

for (zone, compliant, tested, pressure, pmin, pmax, input_volume, authorized_volume, telemetry, data_quality, coverage, metadata, latency, backup, response, exposure) in records
    quality = tested > 0 ? clamp(compliant / tested, 0.0, 1.0) : 0.0
    pressure_score = pmax > pmin ? clamp((pressure - pmin) / (pmax - pmin), 0.0, 1.0) : 0.0
    leakage = input_volume > 0 ? clamp((input_volume - authorized_volume) / input_volume, 0.0, 1.0) : 0.0
    continuity = clamp(0.50 * telemetry + 0.25 * backup + 0.25 * response, 0.0, 1.0)
    observability = clamp(0.25 * telemetry + 0.25 * data_quality + 0.20 * coverage + 0.15 * metadata + 0.15 * latency, 0.0, 1.0)
    resilience = clamp(0.25 * continuity + 0.20 * quality + 0.20 * backup + 0.15 * observability + 0.15 * response - 0.15 * exposure, 0.0, 1.0)
    println("$(zone),$(round(quality, digits=3)),$(round(pressure_score, digits=3)),$(round(leakage, digits=3)),$(round(observability, digits=3)),$(round(resilience, digits=3))")
end
