package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

type AdaptationStatus struct {
	Article     string `json:"article"`
	Series      string `json:"series"`
	Status      string `json:"status"`
	Warning     string `json:"warning"`
	ReviewFocus string `json:"review_focus"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := AdaptationStatus{
		Article:     "Infrastructure Systems for Climate Adaptation",
		Series:      "Intelligent Infrastructure Systems",
		Status:      "scaffold",
		Warning:     "Illustrative service only; not a live infrastructure risk system.",
		ReviewFocus: "residual risk, implementation readiness, maladaptation, equity, governance",
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(status)
}

func main() {
	http.HandleFunc("/adaptation-status", statusHandler)
	fmt.Println("Serving adaptation status scaffold at http://localhost:8080/adaptation-status")
	http.ListenAndServe(":8080", nil)
}
