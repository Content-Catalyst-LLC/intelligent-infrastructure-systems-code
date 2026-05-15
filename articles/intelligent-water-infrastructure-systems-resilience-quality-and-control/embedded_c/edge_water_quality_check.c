#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float pressure_psi;
    float turbidity_ntu;
    float chlorine_mg_l;
    float ph;
    unsigned int latency_seconds;
    float battery_voltage;
    bool telemetry_current;
    bool fallback_available;
} WaterTelemetryFrame;

typedef struct {
    float min_pressure_psi;
    float max_turbidity_ntu;
    float min_chlorine_mg_l;
    float max_chlorine_mg_l;
    float min_ph;
    float max_ph;
    unsigned int max_latency_seconds;
    float min_battery_voltage;
} WaterTelemetryPolicy;

bool water_frame_valid(WaterTelemetryFrame frame, WaterTelemetryPolicy policy) {
    bool pressure_ok = frame.pressure_psi >= policy.min_pressure_psi;
    bool turbidity_ok = frame.turbidity_ntu <= policy.max_turbidity_ntu;
    bool chlorine_ok = frame.chlorine_mg_l >= policy.min_chlorine_mg_l &&
                       frame.chlorine_mg_l <= policy.max_chlorine_mg_l;
    bool ph_ok = frame.ph >= policy.min_ph && frame.ph <= policy.max_ph;
    bool latency_ok = frame.latency_seconds <= policy.max_latency_seconds;
    bool battery_ok = frame.battery_voltage >= policy.min_battery_voltage;
    return pressure_ok && turbidity_ok && chlorine_ok && ph_ok && latency_ok && battery_ok && frame.telemetry_current;
}

bool water_review_required(WaterTelemetryFrame frame, WaterTelemetryPolicy policy) {
    return !water_frame_valid(frame, policy) || !frame.fallback_available;
}

int main(void) {
    WaterTelemetryFrame frame = {34.0f, 0.9f, 0.5f, 7.1f, 88, 3.7f, true, false};
    WaterTelemetryPolicy policy = {35.0f, 1.0f, 0.6f, 4.0f, 6.5f, 8.5f, 120, 3.2f};

    printf("water_frame_valid=%s\n", water_frame_valid(frame, policy) ? "true" : "false");
    printf("water_review_required=%s\n", water_review_required(frame, policy) ? "true" : "false");
    return 0;
}
