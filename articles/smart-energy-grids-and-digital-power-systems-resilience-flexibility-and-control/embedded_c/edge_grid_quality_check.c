#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float voltage_pu;
    float frequency_hz;
    float loading_percent;
    unsigned int latency_seconds;
    float battery_voltage;
    bool telemetry_current;
    bool fallback_available;
} GridTelemetryFrame;

typedef struct {
    float min_voltage_pu;
    float max_voltage_pu;
    float min_frequency_hz;
    float max_frequency_hz;
    float max_loading_percent;
    unsigned int max_latency_seconds;
    float min_battery_voltage;
} GridTelemetryPolicy;

bool grid_frame_valid(GridTelemetryFrame frame, GridTelemetryPolicy policy) {
    bool voltage_ok = frame.voltage_pu >= policy.min_voltage_pu && frame.voltage_pu <= policy.max_voltage_pu;
    bool frequency_ok = frame.frequency_hz >= policy.min_frequency_hz && frame.frequency_hz <= policy.max_frequency_hz;
    bool loading_ok = frame.loading_percent <= policy.max_loading_percent;
    bool latency_ok = frame.latency_seconds <= policy.max_latency_seconds;
    bool battery_ok = frame.battery_voltage >= policy.min_battery_voltage;
    return voltage_ok && frequency_ok && loading_ok && latency_ok && battery_ok && frame.telemetry_current;
}

bool grid_review_required(GridTelemetryFrame frame, GridTelemetryPolicy policy) {
    return !grid_frame_valid(frame, policy) || !frame.fallback_available;
}

int main(void) {
    GridTelemetryFrame frame = {0.94f, 59.97f, 0.96f, 88, 3.7f, true, false};
    GridTelemetryPolicy policy = {0.95f, 1.05f, 59.95f, 60.05f, 0.95f, 120, 3.2f};

    printf("grid_frame_valid=%s\n", grid_frame_valid(frame, policy) ? "true" : "false");
    printf("grid_review_required=%s\n", grid_review_required(frame, policy) ? "true" : "false");
    return 0;
}
