#include <algorithm>
#include <iostream>

struct ServiceContinuity {
    double outage_hours;
    double critical_hours;

    double score() const {
        if (critical_hours <= 0.0) return 0.0;
        return 1.0 - (std::min(outage_hours, critical_hours) / critical_hours);
    }
};

int main() {
    ServiceContinuity cooling{1.5, 2.0};
    std::cout << "Service continuity score: " << cooling.score() << std::endl;
    return 0;
}
