records = [
    ("SZ-CBD-B", 0.84, 0.82, 0.78, 0.76, 0.54, 0.98, 0.05, 28.0, 46.0, 112.0, 105.0, 22.5, 24.0, 0.56, 0.60, 0.42),
    ("SZ-SOUTH-C", 0.78, 0.76, 0.72, 0.70, 0.39, 0.95, 0.05, 24.0, 38.0, 44.0, 38.0, 21.0, 24.0, 0.52, 0.58, 0.50),
    ("SZ-EAST-D", 0.74, 0.72, 0.68, 0.64, 0.27, 0.94, 0.05, 16.0, 30.0, 25.0, 21.0, 20.5, 24.0, 0.46, 0.54, 0.56)
]

println("service_zone_id,observability,voltage_adequacy,flexibility_adequacy,balancing_pressure,resilience")

for (zone, telemetry, data_quality, coverage, metadata, latency, voltage, allowed, flex_available, flex_need, load, supply, served, required, backup, response, exposure) in records
    observability = clamp(0.25 * telemetry + 0.25 * data_quality + 0.20 * coverage + 0.15 * metadata + 0.15 * latency, 0.0, 1.0)
    voltage_adequacy = allowed > 0 ? clamp(1.0 - abs(voltage - 1.0) / allowed, 0.0, 1.0) : 0.0
    flexibility = flex_need > 0 ? clamp(flex_available / flex_need, 0.0, 1.0) : 1.0
    balancing = load > 0 ? clamp(abs(load - supply - flex_available) / load, 0.0, 1.0) : 0.0
    continuity = required > 0 ? clamp(served / required, 0.0, 1.0) : 0.0
    resilience = clamp(0.25 * continuity + 0.20 * flexibility + 0.20 * observability + 0.15 * backup + 0.15 * response - 0.15 * exposure, 0.0, 1.0)
    println("$(zone),$(round(observability, digits=3)),$(round(voltage_adequacy, digits=3)),$(round(flexibility, digits=3)),$(round(balancing, digits=3)),$(round(resilience, digits=3))")
end
