export type EnergyPerformanceRecord = {
  assetId: string;
  assetClass: string;
  availabilityScore: number;
  serviceContinuityScore: number;
  degradationScore: number;
  stressScore: number;
  powerQualityRiskScore: number;
  resilienceScore: number;
};

export function classifyEnergyPerformanceRecord(record: EnergyPerformanceRecord): string {
  if (record.availabilityScore < 0.95) return "availability review required";
  if (record.serviceContinuityScore < 0.90) return "service continuity review required";
  if (record.degradationScore >= 0.25) return "degradation review required";
  if (record.stressScore >= 0.65) return "stress review required";
  if (record.powerQualityRiskScore >= 0.35) return "power quality review required";
  if (record.resilienceScore < 0.70) return "resilience review required";
  return "monitor";
}
