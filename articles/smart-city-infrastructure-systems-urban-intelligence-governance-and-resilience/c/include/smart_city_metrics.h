#ifndef SMART_CITY_METRICS_H
#define SMART_CITY_METRICS_H

double service_continuity_score(double observed_capacity, double normal_capacity);
double domain_observability_score(double quality, double coverage, double interoperability, double latency, double governance);
double public_value_score(double continuity, double accessibility, double resilience, double inclusion, double trust, double burden);

#endif
