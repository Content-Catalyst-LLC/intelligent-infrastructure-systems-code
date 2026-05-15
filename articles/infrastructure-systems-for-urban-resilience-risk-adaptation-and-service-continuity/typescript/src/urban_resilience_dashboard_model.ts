export type UrbanResilienceRecord = {
  serviceId: string;
  serviceName: string;
  serviceDomain: string;
  serviceZoneId: string;
  serviceContinuityScore: number;
  recoveryLagHours: number;
  dependencyStress: number;
  urbanRiskScore: number;
  equityGapScore: number;
};

export function classifyUrbanResilienceRecord(record: UrbanResilienceRecord): string {
  if (record.serviceContinuityScore < 0.75) return "service continuity review required";
  if (record.recoveryLagHours > 0) return "recovery lag review required";
  if (record.dependencyStress >= 0.30) return "dependency stress review required";
  if (record.urbanRiskScore >= 0.25) return "urban risk review required";
  if (record.equityGapScore >= 0.35) return "equity gap review required";
  return "monitor";
}
