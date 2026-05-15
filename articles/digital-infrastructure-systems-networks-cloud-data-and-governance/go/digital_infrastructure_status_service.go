package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type DigitalInfrastructureStatus struct {
	Article                  string  `json:"article"`
	Series                   string  `json:"series"`
	Warning                  string  `json:"warning"`
	ServiceZoneID            string  `json:"service_zone_id"`
	RegionName              string  `json:"region_name"`
	DigitalAccessScore       float64 `json:"digital_access_score"`
	NetworkCapacityScore     float64 `json:"network_capacity_score"`
	ComputeStorageScore      float64 `json:"compute_storage_score"`
	InteroperabilityScore    float64 `json:"interoperability_score"`
	TrustSecurityScore       float64 `json:"trust_security_score"`
	VendorDependencyScore    float64 `json:"vendor_dependency_score"`
	DigitalResilienceScore   float64 `json:"digital_resilience_score"`
	ExclusionRiskScore       float64 `json:"exclusion_risk_score"`
	ReviewRequired           bool    `json:"review_required"`
}

func statusHandler(w http.ResponseWriter, r *http.Request) {
	status := DigitalInfrastructureStatus{
		Article:                "Digital Infrastructure Systems",
		Series:                 "Intelligent Infrastructure Systems",
		Warning:                "Illustrative service only; not certified for public infrastructure operations, network engineering, cybersecurity assurance, or procurement decisions.",
		ServiceZoneID:          "DIGI-RURAL-EDGE",
		RegionName:            "Rural Edge",
		DigitalAccessScore:     0.646,
		NetworkCapacityScore:   0.595,
		ComputeStorageScore:    0.533,
		InteroperabilityScore:  0.444,
		TrustSecurityScore:     0.544,
		VendorDependencyScore:  0.833,
		DigitalResilienceScore: 0.340,
		ExclusionRiskScore:     0.520,
		ReviewRequired:         true,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(status)
}

func main() {
	http.HandleFunc("/digital-infrastructure-status", statusHandler)
	fmt.Println("Serving digital infrastructure status scaffold at http://localhost:8080/digital-infrastructure-status")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
