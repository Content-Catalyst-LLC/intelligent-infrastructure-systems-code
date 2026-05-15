export type UrbanSensorMonitoringRecord = {
  sensorId: string;
  assetId: string;
  domain: string;
  variable: string;
  value: number;
  thresholdValue: number;
  latencySeconds: number;
  maxAcceptableLatencySeconds: number;
  sensorQualityScore: number;
  coverageGapScore: number;
  urbanObservabilityScore: number;
  governanceResponseScore: number;
};

export function classifyUrbanSensorRecord(record: UrbanSensorMonitoringRecord): string {
  if (record.value >= record.thresholdValue) return "threshold review required";
  if (record.sensorQualityScore < 0.75) return "sensor quality review required";
  if (record.coverageGapScore >= 0.35) return "coverage gap review required";
  if (record.latencySeconds > record.maxAcceptableLatencySeconds) return "telemetry latency review required";
  if (record.governanceResponseScore < 0.60) return "governance response review required";
  return "monitor";
}
