export type EnvironmentalMonitoringRecord = {
  siteId: string;
  siteName: string;
  domain: string;
  variable: string;
  value: number;
  thresholdValue: number;
  monitoringQualityScore: number;
  coverageGapScore: number;
  environmentalRiskScore: number;
  calibrationStatus: "current" | "expired" | "review_required";
};

export function classifyMonitoringRecord(record: EnvironmentalMonitoringRecord): string {
  if (record.value >= record.thresholdValue) return "threshold exceeded";
  if (record.monitoringQualityScore < 0.75) return "monitoring quality review required";
  if (record.coverageGapScore >= 0.35) return "coverage gap review required";
  if (record.environmentalRiskScore >= 0.25) return "environmental risk review required";
  if (record.calibrationStatus !== "current") return "calibration review required";
  return "monitor";
}
