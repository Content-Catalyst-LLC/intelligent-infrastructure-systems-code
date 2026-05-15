export type AdaptationRecord = {
  systemId: string;
  assetName: string;
  sector: string;
  hazardType: string;
  residualRisk: number;
  implementationReadiness: number;
  equityPriority: number;
  maladaptationFlag: "current" | "review_required";
};

export function classifyAdaptationRecord(record: AdaptationRecord): string {
  if (record.maladaptationFlag === "review_required") return "maladaptation review required";
  if (record.residualRisk >= 0.25) return "high residual risk";
  if (record.implementationReadiness < 0.65) return "implementation gap";
  if (record.equityPriority >= 0.10) return "equity priority";
  return "monitor";
}
