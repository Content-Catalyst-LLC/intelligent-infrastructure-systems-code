#include <stdio.h>

typedef struct {
    const char *asset_id;
    double value;
    double threshold;
} ClimateSignal;

int review_required(ClimateSignal signal) {
    return signal.value >= signal.threshold;
}

int main(void) {
    ClimateSignal signal = {"stormwater-pump-01", 0.87, 0.80};
    printf("%s: %s\n", signal.asset_id, review_required(signal) ? "review_required" : "within_operating_range");
    return 0;
}
