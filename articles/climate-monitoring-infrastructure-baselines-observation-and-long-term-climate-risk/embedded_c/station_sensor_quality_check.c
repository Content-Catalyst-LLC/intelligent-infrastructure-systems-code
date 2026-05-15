#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float temperature_c;
    float relative_humidity_pct;
    float battery_voltage;
    bool calibration_current;
} ClimateSensorFrame;

bool sensor_frame_in_range(ClimateSensorFrame frame) {
    bool temp_ok = frame.temperature_c >= -80.0f && frame.temperature_c <= 60.0f;
    bool humidity_ok = frame.relative_humidity_pct >= 0.0f && frame.relative_humidity_pct <= 100.0f;
    bool battery_ok = frame.battery_voltage >= 3.2f;
    return temp_ok && humidity_ok && battery_ok && frame.calibration_current;
}

int main(void) {
    ClimateSensorFrame frame = {
        .temperature_c = 42.1f,
        .relative_humidity_pct = 55.0f,
        .battery_voltage = 3.7f,
        .calibration_current = true
    };

    bool ok = sensor_frame_in_range(frame);
    printf("sensor_quality_ok=%s\n", ok ? "true" : "false");
    return ok ? 0 : 1;
}
