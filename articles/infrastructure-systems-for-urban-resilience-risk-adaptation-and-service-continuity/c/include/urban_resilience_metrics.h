#ifndef URBAN_RESILIENCE_METRICS_H
#define URBAN_RESILIENCE_METRICS_H

double service_continuity_score(double disruption_capacity, double normal_capacity);

double recovery_lag_hours(double expected_recovery_hours, double target_recovery_hours);

double urban_risk_score(
    double hazard_intensity,
    double exposure,
    double vulnerability,
    double governance_response
);

double service_resilience_score(
    double continuity,
    double redundancy,
    double maintainability,
    double adaptability,
    double governance
);

#endif
