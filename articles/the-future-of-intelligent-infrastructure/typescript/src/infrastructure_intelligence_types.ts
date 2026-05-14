export type InfrastructureSector =
  | "water"
  | "transport"
  | "energy"
  | "stormwater"
  | "public_buildings"
  | "communications"
  | "digital_public_infrastructure";

export interface InfrastructureIntelligenceKPI {
  systemId: string;
  sector: InfrastructureSector;
  observability: number;
  interoperability: number;
  aiGovernance: number;
  resilienceReadiness: number;
  cyberResilience: number;
  equityReadiness: number;
  publicAccountability: number;
  adaptiveCapacity: number;
  highCriticality: boolean;
}

export interface ResilienceScenario {
  scenarioId: string;
  systemId: string;
  scenarioType: string;
  severity: "low" | "medium" | "high";
  timeHorizonYears: number;
  recoveryObjectiveHours: number;
  scenarioStatus: "current" | "review_required" | "archived";
  assumptionNote: string;
}

export interface GovernanceReview {
  reviewId: string;
  date: string;
  reviewArea: string;
  decision: string;
  owner: string;
  status: "open" | "closed" | "review_required";
  publicNoteRequired: boolean;
}

export function intelligenceQuality(kpi: InfrastructureIntelligenceKPI): number {
  return (
    0.15 * kpi.observability +
    0.13 * kpi.interoperability +
    0.12 * kpi.aiGovernance +
    0.15 * kpi.resilienceReadiness +
    0.14 * kpi.cyberResilience +
    0.12 * kpi.equityReadiness +
    0.10 * kpi.publicAccountability +
    0.09 * kpi.adaptiveCapacity
  );
}

export function requiresGovernanceReview(kpi: InfrastructureIntelligenceKPI): boolean {
  return (
    (kpi.highCriticality && kpi.cyberResilience < 0.70) ||
    (kpi.highCriticality && kpi.resilienceReadiness < 0.70) ||
    kpi.aiGovernance < 0.70 ||
    kpi.interoperability < 0.65 ||
    kpi.equityReadiness < 0.65 ||
    kpi.publicAccountability < 0.65 ||
    intelligenceQuality(kpi) < 0.70
  );
}
