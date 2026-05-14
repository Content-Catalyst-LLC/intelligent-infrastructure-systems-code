#include <iostream>
#include <queue>
#include <string>
#include <vector>

struct ScenarioReviewEvent {
    std::string scenario_id;
    std::string asset_id;
    std::string intervention;
    double service_risk;
    double decision_value;
};

struct CompareRisk {
    bool operator()(const ScenarioReviewEvent& a, const ScenarioReviewEvent& b) {
        return a.service_risk < b.service_risk;
    }
};

int main() {
    std::priority_queue<ScenarioReviewEvent, std::vector<ScenarioReviewEvent>, CompareRisk> queue;

    queue.push({"SCN-003", "DT-0002", "targeted_repair", 0.45, 0.19});
    queue.push({"SCN-003", "DT-0005", "targeted_repair", 0.46, 0.16});
    queue.push({"SCN-006", "DT-0002", "renewal", 0.31, 0.10});

    while (!queue.empty()) {
        ScenarioReviewEvent event = queue.top();
        queue.pop();

        std::cout << "scenario=" << event.scenario_id
                  << " asset=" << event.asset_id
                  << " intervention=" << event.intervention
                  << " service_risk=" << event.service_risk
                  << " decision_value=" << event.decision_value
                  << std::endl;
    }

    return 0;
}
