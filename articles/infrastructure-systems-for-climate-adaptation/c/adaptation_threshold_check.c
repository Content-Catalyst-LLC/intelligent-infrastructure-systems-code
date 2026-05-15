#include <stdio.h>

typedef struct {
    const char *asset_id;
    double value;
    double threshold;
} ClimateSignal;

int normalized(double value) {
    return value >= 0.0 && value <= 1.0;
}

int review_required(ClimateSignal signal) {
    if (!normalized(signal.value) || !normalized(signal.threshold)) {
        return -1;
    }
    return signal.value >= signal.threshold;
}

int main(void) {
    ClimateSignal signal = {"stormwater-pump-01", 0.87, 0.80};
    int status = review_required(signal);
    if (status < 0) {
        printf("%s: invalid_signal\n", signal.asset_id);
        return 1;
    }
    printf("%s: %s\n", signal.asset_id, status ? "review_required" : "within_operating_range");
    return 0;
}
