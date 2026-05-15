package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type SmartGridStatus struct {
	Article                   string  `json:"article"`
	Series                    string  `json:"series"`
	Warning                   string  `json:"warning"`
	AssetID                   string  `json:"asset_id"`
	ServiceZoneID             string  `json:"service_zone_id"`
	GridObservabilityScore    float64 `json:"grid_observability_score"`
	VoltageAdequacyScore      float64 `json:"voltage_adequacy_score"`
	FlexibilityAdequacyScore  float64 `json:"flexibility_adequacy_score"`
	BalancingPressureScore    float64 `json:"balancing_pressure_score"`
	GridResilienceScore       float64 `json:"grid_resilience_score"`
	CyberPhysicalRiskScore    float64 `json:"cyber_physical_risk_score"`
	ReviewRequired            bool    `json:"review_required"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := SmartGridStatus{
		Article:                  "Smart Energy Grids and Digital Power Systems",
		Series:                   "Intelligent Infrastructure Systems",
		Warning:                  "Illustrative service only; not certified for grid operations, protection engineering, reliability compliance, or public safety.",
		AssetID:                  "SG-TRF-001",
		ServiceZoneID:            "SZ-EAST-D",
		GridObservabilityScore:   0.672,
		VoltageAdequacyScore:     0.000,
		FlexibilityAdequacyScore: 0.533,
		BalancingPressureScore:   0.480,
		GridResilienceScore:      0.501,
		CyberPhysicalRiskScore:   0.500,
		ReviewRequired:           true,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(status)
}

func main() {
	http.HandleFunc("/smart-grid-status", statusHandler)
	fmt.Println("Serving smart grid status scaffold at http://localhost:8080/smart-grid-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
