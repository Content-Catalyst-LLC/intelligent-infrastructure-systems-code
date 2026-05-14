#include <iostream>
#include <queue>
#include <string>
#include <vector>

struct RiskReviewEvent {
    std::string risk_id;
    std::string asset_id;
    std::string review_priority;
    double priority_score;
};

struct ComparePriority {
    bool operator()(const RiskReviewEvent& a, const RiskReviewEvent& b) {
        return a.priority_score < b.priority_score;
    }
};

int main() {
    std::priority_queue<RiskReviewEvent, std::vector<RiskReviewEvent>, ComparePriority> queue;

    queue.push({"R-001", "A-WATER-01", "urgent_continuity_review", 0.55});
    queue.push({"R-004", "A-CYBER-03", "urgent_governance_review", 0.58});
    queue.push({"R-005", "A-FLOOD-09", "urgent_continuity_review", 0.57});

    while (!queue.empty()) {
        RiskReviewEvent event = queue.top();
        queue.pop();

        std::cout << "risk=" << event.risk_id
                  << " asset=" << event.asset_id
                  << " priority=" << event.review_priority
                  << " score=" << event.priority_score
                  << std::endl;
    }

    return 0;
}
