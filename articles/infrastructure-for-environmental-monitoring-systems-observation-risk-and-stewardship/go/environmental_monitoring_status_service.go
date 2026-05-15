package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type MonitoringStatus struct {
	Article                string  `json:"article"`
	Series                 string  `json:"series"`
	Status                 string  `json:"status"`
	Warning                string  `json:"warning"`
	SiteID                 string  `json:"site_id"`
	Domain                 string  `json:"domain"`
	Variable               string  `json:"variable"`
	MonitoringQualityScore float64 `json:"monitoring_quality_score"`
	ThresholdExceeded      bool    `json:"threshold_exceeded"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := MonitoringStatus{
		Article:                "Infrastructure for Environmental Monitoring Systems",
		Series:                 "Intelligent Infrastructure Systems",
		Status:                 "scaffold",
		Warning:                "Illustrative service only; not a certified environmental monitoring system.",
		SiteID:                 "ENV-AIR-002",
		Domain:                 "air_quality",
		Variable:               "no2",
		MonitoringQualityScore: 0.684,
		ThresholdExceeded:      true,
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(status); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func main() {
	http.HandleFunc("/environmental-monitoring-status", statusHandler)
	fmt.Println("Serving environmental monitoring status scaffold at http://localhost:8080/environmental-monitoring-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
