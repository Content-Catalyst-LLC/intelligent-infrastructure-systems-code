export type EarlyWarningRecord = {
  hazardId: string;
  warningZoneId: string;
  communityName: string;
  hazardType: string;
  usefulLeadTimeMinutes: number;
  protectiveWarningProbability: number;
  residualWarningRisk: number;
  accessibilityGap: number;
};

export function classifyWarningRecord(record: EarlyWarningRecord): string {
  if (record.usefulLeadTimeMinutes < 20) return "low useful lead time";
  if (record.residualWarningRisk >= 0.25) return "high residual warning risk";
  if (record.accessibilityGap >= 0.35) return "accessibility review required";
  if (record.protectiveWarningProbability < 0.35) return "protective-action gap";
  return "monitor";
}
