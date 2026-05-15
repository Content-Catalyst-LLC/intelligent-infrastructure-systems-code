#include <stdbool.h>
#include <stdio.h>

typedef struct {
    unsigned int latency_ms;
    float packet_loss_percent;
    float link_quality_score;
    float battery_voltage;
    bool upstream_reachable;
    bool local_cache_available;
    bool fallback_route_available;
    bool identity_service_reachable;
    bool command_channel_secure;
} EdgeServiceFrame;

typedef struct {
    unsigned int max_latency_ms;
    float max_packet_loss_percent;
    float min_link_quality_score;
    float min_battery_voltage;
} EdgeServicePolicy;

bool edge_service_healthy(EdgeServiceFrame frame, EdgeServicePolicy policy) {
    return frame.latency_ms <= policy.max_latency_ms &&
           frame.packet_loss_percent <= policy.max_packet_loss_percent &&
           frame.link_quality_score >= policy.min_link_quality_score &&
           frame.battery_voltage >= policy.min_battery_voltage &&
           frame.upstream_reachable &&
           frame.local_cache_available &&
           frame.fallback_route_available &&
           frame.identity_service_reachable &&
           frame.command_channel_secure;
}

bool degraded_mode_required(EdgeServiceFrame frame, EdgeServicePolicy policy) {
    return !edge_service_healthy(frame, policy);
}

int main(void) {
    EdgeServiceFrame frame = {180, 4.5f, 0.68f, 3.7f, true, true, false, true, true};
    EdgeServicePolicy policy = {250, 5.0f, 0.70f, 3.2f};

    printf("edge_service_healthy=%s\n", edge_service_healthy(frame, policy) ? "true" : "false");
    printf("degraded_mode_required=%s\n", degraded_mode_required(frame, policy) ? "true" : "false");
    return 0;
}
