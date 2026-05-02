type InfrastructureSummary = {
  sector: string;
  assets: number;
  validTelemetryRate: number;
  resilienceIndex: number;
};

const summaries: InfrastructureSummary[] = [
  { sector: "water", assets: 12, validTelemetryRate: 0.91, resilienceIndex: 0.64 },
  { sector: "energy", assets: 9, validTelemetryRate: 0.96, resilienceIndex: 0.76 },
  { sector: "transportation", assets: 15, validTelemetryRate: 0.88, resilienceIndex: 0.58 },
];

for (const summary of summaries) {
  console.log(
    `${summary.sector}: assets=${summary.assets}, telemetry=${summary.validTelemetryRate}, resilience=${summary.resilienceIndex}`
  );
}
