#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float value;
    float battery_voltage;
    unsigned int latency_seconds;
    bool calibration_current;
    bool telemetry_current;
} UrbanSensorFrame;

typedef struct {
    float min_value;
    float max_value;
    float review_threshold;
    float min_battery_voltage;
    unsigned int max_latency_seconds;
} UrbanSensorPolicy;

bool sensor_frame_valid(UrbanSensorFrame frame, UrbanSensorPolicy policy) {
    bool range_ok = frame.value >= policy.min_value && frame.value <= policy.max_value;
    bool battery_ok = frame.battery_voltage >= policy.min_battery_voltage;
    bool latency_ok = frame.latency_seconds <= policy.max_latency_seconds;
    return range_ok && battery_ok && latency_ok && frame.calibration_current && frame.telemetry_current;
}

int main(void) {
    UrbanSensorFrame frame = {36.8f, 3.7f, 44, true, true};
    UrbanSensorPolicy policy = {0.0f, 1000.0f, 35.0f, 3.2f, 300};

    printf("sensor_frame_valid=%s\n", sensor_frame_valid(frame, policy) ? "true" : "false");
    printf("threshold_review_required=%s\n", frame.value >= policy.review_threshold ? "true" : "false");
    return 0;
}
