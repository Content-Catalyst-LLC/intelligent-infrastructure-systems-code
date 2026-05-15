records = [
    ("LOOP-GRID-001", 0.86, 0.82, 0.84, 0.86, 0.88, 1440.0, 30.0, 36.0, 12.0, 7.0, 10.0, 5.0, 5.0, 4.0, 4.0, 0.78, 0.32, 0.82, 0.86, 0.80),
    ("LOOP-BLDG-001", 0.74, 0.68, 0.60, 0.70, 0.75, 288.0, 44.0, 28.0, 20.0, 6.0, 7.0, 2.0, 5.0, 2.0, 4.0, 0.68, 0.46, 0.64, 0.74, 0.62),
    ("LOOP-SEC-001", 0.70, 0.66, 0.84, 0.64, 0.78, 1440.0, 130.0, 110.0, 85.0, 9.0, 10.0, 1.0, 5.0, 3.0, 4.0, 0.62, 0.55, 0.58, 0.76, 0.60)
]

println("control_loop_id,signal_quality,telemetry,dependency,validation,oversight,integrity,resilience")

for (loop_id, accuracy, calibration, timeliness, validity, metadata, expected, missing, late, invalid, dependent, critical, valid_checks, total_checks, oversight_checks, oversight_total, security, exposure, fallback, manual_override, recovery) in records
    signal_quality = clamp(0.25 * accuracy + 0.20 * calibration + 0.20 * timeliness + 0.20 * validity + 0.15 * metadata, 0.0, 1.0)
    telemetry = expected > 0 ? clamp(1.0 - (missing + late + invalid) / expected, 0.0, 1.0) : 0.0
    dependency = critical > 0 ? clamp(dependent / critical, 0.0, 1.0) : 0.0
    validation = total_checks > 0 ? clamp(valid_checks / total_checks, 0.0, 1.0) : 0.0
    oversight = oversight_total > 0 ? clamp(oversight_checks / oversight_total, 0.0, 1.0) : 0.0
    integrity = clamp(0.25 * signal_quality + 0.20 * telemetry + 0.20 * validation + 0.15 * security + 0.15 * oversight - 0.10 * exposure, 0.0, 1.0)
    resilience = clamp(0.30 * integrity + 0.20 * fallback + 0.20 * manual_override + 0.20 * recovery - 0.10 * dependency - 0.10 * exposure, 0.0, 1.0)
    println("$(loop_id),$(round(signal_quality, digits=3)),$(round(telemetry, digits=3)),$(round(dependency, digits=3)),$(round(validation, digits=3)),$(round(oversight, digits=3)),$(round(integrity, digits=3)),$(round(resilience, digits=3))")
end
