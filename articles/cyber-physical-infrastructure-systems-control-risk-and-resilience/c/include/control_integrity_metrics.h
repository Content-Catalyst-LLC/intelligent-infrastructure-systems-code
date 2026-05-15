#ifndef CONTROL_INTEGRITY_METRICS_H
#define CONTROL_INTEGRITY_METRICS_H

double signal_quality_score(double accuracy, double calibration, double timeliness, double validity, double metadata);
double telemetry_reliability_score(double expected, double missing, double late, double invalid);
double dependency_intensity_score(double cyber_dependent_functions, double critical_functions);
double control_validation_score(double validated_checks, double total_checks);
double control_integrity_score(double signal_quality, double telemetry, double validation, double security, double oversight, double exposure);
double cyber_physical_resilience_score(double integrity, double fallback, double manual_override, double recovery, double dependency, double exposure);

#endif
