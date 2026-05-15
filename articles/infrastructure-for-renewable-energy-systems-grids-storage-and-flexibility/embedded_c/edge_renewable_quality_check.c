#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float voltage_pu;
    float generation_mw;
    float forecast_generation_mw;
    float inverter_temperature_c;
    unsigned int latency_seconds;
    float battery_voltage;
    bool telemetry_current;
    bool fallback_available;
} RenewableTelemetryFrame;

typedef struct {
    float min_voltage_pu;
    float max_voltage_pu;
    float max_inverter_temperature_c;
    unsigned int max_latency_seconds;
    float min_battery_voltage;
} RenewableTelemetryPolicy;

float absolute_float(float x) {
    return x < 0.0f ? -x : x;
}

bool renewable_frame_valid(RenewableTelemetryFrame frame, RenewableTelemetryPolicy policy) {
    bool voltage_ok = frame.voltage_pu >= policy.min_voltage_pu && frame.voltage_pu <= policy.max_voltage_pu;
    bool thermal_ok = frame.inverter_temperature_c <= policy.max_inverter_temperature_c;
    bool latency_ok = frame.latency_seconds <= policy.max_latency_seconds;
    bool battery_ok = frame.battery_voltage >= policy.min_battery_voltage;
    bool generation_ok = frame.generation_mw >= 0.0f && frame.forecast_generation_mw >= 0.0f;
    return voltage_ok && thermal_ok && latency_ok && battery_ok && generation_ok && frame.telemetry_current;
}

bool renewable_review_required(RenewableTelemetryFrame frame, RenewableTelemetryPolicy policy) {
    float forecast_error = absolute_float(frame.forecast_generation_mw - frame.generation_mw);
    bool high_forecast_error = frame.forecast_generation_mw > 0.0f && (forecast_error / frame.forecast_generation_mw) > 0.25f;
    return !renewable_frame_valid(frame, policy) || !frame.fallback_available || high_forecast_error;
}

int main(void) {
    RenewableTelemetryFrame frame = {0.96f, 118.0f, 135.0f, 58.0f, 65, 3.7f, true, false};
    RenewableTelemetryPolicy policy = {0.95f, 1.05f, 70.0f, 120, 3.2f};

    printf("renewable_frame_valid=%s\n", renewable_frame_valid(frame, policy) ? "true" : "false");
    printf("renewable_review_required=%s\n", renewable_review_required(frame, policy) ? "true" : "false");
    return 0;
}
