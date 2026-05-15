#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float measured_state;
    float min_valid_state;
    float max_valid_state;
    float requested_command;
    float min_allowed_command;
    float max_allowed_command;
    unsigned int latency_seconds;
    bool telemetry_current;
    bool operator_acknowledged;
    bool manual_override_available;
    bool fallback_available;
    bool safe_state_available;
} EdgeControlFrame;

typedef struct {
    unsigned int max_latency_seconds;
    bool require_operator_ack;
    bool require_fallback;
} EdgeControlPolicy;

bool measurement_valid(EdgeControlFrame frame) {
    return frame.measured_state >= frame.min_valid_state &&
           frame.measured_state <= frame.max_valid_state;
}

bool command_within_bounds(EdgeControlFrame frame) {
    return frame.requested_command >= frame.min_allowed_command &&
           frame.requested_command <= frame.max_allowed_command;
}

bool edge_control_permitted(EdgeControlFrame frame, EdgeControlPolicy policy) {
    bool latency_ok = frame.latency_seconds <= policy.max_latency_seconds;
    bool ack_ok = !policy.require_operator_ack || frame.operator_acknowledged;
    bool fallback_ok = !policy.require_fallback || frame.fallback_available;
    return measurement_valid(frame) &&
           command_within_bounds(frame) &&
           latency_ok &&
           frame.telemetry_current &&
           ack_ok &&
           fallback_ok &&
           frame.manual_override_available &&
           frame.safe_state_available;
}

bool cyber_physical_review_required(EdgeControlFrame frame, EdgeControlPolicy policy) {
    return !edge_control_permitted(frame, policy);
}

int main(void) {
    EdgeControlFrame frame = {6.5f, 0.0f, 5.0f, 1.0f, 0.0f, 2.0f, 25, true, true, true, false, true};
    EdgeControlPolicy policy = {120, true, true};

    printf("measurement_valid=%s\n", measurement_valid(frame) ? "true" : "false");
    printf("command_within_bounds=%s\n", command_within_bounds(frame) ? "true" : "false");
    printf("edge_control_permitted=%s\n", edge_control_permitted(frame, policy) ? "true" : "false");
    printf("cyber_physical_review_required=%s\n", cyber_physical_review_required(frame, policy) ? "true" : "false");
    return 0;
}
