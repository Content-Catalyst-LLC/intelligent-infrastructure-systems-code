records = [
    ("SENS-ENERGY-001", 14.0, 18.0, 0.86, 0.84, 0.82, 0.84, 0.82, 107.0, 1440.0, 35.0, 42.0, 18.0, 8.0, 8.0, 1.0, 6.0),
    ("SENS-BLDG-001", 7.0, 12.0, 0.74, 0.72, 0.60, 0.70, 0.58, 268.0, 288.0, 44.0, 28.0, 20.0, 6.0, 8.0, 2.0, 6.0),
    ("SENS-SEC-001", 12.0, 20.0, 0.70, 0.68, 0.66, 0.64, 0.84, 244.0, 1440.0, 130.0, 110.0, 85.0, 7.0, 8.0, 3.0, 6.0)
]

println("sensor_id,coverage,signal_quality,calibration,telemetry,metadata,observability")

for (sensor, monitored, critical, accuracy, precision, completeness, validity, freshness, days_since_calibration, expected, missing, late, invalid, metadata_present, metadata_required, blindspots, zones) in records
    coverage = critical > 0 ? clamp(monitored / critical, 0.0, 1.0) : 0.0
    signal_quality = clamp(0.25 * accuracy + 0.20 * precision + 0.20 * completeness + 0.20 * validity + 0.15 * freshness, 0.0, 1.0)
    calibration = clamp(exp(-0.004 * days_since_calibration), 0.0, 1.0)
    telemetry = expected > 0 ? clamp(1.0 - (missing + late + invalid) / expected, 0.0, 1.0) : 0.0
    metadata = metadata_required > 0 ? clamp(metadata_present / metadata_required, 0.0, 1.0) : 0.0
    blindspot = zones > 0 ? clamp(blindspots / zones, 0.0, 1.0) : 0.0
    observability = clamp(0.20 * coverage + 0.20 * signal_quality + 0.20 * calibration + 0.20 * telemetry + 0.15 * metadata - 0.15 * blindspot, 0.0, 1.0)
    println("$(sensor),$(round(coverage, digits=3)),$(round(signal_quality, digits=3)),$(round(calibration, digits=3)),$(round(telemetry, digits=3)),$(round(metadata, digits=3)),$(round(observability, digits=3))")
end
