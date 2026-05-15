records = [
    ("NET-RD-001", "road_traffic", 28.0, 9.0, 0.70, 0.62, 0.68, 0.44),
    ("NET-BUS-001", "public_transit", 34.0, 13.0, 0.76, 0.70, 0.60, 0.30),
    ("NET-FRT-001", "freight", 31.0, 10.0, 0.66, 0.60, 0.58, 0.48)
]

println("network_element_id,mode,travel_time_reliability,mobility_quality_score")

for (id, mode, mean_t, std_t, accessibility, safety, coordination, emissions) in records
    reliability = clamp(1.0 - std_t / mean_t, 0.0, 1.0)
    quality = clamp(0.25 * reliability + 0.20 * accessibility + 0.20 * safety + 0.20 * coordination - 0.15 * emissions, 0.0, 1.0)
    println("$(id),$(mode),$(round(reliability, digits=3)),$(round(quality, digits=3))")
end
