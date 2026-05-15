#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float observed_speed_kph;
    float target_min_speed_kph;
    unsigned int latency_seconds;
    bool telemetry_current;
    bool fallback_available;
} MobilityStatusFrame;

typedef struct {
    float minimum_speed_kph;
    unsigned int max_latency_seconds;
} MobilityPolicy;

bool mobility_frame_valid(MobilityStatusFrame frame, MobilityPolicy policy) {
    bool speed_ok = frame.observed_speed_kph >= 0.0f;
    bool latency_ok = frame.latency_seconds <= policy.max_latency_seconds;
    return speed_ok && latency_ok && frame.telemetry_current;
}

bool mobility_review_required(MobilityStatusFrame frame, MobilityPolicy policy) {
    return frame.observed_speed_kph < policy.minimum_speed_kph || !frame.fallback_available;
}

int main(void) {
    MobilityStatusFrame frame = {24.0f, 30.0f, 34, true, false};
    MobilityPolicy policy = {30.0f, 120};

    printf("mobility_frame_valid=%s\n", mobility_frame_valid(frame, policy) ? "true" : "false");
    printf("mobility_review_required=%s\n", mobility_review_required(frame, policy) ? "true" : "false");
    return 0;
}
