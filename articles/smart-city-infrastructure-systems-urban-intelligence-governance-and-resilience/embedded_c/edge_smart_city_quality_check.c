#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float observed_service_capacity;
    float normal_service_capacity;
    unsigned int latency_seconds;
    float battery_voltage;
    bool telemetry_current;
    bool fallback_available;
} SmartCityFrame;

typedef struct {
    float min_service_continuity;
    unsigned int max_latency_seconds;
    float min_battery_voltage;
} SmartCityPolicy;

float service_continuity(SmartCityFrame frame) {
    if (frame.normal_service_capacity <= 0.0f) return 0.0f;
    float score = frame.observed_service_capacity / frame.normal_service_capacity;
    if (score < 0.0f) return 0.0f;
    if (score > 1.0f) return 1.0f;
    return score;
}

bool smart_city_frame_valid(SmartCityFrame frame, SmartCityPolicy policy) {
    bool capacity_ok = frame.observed_service_capacity >= 0.0f && frame.normal_service_capacity > 0.0f;
    bool latency_ok = frame.latency_seconds <= policy.max_latency_seconds;
    bool battery_ok = frame.battery_voltage >= policy.min_battery_voltage;
    return capacity_ok && latency_ok && battery_ok && frame.telemetry_current;
}

bool review_required(SmartCityFrame frame, SmartCityPolicy policy) {
    return service_continuity(frame) < policy.min_service_continuity || !frame.fallback_available;
}

int main(void) {
    SmartCityFrame frame = {0.58f, 1.00f, 55, 3.7f, true, false};
    SmartCityPolicy policy = {0.75f, 120, 3.2f};

    printf("frame_valid=%s\n", smart_city_frame_valid(frame, policy) ? "true" : "false");
    printf("service_continuity=%.3f\n", service_continuity(frame));
    printf("review_required=%s\n", review_required(frame, policy) ? "true" : "false");
    return 0;
}
