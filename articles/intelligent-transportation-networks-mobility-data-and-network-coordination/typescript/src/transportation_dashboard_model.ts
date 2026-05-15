export type TransportationNetworkRecord = {
  networkElementId: string;
  mode: string;
  travelTimeReliability: number;
  accessibilityGapScore: number;
  safetyRiskScore: number;
  coordinationScore: number;
  incidentRecoveryLagMinutes: number;
  mobilityQualityScore: number;
};

export function classifyTransportationRecord(record: TransportationNetworkRecord): string {
  if (record.travelTimeReliability < 0.70) return "reliability review required";
  if (record.accessibilityGapScore >= 0.35) return "accessibility gap review required";
  if (record.safetyRiskScore >= 0.35) return "safety review required";
  if (record.incidentRecoveryLagMinutes > 0) return "incident recovery review required";
  if (record.coordinationScore < 0.65) return "coordination review required";
  return "monitor";
}
