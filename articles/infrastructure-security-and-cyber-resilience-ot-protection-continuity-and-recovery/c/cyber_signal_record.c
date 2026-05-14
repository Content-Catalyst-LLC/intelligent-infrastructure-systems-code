#include <stdio.h>
#include <stdbool.h>

typedef struct {
    const char *system_id;
    double exposure;
    double vulnerability;
    double control_effectiveness;
    double continuity_readiness;
    double recovery_readiness;
} CyberSignalRecord;

double raw_exposure(CyberSignalRecord record) {
    return record.exposure * record.vulnerability;
}

double residual_exposure(CyberSignalRecord record) {
    return raw_exposure(record) * (1.0 - record.control_effectiveness);
}

bool requires_review(CyberSignalRecord record) {
    return residual_exposure(record) > 0.30 ||
           record.continuity_readiness < 0.65 ||
           record.recovery_readiness < 0.65;
}

int main(void) {
    CyberSignalRecord record = {
        .system_id = "water-ot-environment",
        .exposure = 0.72,
        .vulnerability = 0.62,
        .control_effectiveness = 0.58,
        .continuity_readiness = 0.58,
        .recovery_readiness = 0.60
    };

    printf("system=%s residual_exposure=%.3f review=%s\n",
           record.system_id,
           residual_exposure(record),
           requires_review(record) ? "true" : "false");

    return 0;
}
