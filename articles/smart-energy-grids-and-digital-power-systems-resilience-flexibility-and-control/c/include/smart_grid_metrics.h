#ifndef SMART_GRID_METRICS_H
#define SMART_GRID_METRICS_H

double grid_observability_score(double telemetry_reliability, double data_quality, double coverage, double metadata, double latency_score);
double voltage_adequacy_score(double voltage_pu, double nominal_voltage_pu, double allowed_deviation_pu);
double flexibility_adequacy_score(double available_flexibility_mw, double flexibility_need_mw);
double balancing_pressure_score(double load_mw, double available_supply_mw, double available_flexibility_mw);
double service_continuity_score(double served_hours, double required_hours);
double grid_resilience_score(double continuity, double flexibility, double observability, double backup, double response, double exposure);

#endif
