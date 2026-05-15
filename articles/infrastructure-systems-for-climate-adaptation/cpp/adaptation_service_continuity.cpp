#include <algorithm>
#include <iostream>
#include <stdexcept>

class ServiceContinuity {
public:
    ServiceContinuity(double outage_hours, double critical_hours)
        : outage_hours_(outage_hours), critical_hours_(critical_hours) {
        if (outage_hours_ < 0.0) throw std::invalid_argument("outage_hours must be non-negative");
        if (critical_hours_ <= 0.0) throw std::invalid_argument("critical_hours must be positive");
    }

    double score() const {
        const double capped_outage = std::min(outage_hours_, critical_hours_);
        return 1.0 - capped_outage / critical_hours_;
    }

private:
    double outage_hours_;
    double critical_hours_;
};

int main() {
    try {
        ServiceContinuity cooling(1.5, 2.0);
        std::cout << "Service continuity score: " << cooling.score() << std::endl;
    } catch (const std::exception& exc) {
        std::cerr << "error: " << exc.what() << std::endl;
        return 1;
    }
    return 0;
}
