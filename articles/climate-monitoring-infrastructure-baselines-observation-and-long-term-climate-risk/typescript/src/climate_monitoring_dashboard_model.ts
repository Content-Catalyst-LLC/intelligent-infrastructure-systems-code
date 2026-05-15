export type ClimateStationRecord = {
  stationId: string;
  stationName: string;
  domain: string;
  variable: string;
  recordCompleteness: number;
  metadataStatus: "complete" | "partial" | "missing" | "review_required";
  calibrationStatus: "current" | "expired" | "review_required";
  knownBreakpoint: boolean;
  meanAnomaly: number | null;
};

export function classifyStationRecord(record: ClimateStationRecord): string {
  if (record.recordCompleteness < 0.8) return "low record completeness";
  if (record.metadataStatus !== "complete") return "metadata review required";
  if (record.calibrationStatus !== "current") return "calibration review required";
  if (record.knownBreakpoint) return "homogeneity review required";
  return "monitor";
}
