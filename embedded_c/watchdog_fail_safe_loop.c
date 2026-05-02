#include <stdio.h>
#include <stdbool.h>

void refresh_watchdog(void) {
    printf("Watchdog refreshed.\n");
}

void enter_fail_safe_state(void) {
    printf("Entering fail-safe state.\n");
}

int main(void) {
    bool sensor_ok = true;
    bool communication_ok = true;

    if (!sensor_ok || !communication_ok) {
        enter_fail_safe_state();
        return 1;
    }

    refresh_watchdog();
    return 0;
}
