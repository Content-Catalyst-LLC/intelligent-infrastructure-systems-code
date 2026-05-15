#ifndef ENERGY_PERFORMANCE_METRICS_H
#define ENERGY_PERFORMANCE_METRICS_H

double availability_score(double available_hours, double total_hours);
double service_continuity_score(double power_served_mw, double power_demand_mw);
double degradation_score(double baseline_health, double current_health);
double stress_score(double loading, double thermal, double cycling, double environmental);
double resilience_score(double availability, double continuity, double fallback, double observability, double restoration_time);

#endif
