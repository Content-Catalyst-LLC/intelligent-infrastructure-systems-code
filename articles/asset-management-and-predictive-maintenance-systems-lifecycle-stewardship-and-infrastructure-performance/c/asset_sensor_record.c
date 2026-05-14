#include <stdio.h>
#include <stdbool.h>

typedef struct {
    const char *telemetry_id;
    const char *asset_id;
    const char *signal_type;
    double value;
    const char *unit;
    const char *qc_flag;
} AssetTelemetryRecord;

bool requires_review(AssetTelemetryRecord record) {
    return record.qc_flag[0] != 'p';
}

int main(void) {
    AssetTelemetryRecord record = {
        .telemetry_id = "TEL-001",
        .asset_id = "A-0001",
        .signal_type = "vibration_rms",
        .value = 6.2,
        .unit = "mm_s",
        .qc_flag = "pass"
    };

    printf("telemetry=%s asset=%s signal=%s value=%.2f unit=%s review=%s\n",
           record.telemetry_id,
           record.asset_id,
           record.signal_type,
           record.value,
           record.unit,
           requires_review(record) ? "true" : "false");

    return 0;
}
