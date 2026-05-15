export type AdaptationRecord = {
  programId: string;
  scenarioCredibility: number;
  dependencyMapping: number;
  serviceProtection: number;
  equityScreen: number;
  financeReadiness: number;
  maintenanceReadiness: number;
  observability: number;
  maladaptationRisk: number;
};

export function readinessScore(record: AdaptationRecord): number {
  return (
    0.18 * record.scenarioCredibility +
    0.14 * record.dependencyMapping +
    0.16 * record.serviceProtection +
    0.14 * record.equityScreen +
    0.14 * record.financeReadiness +
    0.10 * record.maintenanceReadiness +
    0.10 * record.observability
  );
}

export function reviewPriority(record: AdaptationRecord): string {
  if (record.maladaptationRisk >= 0.65) return "maladaptation_review_required";
  if (record.equityScreen < 0.70) return "equity_review_required";
  if (record.financeReadiness < 0.70) return "finance_gap";
  if (record.maintenanceReadiness < 0.70) return "maintenance_gap";
  if (readinessScore(record) < 0.75) return "readiness_review";
  return "implementation_ready";
}
