package main

import "fmt"

type ClimateSignal struct {
	AssetID   string
	Hazard    string
	Value     float64
	Threshold float64
	Service   string
}

func alert(signal ClimateSignal) string {
	if signal.Value >= signal.Threshold {
		return "review_required"
	}
	return "within_operating_range"
}

func main() {
	signal := ClimateSignal{
		AssetID:   "stormwater-pump-01",
		Hazard:    "extreme_rainfall",
		Value:     0.87,
		Threshold: 0.80,
		Service:   "urban drainage",
	}
	fmt.Printf("%s %s: %s\n", signal.AssetID, signal.Hazard, alert(signal))
}
