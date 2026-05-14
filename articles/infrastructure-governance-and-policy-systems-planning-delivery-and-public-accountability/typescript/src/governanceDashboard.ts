type GovernanceRecord = {
  project_id: string;
  project_name: string;
  sector: string;
  governance_quality: number;
  governance_risk: number;
  maintenance_backlog_musd: number;
  accountability_quality: number;
};

export function classifyGovernance(record: GovernanceRecord): string {
  if (record.governance_quality < 0.6 || record.governance_risk > 0.25) {
    return "Escalate";
  }
  if (record.maintenance_backlog_musd > 0 || record.accountability_quality < 0.65) {
    return "Review required";
  }
  return "Ready with monitoring";
}

export function summarize(records: GovernanceRecord[]) {
  return records.map((record) => ({
    ...record,
    status_label: classifyGovernance(record),
  }));
}

const example: GovernanceRecord = {
  project_id: "GOV-TRN-001",
  project_name: "Regional Bus Rapid Transit Corridor",
  sector: "transport",
  governance_quality: 0.67,
  governance_risk: 0.19,
  maintenance_backlog_musd: 5,
  accountability_quality: 0.67,
};

console.log(summarize([example]));
