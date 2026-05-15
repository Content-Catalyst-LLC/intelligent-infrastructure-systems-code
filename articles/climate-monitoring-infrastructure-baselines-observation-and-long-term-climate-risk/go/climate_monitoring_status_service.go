package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type ClimateMonitoringStatus struct {
	Article            string  `json:"article"`
	Series             string  `json:"series"`
	Status             string  `json:"status"`
	Warning            string  `json:"warning"`
	StationID          string  `json:"station_id"`
	RecordCompleteness float64 `json:"record_completeness"`
	MetadataStatus     string  `json:"metadata_status"`
	CalibrationStatus  string  `json:"calibration_status"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := ClimateMonitoringStatus{
		Article:            "Climate Monitoring Infrastructure",
		Series:             "Intelligent Infrastructure Systems",
		Status:             "scaffold",
		Warning:            "Illustrative service only; not an official climate monitoring service.",
		StationID:          "CLM-ATM-001",
		RecordCompleteness: 0.83,
		MetadataStatus:     "complete",
		CalibrationStatus:  "current",
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(status); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func main() {
	http.HandleFunc("/climate-monitoring-status", statusHandler)
	fmt.Println("Serving climate monitoring status scaffold at http://localhost:8080/climate-monitoring-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
