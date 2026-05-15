# Lightweight Julia scenario scaffold for early warning infrastructure.
# Extend with DataFrames.jl, CSV.jl, or optimization packages as needed.

zones = [
    ("WZ-FLASH-B", 0.78, 0.76, 0.70, 0.68, 0.62, 0.82, 0.78, 0.70),
    ("WZ-URBAN-C", 0.72, 0.72, 0.68, 0.64, 0.60, 0.76, 0.74, 0.62),
    ("WZ-COAST-D", 0.86, 0.82, 0.76, 0.70, 0.74, 0.80, 0.76, 0.64)
]

println("warning_zone_id,protective_probability,residual_warning_risk")

for (zone, detection, reach, comprehension, trust, action, hazard, exposure, vulnerability) in zones
    protective = detection * reach * comprehension * trust * action
    residual = hazard * exposure * vulnerability * (1 - protective)
    println("$(zone),$(round(protective, digits=3)),$(round(residual, digits=3))")
end
