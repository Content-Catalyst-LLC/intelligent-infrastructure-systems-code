#ifndef RENEWABLE_INFRASTRUCTURE_METRICS_H
#define RENEWABLE_INFRASTRUCTURE_METRICS_H

double usable_renewable_mw(double generation_mw, double grid_capacity_mw, double flexibility_mw, double storage_charge_mw);
double curtailment_rate(double generation_mw, double usable_mw);
double flexibility_adequacy(double available_flexibility_mw, double flexibility_need_mw);
double grid_constraint_score(double grid_transfer_capacity_mw, double connection_capacity_mw);
double renewable_infrastructure_score(double curtailment_rate, double flexibility_adequacy, double resilience, double forecast_quality, double storage_readiness, double grid_constraint);

#endif
