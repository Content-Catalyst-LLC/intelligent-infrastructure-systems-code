#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float voltage_pu;
    float temperature_c;
    float loading_percent;
    unsigned int latency_seconds;
    float battery_voltage;
    bool telemetry_current;
    bool fallback_available;
} EnergyTelemetryFrame;

typedef struct {
    float min_voltage_pu;
    float max_voltage_pu;
    float max_temperature_c;
    float max_loading_percent;
    unsigned int max_latency_seconds;
    float min_battery_voltage;
} EnergyTelemetryPolicy;

bool energy_frame_valid(EnergyTelemetryFrame frame, EnergyTelemetryPolicy policy) {
    bool voltage_ok = frame.voltage_pu >= policy.min_voltage_pu && frame.voltage_pu <= policy.max_voltage_pu;
    bool thermal_ok = frame.temperature_c <= policy.max_temperature_c;
    bool loading_ok = frame.loading_percent <= policy.max_loading_percent;
    bool latency_ok = frame.latency_seconds <= policy.max_latency_seconds;
    bool battery_ok = frame.battery_voltage >= policy.min_battery_voltage;
    return voltage_ok && thermal_ok && loading_ok && latency_ok && battery_ok && frame.telemetry_current;
}

bool energy_review_required(EnergyTelemetryFrame frame, EnergyTelemetryPolicy policy) {
    return !energy_frame_valid(frame, policy) || !frame.fallback_available;
}

int main(void) {
    EnergyTelemetryFrame frame = {0.95f, 71.0f, 0.96f, 63, 3.7f, true, false};
    EnergyTelemetryPolicy policy = {0.95f, 1.05f, 70.0f, 0.95f, 120, 3.2f};

    printf("energy_frame_valid=%s\n", energy_frame_valid(frame, policy) ? "true" : "false");
    printf("energy_review_required=%s\n", energy_review_required(frame, policy) ? "true" : "false");
    return 0;
}
