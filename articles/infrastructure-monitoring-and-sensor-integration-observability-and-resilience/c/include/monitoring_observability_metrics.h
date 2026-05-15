#ifndef MONITORING_OBSERVABILITY_METRICS_H
#define MONITORING_OBSERVABILITY_METRICS_H

double sensor_coverage_score(double monitored_critical_assets, double critical_assets);
double signal_quality_score(double accuracy, double precision, double completeness, double validity, double freshness);
double calibration_confidence_score(double lambda, double days_since_calibration);
double telemetry_reliability_score(double expected, double missing, double late, double invalid);
double metadata_completeness_score(double present_fields, double required_fields);
double monitoring_observability_score(double coverage, double signal_quality, double calibration, double telemetry, double metadata, double blindspot);
double monitoring_resilience_score(double observability, double actionability, double backup, double validation, double exposure);

#endif
