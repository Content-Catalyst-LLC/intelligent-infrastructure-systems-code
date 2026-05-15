#ifndef URBAN_SENSOR_QUALITY_H
#define URBAN_SENSOR_QUALITY_H

double sensor_quality_score(double uptime, double calibration, double metadata, double latency, double provenance);
double urban_observability_score(double sensor_quality, double coverage, double interoperability, double service_relevance, double governance);
int threshold_exceeded(double observed_value, double threshold_value);

#endif
