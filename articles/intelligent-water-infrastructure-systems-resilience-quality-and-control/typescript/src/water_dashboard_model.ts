export type WaterInfrastructureRecord = {
  assetId: string;
  assetClass: string;
  serviceZoneId: string;
  qualityComplianceScore: number;
  pressureAdequacyScore: number;
  leakageRate: number;
  serviceContinuityScore: number;
  waterObservabilityScore: number;
  waterResilienceScore: number;
  overflowRiskScore: number;
};

export function classifyWaterInfrastructureRecord(record: WaterInfrastructureRecord): string {
  if (record.qualityComplianceScore < 0.98) return "water quality review required";
  if (record.pressureAdequacyScore < 0.35) return "pressure review required";
  if (record.leakageRate >= 0.20) return "leakage review required";
  if (record.serviceContinuityScore < 0.90) return "service continuity review required";
  if (record.waterObservabilityScore < 0.70) return "observability review required";
  if (record.waterResilienceScore < 0.70) return "resilience review required";
  if (record.overflowRiskScore >= 0.35) return "wastewater/stormwater review required";
  return "monitor";
}
