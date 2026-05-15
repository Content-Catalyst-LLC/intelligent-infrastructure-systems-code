#include <stdbool.h>
#include <stdio.h>

typedef struct {
    float service_capacity_pct;
    float battery_voltage;
    bool telemetry_current;
    bool backup_power_available;
} ServiceStatusFrame;

typedef struct {
    float minimum_service_capacity_pct;
    float minimum_battery_voltage;
} ServiceStatusPolicy;

bool service_status_valid(ServiceStatusFrame frame, ServiceStatusPolicy policy) {
    bool capacity_ok = frame.service_capacity_pct >= 0.0f && frame.service_capacity_pct <= 100.0f;
    bool battery_ok = frame.battery_voltage >= policy.minimum_battery_voltage;
    return capacity_ok && battery_ok && frame.telemetry_current;
}

bool continuity_review_required(ServiceStatusFrame frame, ServiceStatusPolicy policy) {
    return frame.service_capacity_pct < policy.minimum_service_capacity_pct || !frame.backup_power_available;
}

int main(void) {
    ServiceStatusFrame frame = {
        .service_capacity_pct = 58.0f,
        .battery_voltage = 3.7f,
        .telemetry_current = true,
        .backup_power_available = false
    };

    ServiceStatusPolicy policy = {
        .minimum_service_capacity_pct = 75.0f,
        .minimum_battery_voltage = 3.2f
    };

    printf("service_status_valid=%s\n", service_status_valid(frame, policy) ? "true" : "false");
    printf("continuity_review_required=%s\n", continuity_review_required(frame, policy) ? "true" : "false");

    return 0;
}
