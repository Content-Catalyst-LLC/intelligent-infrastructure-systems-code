export type InfrastructureEnvironment =
  | "IT"
  | "OT"
  | "ICS"
  | "OT_field"
  | "IT_OT_hybrid"
  | "cloud"
  | "vendor";

export interface CyberAssetRecord {
  systemId: string;
  assetId: string;
  assetName: string;
  sector: string;
  environment: InfrastructureEnvironment;
  assetType: string;
  serviceRole: string;
  criticality: "low" | "medium" | "high";
  owner: string;
  remoteAccess: boolean;
  inventoryStatus: "current" | "review_required" | "unknown";
}

export interface CyberResilienceKPI {
  systemId: string;
  sector: string;
  serviceRole: string;
  exposure: number;
  vulnerability: number;
  controlEffectiveness: number;
  assetVisibility: number;
  identityGovernance: number;
  detectionCapability: number;
  containmentReadiness: number;
  recoveryReadiness: number;
  continuityReadiness: number;
  governanceReadiness: number;
  highCriticality: boolean;
}

export function rawExposure(kpi: CyberResilienceKPI): number {
  return kpi.exposure * kpi.vulnerability;
}

export function residualExposure(kpi: CyberResilienceKPI): number {
  return rawExposure(kpi) * (1 - kpi.controlEffectiveness);
}

export function resilienceQuality(kpi: CyberResilienceKPI): number {
  return (
    0.14 * kpi.assetVisibility +
    0.14 * kpi.identityGovernance +
    0.15 * kpi.controlEffectiveness +
    0.14 * kpi.detectionCapability +
    0.13 * kpi.containmentReadiness +
    0.15 * kpi.recoveryReadiness +
    0.15 * kpi.governanceReadiness
  );
}

export function requiresReview(kpi: CyberResilienceKPI): boolean {
  return (
    (kpi.highCriticality && kpi.continuityReadiness < 0.65) ||
    (kpi.highCriticality && kpi.recoveryReadiness < 0.65) ||
    kpi.identityGovernance < 0.65 ||
    kpi.detectionCapability < 0.65 ||
    residualExposure(kpi) > 0.30 ||
    resilienceQuality(kpi) < 0.70
  );
}
