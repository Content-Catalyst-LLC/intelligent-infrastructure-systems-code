export type DigitalInfrastructureRecord = {
  serviceZoneId: string;
  regionName: string;
  digitalAccessScore: number;
  networkCapacityScore: number;
  computeStorageScore: number;
  interoperabilityScore: number;
  trustSecurityScore: number;
  vendorDependencyScore: number;
  digitalResilienceScore: number;
  exclusionRiskScore: number;
};

export function classifyDigitalInfrastructureRecord(record: DigitalInfrastructureRecord): string {
  if (record.digitalAccessScore < 0.85) return "access review required";
  if (record.networkCapacityScore < 0.80) return "network capacity review required";
  if (record.computeStorageScore < 0.75) return "compute and storage review required";
  if (record.interoperabilityScore < 0.70) return "interoperability review required";
  if (record.trustSecurityScore < 0.75) return "trust and security review required";
  if (record.digitalResilienceScore < 0.75) return "resilience review required";
  if (record.vendorDependencyScore > 0.70) return "vendor dependency review required";
  if (record.exclusionRiskScore > 0.30) return "inclusion review required";
  return "monitor";
}
