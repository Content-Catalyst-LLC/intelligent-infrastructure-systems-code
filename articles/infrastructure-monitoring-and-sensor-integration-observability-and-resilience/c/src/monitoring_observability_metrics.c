#include <stdio.h>
#include <math.h>
#include "monitoring_observability_metrics.h"

static double clamp01(double x) {
    if (x < 0.0) return 0.0;
    if (x > 1.0) return 1.0;
    return x;
}

double sensor_coverage_score(double monitored_critical_assets, double critical_assets) {
    if (critical_assets <= 0.0) return 0.0;
    return clamp01(monitored_critical_assets / critical_assets);
}

double signal_quality_score(double accuracy, double precision, double completeness, double validity, double freshness) {
    return clamp01(0.25 * accuracy + 0.20 * precision + 0.20 * completeness + 0.20 * validity + 0.15 * freshness);
}

double calibration_confidence_score(double lambda, double days_since_calibration) {
    if (lambda < 0.0 || days_since_calibration < 0.0) return 0.0;
    return clamp01(exp(-lambda * days_since_calibration));
}

double telemetry_reliability_score(double expected, double missing, double late, double invalid) {
    if (expected <= 0.0) return 0.0;
    return clamp01(1.0 - (missing + late + invalid) / expected);
}

double metadata_completeness_score(double present_fields, double required_fields) {
    if (required_fields <= 0.0) return 0.0;
    return clamp01(present_fields / required_fields);
}

double monitoring_observability_score(double coverage, double signal_quality, double calibration, double telemetry, double metadata, double blindspot) {
    return clamp01(0.20 * coverage + 0.20 * signal_quality + 0.20 * calibration + 0.20 * telemetry + 0.15 * metadata - 0.15 * blindspot);
}

double monitoring_resilience_score(double observability, double actionability, double backup, double validation, double exposure) {
    return clamp01(0.35 * observability + 0.25 * actionability + 0.20 * backup + 0.10 * validation - 0.10 * exposure);
}

int main(void) {
    double coverage = sensor_coverage_score(12.0, 20.0);
    double quality = signal_quality_score(0.70, 0.68, 0.66, 0.64, 0.84);
    double calibration = calibration_confidence_score(0.004, 244.0);
    double telemetry = telemetry_reliability_score(1440.0, 130.0, 110.0, 85.0);
    double metadata = metadata_completeness_score(7.0, 8.0);
    double blindspot = 3.0 / 6.0;
    double observability = monitoring_observability_score(coverage, quality, calibration, telemetry, metadata, blindspot);
    double resilience = monitoring_resilience_score(observability, 1.0, 0.60, 0.66, 0.42);

    printf("sensor_coverage_score=%.3f\n", coverage);
    printf("signal_quality_score=%.3f\n", quality);
    printf("calibration_confidence_score=%.3f\n", calibration);
    printf("telemetry_reliability_score=%.3f\n", telemetry);
    printf("metadata_completeness_score=%.3f\n", metadata);
    printf("monitoring_observability_score=%.3f\n", observability);
    printf("monitoring_resilience_score=%.3f\n", resilience);

    return 0;
}
