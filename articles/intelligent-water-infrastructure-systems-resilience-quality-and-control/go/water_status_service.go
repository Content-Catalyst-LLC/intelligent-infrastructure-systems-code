package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type WaterStatus struct {
	Article                  string  `json:"article"`
	Series                   string  `json:"series"`
	Warning                  string  `json:"warning"`
	AssetID                  string  `json:"asset_id"`
	ServiceZoneID            string  `json:"service_zone_id"`
	QualityComplianceScore   float64 `json:"quality_compliance_score"`
	PressureAdequacyScore    float64 `json:"pressure_adequacy_score"`
	LeakageRate              float64 `json:"leakage_rate"`
	WaterObservabilityScore  float64 `json:"water_observability_score"`
	WaterResilienceScore     float64 `json:"water_resilience_score"`
	OverflowRiskScore        float64 `json:"overflow_risk_score"`
	ReviewRequired           bool    `json:"review_required"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := WaterStatus{
		Article:                 "Intelligent Water Infrastructure Systems",
		Series:                  "Intelligent Infrastructure Systems",
		Warning:                 "Illustrative service only; not certified for utility operations, water-quality compliance, or public-health action.",
		AssetID:                 "WAT-DST-001",
		ServiceZoneID:           "WZ-SOUTH-D",
		QualityComplianceScore:  0.943,
		PressureAdequacyScore:   0.000,
		LeakageRate:             0.256,
		WaterObservabilityScore: 0.704,
		WaterResilienceScore:    0.633,
		OverflowRiskScore:       0.360,
		ReviewRequired:          true,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(status)
}

func main() {
	http.HandleFunc("/water-status", statusHandler)
	fmt.Println("Serving water infrastructure status scaffold at http://localhost:8080/water-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
