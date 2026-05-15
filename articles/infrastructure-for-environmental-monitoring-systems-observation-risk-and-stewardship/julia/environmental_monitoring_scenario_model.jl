# Lightweight Julia scaffold for environmental threshold and risk review.
# Extend with CSV.jl, DataFrames.jl, or geospatial workflows as needed.

records = [
    ("ENV-AIR-001", "pm25", 36.2, 35.0, 0.74, 0.66, 0.72),
    ("ENV-AIR-002", "no2", 42.0, 40.0, 0.82, 0.70, 0.58),
    ("ENV-WTR-001", "turbidity", 22.5, 20.0, 0.70, 0.62, 0.68),
    ("ENV-BIO-001", "habitat_condition", 0.58, 0.65, 0.60, 0.68, 0.52)
]

println("site_id,variable,threshold_exceeded,environmental_risk_score")

for (site_id, variable, value, threshold, exposure, vulnerability, governance) in records
    # For habitat condition, low values are concerning. This simple scenario treats all values
    # as high-threshold examples except where domain-specific logic is added later.
    exceeded = value >= threshold
    hazard_intensity = min(value / threshold, 2.0) / 2.0
    risk = hazard_intensity * exposure * vulnerability * (1 - governance)
    println("$(site_id),$(variable),$(exceeded),$(round(risk, digits=3))")
end
