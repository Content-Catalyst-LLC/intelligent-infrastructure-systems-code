#ifndef CLIMATE_RECORD_QUALITY_H
#define CLIMATE_RECORD_QUALITY_H

double climate_anomaly(double observed_value, double baseline_value);

double record_completeness(int observed_count, int expected_count);

double station_quality_score(
    double completeness,
    double metadata_score,
    double calibration_score,
    double homogeneity_score,
    double provenance_score
);

#endif
