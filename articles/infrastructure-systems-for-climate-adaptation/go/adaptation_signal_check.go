package main

import (
	"errors"
	"fmt"
)

type ClimateSignal struct {
	AssetID   string
	Hazard    string
	Value     float64
	Threshold float64
	Service   string
}

func (s ClimateSignal) Validate() error {
	if s.AssetID == "" || s.Hazard == "" || s.Service == "" {
		return errors.New("asset, hazard, and service are required")
	}
	if s.Threshold < 0 || s.Threshold > 1 || s.Value < 0 || s.Value > 1 {
		return errors.New("value and threshold must be normalized between 0 and 1")
	}
	return nil
}

func Alert(signal ClimateSignal) (string, error) {
	if err := signal.Validate(); err != nil {
		return "invalid_signal", err
	}
	if signal.Value >= signal.Threshold {
		return "review_required", nil
	}
	return "within_operating_range", nil
}

func main() {
	signal := ClimateSignal{AssetID: "stormwater-pump-01", Hazard: "extreme_rainfall", Value: 0.87, Threshold: 0.80, Service: "urban drainage"}
	status, err := Alert(signal)
	if err != nil {
		panic(err)
	}
	fmt.Printf("%s %s: %s\n", signal.AssetID, signal.Hazard, status)
}
