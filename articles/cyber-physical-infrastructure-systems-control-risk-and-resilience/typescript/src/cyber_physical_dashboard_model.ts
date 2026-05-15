export type CyberPhysicalControlRecord = {
  controlLoopId: string;
  assetId: string;
  infrastructureDomain: string;
  signalQualityScore: number;
  telemetryReliabilityScore: number;
  dependencyIntensityScore: number;
  controlValidationScore: number;
  humanOversightScore: number;
  controlIntegrityScore: number;
  cyberPhysicalResilienceScore: number;
  exposureScore: number;
};

export function classifyCyberPhysicalRecord(record: CyberPhysicalControlRecord): string {
  if (record.signalQualityScore < 0.80) return "signal quality review required";
  if (record.telemetryReliabilityScore < 0.85) return "telemetry review required";
  if (record.controlValidationScore < 0.75) return "control validation review required";
  if (record.humanOversightScore < 0.75) return "human oversight review required";
  if (record.controlIntegrityScore < 0.75) return "control integrity review required";
  if (record.cyberPhysicalResilienceScore < 0.70) return "resilience review required";
  if (record.dependencyIntensityScore > 0.70) return "dependency review required";
  if (record.exposureScore > 0.40) return "exposure review required";
  return "monitor";
}
