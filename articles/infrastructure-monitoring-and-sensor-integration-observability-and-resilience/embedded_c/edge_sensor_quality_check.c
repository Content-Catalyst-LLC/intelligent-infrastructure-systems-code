#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float measurement_value;
    float min_valid;
    float max_valid;
    unsigned int latency_seconds;
    float battery_voltage;
    bool has_sensor_id;
    bool has_asset_id;
    bool has_unit;
    bool has_timestamp_source;
    bool has_quality_flag;
    bool telemetry_current;
    bool fallback_available;
} SensorTelemetryFrame;

typedef struct {
    unsigned int max_latency_seconds;
    float min_battery_voltage;
    unsigned int minimum_required_metadata_fields;
} SensorTelemetryPolicy;

unsigned int metadata_count(SensorTelemetryFrame frame) {
    return frame.has_sensor_id +
           frame.has_asset_id +
           frame.has_unit +
           frame.has_timestamp_source +
           frame.has_quality_flag;
}

bool edge_sensor_frame_valid(SensorTelemetryFrame frame, SensorTelemetryPolicy policy) {
    bool measurement_ok = frame.measurement_value >= frame.min_valid && frame.measurement_value <= frame.max_valid;
    bool latency_ok = frame.latency_seconds <= policy.max_latency_seconds;
    bool battery_ok = frame.battery_voltage >= policy.min_battery_voltage;
    bool metadata_ok = metadata_count(frame) >= policy.minimum_required_metadata_fields;
    return measurement_ok && latency_ok && battery_ok && metadata_ok && frame.telemetry_current;
}

bool monitoring_review_required(SensorTelemetryFrame frame, SensorTelemetryPolicy policy) {
    return !edge_sensor_frame_valid(frame, policy) || !frame.fallback_available;
}

int main(void) {
    SensorTelemetryFrame frame = {6.5f, 0.0f, 5.0f, 25, 3.7f, true, true, true, true, true, true, false};
    SensorTelemetryPolicy policy = {120, 3.2f, 5};

    printf("metadata_count=%u\n", metadata_count(frame));
    printf("edge_sensor_frame_valid=%s\n", edge_sensor_frame_valid(frame, policy) ? "true" : "false");
    printf("monitoring_review_required=%s\n", monitoring_review_required(frame, policy) ? "true" : "false");
    return 0;
}
