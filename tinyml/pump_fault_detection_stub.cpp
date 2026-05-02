#include <stdio.h>

float pump_fault_score(float vibration, float temperature, float pressure_delta) {
    return 0.45f * vibration + 0.25f * temperature + 0.30f * pressure_delta;
}

int main(void) {
    float score = pump_fault_score(0.7f, 0.4f, 0.6f);
    printf("Pump fault score: %0.3f\n", score);
    return 0;
}
