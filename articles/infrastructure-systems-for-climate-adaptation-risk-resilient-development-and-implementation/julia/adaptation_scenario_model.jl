# Lightweight Julia scenario scaffold for climate adaptation infrastructure.
systems = [
    ("DRN-001", 0.80, 0.76, 0.72, 0.48, 0.52, 0.04),
    ("COA-001", 0.84, 0.78, 0.74, 0.46, 0.42, 0.08),
    ("ENE-001", 0.78, 0.69, 0.65, 0.57, 0.44, 0.05)
]

println("system_id,baseline_risk,residual_risk")
for (system_id, hazard, exposure, sensitivity, adaptive_capacity, option_effectiveness, maladaptation_penalty) in systems
    baseline = hazard * exposure * sensitivity * (1 - adaptive_capacity)
    residual = baseline * (1 - option_effectiveness) + maladaptation_penalty
    println("$(system_id),$(round(baseline, digits=3)),$(round(residual, digits=3))")
end
