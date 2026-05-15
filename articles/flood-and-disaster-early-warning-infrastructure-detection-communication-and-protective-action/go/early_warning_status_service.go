package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type EarlyWarningStatus struct {
	Article      string  `json:"article"`
	Series       string  `json:"series"`
	Status       string  `json:"status"`
	Warning      string  `json:"warning"`
	UsefulLead   float64 `json:"useful_lead_time_minutes"`
	ResidualRisk float64 `json:"residual_warning_risk"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := EarlyWarningStatus{
		Article:      "Flood and Disaster Early Warning Infrastructure",
		Series:       "Intelligent Infrastructure Systems",
		Status:       "scaffold",
		Warning:      "Illustrative service only; not a live public warning system.",
		UsefulLead:   17.0,
		ResidualRisk: 0.36,
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(status); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func main() {
	http.HandleFunc("/early-warning-status", statusHandler)
	fmt.Println("Serving early warning status scaffold at http://localhost:8080/early-warning-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
