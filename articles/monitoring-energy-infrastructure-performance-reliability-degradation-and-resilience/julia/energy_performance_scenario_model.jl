records = [
    ("EN-TRN-001", "transmission", 22.0, 24.0, 430.0, 455.0, 0.95, 0.74, 0.78, 0.66, 0.38, 0.52, 0.58, 0.72, 0.70),
    ("EN-TRF-001", "transformer", 20.5, 24.0, 21.0, 25.0, 0.90, 0.58, 0.88, 0.86, 0.44, 0.54, 0.42, 0.62, 0.86),
    ("EN-BAT-001", "storage", 23.0, 24.0, 22.0, 25.0, 0.98, 0.76, 0.52, 0.56, 0.82, 0.34, 0.76, 0.74, 0.42)
]

println("asset_id,asset_class,availability,degradation,stress,resilience")

for (asset_id, asset_class, available_hours, total_hours, served, demand, baseline, current, loading, thermal, cycling, environmental, fallback, observability, restoration) in records
    availability = clamp(available_hours / total_hours, 0.0, 1.0)
    continuity = clamp(served / demand, 0.0, 1.0)
    degradation = clamp((baseline - current) / baseline, 0.0, 1.0)
    stress = clamp(0.30 * loading + 0.25 * thermal + 0.25 * cycling + 0.20 * environmental, 0.0, 1.0)
    resilience = clamp(0.25 * availability + 0.25 * continuity + 0.20 * fallback + 0.15 * observability - 0.15 * restoration, 0.0, 1.0)
    println("$(asset_id),$(asset_class),$(round(availability, digits=3)),$(round(degradation, digits=3)),$(round(stress, digits=3)),$(round(resilience, digits=3))")
end
