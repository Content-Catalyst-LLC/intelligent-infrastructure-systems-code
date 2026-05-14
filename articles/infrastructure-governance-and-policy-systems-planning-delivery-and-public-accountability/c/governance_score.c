#include <stdio.h>

double governance_quality(
    double public_value,
    double affordability,
    double delivery,
    double stewardship,
    double accountability,
    double learning
) {
    return 0.20 * public_value
         + 0.15 * affordability
         + 0.15 * delivery
         + 0.20 * stewardship
         + 0.15 * accountability
         + 0.15 * learning;
}

int main(void) {
    double score = governance_quality(0.78, 0.66, 0.68, 0.62, 0.67, 0.64);
    printf("Governance quality score: %.3f\n", score);
    return 0;
}
