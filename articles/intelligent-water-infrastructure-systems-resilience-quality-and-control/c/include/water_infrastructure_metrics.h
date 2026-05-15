#ifndef WATER_INFRASTRUCTURE_METRICS_H
#define WATER_INFRASTRUCTURE_METRICS_H

double quality_compliance_score(double compliant_observations, double tested_observations);
double pressure_adequacy_score(double pressure_psi, double minimum_pressure_psi, double maximum_pressure_psi);
double leakage_rate(double system_input_volume_m3, double authorized_consumption_m3);
double service_continuity_score(double available_hours, double required_hours);
double water_observability_score(double telemetry_reliability, double data_quality, double coverage, double metadata, double latency_score);
double water_resilience_score(double continuity, double quality, double backup, double observability, double response, double exposure);

#endif
