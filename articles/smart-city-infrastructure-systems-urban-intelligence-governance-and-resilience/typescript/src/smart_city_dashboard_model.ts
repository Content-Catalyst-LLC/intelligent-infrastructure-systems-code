export type SmartCityInfrastructureRecord = {
  infrastructureId: string;
  domain: string;
  serviceContinuityScore: number;
  domainObservabilityScore: number;
  publicValueScore: number;
  dependencyStress: number;
  digitalAccessGapScore: number;
  privacyRiskScore: number;
};

export function classifySmartCityRecord(record: SmartCityInfrastructureRecord): string {
  if (record.serviceContinuityScore < 0.75) return "service continuity review required";
  if (record.domainObservabilityScore < 0.70) return "observability review required";
  if (record.publicValueScore < 0.65) return "public value review required";
  if (record.dependencyStress >= 0.30) return "dependency stress review required";
  if (record.digitalAccessGapScore >= 0.35) return "digital inclusion review required";
  if (record.privacyRiskScore >= 0.35) return "privacy and rights review required";
  return "monitor";
}
