#include <stdio.h>
#include <math.h>
#include "smart_grid_metrics.h"

static double clamp01(double x) {
    if (x < 0.0) return 0.0;
    if (x > 1.0) return 1.0;
    return x;
}

double grid_observability_score(double telemetry_reliability, double data_quality, double coverage, double metadata, double latency_score) {
    return clamp01(0.25 * telemetry_reliability + 0.25 * data_quality + 0.20 * coverage + 0.15 * metadata + 0.15 * latency_score);
}

double voltage_adequacy_score(double voltage_pu, double nominal_voltage_pu, double allowed_deviation_pu) {
    if (allowed_deviation_pu <= 0.0) return 0.0;
    return clamp01(1.0 - fabs(voltage_pu - nominal_voltage_pu) / allowed_deviation_pu);
}

double flexibility_adequacy_score(double available_flexibility_mw, double flexibility_need_mw) {
    if (flexibility_need_mw <= 0.0) return 1.0;
    return clamp01(available_flexibility_mw / flexibility_need_mw);
}

double balancing_pressure_score(double load_mw, double available_supply_mw, double available_flexibility_mw) {
    if (load_mw <= 0.0) return 0.0;
    return clamp01(fabs(load_mw - available_supply_mw - available_flexibility_mw) / load_mw);
}

double service_continuity_score(double served_hours, double required_hours) {
    if (required_hours <= 0.0) return 0.0;
    return clamp01(served_hours / required_hours);
}

double grid_resilience_score(double continuity, double flexibility, double observability, double backup, double response, double exposure) {
    return clamp01(0.25 * continuity + 0.20 * flexibility + 0.20 * observability + 0.15 * backup + 0.15 * response - 0.15 * exposure);
}

int main(void) {
    double obs = grid_observability_score(0.74, 0.72, 0.68, 0.64, 0.27);
    double volt = voltage_adequacy_score(0.94, 1.0, 0.05);
    double flex = flexibility_adequacy_score(16.0, 30.0);
    double bal = balancing_pressure_score(25.0, 21.0, 16.0);
    double cont = service_continuity_score(20.5, 24.0);
    double res = grid_resilience_score(cont, flex, obs, 0.46, 0.54, 0.56);

    printf("grid_observability_score=%.3f\n", obs);
    printf("voltage_adequacy_score=%.3f\n", volt);
    printf("flexibility_adequacy_score=%.3f\n", flex);
    printf("balancing_pressure_score=%.3f\n", bal);
    printf("service_continuity_score=%.3f\n", cont);
    printf("grid_resilience_score=%.3f\n", res);

    return 0;
}
