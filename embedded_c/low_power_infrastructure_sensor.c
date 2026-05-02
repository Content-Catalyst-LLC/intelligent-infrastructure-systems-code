#include <stdio.h>
#include <stdbool.h>

#define WINDOW_SIZE 12
#define ANOMALY_THRESHOLD 8.0f
#define SCALE_FACTOR 1.01f
#define OFFSET_VALUE -0.15f

static float samples[WINDOW_SIZE];
static int sample_index = 0;
static bool buffer_full = false;

float read_raw_sensor_value(void) {
    static float synthetic_value = 40.0f;
    synthetic_value += 0.55f;
    return synthetic_value;
}

float apply_calibration(float raw_value) {
    return (SCALE_FACTOR * raw_value) + OFFSET_VALUE;
}

void add_sample(float value) {
    samples[sample_index] = value;
    sample_index++;

    if (sample_index >= WINDOW_SIZE) {
        sample_index = 0;
        buffer_full = true;
    }
}

float rolling_average(void) {
    int count = buffer_full ? WINDOW_SIZE : sample_index;

    if (count == 0) {
        return 0.0f;
    }

    float total = 0.0f;

    for (int i = 0; i < count; i++) {
        total += samples[i];
    }

    return total / count;
}

bool is_anomaly(float current_value, float average_value) {
    float difference = current_value - average_value;

    if (difference < 0.0f) {
        difference = -difference;
    }

    return difference > ANOMALY_THRESHOLD;
}

void trigger_local_alert(float value, float average) {
    printf("INFRASTRUCTURE ALERT: value=%0.2f rolling_average=%0.2f\n", value, average);
}

int main(void) {
    for (int cycle = 0; cycle < 40; cycle++) {
        float raw_value = read_raw_sensor_value();
        float calibrated_value = apply_calibration(raw_value);
        float average = rolling_average();

        if (buffer_full && is_anomaly(calibrated_value, average)) {
            trigger_local_alert(calibrated_value, average);
        }

        add_sample(calibrated_value);
    }

    return 0;
}
