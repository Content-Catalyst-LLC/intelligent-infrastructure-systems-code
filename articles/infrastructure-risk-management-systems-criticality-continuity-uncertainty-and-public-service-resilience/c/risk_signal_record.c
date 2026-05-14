#include <stdio.h>
#include <stdbool.h>

typedef struct {
    const char *risk_id;
    const char *asset_id;
    double failure_probability;
    double consequence_score;
    double dependency_centrality;
    double mitigation_effectiveness;
    double continuity_readiness;
} RiskSignalRecord;

double basic_risk(RiskSignalRecord record) {
    return record.failure_probability * record.consequence_score;
}

double residual_risk(RiskSignalRecord record) {
    double system_risk = basic_risk(record) * (1.0 + record.dependency_centrality);
    return system_risk * (1.0 - record.mitigation_effectiveness);
}

bool requires_review(RiskSignalRecord record) {
    return residual_risk(record) > 0.40 || record.continuity_readiness < 0.65;
}

int main(void) {
    RiskSignalRecord record = {
        .risk_id = "R-001",
        .asset_id = "A-WATER-01",
        .failure_probability = 0.42,
        .consequence_score = 0.80,
        .dependency_centrality = 0.70,
        .mitigation_effectiveness = 0.45,
        .continuity_readiness = 0.58
    };

    printf("risk=%s asset=%s residual_risk=%.3f review=%s\n",
           record.risk_id,
           record.asset_id,
           residual_risk(record),
           requires_review(record) ? "true" : "false");

    return 0;
}
