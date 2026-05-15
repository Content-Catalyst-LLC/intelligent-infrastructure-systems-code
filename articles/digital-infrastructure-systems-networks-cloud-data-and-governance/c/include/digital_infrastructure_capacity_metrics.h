#ifndef DIGITAL_INFRASTRUCTURE_CAPACITY_METRICS_H
#define DIGITAL_INFRASTRUCTURE_CAPACITY_METRICS_H

double digital_access_score(double users_with_access, double users_needing_access);
double network_capacity_score(double bandwidth, double latency, double uptime, double redundancy);
double compute_storage_score(double compute, double storage, double geo_redundancy, double edge_readiness);
double interoperability_score(double shared_standards, double systems_requiring_exchange);
double trust_security_score(double security, double privacy, double auditability, double recovery, double governance);
double vendor_dependency_score(double concentrated_services, double critical_services);
double digital_resilience_score(double access, double network, double compute, double interoperability, double trust, double dependency, double exposure);

#endif
