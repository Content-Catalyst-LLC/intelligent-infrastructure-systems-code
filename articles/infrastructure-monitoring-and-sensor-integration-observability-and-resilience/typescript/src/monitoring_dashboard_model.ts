export type InfrastructureMonitoringRecord = {
  sensorId: string;
  assetId: string;
  serviceZoneId: string;
  signalQualityScore: number;
  calibrationConfidenceScore: number;
  telemetryReliabilityScore: number;
  metadataCompletenessScore: number;
  sensorCoverageScore: number;
  monitoringObservabilityScore: number;
  actionabilityScore: number;
};

export function classifyMonitoringRecord(record: InfrastructureMonitoringRecord): string {
  if (record.signalQualityScore < 0.80) return "signal quality review required";
  if (record.calibrationConfidenceScore < 0.70) return "calibration review required";
  if (record.telemetryReliabilityScore < 0.85) return "telemetry review required";
  if (record.metadataCompletenessScore < 0.85) return "metadata review required";
  if (record.sensorCoverageScore < 0.75) return "coverage review required";
  if (record.monitoringObservabilityScore < 0.75) return "observability review required";
  if (record.actionabilityScore < 0.50) return "actionability review required";
  return "monitor";
}
