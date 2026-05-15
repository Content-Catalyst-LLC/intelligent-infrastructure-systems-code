export type SmartGridInfrastructureRecord = {
  assetId: string;
  assetClass: string;
  serviceZoneId: string;
  gridObservabilityScore: number;
  voltageAdequacyScore: number;
  flexibilityAdequacyScore: number;
  balancingPressureScore: number;
  serviceContinuityScore: number;
  gridResilienceScore: number;
  cyberPhysicalRiskScore: number;
};

export function classifySmartGridRecord(record: SmartGridInfrastructureRecord): string {
  if (record.gridObservabilityScore < 0.70) return "observability review required";
  if (record.voltageAdequacyScore < 0.70) return "voltage review required";
  if (record.flexibilityAdequacyScore < 0.75) return "flexibility review required";
  if (record.balancingPressureScore >= 0.20) return "balancing pressure review required";
  if (record.serviceContinuityScore < 0.90) return "service continuity review required";
  if (record.gridResilienceScore < 0.70) return "resilience review required";
  if (record.cyberPhysicalRiskScore >= 0.35) return "cyber-physical review required";
  return "monitor";
}
