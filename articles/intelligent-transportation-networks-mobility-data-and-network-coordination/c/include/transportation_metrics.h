#ifndef TRANSPORTATION_METRICS_H
#define TRANSPORTATION_METRICS_H

double travel_time_reliability(double mean_minutes, double std_minutes);
double recovery_lag_minutes(double expected_recovery, double target_recovery);
double mobility_quality_score(double reliability, double accessibility, double safety, double coordination, double emissions_burden);

#endif
