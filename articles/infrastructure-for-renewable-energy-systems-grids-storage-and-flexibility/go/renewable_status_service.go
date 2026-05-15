package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type RenewableStatus struct {
	Article                       string  `json:"article"`
	Series                        string  `json:"series"`
	Warning                       string  `json:"warning"`
	AssetID                       string  `json:"asset_id"`
	Technology                    string  `json:"technology"`
	InterconnectionStatus         string  `json:"interconnection_status"`
	CurtailmentRate               float64 `json:"curtailment_rate"`
	FlexibilityAdequacyScore      float64 `json:"flexibility_adequacy_score"`
	GridConstraintScore           float64 `json:"grid_constraint_score"`
	RenewableInfrastructureScore  float64 `json:"renewable_infrastructure_score"`
	ReviewRequired                bool    `json:"review_required"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := RenewableStatus{
		Article:                      "Infrastructure for Renewable Energy Systems",
		Series:                       "Intelligent Infrastructure Systems",
		Warning:                      "Illustrative service only; not certified for power-system planning, grid operations, or public safety.",
		AssetID:                      "RE-WND-001",
		Technology:                   "onshore_wind",
		InterconnectionStatus:        "constrained",
		CurtailmentRate:              0.0,
		FlexibilityAdequacyScore:     0.654,
		GridConstraintScore:          0.278,
		RenewableInfrastructureScore: 0.693,
		ReviewRequired:               true,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(status)
}

func main() {
	http.HandleFunc("/renewable-status", statusHandler)
	fmt.Println("Serving renewable infrastructure status scaffold at http://localhost:8080/renewable-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
