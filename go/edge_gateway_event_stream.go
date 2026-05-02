package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"time"
)

type TelemetryEvent struct {
	AssetID           string  `json:"asset_id"`
	Sector            string  `json:"sector"`
	SensorType        string  `json:"sensor_type"`
	ObservedAt        string  `json:"observed_at"`
	ObservedValue     float64 `json:"observed_value"`
	BatteryVoltage    float64 `json:"battery_voltage"`
	SignalQuality     float64 `json:"signal_quality"`
	CommunicationMode string  `json:"communication_mode"`
}

func main() {
	event := TelemetryEvent{
		AssetID:           "PUMP-001",
		Sector:            "water",
		SensorType:        "vibration",
		ObservedAt:        time.Now().UTC().Format(time.RFC3339),
		ObservedValue:     rand.Float64() * 2,
		BatteryVoltage:    3.3 + rand.Float64()*0.8,
		SignalQuality:     0.7 + rand.Float64()*0.3,
		CommunicationMode: "lorawan",
	}

	payload, _ := json.MarshalIndent(event, "", "  ")
	fmt.Println(string(payload))
}
