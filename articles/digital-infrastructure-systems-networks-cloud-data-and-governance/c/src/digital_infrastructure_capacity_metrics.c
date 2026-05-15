#include <stdio.h>
#include "digital_infrastructure_capacity_metrics.h"

static double clamp01(double x) {
    if (x < 0.0) return 0.0;
    if (x > 1.0) return 1.0;
    return x;
}

double digital_access_score(double users_with_access, double users_needing_access) {
    if (users_needing_access <= 0.0) return 0.0;
    return clamp01(users_with_access / users_needing_access);
}

double network_capacity_score(double bandwidth, double latency, double uptime, double redundancy) {
    return clamp01(0.30 * bandwidth + 0.25 * latency + 0.25 * uptime + 0.20 * redundancy);
}

double compute_storage_score(double compute, double storage, double geo_redundancy, double edge_readiness) {
    return clamp01(0.30 * compute + 0.25 * storage + 0.25 * geo_redundancy + 0.20 * edge_readiness);
}

double interoperability_score(double shared_standards, double systems_requiring_exchange) {
    if (systems_requiring_exchange <= 0.0) return 0.0;
    return clamp01(shared_standards / systems_requiring_exchange);
}

double trust_security_score(double security, double privacy, double auditability, double recovery, double governance) {
    return clamp01(0.25 * security + 0.20 * privacy + 0.20 * auditability + 0.20 * recovery + 0.15 * governance);
}

double vendor_dependency_score(double concentrated_services, double critical_services) {
    if (critical_services <= 0.0) return 0.0;
    return clamp01(concentrated_services / critical_services);
}

double digital_resilience_score(double access, double network, double compute, double interoperability, double trust, double dependency, double exposure) {
    return clamp01(0.20 * access + 0.20 * network + 0.20 * compute + 0.15 * interoperability + 0.20 * trust - 0.15 * dependency - 0.10 * exposure);
}

int main(void) {
    double access = digital_access_score(42000.0, 65000.0);
    double network = network_capacity_score(0.62, 0.58, 0.70, 0.46);
    double compute = compute_storage_score(0.62, 0.64, 0.42, 0.38);
    double interoperability = interoperability_score(8.0, 18.0);
    double trust = trust_security_score(0.62, 0.58, 0.50, 0.52, 0.48);
    double dependency = vendor_dependency_score(10.0, 12.0);
    double resilience = digital_resilience_score(access, network, compute, interoperability, trust, dependency, 0.55);

    printf("digital_access_score=%.3f\n", access);
    printf("network_capacity_score=%.3f\n", network);
    printf("compute_storage_score=%.3f\n", compute);
    printf("interoperability_score=%.3f\n", interoperability);
    printf("trust_security_score=%.3f\n", trust);
    printf("vendor_dependency_score=%.3f\n", dependency);
    printf("digital_resilience_score=%.3f\n", resilience);

    return 0;
}
