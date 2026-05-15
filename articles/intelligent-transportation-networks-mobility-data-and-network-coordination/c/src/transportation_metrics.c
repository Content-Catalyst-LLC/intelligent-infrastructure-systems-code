#include <stdio.h>
#include "transportation_metrics.h"

double travel_time_reliability(double mean_minutes, double std_minutes) {
    if (mean_minutes <= 0.0) {
        return 0.0;
    }
    double score = 1.0 - (std_minutes / mean_minutes);
    if (score < 0.0) return 0.0;
    if (score > 1.0) return 1.0;
    return score;
}

double recovery_lag_minutes(double expected_recovery, double target_recovery) {
    double lag = expected_recovery - target_recovery;
    return lag > 0.0 ? lag : 0.0;
}

double mobility_quality_score(double reliability, double accessibility, double safety, double coordination, double emissions_burden) {
    double score = 0.25 * reliability + 0.20 * accessibility + 0.20 * safety + 0.20 * coordination - 0.15 * emissions_burden;
    if (score < 0.0) return 0.0;
    if (score > 1.0) return 1.0;
    return score;
}

int main(void) {
    double reliability = travel_time_reliability(34.0, 13.0);
    double lag = recovery_lag_minutes(35.0, 20.0);
    double quality = mobility_quality_score(reliability, 0.76, 0.70, 0.60, 0.30);

    printf("travel_time_reliability=%.3f\n", reliability);
    printf("recovery_lag_minutes=%.1f\n", lag);
    printf("mobility_quality_score=%.3f\n", quality);

    return 0;
}
