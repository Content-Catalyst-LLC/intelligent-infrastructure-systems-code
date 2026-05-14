#include <iostream>
#include <queue>
#include <string>
#include <vector>

struct ResilienceReviewEvent {
    std::string system_id;
    std::string review_priority;
    double intelligence_quality;
};

struct ComparePriority {
    bool operator()(const ResilienceReviewEvent& a, const ResilienceReviewEvent& b) {
        return a.intelligence_quality > b.intelligence_quality;
    }
};

int main() {
    std::priority_queue<ResilienceReviewEvent, std::vector<ResilienceReviewEvent>, ComparePriority> queue;

    queue.push({"stormwater-monitoring-intelligence", "urgent_cyber_resilience_review", 0.657});
    queue.push({"public-buildings-intelligence", "infrastructure_intelligence_review", 0.650});
    queue.push({"water-network-intelligence", "urgent_cyber_resilience_review", 0.714});

    while (!queue.empty()) {
        ResilienceReviewEvent event = queue.top();
        queue.pop();

        std::cout << "system=" << event.system_id
                  << " priority=" << event.review_priority
                  << " quality=" << event.intelligence_quality
                  << std::endl;
    }

    return 0;
}
