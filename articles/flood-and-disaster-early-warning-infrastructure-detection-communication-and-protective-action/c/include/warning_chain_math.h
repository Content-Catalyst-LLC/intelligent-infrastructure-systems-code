#ifndef WARNING_CHAIN_MATH_H
#define WARNING_CHAIN_MATH_H

double protective_warning_probability(
    double detection,
    double reach,
    double comprehension,
    double trust,
    double action_capacity
);

double useful_lead_time(
    double forecast_lead_time_minutes,
    double decision_delay_minutes,
    double communication_delay_minutes,
    double mobilization_time_minutes
);

double residual_warning_risk(
    double hazard_severity,
    double exposure_score,
    double vulnerability_score,
    double protective_probability
);

#endif
