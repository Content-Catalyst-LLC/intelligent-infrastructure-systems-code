#include <stdio.h>
#include <stdbool.h>

typedef struct {
    const char *system_id;
    double observability;
    double interoperability;
    double resilience_readiness;
    double cyber_resilience;
    double equity_readiness;
} InfrastructureSignalRecord;

double public_system_readiness( InfrastructureSignalRecord record ) {
    return (
        0.20 * record.observability +
        0.20 * record.interoperability +
        0.25 * record.resilience_readiness +
        0.25 * record.cyber_resilience +
        0.10 * record.equity_readiness
    );
}

bool requires_review( InfrastructureSignalRecord record ) {
    return public_system_readiness(record) < 0.70 || record.cyber_resilience < 0.70;
}

int main(void) {
    InfrastructureSignalRecord record = {
        .system_id = "water-network-intelligence",
        .observability = 0.78,
        .interoperability = 0.66,
        .resilience_readiness = 0.74,
        .cyber_resilience = 0.68,
        .equity_readiness = 0.72
    };

    printf("system=%s readiness=%.3f review=%s\n",
           record.system_id,
           public_system_readiness(record),
           requires_review(record) ? "true" : "false");

    return 0;
}
