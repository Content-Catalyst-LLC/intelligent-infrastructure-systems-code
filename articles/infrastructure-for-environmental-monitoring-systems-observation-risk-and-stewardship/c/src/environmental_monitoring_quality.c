#include <stdio.h>
#include "environmental_monitoring_quality.h"

double environmental_anomaly(double observed_value, double baseline_value) {
    return observed_value - baseline_value;
}

int threshold_exceeded(double observed_value, double threshold_value) {
    return observed_value >= threshold_value;
}

double monitoring_quality_score(
    double completeness,
    double calibration,
    double metadata,
    double provenance,
    double sampling_design
) {
    return 0.25 * completeness
        + 0.20 * calibration
        + 0.20 * metadata
        + 0.20 * provenance
        + 0.15 * sampling_design;
}

double environmental_risk_score(
    double hazard_intensity,
    double exposure,
    double vulnerability,
    double governance_response
) {
    return hazard_intensity * exposure * vulnerability * (1.0 - governance_response);
}

int main(void) {
    double quality = monitoring_quality_score(0.70, 0.62, 0.68, 0.72, 0.70);
    double risk = environmental_risk_score(0.525, 0.82, 0.70, 0.58);

    printf("threshold_exceeded=%d\n", threshold_exceeded(42.0, 40.0));
    printf("monitoring_quality_score=%.3f\n", quality);
    printf("environmental_risk_score=%.3f\n", risk);

    return 0;
}
