records = [
    ("RE-SOL-001", "solar_pv", 72.0, 76.0, 24.0, 12.0, 36.0, 100.0, 0.66, 0.82, 0.68),
    ("RE-WND-001", "onshore_wind", 118.0, 130.0, 34.0, 18.0, 52.0, 180.0, 0.62, 0.70, 0.62),
    ("RE-DER-001", "distributed_energy_resource", 19.0, 42.0, 22.0, 5.0, 38.0, 60.0, 0.60, 0.68, 0.60)
]

println("asset_id,technology,curtailment_rate,flexibility_adequacy,grid_constraint_score,infrastructure_score")

for (asset_id, tech, generation, grid_capacity, flexibility, storage_charge, flex_need, connection_capacity, resilience, forecast_quality, storage_readiness) in records
    usable = min(generation, max(0.0, grid_capacity + flexibility + storage_charge))
    curtailment = generation > 0 ? clamp((generation - usable) / generation, 0.0, 1.0) : 0.0
    flex_adequacy = flex_need > 0 ? clamp(flexibility / flex_need, 0.0, 1.0) : 1.0
    constraint = connection_capacity > 0 ? clamp(1.0 - grid_capacity / connection_capacity, 0.0, 1.0) : 0.0
    score = clamp(0.25 * (1.0 - curtailment) + 0.20 * flex_adequacy + 0.20 * resilience + 0.15 * forecast_quality + 0.10 * storage_readiness - 0.10 * constraint, 0.0, 1.0)
    println("$(asset_id),$(tech),$(round(curtailment, digits=3)),$(round(flex_adequacy, digits=3)),$(round(constraint, digits=3)),$(round(score, digits=3))")
end
