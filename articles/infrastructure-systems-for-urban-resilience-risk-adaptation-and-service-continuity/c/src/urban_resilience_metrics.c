#include <stdio.h>
#include "urban_resilience_metrics.h"

double service_continuity_score(double disruption_capacity, double normal_capacity) {
    if (normal_capacity <= 0.0) {
        return 0.0;
    }

    double score = disruption_capacity / normal_capacity;
    return score > 1.0 ? 1.0 : score;
}

double recovery_lag_hours(double expected_recovery_hours, double target_recovery_hours) {
    double lag = expected_recovery_hours - target_recovery_hours;
    return lag > 0.0 ? lag : 0.0;
}

double urban_risk_score(
    double hazard_intensity,
    double exposure,
    double vulnerability,
    double governance_response
) {
    return hazard_intensity * exposure * vulnerability * (1.0 - governance_response);
}

double service_resilience_score(
    double continuity,
    double redundancy,
    double maintainability,
    double adaptability,
    double governance
) {
    return 0.30 * continuity
        + 0.20 * redundancy
        + 0.20 * maintainability
        + 0.15 * adaptability
        + 0.15 * governance;
}

int main(void) {
    double continuity = service_continuity_score(58.0, 100.0);
    double lag = recovery_lag_hours(14.0, 6.0);
    double risk = urban_risk_score(0.82, 0.78, 0.76, 0.66);
    double resilience = service_resilience_score(continuity, 0.62, 0.68, 0.64, 0.66);

    printf("service_continuity_score=%.3f\n", continuity);
    printf("recovery_lag_hours=%.1f\n", lag);
    printf("urban_risk_score=%.3f\n", risk);
    printf("service_resilience_score=%.3f\n", resilience);

    return 0;
}
