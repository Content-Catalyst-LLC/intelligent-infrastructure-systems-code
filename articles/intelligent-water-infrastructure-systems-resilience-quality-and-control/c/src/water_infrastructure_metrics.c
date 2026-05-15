#include <stdio.h>
#include "water_infrastructure_metrics.h"

static double clamp01(double x) {
    if (x < 0.0) return 0.0;
    if (x > 1.0) return 1.0;
    return x;
}

double quality_compliance_score(double compliant_observations, double tested_observations) {
    if (tested_observations <= 0.0) return 0.0;
    return clamp01(compliant_observations / tested_observations);
}

double pressure_adequacy_score(double pressure_psi, double minimum_pressure_psi, double maximum_pressure_psi) {
    if (maximum_pressure_psi <= minimum_pressure_psi) return 0.0;
    return clamp01((pressure_psi - minimum_pressure_psi) / (maximum_pressure_psi - minimum_pressure_psi));
}

double leakage_rate(double system_input_volume_m3, double authorized_consumption_m3) {
    if (system_input_volume_m3 <= 0.0) return 0.0;
    return clamp01((system_input_volume_m3 - authorized_consumption_m3) / system_input_volume_m3);
}

double service_continuity_score(double available_hours, double required_hours) {
    if (required_hours <= 0.0) return 0.0;
    return clamp01(available_hours / required_hours);
}

double water_observability_score(double telemetry_reliability, double data_quality, double coverage, double metadata, double latency_score) {
    return clamp01(0.25 * telemetry_reliability + 0.25 * data_quality + 0.20 * coverage + 0.15 * metadata + 0.15 * latency_score);
}

double water_resilience_score(double continuity, double quality, double backup, double observability, double response, double exposure) {
    return clamp01(0.25 * continuity + 0.20 * quality + 0.20 * backup + 0.15 * observability + 0.15 * response - 0.15 * exposure);
}

int main(void) {
    double quality = quality_compliance_score(132.0, 140.0);
    double pressure = pressure_adequacy_score(34.0, 35.0, 80.0);
    double leakage = leakage_rate(125000.0, 93000.0);
    double continuity = service_continuity_score(19.0, 24.0);
    double observability = water_observability_score(0.76, 0.74, 0.70, 0.66, 0.27);
    double resilience = water_resilience_score(continuity, quality, 0.58, observability, 0.60, 0.42);

    printf("quality_compliance_score=%.3f\n", quality);
    printf("pressure_adequacy_score=%.3f\n", pressure);
    printf("leakage_rate=%.3f\n", leakage);
    printf("service_continuity_score=%.3f\n", continuity);
    printf("water_observability_score=%.3f\n", observability);
    printf("water_resilience_score=%.3f\n", resilience);

    return 0;
}
