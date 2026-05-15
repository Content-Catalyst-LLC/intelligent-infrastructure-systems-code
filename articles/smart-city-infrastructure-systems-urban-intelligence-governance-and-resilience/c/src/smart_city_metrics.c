#include <stdio.h>
#include "smart_city_metrics.h"

static double clamp01(double x) {
    if (x < 0.0) return 0.0;
    if (x > 1.0) return 1.0;
    return x;
}

double service_continuity_score(double observed_capacity, double normal_capacity) {
    if (normal_capacity <= 0.0) return 0.0;
    return clamp01(observed_capacity / normal_capacity);
}

double domain_observability_score(double quality, double coverage, double interoperability, double latency, double governance) {
    return clamp01(0.25 * quality + 0.20 * coverage + 0.20 * interoperability + 0.20 * latency + 0.15 * governance);
}

double public_value_score(double continuity, double accessibility, double resilience, double inclusion, double trust, double burden) {
    return clamp01(0.25 * continuity + 0.20 * accessibility + 0.20 * resilience + 0.20 * inclusion + 0.15 * trust - 0.15 * burden);
}

int main(void) {
    double continuity = service_continuity_score(0.58, 1.00);
    double observability = domain_observability_score(0.78, 0.56, 0.70, 0.58, 0.62);
    double public_value = public_value_score(continuity, 0.66, 0.58, 0.62, 0.60, 0.44);

    printf("service_continuity_score=%.3f\n", continuity);
    printf("domain_observability_score=%.3f\n", observability);
    printf("public_value_score=%.3f\n", public_value);

    return 0;
}
