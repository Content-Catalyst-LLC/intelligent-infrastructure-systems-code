#include <stdio.h>

double pue(double total_facility_energy_mwh, double it_energy_mwh) {
    if (it_energy_mwh <= 0.0) {
        return 0.0;
    }
    return total_facility_energy_mwh / it_energy_mwh;
}

double wue_l_per_kwh(double water_consumption_m3, double it_energy_mwh) {
    if (it_energy_mwh <= 0.0) {
        return 0.0;
    }
    return (water_consumption_m3 * 1000.0) / (it_energy_mwh * 1000.0);
}

double emissions_tco2e(double total_energy_mwh, double carbon_intensity_kgco2e_mwh) {
    return total_energy_mwh * carbon_intensity_kgco2e_mwh / 1000.0;
}

int main(void) {
    double facility_pue = pue(775000.0, 620000.0);
    double facility_wue = wue_l_per_kwh(510000.0, 620000.0);
    double facility_emissions = emissions_tco2e(775000.0, 390.0);

    printf("PUE: %.3f\n", facility_pue);
    printf("WUE: %.3f L/kWh IT\n", facility_wue);
    printf("Operational emissions: %.2f tCO2e\n", facility_emissions);

    return 0;
}
