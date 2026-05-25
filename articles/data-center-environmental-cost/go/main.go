package main

import "fmt"

func PUE(totalFacilityEnergyMWh float64, itEnergyMWh float64) float64 {
	if itEnergyMWh <= 0 {
		return 0
	}
	return totalFacilityEnergyMWh / itEnergyMWh
}

func WUELitersPerKWh(waterConsumptionM3 float64, itEnergyMWh float64) float64 {
	if itEnergyMWh <= 0 {
		return 0
	}
	return (waterConsumptionM3 * 1000.0) / (itEnergyMWh * 1000.0)
}

func EmissionsTCO2e(totalEnergyMWh float64, carbonIntensityKgCO2eMWh float64) float64 {
	return totalEnergyMWh * carbonIntensityKgCO2eMWh / 1000.0
}

func main() {
	facilityPUE := PUE(775000.0, 620000.0)
	facilityWUE := WUELitersPerKWh(510000.0, 620000.0)
	facilityEmissions := EmissionsTCO2e(775000.0, 390.0)

	fmt.Printf("PUE: %.3f\n", facilityPUE)
	fmt.Printf("WUE: %.3f L/kWh IT\n", facilityWUE)
	fmt.Printf("Operational emissions: %.2f tCO2e\n", facilityEmissions)
}
