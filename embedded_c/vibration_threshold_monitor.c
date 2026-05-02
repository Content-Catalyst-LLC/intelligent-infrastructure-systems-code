#include <stdio.h>
#include <stdbool.h>

#define VIBRATION_THRESHOLD 1.25f

bool vibration_exceeds_threshold(float vibration_g) {
    return vibration_g > VIBRATION_THRESHOLD;
}

int main(void) {
    float vibration_g = 1.42f;

    if (vibration_exceeds_threshold(vibration_g)) {
        printf("Vibration threshold exceeded: %0.2f g\n", vibration_g);
    }

    return 0;
}
