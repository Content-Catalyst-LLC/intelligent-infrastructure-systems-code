#include <stdio.h>
#include "urban_sensor_quality.h"

double sensor_quality_score(double uptime, double calibration, double metadata, double latency, double provenance) {
    return 0.25 * uptime + 0.20 * calibration + 0.20 * metadata + 0.20 * latency + 0.15 * provenance;
}

double urban_observability_score(double sensor_quality, double coverage, double interoperability, double service_relevance, double governance) {
    return 0.30 * sensor_quality + 0.20 * coverage + 0.20 * interoperability + 0.15 * service_relevance + 0.15 * governance;
}

int threshold_exceeded(double observed_value, double threshold_value) {
    return observed_value >= threshold_value;
}

int main(void) {
    double quality = sensor_quality_score(0.70, 0.62, 0.78, 0.45, 0.76);
    double observability = urban_observability_score(quality, 0.80, 0.78, 0.93, 0.68);

    printf("threshold_exceeded=%d\n", threshold_exceeded(36.8, 35.0));
    printf("sensor_quality_score=%.3f\n", quality);
    printf("urban_observability_score=%.3f\n", observability);
    return 0;
}
