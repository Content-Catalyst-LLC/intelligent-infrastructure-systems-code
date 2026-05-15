#include <stdio.h>
#include "energy_performance_metrics.h"

static double clamp01(double x) {
    if (x < 0.0) return 0.0;
    if (x > 1.0) return 1.0;
    return x;
}

double availability_score(double available_hours, double total_hours) {
    if (total_hours <= 0.0) return 0.0;
    return clamp01(available_hours / total_hours);
}

double service_continuity_score(double power_served_mw, double power_demand_mw) {
    if (power_demand_mw <= 0.0) return 1.0;
    return clamp01(power_served_mw / power_demand_mw);
}

double degradation_score(double baseline_health, double current_health) {
    if (baseline_health <= 0.0) return 0.0;
    return clamp01((baseline_health - current_health) / baseline_health);
}

double stress_score(double loading, double thermal, double cycling, double environmental) {
    return clamp01(0.30 * loading + 0.25 * thermal + 0.25 * cycling + 0.20 * environmental);
}

double resilience_score(double availability, double continuity, double fallback, double observability, double restoration_time) {
    return clamp01(0.25 * availability + 0.25 * continuity + 0.20 * fallback + 0.15 * observability - 0.15 * restoration_time);
}

int main(void) {
    double availability = availability_score(20.5, 24.0);
    double continuity = service_continuity_score(21.0, 25.0);
    double degradation = degradation_score(0.90, 0.58);
    double stress = stress_score(0.88, 0.86, 0.44, 0.54);
    double resilience = resilience_score(availability, continuity, 0.42, 0.62, 0.86);

    printf("availability_score=%.3f\n", availability);
    printf("service_continuity_score=%.3f\n", continuity);
    printf("degradation_score=%.3f\n", degradation);
    printf("stress_score=%.3f\n", stress);
    printf("resilience_score=%.3f\n", resilience);

    return 0;
}
