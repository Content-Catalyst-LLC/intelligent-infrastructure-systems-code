#include <stdio.h>
#include "renewable_infrastructure_metrics.h"

static double clamp01(double x) {
    if (x < 0.0) return 0.0;
    if (x > 1.0) return 1.0;
    return x;
}

static double min2(double a, double b) {
    return a < b ? a : b;
}

double usable_renewable_mw(double generation_mw, double grid_capacity_mw, double flexibility_mw, double storage_charge_mw) {
    double usable = grid_capacity_mw + flexibility_mw + storage_charge_mw;
    if (usable > generation_mw) return generation_mw;
    if (usable < 0.0) return 0.0;
    return min2(generation_mw, usable);
}

double curtailment_rate(double generation_mw, double usable_mw) {
    if (generation_mw <= 0.0) return 0.0;
    return clamp01((generation_mw - usable_mw) / generation_mw);
}

double flexibility_adequacy(double available_flexibility_mw, double flexibility_need_mw) {
    if (flexibility_need_mw <= 0.0) return 1.0;
    return clamp01(available_flexibility_mw / flexibility_need_mw);
}

double grid_constraint_score(double grid_transfer_capacity_mw, double connection_capacity_mw) {
    if (connection_capacity_mw <= 0.0) return 0.0;
    return clamp01(1.0 - grid_transfer_capacity_mw / connection_capacity_mw);
}

double renewable_infrastructure_score(double curtailment, double flexibility, double resilience, double forecast_quality, double storage_readiness, double grid_constraint) {
    return clamp01(0.25 * (1.0 - curtailment) + 0.20 * flexibility + 0.20 * resilience + 0.15 * forecast_quality + 0.10 * storage_readiness - 0.10 * grid_constraint);
}

int main(void) {
    double usable = usable_renewable_mw(118.0, 130.0, 34.0, 18.0);
    double curt = curtailment_rate(118.0, usable);
    double flex = flexibility_adequacy(34.0, 52.0);
    double constraint = grid_constraint_score(130.0, 180.0);
    double score = renewable_infrastructure_score(curt, flex, 0.62, 0.70, 0.62, constraint);

    printf("usable_renewable_mw=%.3f\n", usable);
    printf("curtailment_rate=%.3f\n", curt);
    printf("flexibility_adequacy=%.3f\n", flex);
    printf("grid_constraint_score=%.3f\n", constraint);
    printf("renewable_infrastructure_score=%.3f\n", score);

    return 0;
}
