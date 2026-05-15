records = [
    ("SCI-TRN-001", "transport", 0.72, 0.82, 0.80, 0.76, 0.68, 0.72, 0.66, 0.64, 0.62, 0.36),
    ("SCI-STM-001", "stormwater", 0.58, 0.78, 0.56, 0.70, 0.62, 0.66, 0.58, 0.62, 0.60, 0.44),
    ("SCI-DPI-001", "digital_public_infrastructure", 0.81, 0.84, 0.88, 0.82, 0.60, 0.62, 0.64, 0.54, 0.56, 0.38)
]

println("infrastructure_id,domain,observability_score,public_value_score")

for (id, domain, continuity, quality, coverage, interoperability, governance, accessibility, resilience, inclusion, trust, burden) in records
    latency = 0.65
    observability = clamp(0.25 * quality + 0.20 * coverage + 0.20 * interoperability + 0.20 * latency + 0.15 * governance, 0.0, 1.0)
    public_value = clamp(0.25 * continuity + 0.20 * accessibility + 0.20 * resilience + 0.20 * inclusion + 0.15 * trust - 0.15 * burden, 0.0, 1.0)
    println("$(id),$(domain),$(round(observability, digits=3)),$(round(public_value, digits=3))")
end
