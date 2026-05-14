#include <stdio.h>
#include <stdbool.h>

typedef struct {
    const char *state_id;
    const char *asset_id;
    double condition_state;
    double load_factor;
    double climate_exposure;
    double service_criticality;
    double estimated_failure_risk;
    const char *state_quality_flag;
} DigitalTwinStateRecord;

double service_risk(DigitalTwinStateRecord record) {
    return record.estimated_failure_risk * record.service_criticality;
}

bool requires_review(DigitalTwinStateRecord record) {
    return record.state_quality_flag[0] != 'p' || service_risk(record) > 0.4;
}

int main(void) {
    DigitalTwinStateRecord record = {
        .state_id = "STATE-001",
        .asset_id = "DT-0001",
        .condition_state = 0.72,
        .load_factor = 0.68,
        .climate_exposure = 0.45,
        .service_criticality = 0.86,
        .estimated_failure_risk = 0.34,
        .state_quality_flag = "pass"
    };

    printf("state=%s asset=%s service_risk=%.3f review=%s\n",
           record.state_id,
           record.asset_id,
           service_risk(record),
           requires_review(record) ? "true" : "false");

    return 0;
}
