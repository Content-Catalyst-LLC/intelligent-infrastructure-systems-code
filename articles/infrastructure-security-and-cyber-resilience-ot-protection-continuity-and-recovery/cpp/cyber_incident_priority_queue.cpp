#include <iostream>
#include <queue>
#include <string>
#include <vector>

struct CyberIncidentReviewEvent {
    std::string system_id;
    std::string review_priority;
    double residual_exposure;
};

struct CompareExposure {
    bool operator()(const CyberIncidentReviewEvent& a, const CyberIncidentReviewEvent& b) {
        return a.residual_exposure < b.residual_exposure;
    }
};

int main() {
    std::priority_queue<CyberIncidentReviewEvent, std::vector<CyberIncidentReviewEvent>, CompareExposure> queue;

    queue.push({"water-ot-environment", "urgent_continuity_review", 0.187});
    queue.push({"grid-substation-control", "urgent_recovery_review", 0.142});
    queue.push({"hospital-building-management", "urgent_continuity_review", 0.151});

    while (!queue.empty()) {
        CyberIncidentReviewEvent event = queue.top();
        queue.pop();

        std::cout << "system=" << event.system_id
                  << " priority=" << event.review_priority
                  << " residual_exposure=" << event.residual_exposure
                  << std::endl;
    }

    return 0;
}
