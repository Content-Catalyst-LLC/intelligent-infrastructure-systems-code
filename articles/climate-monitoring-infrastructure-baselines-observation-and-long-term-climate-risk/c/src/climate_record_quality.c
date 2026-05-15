#include <stdio.h>
#include "climate_record_quality.h"

double climate_anomaly(double observed_value, double baseline_value) {
    return observed_value - baseline_value;
}

double record_completeness(int observed_count, int expected_count) {
    if (expected_count <= 0) {
        return 0.0;
    }
    return (double) observed_count / (double) expected_count;
}

double station_quality_score(
    double completeness,
    double metadata_score,
    double calibration_score,
    double homogeneity_score,
    double provenance_score
) {
    return 0.25 * completeness
        + 0.20 * metadata_score
        + 0.20 * calibration_score
        + 0.20 * homogeneity_score
        + 0.15 * provenance_score;
}

int main(void) {
    double anomaly = climate_anomaly(5.9, 4.3);
    double completeness = record_completeness(29, 35);
    double quality = station_quality_score(completeness, 0.80, 0.95, 0.75, 0.90);

    printf("climate_anomaly=%.3f\n", anomaly);
    printf("record_completeness=%.3f\n", completeness);
    printf("station_quality_score=%.3f\n", quality);

    return 0;
}
