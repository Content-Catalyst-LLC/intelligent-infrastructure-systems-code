export type AssetClass =
  | "pump"
  | "valve"
  | "bridge_component"
  | "road_segment"
  | "substation_asset"
  | "pipe_segment"
  | "rail_component"
  | "building_system";

export type MaintenanceStrategy =
  | "reactive"
  | "preventive"
  | "condition_based"
  | "predictive"
  | "rehabilitation"
  | "renewal"
  | "replacement"
  | "decommission";

export interface AssetRegisterRecord {
  assetId: string;
  assetClass: AssetClass;
  assetName: string;
  location: string;
  owner: string;
  installYear: number;
  designLifeYears: number;
  replacementCost: number;
  serviceRole: string;
  operationalStatus: "active" | "review_required" | "offline";
}

export interface ConditionInspection {
  inspectionId: string;
  assetId: string;
  inspectionDate: string;
  conditionScore: number;
  defectScore: number;
  inspectionMethod: string;
  inspector: string;
}

export interface WorkOrder {
  workOrderId: string;
  assetId: string;
  createdDate: string;
  maintenanceStrategy: MaintenanceStrategy;
  priority: "low" | "medium" | "high" | "urgent";
  status: "planned" | "review_required" | "closed" | "deferred";
  estimatedCost: number;
}

export function riskScore(failureProbability: number, criticalityScore: number): number {
  return failureProbability * criticalityScore;
}

export function requiresGovernanceReview(priorityScore: number, criticalityScore: number): boolean {
  return priorityScore >= 0.7 || criticalityScore >= 0.85;
}
