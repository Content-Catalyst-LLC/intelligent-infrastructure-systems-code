#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float value;
    float battery_voltage;
    bool calibration_current;
    bool telemetry_current;
} EnvironmentalSensorFrame;

typedef struct {
    float min_value;
    float max_value;
    float review_threshold;
    float min_battery_voltage;
} EnvironmentalSensorPolicy;

bool sensor_frame_valid(EnvironmentalSensorFrame frame, EnvironmentalSensorPolicy policy) {
    bool range_ok = frame.value >= policy.min_value && frame.value <= policy.max_value;
    bool battery_ok = frame.battery_voltage >= policy.min_battery_voltage;
    return range_ok && battery_ok && frame.calibration_current && frame.telemetry_current;
}

bool threshold_review_required(EnvironmentalSensorFrame frame, EnvironmentalSensorPolicy policy) {
    return frame.value >= policy.review_threshold;
}

int main(void) {
    EnvironmentalSensorFrame frame = {
        .value = 36.2f,
        .battery_voltage = 3.7f,
        .calibration_current = true,
        .telemetry_current = true
    };

    EnvironmentalSensorPolicy pm25_policy = {
        .min_value = 0.0f,
        .max_value = 1000.0f,
        .review_threshold = 35.0f,
        .min_battery_voltage = 3.2f
    };

    printf("sensor_frame_valid=%s\n", sensor_frame_valid(frame, pm25_policy) ? "true" : "false");
    printf("threshold_review_required=%s\n", threshold_review_required(frame, pm25_policy) ? "true" : "false");

    return 0;
}
