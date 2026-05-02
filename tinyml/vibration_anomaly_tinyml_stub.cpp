#include <stdint.h>
#include <stdio.h>

typedef struct {
    float mean_value;
    float standard_deviation;
    float peak_to_peak;
    float signal_energy;
    float crest_factor;
    float recent_change_rate;
} VibrationFeatureVector;

float run_vibration_anomaly_stub(VibrationFeatureVector features) {
    float score = 0.0f;

    score += 0.20f * features.standard_deviation;
    score += 0.20f * features.peak_to_peak;
    score += 0.25f * features.signal_energy;
    score += 0.20f * features.crest_factor;
    score += 0.15f * features.recent_change_rate;

    return score;
}

int main(void) {
    VibrationFeatureVector features = {
        .mean_value = 0.05f,
        .standard_deviation = 0.31f,
        .peak_to_peak = 1.42f,
        .signal_energy = 0.82f,
        .crest_factor = 0.56f,
        .recent_change_rate = 0.22f
    };

    float anomaly_score = run_vibration_anomaly_stub(features);
    printf("Vibration anomaly score: %0.3f\n", anomaly_score);

    return 0;
}
