package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type SmartCityStatus struct {
	Article                  string  `json:"article"`
	Series                   string  `json:"series"`
	Warning                  string  `json:"warning"`
	InfrastructureID          string  `json:"infrastructure_id"`
	Domain                   string  `json:"domain"`
	ServiceContinuityScore    float64 `json:"service_continuity_score"`
	DomainObservabilityScore float64 `json:"domain_observability_score"`
	PublicValueScore          float64 `json:"public_value_score"`
	DigitalAccessGapScore     float64 `json:"digital_access_gap_score"`
	PrivacyRiskScore          float64 `json:"privacy_risk_score"`
	ReviewRequired            bool    `json:"review_required"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := SmartCityStatus{
		Article:                  "Smart City Infrastructure Systems",
		Series:                   "Intelligent Infrastructure Systems",
		Warning:                  "Illustrative service only; not a certified municipal operations or public safety system.",
		InfrastructureID:          "SCI-STM-001",
		Domain:                   "stormwater",
		ServiceContinuityScore:    0.58,
		DomainObservabilityScore: 0.66,
		PublicValueScore:          0.59,
		DigitalAccessGapScore:     0.42,
		PrivacyRiskScore:          0.34,
		ReviewRequired:            true,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(status)
}

func main() {
	http.HandleFunc("/smart-city-status", statusHandler)
	fmt.Println("Serving smart city status scaffold at http://localhost:8080/smart-city-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
