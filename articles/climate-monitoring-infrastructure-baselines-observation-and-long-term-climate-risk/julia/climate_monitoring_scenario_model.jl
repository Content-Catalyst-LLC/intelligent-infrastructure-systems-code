# Lightweight Julia scaffold for climate monitoring baseline and anomaly checks.
# Extend with CSV.jl, DataFrames.jl, GLM.jl, or ClimateTools-style workflows.

stations = [
    ("CLM-ATM-001", 4.2, 4.5, 4.1, 5.9),
    ("CLM-ATM-002", 6.1, 6.3, 6.4, 7.5),
    ("CLM-OCE-001", 0.12, 0.13, 0.14, 0.21)
]

println("station_id,baseline,latest_value,anomaly")

for (station_id, v1, v2, v3, latest) in stations
    baseline = (v1 + v2 + v3) / 3
    anomaly = latest - baseline
    println("$(station_id),$(round(baseline, digits=3)),$(latest),$(round(anomaly, digits=3))")
end
