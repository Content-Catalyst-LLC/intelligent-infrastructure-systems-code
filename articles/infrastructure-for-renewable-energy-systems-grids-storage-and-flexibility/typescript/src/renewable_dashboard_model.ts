export type RenewableInfrastructureRecord = {
  assetId: string;
  technology: string;
  interconnectionStatus: string;
  curtailmentRate: number;
  flexibilityAdequacyScore: number;
  gridConstraintScore: number;
  forecastQualityScore: number;
  storageReadinessScore: number;
  resilienceScore: number;
  renewableInfrastructureScore: number;
};

export function classifyRenewableInfrastructureRecord(record: RenewableInfrastructureRecord): string {
  if (record.interconnectionStatus === "delayed" || record.interconnectionStatus === "queued" || record.interconnectionStatus === "constrained") return "interconnection review required";
  if (record.curtailmentRate >= 0.10) return "curtailment review required";
  if (record.flexibilityAdequacyScore < 0.75) return "flexibility review required";
  if (record.gridConstraintScore >= 0.30) return "grid constraint review required";
  if (record.forecastQualityScore < 0.70) return "forecast review required";
  if (record.resilienceScore < 0.70) return "resilience review required";
  return "monitor";
}
