export type TwinType =
  | "asset_twin"
  | "network_twin"
  | "operational_twin"
  | "planning_twin"
  | "territorial_twin";

export type Intervention =
  | "defer"
  | "inspect"
  | "targeted_repair"
  | "renewal";

export interface TwinAsset {
  assetId: string;
  assetClass: string;
  assetName: string;
  location: string;
  owner: string;
  serviceRole: string;
  networkId: string;
  criticalityScore: number;
  operationalStatus: "active" | "review_required" | "offline";
}

export interface DigitalTwinState {
  stateId: string;
  assetId: string;
  timestamp: string;
  conditionState: number;
  loadFactor: number;
  climateExposure: number;
  serviceCriticality: number;
  estimatedFailureRisk: number;
  stateQualityFlag: "pass" | "review_required" | "suspect";
}

export interface SimulationScenario {
  scenarioId: string;
  scenarioType: string;
  loadMultiplier: number;
  climateMultiplier: number;
  disruptionMultiplier: number;
  intervention: Intervention;
  timeHorizonYears: number;
  assumptionNote: string;
}

export interface SimulationOutput {
  outputId: string;
  scenarioId: string;
  assetId: string;
  intervention: Intervention;
  simCondition: number;
  failureRisk: number;
  serviceRisk: number;
  costIndex: number;
  decisionValue: number;
  reviewRequired: boolean;
}

export function serviceRisk(failureRisk: number, criticalityScore: number): number {
  return failureRisk * criticalityScore;
}

export function requiresGovernanceReview(output: SimulationOutput): boolean {
  return output.reviewRequired || output.serviceRisk >= 0.4 || output.decisionValue < 0.2;
}
