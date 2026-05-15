#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float rainfall_mm_per_hour;
    float river_stage_meters;
    float soil_saturation_index;
} SensorFrame;

typedef struct {
    float rainfall_threshold;
    float river_stage_threshold;
    float soil_saturation_threshold;
} WarningThresholds;

bool should_trigger_local_watch(SensorFrame frame, WarningThresholds thresholds) {
    bool rainfall_high = frame.rainfall_mm_per_hour >= thresholds.rainfall_threshold;
    bool river_high = frame.river_stage_meters >= thresholds.river_stage_threshold;
    bool soil_high = frame.soil_saturation_index >= thresholds.soil_saturation_threshold;

    return (rainfall_high && soil_high) || river_high;
}

int main(void) {
    SensorFrame frame = {
        .rainfall_mm_per_hour = 42.0f,
        .river_stage_meters = 3.1f,
        .soil_saturation_index = 0.82f
    };

    WarningThresholds thresholds = {
        .rainfall_threshold = 35.0f,
        .river_stage_threshold = 3.5f,
        .soil_saturation_threshold = 0.75f
    };

    bool trigger = should_trigger_local_watch(frame, thresholds);

    printf("edge_local_watch=%s\n", trigger ? "true" : "false");
    return trigger ? 0 : 1;
}
