#ifndef ENVIRONMENTAL_MONITORING_QUALITY_H
#define ENVIRONMENTAL_MONITORING_QUALITY_H

double environmental_anomaly(double observed_value, double baseline_value);

int threshold_exceeded(double observed_value, double threshold_value);

double monitoring_quality_score(
    double completeness,
    double calibration,
    double metadata,
    double provenance,
    double sampling_design
);

double environmental_risk_score(
    double hazard_intensity,
    double exposure,
    double vulnerability,
    double governance_response
);

#endif
