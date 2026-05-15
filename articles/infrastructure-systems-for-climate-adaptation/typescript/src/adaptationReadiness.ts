export type AdaptationRecord = {
  programId: string;
  scenarioCredibility: number;
  dependencyMapping: number;
  serviceProtection: number;
  equityScreen: number;
  financeReadiness: number;
  maintenanceReadiness: number;
  observability: number;
  governanceClarity: number;
  maladaptationRisk: number;
};

const weights = {
  scenarioCredibility: 0.16,
  dependencyMapping: 0.14,
  serviceProtection: 0.15,
  equityScreen: 0.14,
  financeReadiness: 0.12,
  maintenanceReadiness: 0.10,
  observability: 0.10,
  governanceClarity: 0.09,
} as const;

function bounded(value: number): boolean {
  return Number.isFinite(value) && value >= 0 && value <= 1;
}

export function validateRecord(record: AdaptationRecord): string[] {
  const errors: string[] = [];
  for (const [key, value] of Object.entries(record)) {
    if (key !== "programId" && typeof value === "number" && !bounded(value)) {
      errors.push(`${key} must be between 0 and 1`);
    }
  }
  if (!record.programId.trim()) errors.push("programId is required");
  return errors;
}

export function readinessScore(record: AdaptationRecord): number {
  const score =
    weights.scenarioCredibility * record.scenarioCredibility +
    weights.dependencyMapping * record.dependencyMapping +
    weights.serviceProtection * record.serviceProtection +
    weights.equityScreen * record.equityScreen +
    weights.financeReadiness * record.financeReadiness +
    weights.maintenanceReadiness * record.maintenanceReadiness +
    weights.observability * record.observability +
    weights.governanceClarity * record.governanceClarity;
  return Math.round(score * 1000) / 1000;
}

export function netReadinessScore(record: AdaptationRecord): number {
  return Math.max(0, Math.round((readinessScore(record) - 0.2 * record.maladaptationRisk) * 1000) / 1000);
}

export function reviewPriority(record: AdaptationRecord): string {
  const errors = validateRecord(record);
  if (errors.length > 0) return "invalid_record";
  if (record.maladaptationRisk >= 0.60) return "maladaptation_review_required";
  if (record.equityScreen < 0.70) return "equity_review_required";
  if (record.financeReadiness < 0.70) return "finance_gap";
  if (record.maintenanceReadiness < 0.70) return "maintenance_gap";
  if (record.dependencyMapping < 0.70) return "dependency_mapping_review";
  if (netReadinessScore(record) < 0.70) return "readiness_review";
  return "implementation_ready";
}
