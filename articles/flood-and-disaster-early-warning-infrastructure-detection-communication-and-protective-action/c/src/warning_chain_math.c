#include <stdio.h>
#include "warning_chain_math.h"

double protective_warning_probability(
    double detection,
    double reach,
    double comprehension,
    double trust,
    double action_capacity
) {
    return detection * reach * comprehension * trust * action_capacity;
}

double useful_lead_time(
    double forecast_lead_time_minutes,
    double decision_delay_minutes,
    double communication_delay_minutes,
    double mobilization_time_minutes
) {
    return forecast_lead_time_minutes
        - decision_delay_minutes
        - communication_delay_minutes
        - mobilization_time_minutes;
}

double residual_warning_risk(
    double hazard_severity,
    double exposure_score,
    double vulnerability_score,
    double protective_probability
) {
    return hazard_severity * exposure_score * vulnerability_score * (1.0 - protective_probability);
}

int main(void) {
    double p = protective_warning_probability(0.78, 0.76, 0.70, 0.68, 0.62);
    double lead = useful_lead_time(60.0, 15.0, 8.0, 20.0);
    double risk = residual_warning_risk(0.82, 0.78, 0.70, p);

    printf("protective_warning_probability=%.3f\n", p);
    printf("useful_lead_time_minutes=%.1f\n", lead);
    printf("residual_warning_risk=%.3f\n", risk);

    return 0;
}
