package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type TransportationStatus struct {
	Article                    string  `json:"article"`
	Series                     string  `json:"series"`
	Warning                    string  `json:"warning"`
	NetworkElementID           string  `json:"network_element_id"`
	Mode                       string  `json:"mode"`
	TravelTimeReliability      float64 `json:"travel_time_reliability"`
	AccessibilityGapScore      float64 `json:"accessibility_gap_score"`
	SafetyRiskScore            float64 `json:"safety_risk_score"`
	IncidentRecoveryLagMinutes float64 `json:"incident_recovery_lag_minutes"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := TransportationStatus{
		Article:                    "Intelligent Transportation Networks",
		Series:                     "Intelligent Infrastructure Systems",
		Warning:                    "Illustrative service only; not a certified transport operations or public safety system.",
		NetworkElementID:           "NET-BUS-001",
		Mode:                       "public_transit",
		TravelTimeReliability:      0.618,
		AccessibilityGapScore:      0.32,
		SafetyRiskScore:            0.42,
		IncidentRecoveryLagMinutes: 15.0,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(status)
}

func main() {
	http.HandleFunc("/transportation-status", statusHandler)
	fmt.Println("Serving transportation status scaffold at http://localhost:8080/transportation-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
