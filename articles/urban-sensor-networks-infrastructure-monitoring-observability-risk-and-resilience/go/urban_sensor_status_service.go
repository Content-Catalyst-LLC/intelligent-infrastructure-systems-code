package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type UrbanSensorStatus struct {
	Article                 string  `json:"article"`
	Series                  string  `json:"series"`
	Warning                 string  `json:"warning"`
	SensorID                string  `json:"sensor_id"`
	Domain                  string  `json:"domain"`
	Variable                string  `json:"variable"`
	SensorQualityScore      float64 `json:"sensor_quality_score"`
	UrbanObservabilityScore float64 `json:"urban_observability_score"`
	ThresholdExceeded       bool    `json:"threshold_exceeded"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := UrbanSensorStatus{
		Article:                 "Urban Sensor Networks and Infrastructure Monitoring",
		Series:                  "Intelligent Infrastructure Systems",
		Warning:                 "Illustrative service only; not a certified operations or public safety system.",
		SensorID:                "USN-AIR-001",
		Domain:                  "environmental_exposure",
		Variable:                "pm25_ug_m3",
		SensorQualityScore:      0.72,
		UrbanObservabilityScore: 0.74,
		ThresholdExceeded:       true,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(status)
}

func main() {
	http.HandleFunc("/urban-sensor-status", statusHandler)
	fmt.Println("Serving urban sensor status scaffold at http://localhost:8080/urban-sensor-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
