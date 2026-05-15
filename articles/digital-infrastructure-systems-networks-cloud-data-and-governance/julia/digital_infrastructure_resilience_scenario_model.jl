records = [
    ("DIGI-URBAN-CORE", 238000.0, 250000.0, 0.92, 0.88, 0.94, 0.82, 0.88, 0.90, 0.82, 0.80, 34.0, 42.0, 0.84, 0.78, 0.82, 0.78, 0.76, 10.0, 20.0, 0.28),
    ("DIGI-RURAL-EDGE", 42000.0, 65000.0, 0.62, 0.58, 0.70, 0.46, 0.62, 0.64, 0.42, 0.38, 8.0, 18.0, 0.62, 0.58, 0.50, 0.52, 0.48, 10.0, 12.0, 0.55),
    ("DIGI-CIVIC-SERVICES", 97000.0, 120000.0, 0.80, 0.74, 0.84, 0.64, 0.74, 0.72, 0.50, 0.52, 23.0, 37.0, 0.72, 0.62, 0.64, 0.62, 0.60, 14.0, 18.0, 0.50)
]

println("service_zone_id,access,network,compute,interoperability,trust,dependency,resilience")

for (zone, users_with, users_need, bandwidth, latency, uptime, redundancy, compute_score, storage, geo, edge, shared, exchange, security, privacy, auditability, recovery, governance, concentrated, critical, exposure) in records
    access = users_need > 0 ? clamp(users_with / users_need, 0.0, 1.0) : 0.0
    network = clamp(0.30 * bandwidth + 0.25 * latency + 0.25 * uptime + 0.20 * redundancy, 0.0, 1.0)
    compute_capacity = clamp(0.30 * compute_score + 0.25 * storage + 0.25 * geo + 0.20 * edge, 0.0, 1.0)
    interoperability = exchange > 0 ? clamp(shared / exchange, 0.0, 1.0) : 0.0
    trust = clamp(0.25 * security + 0.20 * privacy + 0.20 * auditability + 0.20 * recovery + 0.15 * governance, 0.0, 1.0)
    dependency = critical > 0 ? clamp(concentrated / critical, 0.0, 1.0) : 0.0
    resilience = clamp(0.20 * access + 0.20 * network + 0.20 * compute_capacity + 0.15 * interoperability + 0.20 * trust - 0.15 * dependency - 0.10 * exposure, 0.0, 1.0)
    println("$(zone),$(round(access, digits=3)),$(round(network, digits=3)),$(round(compute_capacity, digits=3)),$(round(interoperability, digits=3)),$(round(trust, digits=3)),$(round(dependency, digits=3)),$(round(resilience, digits=3))")
end
