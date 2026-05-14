package main

import "fmt"

func classify(governanceQuality float64, governanceRisk float64, maintenanceBacklog float64, accountabilityQuality float64) string {
	if governanceQuality < 0.60 || governanceRisk > 0.25 {
		return "escalate"
	}
	if maintenanceBacklog > 0 || accountabilityQuality < 0.65 {
		return "review_required"
	}
	return "ready_with_monitoring"
}

func main() {
	status := classify(0.67, 0.19, 5.0, 0.67)
	fmt.Printf("Infrastructure governance readiness status: %s\n", status)
}
