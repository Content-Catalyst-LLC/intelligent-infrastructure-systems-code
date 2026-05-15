#include <stdio.h>
#include "control_integrity_metrics.h"

static double clamp01(double x) {
    if (x < 0.0) return 0.0;
    if (x > 1.0) return 1.0;
    return x;
}

double signal_quality_score(double accuracy, double calibration, double timeliness, double validity, double metadata) {
    return clamp01(0.25 * accuracy + 0.20 * calibration + 0.20 * timeliness + 0.20 * validity + 0.15 * metadata);
}

double telemetry_reliability_score(double expected, double missing, double late, double invalid) {
    if (expected <= 0.0) return 0.0;
    return clamp01(1.0 - (missing + late + invalid) / expected);
}

double dependency_intensity_score(double cyber_dependent_functions, double critical_functions) {
    if (critical_functions <= 0.0) return 0.0;
    return clamp01(cyber_dependent_functions / critical_functions);
}

double control_validation_score(double validated_checks, double total_checks) {
    if (total_checks <= 0.0) return 0.0;
    return clamp01(validated_checks / total_checks);
}

double control_integrity_score(double signal_quality, double telemetry, double validation, double security, double oversight, double exposure) {
    return clamp01(0.25 * signal_quality + 0.20 * telemetry + 0.20 * validation + 0.15 * security + 0.15 * oversight - 0.10 * exposure);
}

double cyber_physical_resilience_score(double integrity, double fallback, double manual_override, double recovery, double dependency, double exposure) {
    return clamp01(0.30 * integrity + 0.20 * fallback + 0.20 * manual_override + 0.20 * recovery - 0.10 * dependency - 0.10 * exposure);
}

int main(void) {
    double signal = signal_quality_score(0.70, 0.66, 0.84, 0.64, 0.78);
    double telemetry = telemetry_reliability_score(1440.0, 130.0, 110.0, 85.0);
    double dependency = dependency_intensity_score(9.0, 10.0);
    double validation = control_validation_score(1.0, 5.0);
    double oversight = control_validation_score(3.0, 4.0);
    double integrity = control_integrity_score(signal, telemetry, validation, 0.62, oversight, 0.55);
    double resilience = cyber_physical_resilience_score(integrity, 0.58, 0.76, 0.60, dependency, 0.55);

    printf("signal_quality_score=%.3f\n", signal);
    printf("telemetry_reliability_score=%.3f\n", telemetry);
    printf("dependency_intensity_score=%.3f\n", dependency);
    printf("control_validation_score=%.3f\n", validation);
    printf("human_oversight_score=%.3f\n", oversight);
    printf("control_integrity_score=%.3f\n", integrity);
    printf("cyber_physical_resilience_score=%.3f\n", resilience);

    return 0;
}
