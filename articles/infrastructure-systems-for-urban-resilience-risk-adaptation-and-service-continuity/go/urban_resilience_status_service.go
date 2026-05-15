package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type UrbanResilienceStatus struct {
	Article                string  `json:"article"`
	Series                 string  `json:"series"`
	Status                 string  `json:"status"`
	Warning                string  `json:"warning"`
	ServiceID              string  `json:"service_id"`
	ServiceDomain          string  `json:"service_domain"`
	ServiceContinuityScore float64 `json:"service_continuity_score"`
	RecoveryLagHours      float64 `json:"recovery_lag_hours"`
	EquityGapScore         float64 `json:"equity_gap_score"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := UrbanResilienceStatus{
		Article:                "Infrastructure Systems for Urban Resilience",
		Series:                 "Intelligent Infrastructure Systems",
		Status:                 "scaffold",
		Warning:                "Illustrative service only; not an official emergency-management or infrastructure operations system.",
		ServiceID:              "SVC-DRN-001",
		ServiceDomain:          "drainage",
		ServiceContinuityScore: 0.58,
		RecoveryLagHours:      8.0,
		EquityGapScore:         0.42,
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(status); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func main() {
	http.HandleFunc("/urban-resilience-status", statusHandler)
	fmt.Println("Serving urban resilience status scaffold at http://localhost:8080/urban-resilience-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
