export type RiskType =
  | "physical_asset"
  | "environmental_climate"
  | "cyber_digital"
  | "operational"
  | "financial_fiscal"
  | "supply_chain"
  | "institutional_governance"
  | "social_political";

export interface InfrastructureRiskRecord {
  riskId: string;
  assetId: string;
  sector: string;
  riskType: RiskType;
  hazard: string;
  vulnerability: string;
  failureProbability: number;
  consequenceScore: number;
  mitigationEffectiveness: number;
  continuityReadiness: number;
  governanceReadiness: number;
  riskOwner: string;
  status: "open" | "review_required" | "closed";
}

export interface CriticalityRecord {
  assetId: string;
  serviceImportance: number;
  dependencyCentrality: number;
  substituteGap: number;
  publicHarm: number;
  criticalityScore: number;
  criticalityClass: "low" | "medium" | "medium_high" | "high";
}

export interface ContinuityRecord {
  continuityId: string;
  riskId: string;
  essentialFunction: string;
  fallbackMode: string;
  recoveryTimeObjectiveHours: number;
  exerciseStatus: "current" | "needs_exercise" | "expired";
  afterActionReviewStatus: "pending" | "complete";
  continuityOwner: string;
}

export function basicRisk(risk: InfrastructureRiskRecord): number {
  return risk.failureProbability * risk.consequenceScore;
}

export function residualRisk(risk: InfrastructureRiskRecord, dependencyCentrality: number): number {
  const systemRisk = basicRisk(risk) * (1 + dependencyCentrality);
  return systemRisk * (1 - risk.mitigationEffectiveness);
}

export function requiresGovernanceReview(
  risk: InfrastructureRiskRecord,
  criticality: CriticalityRecord
): boolean {
  return (
    criticality.criticalityScore >= 0.75 &&
    (risk.continuityReadiness < 0.65 || risk.governanceReadiness < 0.65)
  );
}
